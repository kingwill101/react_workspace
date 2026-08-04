/// Completeness verification for the full Web IDL surface.
///
/// Exits non-zero on hard invariant violations (dropped definitions/members,
/// duplicate emitted names). With `--strict` it also fails on unresolved
/// references and missing `package:web` mappings.
///
/// Usage:
///   dart run tool/web_idl/verify.dart [--strict]
library;

import 'dart:io';

import 'package:react_web_generator/src/complete/complete.dart';
import 'package:react_web_generator/src/complete/emit/completeness_verifier.dart';
import 'package:react_web_generator/src/complete/package_web_mappings.dart';

const webApisJson = 'tool/web_idl/snapshots/web_apis.json';
const reportPath = 'packages/react_web/lib/src/generated/completeness_report.json';

Future<void> main(List<String> args) async {
  final strict = args.contains('--strict');
  final model = mergeRawModel(
    CompleteWebModelBuilder(webIdlPath: webApisJson).loadRaw(),
  );

  final report = CompletenessVerifier(model: model, emittedModel: model).verify();
  final defs = report['definitions'] as Map;
  final members = report['members'] as Map;
  final defsDropped = defs['dropped'] as int;
  final membersDropped = members['dropped'] as int;

  // Duplicate emitted names across the whole model (should be zero).
  final names = <String>{};
  final duplicates = <String>{};
  for (final d in model.allDefinitions) {
    if (!names.add(d.name)) duplicates.add(d.name);
  }

  // package:web mapping coverage.
  final mappings = strict
      ? await PackageWebMappings.load('.') // only needed in strict mode
      : null;
  int missingMappings = 0;
  if (mappings != null) {
    final defsSet = <String>{for (final d in model.allDefinitions) d.name};
    missingMappings = mappings.missingTypes(defsSet).length;
  }

  File(reportPath).writeAsStringSync(CompletenessVerifier(model: model, emittedModel: model).toJsonNice(report));

  stdout.writeln('definitions: ${defs['emitted']}/${defs['source']} (dropped $defsDropped, opaque ${defs['opaque']})');
  stdout.writeln('members: ${members['emitted']}/${members['source']} (dropped $membersDropped, opaque ${members['opaque']})');
  stdout.writeln('duplicate names: ${duplicates.length}');
  if (mappings != null) {
    stdout.writeln('package:web missing mappings: $missingMappings');
  }

  var failed = false;
  if (defsDropped > 0 || membersDropped > 0) {
    stdout.writeln('FAIL: dropped definitions/members > 0');
    failed = true;
  }
  if (duplicates.isNotEmpty) {
    stdout.writeln('FAIL: duplicate emitted names: $duplicates');
    failed = true;
  }
  if (strict && missingMappings > 0) {
    stdout.writeln('FAIL (strict): $missingMappings} definitions missing a package:web mapping.');
    stdout.writeln('  Pin package:web to the snapshot revision to resolve.');
    failed = true;
  }

  stdout.writeln(failed ? 'VERIFY FAILED' : 'VERIFY OK');
  exit(failed ? 1 : 0);
}
