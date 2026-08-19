import 'package:analysis_server_plugin/edit/dart/correction_producer.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer_plugin/utilities/change_builder/change_builder_core.dart';
import 'package:analyzer_plugin/utilities/fixes/fixes.dart';

class ReplaceWithPublicApiFix extends ResolvedCorrectionProducer {
  static const _fixKind = FixKind(
    'react.fix.replaceWithPublicApi',
    50,
    'Replace with public API (*.react.dart)',
  );

  ReplaceWithPublicApiFix({required super.context});

  @override
  CorrectionApplicability get applicability =>
      CorrectionApplicability.singleLocation;

  @override
  FixKind get fixKind => _fixKind;

  @override
  Future<void> compute(ChangeBuilder builder) async {
    final node = this.node;
    if (node is ImportDirective) {
      final uri = node.uri.stringValue ?? '';
      final replacement = uri.replaceAll('.react.g.dart', '.react.dart');
      if (replacement != uri) {
        await builder.addDartFileEdit(file, (builder) {
          builder.addSimpleReplacement(node.uri.sourceRange, "'$replacement'");
        });
      }
    }
  }
}
