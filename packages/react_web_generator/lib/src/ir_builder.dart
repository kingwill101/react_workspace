import 'dart:convert';
import 'dart:io';

import 'package:react_web_generator/src/resolver.dart';
import 'package:react_web_generator/src/web_dart_type.dart';
import 'package:react_web_generator/src/web_host_ir.dart';

final class WebHostIrBuilder {
  final PackageWebResolver _resolver;
  final Map<String, dynamic> _idl;
  final Map<String, dynamic> _overlay;
  final List<String> _elements;

  WebHostIrBuilder._({
    required this._resolver,
    required this._idl,
    required this._overlay,
    required this._elements,
  });

  static Future<WebHostIrBuilder> create({
    required String packageRoot,
    required String webApisJsonPath,
    required String overlayPath,
    required String elementsPath,
  }) async {
    final resolver = await PackageWebResolver.create(packageRoot);

    final idlJson = jsonDecode(
      await File(webApisJsonPath).readAsString(),
    ) as Map<String, dynamic>;
    final overlay = jsonDecode(
      await File(overlayPath).readAsString(),
    ) as Map<String, dynamic>;
    final allowlist = jsonDecode(
      await File(elementsPath).readAsString(),
    ) as Map<String, dynamic>;

    final elements = (allowlist['html'] as List<dynamic>).cast<String>();

    return WebHostIrBuilder._(
      resolver: resolver,
      idl: idlJson,
      overlay: overlay,
      elements: elements,
    );
  }

  List<WebHostElementIR> build() {
    final result = <WebHostElementIR>[];
    final idlSpecs = _idl['idl'] as Map<String, dynamic>;
    final idlByName = _flattenIdl(idlSpecs);

    for (final tag in _elements) {
      final interfaceName = _interfaceName(tag);
      final interface = idlByName[interfaceName];

      if (interface == null) {
        throw StateError(
          'IDL interface "$interfaceName" not found for element "$tag". '
          'Check the allowlist or update web_apis.json.',
        );
      }

      if (!_resolver.containsInterface(interfaceName)) {
        throw StateError(
          'package:web does not export "$interfaceName" required by '
          'element "$tag".',
        );
      }

      final elementType = _resolver.resolveInterface(interfaceName);
      final members = _collectMembers(interface, idlByName);
      final voidElement = _isVoidElement(tag);

      result.add(WebHostElementIR(
        tagName: tag,
        factoryName: _camelCase(tag),
        namespace: WebNamespace.html,
        elementType: elementType,
        voidElement: voidElement,
        props: _buildProps(members),
        events: _buildEvents(),
      ));
    }

    return result;
  }

  Map<String, Map<String, dynamic>> _flattenIdl(Map<String, dynamic> specs) {
    final result = <String, Map<String, dynamic>>{};
    for (final spec in specs.values) {
      if (spec is! List) continue;
      for (final item in spec) {
        if (item is Map<String, dynamic> && item['type'] == 'interface') {
          final name = item['name'] as String;
          final existing = result[name];
          // Prefer entries with inheritance chain (more complete)
          if (existing == null || item['inheritance'] != null) {
            result[name] = item;
          }
        }
      }
    }
    return result;
  }

  static const _tagToInterface = {
    'div': 'HTMLDivElement',
    'span': 'HTMLSpanElement',
    'button': 'HTMLButtonElement',
    'input': 'HTMLInputElement',
    'form': 'HTMLFormElement',
    'label': 'HTMLLabelElement',
    'textarea': 'HTMLTextAreaElement',
    'select': 'HTMLSelectElement',
    'option': 'HTMLOptionElement',
    'a': 'HTMLAnchorElement',
    'img': 'HTMLImageElement',
  };

  String _interfaceName(String tag) =>
      _tagToInterface[tag] ??
      'HTML${tag[0].toUpperCase()}${tag.substring(1)}Element';

  bool _isVoidElement(String tag) =>
      const {'area', 'base', 'br', 'col', 'embed', 'hr', 'img', 'input',
        'link', 'meta', 'param', 'source', 'track', 'wbr'}.contains(tag);

  String _camelCase(String tag) =>
      tag.length == 1
          ? tag
          : tag.contains('-')
              ? tag.split('-').map((s) => s[0].toUpperCase() + s.substring(1)).join()
              : tag;

  Map<String, Map<String, dynamic>> _collectMembers(
    Map<String, dynamic> interface,
    Map<String, Map<String, dynamic>> allIdl,
  ) {
    final members = <String, Map<String, dynamic>>{};

    void walk(String name) {
      final iface = allIdl[name];
      if (iface == null) return;

      final rawMembers = iface['members'] as List<dynamic>? ?? [];
      for (final m in rawMembers) {
        final mm = m as Map<String, dynamic>;
        if (mm['type'] == 'attribute') {
          final attrName = mm['name'] as String;
          if (!members.containsKey(attrName)) {
            members[attrName] = mm;
          }
        }
      }

      final parent = iface['inheritance'] as String?;
      if (parent != null) walk(parent);
    }

    walk(interface['name'] as String);
    return members;
  }

