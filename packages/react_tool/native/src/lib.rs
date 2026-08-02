//! TypeScript declaration extraction for `react_tool`.
//!
//! Built with the `oxc` toolchain (parser + resolver). Exposes a tiny C ABI:
//! pass a JSON request `{ specifier, names }` plus the managed npm root, get
//! back a JSON IR describing the requested exported declarations (props, types,
//! optionality) that the Dart generator turns into typed foreign-component
//! helpers.

use std::collections::{HashMap, HashSet, VecDeque};
use std::ffi::{CStr, CString};
use std::os::raw::c_char;
use std::path::{Path, PathBuf};

use oxc_allocator::Allocator;
use oxc_ast::ast::*;
use oxc_parser::Parser;
use oxc_resolver::{Resolution, ResolveOptions, Resolver};
use oxc_span::SourceType;
use serde::Serialize;

// ---------------------------------------------------------------------------
// C ABI
// ---------------------------------------------------------------------------

/// Extracts declarations for `specifier`/`names` from the managed npm root.
/// Returns a JSON string: `{"ok": {...}}` or `{"error": "..."}`.
#[no_mangle]
pub extern "C" fn tsb_extract(request_json: *const c_char, npm_root: *const c_char) -> *mut c_char {
    let result = (|| -> Result<serde_json::Value, String> {
        let request = unsafe_cstr(request_json)?;
        let npm_root = unsafe_cstr(npm_root)?;
        let req: serde_json::Value = serde_json::from_str(request)
            .map_err(|e| format!("invalid request JSON: {e}"))?;
        let specifier = req
            .get("specifier")
            .and_then(|v| v.as_str())
            .ok_or("missing string field: specifier")?
            .to_string();
        let names: Vec<String> = req
            .get("names")
            .and_then(|v| v.as_array())
            .ok_or("missing array field: names")?
            .iter()
            .filter_map(|v| v.as_str().map(String::from))
            .collect();
        if names.is_empty() {
            return Err("empty names".into());
        }
        let entry = req
            .get("entry")
            .and_then(|v| v.as_str())
            .map(PathBuf::from);
        let ir = extract(&specifier, &names, Path::new(npm_root), entry)?;
        Ok(serde_json::json!({ "ok": ir }))
    })();

    let text = match result {
        Ok(v) => v.to_string(),
        Err(e) => serde_json::json!({ "error": e }).to_string(),
    };
    match CString::new(text) {
        Ok(c) => c.into_raw(),
        Err(_) => std::ptr::null_mut(),
    }
}

/// Frees a string returned by `tsb_extract`.
#[no_mangle]
pub extern "C" fn tsb_free_string(p: *mut c_char) {
    if !p.is_null() {
        // SAFETY: pointer came from `CString::into_raw` in this crate.
        unsafe {
            drop(CString::from_raw(p));
        }
    }
}

fn unsafe_cstr<'a>(p: *const c_char) -> Result<&'a str, String> {
    if p.is_null() {
        return Err("null string pointer".into());
    }
    // SAFETY: caller must pass a valid NUL-terminated string.
    unsafe { CStr::from_ptr(p) }
        .to_str()
        .map_err(|e| format!("invalid UTF-8: {e}"))
}

// ---------------------------------------------------------------------------
// IR model
// ---------------------------------------------------------------------------

#[derive(Serialize, Clone, Default)]
struct IrType {
    kind: String,
    /// Resolved declaration name when this type came from a named
    /// interface/alias (e.g. `FutureConfig`); used by the Dart generator
    /// to emit strongly-typed classes instead of anonymous maps.
    #[serde(skip_serializing_if = "Option::is_none")]
    name: Option<String>,
    #[serde(skip_serializing_if = "Option::is_none")]
    element: Option<Box<IrType>>,
    #[serde(skip_serializing_if = "Option::is_none")]
    members: Option<Vec<IrProp>>,
    #[serde(skip_serializing_if = "Option::is_none")]
    params: Option<Vec<IrProp>>,
    #[serde(skip_serializing_if = "Option::is_none")]
    returns: Option<Box<IrType>>,
    #[serde(skip_serializing_if = "Option::is_none")]
    literals: Option<Vec<String>>,
}

#[derive(Serialize, Clone)]
struct IrProp {
    name: String,
    required: bool,
    ty: IrType,
}

#[derive(Serialize)]
struct IrDecl {
    name: String,
    kind: String, // "component" | "interface" | "alias"
    props: Vec<IrProp>,
}

fn prim(kind: &str) -> IrType {
    IrType {
        kind: kind.to_string(),
        ..Default::default()
    }
}

// ---------------------------------------------------------------------------
// Declaration store
// ---------------------------------------------------------------------------

#[derive(Clone)]
struct TsProp {
    name: String,
    optional: bool,
    ty: TyExpr,
}

