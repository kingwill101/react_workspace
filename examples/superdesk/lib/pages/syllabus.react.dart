import 'package:react/react.dart';

const idSyllabusPage = ComponentId('package:superdesk/lib/pages/syllabus.dart#SyllabusPage');

ReactNode SyllabusPage({
  required List<Map<String, dynamic>> classes,
  required List<String> expandedUnits,
  required dynamic Function(String) onSelect,
  required dynamic Function(String) onToast,
  required dynamic Function(String) onToggle,
  required String selectedSyllabus,
  required List<Map<String, dynamic>> syllabuses,
  required List<Map<String, dynamic>> units,
  String? key,
  List<ReactNode> children = const []
}) {
  final props = (classes: classes, expandedUnits: expandedUnits, onSelect: onSelect, onToast: onToast, onToggle: onToggle, selectedSyllabus: selectedSyllabus, syllabuses: syllabuses, units: units);
  return Component(idSyllabusPage, props, key: key, children: children);
}

