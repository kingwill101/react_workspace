import 'dart:io';

import 'package:react_web_generator/react_web_generator.dart';

Future<void> main() =>
    WebBindingsGenerator.forWorkspace(Directory.current).generate();