#[derive(Clone)]
enum TyExpr {
    Prim(&'static str),
    ReactNode,
    Event,
    Named(String),
    Array(Box<TyExpr>),
    Object(Vec<TsProp>),
    Partial(Box<TyExpr>),
    Function { params: Vec<TsProp>, returns: Box<TyExpr> },
    Union(Vec<TyExpr>),
    Literal(String),
    Other,
}

#[derive(Clone)]
enum TsDecl {
    Interface { props: Vec<TsProp>, extends: Vec<Heritage> },
    Alias { ty: TyExpr },
    Component { props: Option<TyExpr> },
}

#[derive(Default)]
struct DeclStore {
    decls: HashMap<String, TsDecl>,
}

impl DeclStore {
    fn insert(&mut self, name: &str, decl: TsDecl) {
        self.decls.entry(name.to_string()).or_insert(decl);
    }
}

/// A follow-on import/re-export discovered while parsing a file.
struct Follow {
    source: String,
    /// None = export * (follow everything); Some(names) = only these names.
    names: Option<Vec<String>>,
}

struct ParsedFile {
    decls: Vec<(String, TsDecl)>,
    follows: Vec<Follow>,
}

// ---------------------------------------------------------------------------
// Parsing
// ---------------------------------------------------------------------------

const BUILTINS: &[&str] = &[
    "string", "number", "boolean", "any", "unknown", "void", "never", "null",
    "undefined", "bigint", "symbol", "object", "function", "true", "false",
];

fn parse_dts<'a>(allocator: &'a Allocator, source: &'a str) -> Option<ParsedFile> {
    let ret = Parser::new(allocator, source, SourceType::ts()).parse();
    if ret.panicked {
        return None;
    }
    let mut out = ParsedFile { decls: Vec::new(), follows: Vec::new() };
    for stmt in &ret.program.body {
        collect_stmt(stmt, &mut out);
    }
    Some(out)
}

fn collect_stmt(stmt: &Statement, out: &mut ParsedFile) {
    match stmt {
        Statement::ExportNamedDeclaration(e) => {
            if let Some(decl) = &e.declaration {
                extract_decl(decl, true, out);
            }
            if let Some(source) = &e.source {
                let mut names = Vec::new();
                for spec in &e.specifiers {
                    if let ModuleExportName::IdentifierName(id) = &spec.local {
                        names.push(id.name.as_str().to_string());
                    }
                }
                out.follows.push(Follow {
                    source: source.value.as_str().to_string(),
                    names: Some(names),
                });
            }
        }
        Statement::ExportAllDeclaration(e) => {
            out.follows.push(Follow {
                source: e.source.value.as_str().to_string(),
                names: None,
            });
        }
        Statement::TSInterfaceDeclaration(d) => {
            extract_interface(d, out);
        }
        Statement::TSTypeAliasDeclaration(d) => {
            extract_type_alias(d, out);
        }
        Statement::FunctionDeclaration(f) => {
            extract_function(f, false, out);
        }
        Statement::VariableDeclaration(v) => {
            extract_variable(v, false, out);
        }
        Statement::ImportDeclaration(i) => {
            if i.import_kind == ImportOrExportKind::Type {
                let names = i.specifiers.as_ref().map(|specs| {
                    let mut names = Vec::new();
                    for spec in specs.iter() {
                        match spec {
                            ImportDeclarationSpecifier::ImportSpecifier(s) => {
                                names.push(s.local.name.as_str().to_string());
                            }
                            ImportDeclarationSpecifier::ImportDefaultSpecifier(s) => {
                                names.push(s.local.name.as_str().to_string());
                            }
                            _ => {} // namespace import: cannot know members
                        }
                    }
                    names
                });
                out.follows.push(Follow {
                    source: i.source.value.as_str().to_string(),
                    names,
                });
            }
        }
        _ => {}
    }
}

fn extract_decl(decl: &Declaration, exported: bool, out: &mut ParsedFile) {
    match decl {
        Declaration::TSInterfaceDeclaration(d) => extract_interface(d, out),
        Declaration::TSTypeAliasDeclaration(d) => extract_type_alias(d, out),
        Declaration::FunctionDeclaration(f) => extract_function(f, exported, out),
        Declaration::VariableDeclaration(v) => extract_variable(v, exported, out),
        _ => {}
    }
}

fn extract_interface(i: &TSInterfaceDeclaration, out: &mut ParsedFile) {
    let props = props_from_signatures(&i.body.body);
    let extends = i.extends.iter().filter_map(heritage).collect();
    out.decls.push((
        i.id.name.as_str().to_string(),
        TsDecl::Interface { props, extends },
    ));
}

/// One `extends` / `implements` clause entry, e.g. `Omit<LinkProps, "href">`
/// carries both the referenced name and its type arguments.
#[derive(Clone)]
struct Heritage {
    name: String,
    args: Vec<TyExpr>,
}

/// The referenced name and type arguments of an interface `extends` entry
/// (e.g. `Omit<LinkProps, "href">` → name `Omit`, args `[LinkProps, "href"]`).
fn heritage(h: &TSInterfaceHeritage) -> Option<Heritage> {
    let name = match &h.expression {
        Expression::Identifier(id) => id.name.as_str().to_string(),
        Expression::TSInstantiationExpression(e) => match &e.expression {
            Expression::Identifier(id) => id.name.as_str().to_string(),
            _ => return None,
        },
        _ => return None,
    };
    let args = h
        .type_arguments
        .as_ref()
        .map(|tp| tp.params.iter().map(ty_to_expr).collect())
        .unwrap_or_default();
    Some(Heritage { name, args })
}

fn extract_type_alias(a: &TSTypeAliasDeclaration, out: &mut ParsedFile) {
    let ty = ty_to_expr(&a.type_annotation);
    out.decls.push((
        a.id.name.as_str().to_string(),
        TsDecl::Alias { ty },
    ));
}

fn extract_function(f: &Function, exported: bool, out: &mut ParsedFile) {
    if exported {
        if let Some(id) = &f.id {
            let props = f.params.items.first().and_then(|p| {
                p.type_annotation
                    .as_ref()
                    .map(|ta| ty_to_expr(&ta.type_annotation))
            });
            out.decls.push((
                id.name.as_str().to_string(),
                TsDecl::Component { props },
            ));
        }
    }
}

