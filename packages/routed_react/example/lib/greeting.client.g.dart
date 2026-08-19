// GENERATED CODE - DO NOT EDIT
// ignore_for_file: type=lint

import 'package:react_actions/react_actions.dart';
import 'greeting.action.g.dart';

/// Invokes the server function `#greet`.
///
/// Must be called from within a browser context where a
/// [ServerFunctionClient] has been configured via
/// `runWithServerFunctionClient`.
///
/// Throws [RemoteServerFunctionException] on server errors,
/// [ServerFunctionTransportException] on network failures.
Future<String> greetAction({
  required String name,
}) async {
  final client = currentServerFunctionClient;
  return client.invoke(
    greetRef,
    (name: name),
  );
}
