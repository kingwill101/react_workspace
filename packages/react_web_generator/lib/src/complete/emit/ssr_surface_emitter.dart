/// Emits the SSR throwing surface: an `Ssr<Name>` class for every interface that
/// implements the neutral interface, with every member throwing
/// [UnsupportedWebApiError], plus an `SsrWebRuntime` that installs it.
///
/// Declarations are identical between browser and SSR; only the runtime
/// behaviour differs.
library;

import 'dart:io';

import '../definition.dart';
import '../member.dart';
import '../members.dart';
import '../model.dart';
import '../type_resolver.dart';

final class SsrSurfaceEmitter {
  final CompleteWebModel model;
  final NeutralTypeResolver _resolver;

  SsrSurfaceEmitter(this.model) : _resolver = NeutralTypeResolver(model);

  void emitTo(String outputDir) {
    final buf = StringBuffer();
    buf.writeln('// GENERATED CODE — DO NOT EDIT');
    buf.writeln('// SSR throwing surface: every live Web API throws at runtime.');
    buf.writeln('// ignore_for_file: unused_local_variable');
    buf.writeln();
    buf.writeln("import 'package:react_web/src/web_runtime.dart';");
    buf.writeln("import 'package:react_web/src/generated/web/web.dart';", );
    buf.writeln();

    for (final iface in model.interfaces.values.toList()
      ..sort((a, b) => a.name.compareTo(b.name))) {
      _emitSsrClass(buf, iface);
    }
    _emitRuntime(buf);

    final dir = Directory(outputDir);
    dir.createSync(recursive: true);
    File('${dir.path}/ssr.dart').writeAsStringSync(buf.toString());
  }

  String? _exposed(IdlInterface d) {
    for (final e in d.extAttrs) {
      if (e.name == 'Exposed') return e.rhs;
    }
    return null;
  }

  // Same dedup as the neutral emitter so signatures line up.
  List<IdlMember> _flattened(IdlInterface d) {
    final members = flattenMembers(model, d);
    final ops = <String, IdlOperation>{};
    final order = <IdlMember>[];
    for (final m in members) {
      if (m is IdlOperation) {
        final ex = ops[m.name];
        if (ex == null || m.parameters.length > ex.parameters.length) {
          ops[m.name] = m;
        }
        if (!order.any((e) => e is IdlOperation && e.name == m.name)) {
          order.add(m);
        }
      } else if (m is IdlAttribute) {
        order.add(m);
      } else if (m is IdlIterable || m is IdlMaplike || m is IdlSetlike) {
        order.add(m);
      }
    }
    // Replace each operation with its representative (max-parameter) overload
    // so SSR overrides match the neutral interface exactly.
    return order.map((m) => m is IdlOperation ? ops[m.name]! : m).toList();
  }