fn extract_variable(v: &VariableDeclaration, exported: bool, out: &mut ParsedFile) {
    if exported {
        for d in v.declarations.iter() {
            if let Some(ta) = &d.type_annotation {
                if let Some(name) = binding_name(&d.id) {
                    if let Some(props) = component_props_from_annotation(&ta.type_annotation) {
                        out.decls.push((
                            name,
                            TsDecl::Component { props: Some(props) },
                        ));
                    }
                }
            }
        }
    }
}

fn binding_name(pattern: &BindingPattern) -> Option<String> {
    match pattern {
        BindingPattern::BindingIdentifier(id) => Some(id.name.as_str().to_string()),
        _ => None,
    }
}

/// `const X: React.FC<Props>` / `FC<Props>` / `ComponentType<Props>` / etc.
fn component_props_from_annotation(ty: &TSType) -> Option<TyExpr> {
    let TSType::TSTypeReference(r) = ty else { return None };
    let base = type_name_base(&r.type_name);
    let matches = matches!(
        base.as_str(),
        "FC" | "FunctionComponent" | "ComponentType" | "ExoticComponent"
            | "ForwardRefExoticComponent" | "MemoExoticComponent" | "LazyExoticComponent"
    );
    if !matches {
        return None;
    }
    r.type_arguments
        .as_ref()
        .and_then(|tp| tp.params.first())
        .map(ty_to_expr)
}

fn props_from_signatures(sigs: &[TSSignature]) -> Vec<TsProp> {
    let mut props = Vec::new();
    for s in sigs.iter() {
        match s {
            TSSignature::TSPropertySignature(p) => {
                if let Some(name) = property_name(&p.key) {
                    let ty = p
                        .type_annotation
                        .as_ref()
                        .map(|ta| ty_to_expr(&ta.type_annotation))
                        .unwrap_or(TyExpr::Other);
                    props.push(TsProp { name, optional: p.optional, ty });
                }
            }
            TSSignature::TSMethodSignature(m) => {
                if let Some(name) = property_name(&m.key) {
                    props.push(TsProp {
                        name,
                        optional: m.optional,
                        ty: function_expr(&m.params, &m.return_type),
                    });
                }
            }
            _ => {}
        }
    }
    props
}

fn property_name(key: &PropertyKey) -> Option<String> {
    match key {
        PropertyKey::StaticIdentifier(id) => Some(id.name.as_str().to_string()),
        PropertyKey::StringLiteral(s) => Some(s.value.as_str().to_string()),
        _ => None,
    }
}

fn function_expr<'a>(
    params: &FormalParameters<'a>,
    return_ta: &Option<oxc_allocator::Box<'a, TSTypeAnnotation<'a>>>,
) -> TyExpr {
    let ps = formal_params(params);
    let ret = return_ta
        .as_ref()
        .map(|ta| ty_to_expr(&ta.type_annotation))
        .unwrap_or(TyExpr::Prim("void"));
    TyExpr::Function { params: ps, returns: Box::new(ret) }
}

fn formal_params(params: &FormalParameters) -> Vec<TsProp> {
    params
        .items
        .iter()
        .map(|p| {
            let name = match &p.pattern {
                BindingPattern::BindingIdentifier(id) => id.name.as_str().to_string(),
                _ => "arg".to_string(),
            };
            let ty = p
                .type_annotation
                .as_ref()
                .map(|ta| ty_to_expr(&ta.type_annotation))
                .unwrap_or(TyExpr::Event);
            TsProp { name, optional: p.optional, ty }
        })
        .collect()
}

fn ty_to_expr(ty: &TSType) -> TyExpr {
    match ty {
        TSType::TSStringKeyword(_) => TyExpr::Prim("string"),
        TSType::TSNumberKeyword(_) => TyExpr::Prim("number"),
        TSType::TSBooleanKeyword(_) => TyExpr::Prim("boolean"),
        TSType::TSAnyKeyword(_) => TyExpr::Prim("any"),
        TSType::TSUnknownKeyword(_) => TyExpr::Prim("unknown"),
        TSType::TSVoidKeyword(_) | TSType::TSNeverKeyword(_) => TyExpr::Prim("void"),
        TSType::TSNullKeyword(_) => TyExpr::Prim("null"),
        TSType::TSUndefinedKeyword(_) => TyExpr::Prim("null"),
        TSType::TSObjectKeyword(_) => TyExpr::Prim("any"),
        TSType::TSBigIntKeyword(_) | TSType::TSSymbolKeyword(_) => TyExpr::Prim("any"),
        TSType::TSArrayType(a) => TyExpr::Array(Box::new(ty_to_expr(&a.element_type))),
        TSType::TSTupleType(_) => TyExpr::Array(Box::new(TyExpr::Prim("any"))),
        TSType::TSLiteralType(l) => TyExpr::Literal(literal_to_string(&l.literal)),
        TSType::TSTypeReference(r) => type_ref_to_expr(r),
        TSType::TSUnionType(u) => union_to_expr(&u.types),
        TSType::TSIntersectionType(i) => intersection_to_expr(&i.types),
        TSType::TSTypeLiteral(l) => TyExpr::Object(props_from_signatures(&l.members)),
        TSType::TSFunctionType(f) => {
            let ret = ty_to_expr(&f.return_type.type_annotation);
            TyExpr::Function {
                params: formal_params(&f.params),
                returns: Box::new(ret),
            }
        }
        TSType::TSTypeOperatorType(o) => ty_to_expr(&o.type_annotation),
        TSType::TSParenthesizedType(p) => ty_to_expr(&p.type_annotation),
        TSType::TSTemplateLiteralType(_) => TyExpr::Prim("string"),
        _ => TyExpr::Other,
    }
}

