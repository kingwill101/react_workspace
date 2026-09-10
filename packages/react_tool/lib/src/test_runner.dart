import 'dart:io';

import 'package:coverage/coverage.dart';
import 'package:path/path.dart' as p;

/// Converts only this test invocation's coverage into a project-local report.
Future<File> writeTestLcov(Directory input, Directory project) async {
  final files = await input
      .list(recursive: true)
      .where((entry) => entry is File && entry.path.endsWith('.json'))
      .cast<File>()
      .toList();
  if (files.isEmpty) {
    throw StateError('The test runner produced no coverage JSON files.');
  }
  // coverage resolves source URIs through symlinks. Match its physical paths
  // when filtering and relativizing, including checkouts opened via an alias.
  final projectPath = await project.resolveSymbolicLinks();
  final hits = await HitMap.parseFiles(files, packagePath: projectPath);
  final resolver = await Resolver.create(packagePath: projectPath);
  final output = File(p.join(project.path, 'coverage', 'lcov.info'));
  await output.parent.create(recursive: true);
  await output.writeAsString(
    hits.formatLcov(
      resolver,
      reportOn: [p.join(projectPath, 'lib')],
      basePath: projectPath,
    ),
  );
  return output;
}

/// Constructs the Dart invocation, preserving arguments after `--` verbatim.
List<String> dartTestArguments({
  String? path,
  List<String> forwarded = const [],
  String? coverageDirectory,
}) => [
  'test',
  ?path,
  ...forwarded,
  if (coverageDirectory != null) ...['--coverage', coverageDirectory],
];