  void _emitSsrClass(StringBuffer buf, IdlInterface d) {
    final name = d.name;
    final exposed = _exposed(d);
    buf.writeln('final class Ssr$name implements $name {');

    // Constructors.
    final ctors = d.members.whereType<IdlConstructor>().toList();
    if (ctors.isNotEmpty) {
      int i = 0;
      for (final c in ctors) {
        final params = _factoryParams(c.parameters);
        if (i == 0) {
          buf.writeln('  factory Ssr$name($params) {');
        } else {
          buf.writeln('  factory Ssr$name.named$i($params) {');
        }
        buf.writeln("    throw UnsupportedWebApiError('$name constructor'");
        if (exposed != null) {
          buf.writeln("      , exposed: '$exposed'");
        }
        buf.writeln('    );');
        buf.writeln('  }');
        i++;
      }
    } else {
      buf.writeln('  factory Ssr$name() {');
      buf.writeln("    throw UnsupportedWebApiError('$name constructor'");
      if (exposed != null) {
        buf.writeln("      , exposed: '$exposed'");
      }
      buf.writeln('    );');
      buf.writeln('  }');
    }

    for (final m in _flattened(d)) {
      final api = '$name.${m.name}';
      switch (m) {
        case IdlAttribute():
          final t = _resolver.resolve(m.type);
          final n = escapeIdentifier(m.name);
          buf.writeln('  @override');
          buf.writeln("  $t get $n => throw UnsupportedWebApiError('$api'");
          if (exposed != null) {
            buf.writeln("      , exposed: '$exposed'");
          }
          buf.writeln('  );');
          if (!m.readonly) {
            buf.writeln('  @override');
            buf.writeln("  set $n($t value) => throw UnsupportedWebApiError('$api'");
            if (exposed != null) {
              buf.writeln("      , exposed: '$exposed'");
            }
            buf.writeln('  );');
          }
          continue;
        case IdlOperation():
          if (m.name.isEmpty) continue;
          if (m.name == _resolver.resolve(m.returnType)) continue;
          final t = _resolver.resolve(m.returnType);
          final n = escapeIdentifier(m.name);
          buf.writeln('  @override');
          buf.writeln("  $t $n(${_paramStr(m.parameters)}) => throw UnsupportedWebApiError('$api'");
          if (exposed != null) {
            buf.writeln("      , exposed: '$exposed'");
          }
          buf.writeln('  );');
          continue;
        case IdlIterable():
          final names = m.types.map(_resolver.resolve).toList();
          if (m.types.length >= 2) {
            buf.writeln('  @override');
            buf.writeln("  Iterable<(${names[0]}, ${names[1]})> get entries => throw UnsupportedWebApiError('$api.entries');");
            buf.writeln('  @override');
            buf.writeln("  Iterable<${names[0]}> get keys => throw UnsupportedWebApiError('$api.keys');");
            buf.writeln('  @override');
            buf.writeln("  Iterable<${names[1]}> get values => throw UnsupportedWebApiError('$api.values');");
          } else {
            buf.writeln('  @override');
            buf.writeln("  Iterable<${names.first}> get values => throw UnsupportedWebApiError('$api.values');");
          }
          continue;
        case IdlMaplike():
          final k = _resolver.resolve(m.keyType);
          final v = _resolver.resolve(m.valueType);
          buf.writeln('  @override');
          buf.writeln("  Iterable<$k> get keys => throw UnsupportedWebApiError('$api.keys');");
          buf.writeln('  @override');
          buf.writeln("  Iterable<$v> get values => throw UnsupportedWebApiError('$api.values');");
          buf.writeln('  @override');
          buf.writeln("  Iterable<MapEntry<$k, $v>> get entries => throw UnsupportedWebApiError('$api.entries');");
          buf.writeln('  @override');
          buf.writeln("  $v? operator [](Object key) => throw UnsupportedWebApiError('$api.[]');");
          buf.writeln('  @override');
          buf.writeln("  bool has(Object key) => throw UnsupportedWebApiError('$api.has');");
          continue;
        case IdlSetlike():
          final v = _resolver.resolve(m.valueType);
          buf.writeln('  @override');
          buf.writeln("  Iterable<$v> get values => throw UnsupportedWebApiError('$api.values');");
          buf.writeln('  @override');
          buf.writeln("  bool has(Object value) => throw UnsupportedWebApiError('$api.has');");
          continue;
        case IdlConstant():
          buf.writeln('  @override');
          buf.writeln("  ${_resolver.resolve(m.type)} get ${escapeIdentifier(m.name)} => throw UnsupportedWebApiError('$api');");
          continue;
        case IdlField():
        case IdlConstructor():
          continue;
      }
    }

    buf.writeln('}');
    buf.writeln();
  }

  String _factoryParams(List parameters) {
    // factory params must be named or positional; use positional-wrapped optional
    final required = <String>[];
    final optional = <String>[];
    for (final p in parameters) {
      final name = escapeIdentifier((p as IdlParameter).name.isEmpty ? 'arg' : p.name);
      var t = _resolver.resolve((p).type);
      if (!p.required) {
        if (!t.endsWith('?')) t = '$t?';
        optional.add('$t $name');
      } else {
        required.add('$t $name');
      }
    }
    final parts = <String>[];
    if (required.isNotEmpty) parts.add(required.join(', '));
    if (optional.isNotEmpty) parts.add('[${optional.join(', ')}]');
    return parts.join(', ');
  }

  String _paramStr(List<IdlParameter> params) {
    final required = <String>[];
    final optional = <String>[];
    for (var i = 0; i < params.length; i++) {
      final p = params[i];
      final name = escapeIdentifier(p.name.isEmpty ? 'arg$i' : p.name);
      var t = _resolver.resolve(p.type);
      if (p.variadic && !t.endsWith('List')) t = 'List<$t>';
      if (!p.required || p.variadic) {
        if (!t.endsWith('?')) t = '$t?';
        optional.add('$t $name');
      } else {
        required.add('$t $name');
      }
    }
    final parts = <String>[];
    if (required.isNotEmpty) parts.add(required.join(', '));
    if (optional.isNotEmpty) parts.add('[${optional.join(', ')}]');
    return parts.join(', ');
  }

  void _emitRuntime(StringBuffer buf) {
    buf.writeln('/// SSR runtime: most live Web APIs throw; host elements are handled');
    buf.writeln('/// by the virtual host-node pipeline.');
    buf.writeln('final class SsrWebRuntime implements WebRuntime {');
    buf.writeln('  const SsrWebRuntime();');
    buf.writeln('  @override');
    buf.writeln("  Window get window => throw UnsupportedWebApiError('Window', exposed: 'Window');");
    buf.writeln('  @override');
    buf.writeln("  Document get document => throw UnsupportedWebApiError('Document', exposed: 'Window');");
    buf.writeln('  @override');
    buf.writeln("  Navigator get navigator => throw UnsupportedWebApiError('Navigator', exposed: 'Window');");
    buf.writeln('}');
  }
}