fn union_to_expr(types: &[TSType]) -> TyExpr {
    let mut members: Vec<TyExpr> = Vec::new();
    for t in types.iter() {
        match t {
            TSType::TSNullKeyword(_) | TSType::TSUndefinedKeyword(_) => continue,
            TSType::TSUnionType(inner) => members.push(union_to_expr(&inner.types)),
            _ => members.push(ty_to_expr(t)),
        }
    }
    match members.len() {
        0 => TyExpr::Prim("null"),
        1 => members.remove(0),
        _ => TyExpr::Union(members),
    }
}

fn intersection_to_expr(types: &[TSType]) -> TyExpr {
    let mut props: Vec<TsProp> = Vec::new();
    for t in types.iter() {
        match t {
            TSType::TSTypeReference(r) => {
                let base = type_name_base(&r.type_name);
                // RefAttributes / HTMLAttributes etc: host props, skip
                if base.ends_with("Attributes") && base != "Attributes" {
                    continue;
                }
                // Keep as Named so serialization resolves from the store.
                props.push(TsProp {
                    name: "__ref".into(),
                    optional: false,
                    ty: TyExpr::Named(base),
                });
            }
            TSType::TSTypeLiteral(l) => props.extend(props_from_signatures(&l.members)),
            TSType::TSIntersectionType(inner) => {
                if let TyExpr::Object(mut ps) = intersection_to_expr(&inner.types) {
                    props.append(&mut ps);
                }
            }
            _ => {}
        }
    }
    if props.is_empty() {
        TyExpr::Other
    } else {
        TyExpr::Object(props)
    }
}

fn literal_to_string(lit: &TSLiteral) -> String {
    match lit {
        TSLiteral::BooleanLiteral(b) => b.value.to_string(),
        TSLiteral::NumericLiteral(n) => n.value.to_string(),
        TSLiteral::BigIntLiteral(b) => b
            .raw
            .as_ref()
            .map(|s| s.as_str().to_string())
            .unwrap_or_else(|| "0".to_string()),
        TSLiteral::StringLiteral(s) => format!("\"{}\"", s.value.as_str()),
        TSLiteral::TemplateLiteral(_) => "\"\"".to_string(),
        TSLiteral::UnaryExpression(_) => "null".to_string(),
    }
}

/// Returns the bare last identifier of a (possibly namespace-qualified) name.
/// The rightmost segment of a type name: `React.ForwardRefExoticComponent`
/// → `ForwardRefExoticComponent`, `Partial` → `Partial`.
fn type_name_base(name: &TSTypeName) -> String {
    match name {
        TSTypeName::IdentifierReference(id) => id.name.as_str().to_string(),
        TSTypeName::QualifiedName(q) => q.right.name.as_str().to_string(),
        TSTypeName::ThisExpression(_) => "this".to_string(),
    }
}

/// Fully-qualified dotted name, e.g. `React.ReactNode` → "React.ReactNode".
fn type_name_flat(name: &TSTypeName) -> String {
    match name {
        TSTypeName::IdentifierReference(id) => id.name.as_str().to_string(),
        TSTypeName::QualifiedName(q) => {
            format!("{}.{}", type_name_flat(&q.left), q.right.name.as_str())
        }
        TSTypeName::ThisExpression(_) => "this".to_string(),
    }
}

fn type_ref_to_expr(r: &TSTypeReference) -> TyExpr {
    let flat = type_name_flat(&r.type_name);
    let base = type_name_base(&r.type_name);
    let tp = r.type_arguments.as_ref();

    // React namespace specials
    let ns = flat.split('.').next().unwrap_or("");
    let is_react = ns.ends_with("React") || ns == "JSX";
    if is_react {
        match flat.rsplit('.').next().unwrap_or("") {
            "ReactNode" => return TyExpr::ReactNode,
            "CSSProperties" => return TyExpr::Object(Vec::new()),
            "Element" => return TyExpr::Prim("any"),
            _ => {}
        }
    }
    if base.ends_with("Event") || base == "SyntheticEvent" {
        return TyExpr::Event;
    }
    if base == "ReactNode" {
        return TyExpr::ReactNode;
    }
    if base == "CSSProperties" {
        return TyExpr::Object(Vec::new());
    }
    if base == "HTMLProps" || base == "SVGProps" || base == "ComponentProps" {
        return TyExpr::Object(Vec::new());
    }

    if BUILTINS.contains(&base.as_str()) {
        return match base.as_str() {
            "string" => TyExpr::Prim("string"),
            "number" => TyExpr::Prim("number"),
            "boolean" => TyExpr::Prim("boolean"),
            _ => TyExpr::Prim("any"),
        };
    }

    // Generic wrappers
    let first = || tp.and_then(|t| t.params.first()).map(ty_to_expr);
    match base.as_str() {
        "Array" | "ReadonlyArray" => {
            let e = first().unwrap_or(TyExpr::Prim("any"));
            return TyExpr::Array(Box::new(e));
        }
        "Partial" => {
            let inner = first().unwrap_or(TyExpr::Other);
            return TyExpr::Partial(Box::new(inner));
        }
        "Record" | "Map" => return TyExpr::Object(Vec::new()),
        "FC" | "FunctionComponent" | "ComponentType" | "ExoticComponent"
        | "ForwardRefExoticComponent" | "MemoExoticComponent" | "LazyExoticComponent" => {
            return first().unwrap_or(TyExpr::Other);
        }
        _ => {}
    }

    TyExpr::Named(base)
}

