import 'package:analysis_server_plugin/edit/dart/correction_producer.dart';
import 'package:analyzer_plugin/utilities/assist/assist.dart';
import 'package:analyzer_plugin/utilities/change_builder/change_builder_core.dart';

class ConvertToReactComponentAssist extends ResolvedCorrectionProducer {
  static const _assistKind = AssistKind(
    'react.assist.convertToReactComponent',
    30,
    "Convert to React component",
  );

  ConvertToReactComponentAssist({required super.context});

  @override
  CorrectionApplicability get applicability => CorrectionApplicability.singleLocation;

  @override
  AssistKind get assistKind => _assistKind;

  @override
  Future<void> compute(ChangeBuilder builder) async {
    final node = this.node;
    await builder.addDartFileEdit(file, (builder) {
      builder.addInsertion(node.offset, (builder) {
        builder.write('@ReactComponent()\n');
      });
    });
  }
}
