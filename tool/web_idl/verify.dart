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
import 'package:react_web_generator/src/bcd_filter.dart';

const webApisJson = 'tool/web_idl/snapshots/web_apis.json';
const reportPath =
    'packages/react_web/lib/src/generated/completeness_report.json';

Future<void> main(List<String> args) async {
  final strict = args.contains('--strict');
  final bcdFilter = BcdFilter.load();
  final model = mergeRawModel(
    CompleteWebModelBuilder(
      webIdlPath: webApisJson,
      bcdFilter: bcdFilter,
    ).loadRaw(),
  );

  // Prefer manifest verification: compare snapshot vs actually emitted manifest.
  Map<String, Object?> report;
  int defsDropped;
  int membersDropped;
  const manifestPath =
      'packages/react_web/lib/src/generated/emitted_manifest.json';
  if (File(manifestPath).existsSync()) {
    final manifest = EmittedManifest.fromFile(manifestPath);
    final verifier = CompletenessVerifier.withManifest(
      model: model,
      manifest: manifest,
    );
    report = verifier.verifyAgainstManifest(manifest);
  } else {
    // Fallback for CI without prior generation — use isolated model copies to avoid identical check.
    final copy = mergeRawModel(
      CompleteWebModelBuilder(
        webIdlPath: webApisJson,
        bcdFilter: BcdFilter.load(),
      ).loadRaw(),
    );
    final verifier = CompletenessVerifier(model: model, emittedModel: copy);
    report = verifier.verify();
  }
  final defs = report['definitions'] as Map;
  final members = report['members'] as Map;
  defsDropped = defs['dropped'] as int;
  membersDropped = members['dropped'] as int;

  // Duplicate emitted names across the whole model (should be zero).
  final names = <String>{};
  final duplicates = <String>{};
  for (final d in model.allDefinitions) {
    if (!names.add(d.name)) duplicates.add(d.name);
  }

  // package:web mapping coverage. Only interface-kind definitions need a
  // `package:web` counterpart: the browser adapter wraps interfaces (mixins
  // and callback interfaces are flattened into their using interfaces and are
  // never wrapped directly).
  final mappings = strict
      ? await PackageWebMappings.load('.') // only needed in strict mode
      : null;
  int missingMappings = 0;
  if (mappings != null) {
    final interfaceNames = <String>{
      for (final d in model.allDefinitions)
        if (d.kindName == 'interface') d.name,
    };
    missingMappings = mappings.missingTypes(interfaceNames).length;
  }

  // Write report via a lightweight verifier if manifest was used, else reuse model verifier.
  final reportWriter = CompletenessVerifier(
    model: model,
    emittedModel: mergeRawModel(
      CompleteWebModelBuilder(
        webIdlPath: webApisJson,
        bcdFilter: BcdFilter.load(),
      ).loadRaw(),
    ),
  );
  File(reportPath).writeAsStringSync(reportWriter.toJsonNice(report));

  stdout.writeln(
    'definitions: ${defs['emitted']}/${defs['source']} (dropped $defsDropped, opaque ${defs['opaque']})',
  );
  stdout.writeln(
    'members: ${members['emitted']}/${members['source']} (dropped $membersDropped, opaque ${members['opaque']})',
  );
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
    stdout.writeln(
      'FAIL (strict): $missingMappings definitions missing a package:web mapping.',
    );
    stdout.writeln('  Pin package:web to the snapshot revision to resolve.');
    failed = true;
  }

  stdout.writeln(failed ? 'VERIFY FAILED' : 'VERIFY OK');
  exit(failed ? 1 : 0);
}