// ---------------------------------------------------------------------------
// Graph loading
// ---------------------------------------------------------------------------

fn make_resolver(npm_root: &Path) -> Resolver {
    let mut opts = ResolveOptions::default();
    opts.condition_names = vec![
        "types".into(),
        "import".into(),
        "node".into(),
        "require".into(),
        "default".into(),
    ];
    opts.main_fields = vec!["types".into(), "typings".into(), "main".into()];
    opts.extensions = vec![
        ".ts".into(),
        ".tsx".into(),
        ".d.ts".into(),
        ".js".into(),
        ".jsx".into(),
        ".mjs".into(),
        ".cjs".into(),
    ];
    // Resolve bare specifiers from the managed npm root.
    let mut opts = opts;
    opts.cwd = Some(npm_root.to_path_buf());
    Resolver::new(opts)
}

fn resolve_import(
    resolver: &Resolver,
    from_file: &Path,
    specifier: &str,
) -> Option<PathBuf> {
    match resolver.resolve_dts(from_file, specifier) {
        Ok(res) => Some(resolution_path(&res)),
        Err(_) => None,
    }
}

fn resolution_path(res: &Resolution) -> PathBuf {
    res.path().to_path_buf()
}

fn find_package_dir(npm_root: &Path, specifier: &str) -> Option<PathBuf> {
    let direct = npm_root.join("node_modules").join(specifier);
    if direct.join("package.json").is_file() {
        return Some(direct);
    }
    // Walk up looking for node_modules (hoisted layouts).
    let mut cur = npm_root;
    loop {
        let candidate = cur.join("node_modules").join(specifier);
        if candidate.join("package.json").is_file() {
            return Some(candidate);
        }
        cur = cur.parent()?;
        if cur.as_os_str().is_empty() {
            break;
        }
    }
    None
}

fn types_entry(pkg_dir: &Path) -> Option<PathBuf> {
    let pkg_json_path = pkg_dir.join("package.json");
    let text = std::fs::read_to_string(&pkg_json_path).ok()?;
    let json: serde_json::Value = serde_json::from_str(&text).ok()?;
    let rel = json
        .get("types")
        .or_else(|| json.get("typings"))
        .and_then(|v| v.as_str())
        .or_else(|| {
            json.get("exports")
                .and_then(|e| e.get("."))
                .and_then(|dot| {
                    if let Some(obj) = dot.as_object() {
                        obj.get("types").and_then(|v| v.as_str())
                    } else {
                        None
                    }
                })
        })?;
    let p = pkg_dir.join(rel);
    if p.is_file() {
        Some(p)
    } else {
        None
    }
}

fn extract(
    specifier: &str,
    names: &[String],
    npm_root: &Path,
    entry_override: Option<PathBuf>,
) -> Result<serde_json::Value, String> {
    let entry = if let Some(e) = entry_override {
        e
    } else if specifier.contains('/') {
        // Subpath export (e.g. `react-router-dom/server`): resolve through
        // the package exports map so the types entry of the submodule is
        // found instead of the top-level package types.
        let (pkg, _) = specifier
            .split_once('/')
            .ok_or_else(|| format!("invalid specifier: {specifier}"))?;
        let pkg_dir = find_package_dir(npm_root, pkg)
            .ok_or_else(|| format!("package not found in npm root: {pkg}"))?;
        let resolver = make_resolver(npm_root);
        match resolver.resolve(&pkg_dir.join("package.json"), specifier) {
            Ok(res) => res.path().to_path_buf(),
            Err(e) => return Err(format!("cannot resolve subpath {specifier}: {e}")),
        }
    } else {
        let pkg_dir = find_package_dir(npm_root, specifier)
            .ok_or_else(|| format!("package not found in npm root: {specifier}"))?;
        types_entry(&pkg_dir)
            .ok_or_else(|| format!("no .d.ts types entry for {specifier}"))?
    };
    if !entry.is_file() {
        return Err(format!("types entry not found: {}", entry.display()));
    }

    let resolver = make_resolver(npm_root);
    let mut store = DeclStore::default();
    let mut queue: VecDeque<PathBuf> = VecDeque::new();
    queue.push_back(entry.clone());
    let mut visited: HashSet<PathBuf> = HashSet::new();
    let mut total_files = 0usize;
    let allocator = Allocator::default();

    while let Some(file) = queue.pop_front() {
        if !visited.insert(file.clone()) {
            continue;
        }
        total_files += 1;
        if total_files > 400 {
            break; // safety cap
        }
        let Ok(source) = std::fs::read_to_string(&file) else {
            continue;
        };
        let Some(parsed) = parse_dts(&allocator, &source) else {
            continue;
        };
        for (name, decl) in parsed.decls {
            store.insert(&name, decl);
        }
        for follow in parsed.follows {
            if let Some(path) = resolve_import(&resolver, &file, &follow.source) {
                if let Some(wanted) = follow.names {
                    if wanted.iter().all(|n| store.decls.contains_key(n)) {
                        continue;
                    }
                }
                queue.push_back(path);
            }
        }
    }

    // Serialize requested declarations.
    let mut declarations = Vec::new();
    let mut missing = Vec::new();
    for name in names {
        match store.decls.get(name) {
            Some(decl) => {
                let mut visiting = HashSet::new();
                let ir = serialize_decl(name, decl, &store, &mut visiting, 0);
                declarations.push(ir);
            }
            None => missing.push(name.clone()),
        }
    }
    if !missing.is_empty() {
        return Err(format!(
            "declaration(s) not found: {} (files visited: {total_files})",
            missing.join(", ")
        ));
    }

    Ok(serde_json::json!({
        "entry": entry.to_string_lossy(),
        "files": total_files,
        "declarations": declarations,
    }))
}