  List<WebHostPropIR> _buildProps(
    Map<String, Map<String, dynamic>> idlMembers,
  ) {
    final renames = _overlay['propertyRenames'] as Map<String, dynamic>? ?? {};
    final globalProps = _overlay['globalProps'] as List<dynamic>? ?? [];
    final globalSet = globalProps.cast<String>().toSet();

    final result = <WebHostPropIR>[];

    for (final entry in idlMembers.entries) {
      final idlName = entry.key;
      final dartName = renames[idlName] as String? ?? idlName;
      final reactName = dartName;

      final mm = entry.value;
      final idlType = mm['idlType'] as Map<String, dynamic>? ?? {};

      final dartType = _resolveIdlType(idlType);

      result.add(WebHostPropIR(
        idlName: idlName,
        dartName: dartName,
        reactName: reactName,
        dartType: dartType,
        required: false,
        clientOnly: false,
        ssrBehavior: _ssrBehavior(idlType),
      ));
    }

    for (final name in globalSet) {
      if (result.any((p) => p.reactName == name)) continue;
      result.add(WebHostPropIR(
        idlName: name,
        dartName: name,
        reactName: name,
        dartType: WebDartType(
          symbol: 'String',
          import: Uri.parse('dart:core'),
          nullable: true,
        ),
        required: false,
        clientOnly: false,
        ssrBehavior: WebSsrBehavior.attribute,
      ));
    }

    return result;
  }

  WebSsrBehavior _ssrBehavior(Map<String, dynamic> idlType) {
    final rawType = idlType['idlType'];
    if (rawType is String && rawType == 'boolean') {
      return WebSsrBehavior.booleanAttribute;
    }
    return WebSsrBehavior.attribute;
  }

  WebDartType _resolveIdlType(Map<String, dynamic> idlType) {
    final rawType = idlType['idlType'];
    final union = idlType['union'] as bool? ?? false;
    final nullable = idlType['nullable'] as bool? ?? false;

    if (union || rawType is List) {
      return WebDartType(
        symbol: 'Object?',
        import: Uri.parse('dart:core'),
        nullable: true,
      );
    }

    final typeStr = rawType as String? ?? 'String';

    if (_resolver.containsInterface(typeStr)) {
      return _resolver.resolveInterface(typeStr);
    }

    final primitive = _primitiveType(typeStr);
    if (primitive != null) return primitive;

    return WebDartType(
      symbol: typeStr,
      import: Uri.parse('dart:core'),
      nullable: nullable,
    );
  }

  WebDartType? _primitiveType(String idlType) {
    return switch (idlType) {
      'DOMString' || 'USVString' || 'ByteString' => WebDartType(
        symbol: 'String',
        import: Uri.parse('dart:core'),
        nullable: false,
      ),
      'boolean' => WebDartType(
        symbol: 'bool',
        import: Uri.parse('dart:core'),
        nullable: false,
      ),
      'long' || 'long long' || 'short' || 'byte' ||
      'unsigned long' || 'unsigned long long' ||
      'unsigned short' || 'unsigned byte' =>
        WebDartType(
          symbol: 'int',
          import: Uri.parse('dart:core'),
          nullable: false,
        ),
      'double' || 'float' || 'unrestricted double' =>
        WebDartType(
          symbol: 'double',
          import: Uri.parse('dart:core'),
          nullable: false,
        ),
      'object' => WebDartType(
        symbol: 'Object',
        import: Uri.parse('dart:core'),
        nullable: false,
      ),
      'undefined' || 'void' => WebDartType(
        symbol: 'void',
        import: Uri.parse('dart:core'),
        nullable: false,
      ),
      _ => null,
    };
  }

  List<WebEventPropIR> _buildEvents() {
    final events = _overlay['events'] as Map<String, dynamic>? ?? {};
    final result = <WebEventPropIR>[];

    for (final entry in events.entries) {
      final domName = entry.key;
      final config = entry.value as Map<String, dynamic>;
      final reactName = config['reactName'] as String;
      final reactEventTypeName = config['eventType'] as String;
      final nativeTypeName = config['nativeType'] as String;

      final reactEventType = _resolver.containsInterface(reactEventTypeName)
          ? _resolver.resolveInterface(reactEventTypeName)
          : WebDartType(
              symbol: reactEventTypeName,
              import: Uri.parse('package:react_web/react_web.dart'),
              nullable: false,
            );

      final nativeEventType = _resolver.resolveInterface(nativeTypeName);

      result.add(WebEventPropIR(
        domEventName: domName,
        reactName: reactName,
        captureName: '${reactName}Capture',
        reactEventType: reactEventType,
        nativeEventType: nativeEventType,
      ));
    }

    return result;
  }
}
