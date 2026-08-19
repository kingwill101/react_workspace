// GENERATED CODE - DO NOT EDIT
// ignore_for_file: type=lint

import 'package:react_actions/react_actions.dart';

// ------------------------------------------------------------------
// Codecs
// ------------------------------------------------------------------

final class _$greet_argsCodec extends ServerFunctionJsonCodec<({String name})> {
  @override
  ({String name}) decode(dynamic json) {
    if (json == null || json is! Map) json = <String, dynamic>{};
    final m = json as Map<String, dynamic>;
    final name = m['name'] as String;
    return (name: name);
  }

  @override
  Map<String, dynamic> encode(({String name}) value) {
    return {
      'name': value.name,
    };
  }
}


final class _$greet_resultCodec extends ServerFunctionJsonCodec<String> {
  @override
  String decode(dynamic json) {
    return json as String;
  }
  @override
  dynamic encode(String value) {
    return value;
  }
}


// ------------------------------------------------------------------
// Refs
// ------------------------------------------------------------------

final greetRef = ServerFunctionRef<
  ({String name}), String>(
  id: ServerFunctionId('package:example/greeting.dart#greet'),
  contractHash: '6a716eca241c0cd657f1fe59d3217a085713d83e601b2526eea412161e8cfe04',
  argumentsCodec: _$greet_argsCodec(),
  resultCodec: _$greet_resultCodec(),
);