// ---------------------------------------------------------------------------
// Serialization
// ---------------------------------------------------------------------------

fn serialize_decl(
    name: &str,
    decl: &TsDecl,
    store: &DeclStore,
    visiting: &mut HashSet<String>,
    depth: usize,
) -> IrDecl {
    let (kind, props) = match decl {
        TsDecl::Interface { props, extends } => {
            ("interface", resolve_interface_props(props, extends, store, visiting))
        }
        TsDecl::Alias { ty } => ("alias", props_for_expr(ty, store, visiting)),
        TsDecl::Component { props } => (
            "component",
            match props {
                Some(ty) => props_for_expr(ty, store, visiting),
                None => Vec::new(),
            },
        ),
    };
    let props = serialize_props(&props, store, visiting, depth + 1);
    IrDecl { name: name.to_string(), kind: kind.to_string(), props }
}

/// Resolves a props type expression to a flat prop list, following named
/// references (interfaces/aliases/other components) through the store with
/// cycle guarding. Unions of object types are merged; non-object types
/// collapse to a single `value` prop.
fn props_for_expr(
    ty: &TyExpr,
    store: &DeclStore,
    visiting: &mut HashSet<String>,
) -> Vec<TsProp> {
    match ty {
        TyExpr::Object(ps) => {
            // `__ref` markers come from intersections of named types
            // (LinkProps & RefAttributes): resolve each marker to the
            // referenced declaration's props.
            let mut out: Vec<TsProp> = Vec::new();
            for p in ps.iter() {
                if p.name == "__ref" {
                    out.extend(props_for_expr(&p.ty, store, visiting));
                } else {
                    out.push(p.clone());
                }
            }
            out
        }
        TyExpr::Named(n) => {
            if visiting.contains(n) {
                return Vec::new();
            }
            match store.decls.get(n) {
                Some(TsDecl::Interface { props, extends }) => {
                    visiting.insert(n.clone());
                    let out = resolve_interface_props(props, extends, store, visiting);
                    visiting.remove(n);
                    out
                }
                Some(TsDecl::Alias { ty }) => props_for_expr(ty, store, visiting),
                Some(TsDecl::Component { props }) => props
                    .as_ref()
                    .map(|p| props_for_expr(p, store, visiting))
                    .unwrap_or_default(),
                None => vec![TsProp {
                    name: "value".into(),
                    optional: false,
                    ty: ty.clone(),
                }],
            }
        }
        TyExpr::Union(members) => {
            let mut merged: Vec<TsProp> = Vec::new();
            let mut seen: HashSet<String> = HashSet::new();
            for m in members {
                for p in props_for_expr(m, store, visiting) {
                    if seen.insert(p.name.clone()) {
                        merged.push(p);
                    }
                }
            }
            merged
        }
        TyExpr::Partial(inner) => props_for_expr(inner, store, visiting),
        TyExpr::Array(_)
        | TyExpr::Literal(_)
        | TyExpr::Prim(_)
        | TyExpr::Event
        | TyExpr::ReactNode
        | TyExpr::Other => vec![TsProp {
            name: "value".into(),
            optional: false,
            ty: ty.clone(),
        }],
        TyExpr::Function { .. } => Vec::new(),
    }
}

/// Merges an interface's own props with props inherited from its `extends`
/// clauses. Own props win on name clashes.
fn resolve_interface_props(
    props: &[TsProp],
    extends: &[Heritage],
    store: &DeclStore,
    visiting: &mut HashSet<String>,
) -> Vec<TsProp> {
    let mut map: HashMap<String, TsProp> = HashMap::new();
    for h in extends {
        for p in inherited_props(h, store, visiting) {
            map.insert(p.name.clone(), p);
        }
    }
    for p in props {
        map.insert(p.name.clone(), p.clone());
    }
    map.into_values().collect()
}

/// Members an interface inherits from one `extends` clause entry.
fn inherited_props(
    h: &Heritage,
    store: &DeclStore,
    visiting: &mut HashSet<String>,
) -> Vec<TsProp> {
    let keys = |args: &[TyExpr]| -> HashSet<String> {
        args.iter()
            .filter_map(|a| match a {
                TyExpr::Literal(s) => Some(s.trim_matches('"').to_string()),
                _ => None,
            })
            .collect()
    };
    match h.name.as_str() {
        "Omit" if h.args.len() >= 2 => {
            let omitted = keys(&h.args[1..]);
            base_members(&h.args[0], store, visiting)
                .into_iter()
                .filter(|p| !omitted.contains(&p.name))
                .collect()
        }
        "Pick" if h.args.len() >= 2 => {
            let wanted = keys(&h.args[1..]);
            base_members(&h.args[0], store, visiting)
                .into_iter()
                .filter(|p| wanted.contains(&p.name))
                .collect()
        }
        _ => base_members(&TyExpr::Named(h.name.clone()), store, visiting),
    }
}

/// Members of a named type: a store interface, or the curated DOM attribute
/// table for `*HTMLAttributes` types that live in @types/react (which the
/// managed environment does not install).
fn base_members(ty: &TyExpr, store: &DeclStore, visiting: &mut HashSet<String>) -> Vec<TsProp> {
    let TyExpr::Named(n) = ty else { return Vec::new() };
    if visiting.contains(n) {
        return Vec::new();
    }
    match store.decls.get(n) {
        Some(TsDecl::Interface { props, extends }) => {
            visiting.insert(n.clone());
            let out = resolve_interface_props(props, extends, store, visiting);
            visiting.remove(n);
            out
        }
        _ => dom_attribute_members(n),
    }
}

