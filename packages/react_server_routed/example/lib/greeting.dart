import 'package:react_actions/react_actions.dart';
import 'package:react_server/react_server.dart';

/// A server function: the implementation runs only on the server, invoked
/// from the browser through the generated client in
/// `.generated/greeting.client.g.dart`.
///
/// The manual `greetRef` below lets `test/greeting_test.dart` run with
/// `ServerFunctionHarness` immediately after `dart pub get` without first
/// running `dart run build_runner build`. The generated
/// `.generated/greeting.action.g.dart`/`.generated/greeting.client.g.dart`
/// will replace/augment this
/// when you run codegen.
@serverFunction
Future<String> greet(
  ServerFunctionContext context, {
  required String name,
}) async {
  // Simulate async I/O.
  await Future.delayed(const Duration(milliseconds: 5));
  return 'Hello, $name! The server answered at '
      '${DateTime.now().toIso8601String()}.';
}
