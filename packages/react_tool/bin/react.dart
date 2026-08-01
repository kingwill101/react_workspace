import 'dart:io';

import 'package:artisanal/args.dart';
import 'package:react_tool/react_tool.dart';

Future<void> main(List<String> args) async {
  try {
    await runReactTool(args);
  } on UsageException catch (error) {
    stderr.writeln(error.message);
    stderr.writeln(error.usage);
    exitCode = 64;
  } on ReactToolException catch (error) {
    stderr.writeln('react: $error');
    exitCode = 1;
  } on ProcessException catch (error) {
    stderr.writeln('react: ${error.message}');
    exitCode = 1;
  }
}
