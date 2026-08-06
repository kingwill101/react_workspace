import 'package:analysis_server_plugin/edit/dart/correction_producer.dart';
import 'package:analyzer_plugin/utilities/change_builder/change_builder_core.dart';
import 'package:analyzer_plugin/utilities/fixes/fixes.dart';

class AddClientOnlyFix extends ResolvedCorrectionProducer {
  static const _fixKind = FixKind(
    'react.fix.addClientOnly',
    50,
    "Add @ClientOnly to this component",
  );

  AddClientOnlyFix({required super.context});

  @override
  CorrectionApplicability get applicability => CorrectionApplicability.singleLocation;

  @override
  FixKind get fixKind => _fixKind;

  @override
  Future<void> compute(ChangeBuilder builder) async {
    final node = this.node;
    // Insert @ClientOnly above the function; minimal placeholder.
    await builder.addDartFileEdit(file, (builder) {
      builder.addInsertion(node.offset, (builder) {
        builder.write('@ClientOnly()\n');
      });
    });
  }
}
