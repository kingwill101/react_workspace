// GENERATED CODE - DO NOT EDIT
// ignore_for_file: type=lint

import 'package:react_server/react_server.dart';

import 'greeting.action.g.dart';
import 'greeting.dart';

void registerGreeting({
  required ServerFunctionRegistry registry,
}) {
  registry.register(
    greetRef,
    (({String name}) args, ServerFunctionContext context) async {
      return await greet(context, name: args.name);
    },
  );

}
