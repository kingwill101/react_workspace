import 'package:react/react.dart';

const idSyllabusPage = ComponentId('package:superdesk/lib/pages/syllabus.dart#SyllabusPage');

ReactNode SyllabusPage({
  required List<String> expandedUnits,
  required dynamic Function(String) onSelect,
  required dynamic Function(String) onToast,
  required dynamic Function(String) onToggle,
  required String selectedSyllabus,
  String? key,
  List<ReactNode> children = const []
}) {
  final props = (expandedUnits: expandedUnits, onSelect: onSelect, onToast: onToast, onToggle: onToggle, selectedSyllabus: selectedSyllabus);
  return Component(idSyllabusPage, props, key: key, children: children);
}