/// Curated members for DOM attribute interfaces (children, className, …).
/// @types/react is not part of the managed JS environment, so these are
/// provided here instead of being resolved from the React type sources.
fn dom_attribute_members(base: &str) -> Vec<TsProp> {
    if !(base.ends_with("HTMLAttributes") || base == "AriaAttributes") {
        return Vec::new();
    }
    let mut v = Vec::new();
    let mut push = |name: &str, ty: TyExpr| {
        v.push(TsProp { name: name.to_string(), optional: true, ty });
    };
    push("children", TyExpr::ReactNode);
    push("className", TyExpr::Prim("string"));
    push("style", TyExpr::Object(Vec::new()));
    push("id", TyExpr::Prim("string"));
    push("title", TyExpr::Prim("string"));
    push("lang", TyExpr::Prim("string"));
    push("dir", TyExpr::Prim("string"));
    push("hidden", TyExpr::Prim("boolean"));
    push("tabIndex", TyExpr::Prim("number"));
    push("role", TyExpr::Prim("string"));
    push("href", TyExpr::Prim("string"));
    push("target", TyExpr::Prim("string"));
    push("rel", TyExpr::Prim("string"));
    push("download", TyExpr::Prim("boolean"));
    push("onClick", TyExpr::Event);
    v
}

fn serialize_props(
    props: &[TsProp],
    store: &DeclStore,
    visiting: &mut HashSet<String>,
    depth: usize,
) -> Vec<IrProp> {
    props
        .iter()
        .map(|p| IrProp {
            name: p.name.clone(),
            required: !p.optional,
            ty: serialize_ty(&p.ty, store, visiting, depth + 1),
        })
        .collect()
}

fn serialize_ty(
    ty: &TyExpr,
    store: &DeclStore,
    visiting: &mut HashSet<String>,
    depth: usize,
) -> IrType {
    if depth > 10 {
        return prim("any");
    }
    match ty {
        TyExpr::Prim(s) => prim(s),
        TyExpr::ReactNode => prim("reactNode"),
        TyExpr::Event => prim("hostValue"),

        TyExpr::Other => prim("any"),
        TyExpr::Literal(l) => IrType {
            kind: "literal".into(),
            literals: Some(vec![l.clone()]),
            ..Default::default()
        },
        TyExpr::Array(e) => IrType {
            kind: "array".into(),
            element: Some(Box::new(serialize_ty(e, store, visiting, depth + 1))),
            ..Default::default()
        },
        TyExpr::Object(props) => IrType {
            kind: "object".into(),
            members: Some(serialize_props(props, store, visiting, depth + 1)),
            ..Default::default()
        },
        TyExpr::Partial(inner) => {
            let ps = props_for_expr(inner, store, visiting);
            let name = match inner.as_ref() {
                TyExpr::Named(n) => Some(n.clone()),
                _ => None,
            };
            IrType {
                kind: "object".into(),
                name,
                members: Some(
                    ps.iter()
                        .map(|p| IrProp {
                            name: p.name.clone(),
                            required: false,
                            ty: serialize_ty(&p.ty, store, visiting, depth + 1),
                        })
                        .collect(),
                ),
                ..Default::default()
            }
        }
        TyExpr::Function { params, returns } => IrType {
            kind: "function".into(),
            params: Some(serialize_props(params, store, visiting, depth + 1)),
            returns: Some(Box::new(serialize_ty(returns, store, visiting, depth + 1))),
            ..Default::default()
        },
        TyExpr::Union(members) => {
            if members.iter().all(|m| matches!(m, TyExpr::Literal(_))) {
                let literals: Vec<String> = members
                    .iter()
                    .map(|m| match m {
                        TyExpr::Literal(l) => l.clone(),
                        _ => "null".into(),
                    })
                    .collect();
                IrType {
                    kind: "literal".into(),
                    literals: Some(literals),
                    ..Default::default()
                }
            } else if members
                .iter()
                .all(|m| matches!(
                    m,
                    TyExpr::Prim("string") | TyExpr::Prim("number") | TyExpr::Prim("boolean")
                ))
            {
                IrType {
                    kind: "union".into(),
                    members: Some(
                        members
                            .iter()
                            .map(|m| IrProp {
                                name: "value".into(),
                                required: true,
                                ty: serialize_ty(m, store, visiting, depth + 1),
                            })
                            .collect(),
                    ),
                    ..Default::default()
                }
            } else {
                prim("any")
            }
        }
        TyExpr::Named(n) => {
            if visiting.contains(n) {
                return prim("any"); // cycle
            }
            match store.decls.get(n) {
                Some(TsDecl::Interface { props, extends }) => {
                    visiting.insert(n.clone());
                    let ps = resolve_interface_props(props, extends, store, visiting);
                    let out = IrType {
                        kind: "object".into(),
                        name: Some(n.clone()),
                        members: Some(serialize_props(&ps, store, visiting, depth + 1)),
                        ..Default::default()
                    };
                    visiting.remove(n);
                    out
                }
                Some(TsDecl::Alias { ty }) => {
                    visiting.insert(n.clone());
                    let out = serialize_ty(ty, store, visiting, depth + 1);
                    visiting.remove(n);
                    out
                }
                Some(TsDecl::Component { props }) => {
                    let ps = match props {
                        Some(TyExpr::Object(ps)) => ps.clone(),
                        _ => Vec::new(),
                    };
                    visiting.insert(n.clone());
                    let out = IrType {
                        kind: "object".into(),
                        members: Some(serialize_props(&ps, store, visiting, depth + 1)),
                        ..Default::default()
                    };
                    visiting.remove(n);
                    out
                }
                None => prim("any"),
            }
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    fn npm_root() -> PathBuf {
        std::env::var("REACT_NPM_ROOT")
            .map(PathBuf::from)
            .unwrap_or_else(|_| {
                let cwd = std::env::current_dir().unwrap();
                // native/Cargo.toml → workspace root
                let ws = cwd
                    .parent()
                    .and_then(|p| p.parent())
                    .and_then(|p| p.parent())
                    .unwrap_or(&cwd);
                ws.join(".dart_tool/react/js")
            })
    }

    #[test]
    fn extracts_memory_router_props_from_react_router_dom() {
        let root = npm_root();
        if !root.join("node_modules/react-router-dom/package.json").is_file() {
            eprintln!("skipping: react-router-dom not installed at {}", root.display());
            return;
        }
        let names = vec!["MemoryRouter".to_string(), "Route".to_string()];
        let out = extract("react-router-dom", &names, &root, None).expect("extract");
        let decls = out["declarations"].as_array().unwrap();
        assert_eq!(decls.len(), 2);
        let memory = &decls[0];
        assert_eq!(memory["name"], "MemoryRouter");
        assert_eq!(memory["kind"], "component");
        let props = memory["props"].as_array().unwrap();
        let names: Vec<&str> = props.iter().map(|p| p["name"].as_str().unwrap()).collect();
        assert!(names.contains(&"basename"), "props: {names:?}");
        assert!(names.contains(&"initialEntries"));
        assert!(names.contains(&"initialIndex"));
        assert!(names.contains(&"children"));
        for p in props {
            let required = p["required"].as_bool().unwrap();
            let kind = p["ty"]["kind"].as_str().unwrap();
            assert!(!required, "all MemoryRouterProps are optional: {p:?}");
            assert!(
                !matches!(kind, "null"),
                "no null kinds leaked: {p:?}"
            );
        }
        // initialEntries: InitialEntry[] → array
        let entries = props
            .iter()
            .find(|p| p["name"] == "initialEntries")
            .unwrap();
        assert_eq!(entries["ty"]["kind"], "array");
        // InitialEntry = string | Partial<Location> → heterogeneous union,
        // curated down to any.
        assert_eq!(entries["ty"]["element"]["kind"], "any");
        // future?: FutureConfig → named object carried through the IR.
        let future = props.iter().find(|p| p["name"] == "future").unwrap();
        assert_eq!(future["ty"]["kind"], "object");
        assert_eq!(future["ty"]["name"], "FutureConfig");
        // children: React.ReactNode → reactNode
        let children = props.iter().find(|p| p["name"] == "children").unwrap();
        assert_eq!(children["ty"]["kind"], "reactNode");

        let route = &decls[1];
        assert_eq!(route["name"], "Route");
        assert_eq!(route["kind"], "component");
    }

    #[test]
    fn extracts_interface_and_type_alias() {
        let root = npm_root();
        if !root.join("node_modules/react-router-dom/package.json").is_file() {
            return;
        }
        let names = vec!["MemoryRouterProps".to_string()];
        let out = extract("react-router-dom", &names, &root, None).expect("extract");
        let d = &out["declarations"][0];
        assert_eq!(d["kind"], "interface");
    }

    #[test]
    fn extracts_link_via_forward_ref_exotic_component() {
        let root = npm_root();
        if !root.join("node_modules/react-router-dom/package.json").is_file() {
            return;
        }
        // Link is `export declare const Link: React.ForwardRefExoticComponent<...>`
        // — requires the rightmost-segment base-name resolution.
        let out = extract("react-router-dom", &["Link".to_string()], &root, None)
            .expect("extract");
        let d = &out["declarations"][0];
        assert_eq!(d["name"], "Link");
        assert_eq!(d["kind"], "component");
        let props = d["props"].as_array().unwrap();
        let names: Vec<&str> = props.iter().map(|p| p["name"].as_str().unwrap()).collect();
        assert!(names.contains(&"to"), "props: {names:?}");
        // `children` is inherited from Omit<AnchorHTMLAttributes, "href"> via
        // the curated DOM attribute table.
        assert!(names.contains(&"children"), "props: {names:?}");
        // The `__ref` placeholder must be flattened away.
        assert!(!names.contains(&"__ref"), "props: {names:?}");
    }

    #[test]
    fn extracts_static_router_from_server_subpath() {
        let root = npm_root();
        if !root.join("node_modules/react-router-dom/package.json").is_file() {
            return;
        }
        // StaticRouter is exported from `react-router-dom/server`, not the
        // top-level entry — the subpath must resolve through exports.
        let out = extract(
            "react-router-dom/server",
            &["StaticRouter".to_string()],
            &root,
            None,
        )
        .expect("extract subpath");
        let d = &out["declarations"][0];
        assert_eq!(d["name"], "StaticRouter");
        assert_eq!(d["kind"], "component");
        let props = d["props"].as_array().unwrap();
        let names: Vec<&str> = props.iter().map(|p| p["name"].as_str().unwrap()).collect();
        assert!(names.contains(&"location"), "props: {names:?}");
    }

    #[test]
    fn missing_name_is_an_error() {
        let root = npm_root();
        if !root.join("node_modules/react-router-dom/package.json").is_file() {
            return;
        }
        let names = vec!["DoesNotExist".to_string()];
        let err = extract("react-router-dom", &names, &root, None).unwrap_err();
        assert!(err.contains("DoesNotExist"), "{err}");
    }
}
