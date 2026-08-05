import 'package:react/react.dart';

const idDashboardPage = ComponentId('package:superdesk/lib/pages/dashboard.dart#DashboardPage');

ReactNode DashboardPage({
  required List<Map<String, dynamic>> classes,
  required List<Map<String, dynamic>> lessons,
  required dynamic Function(String) onNavigate,
  required dynamic Function(String) onToast,
  required List<Map<String, dynamic>> syllabuses,
  required List<Map<String, dynamic>> templates,
  required List<Map<String, dynamic>> units,
  Map<String, dynamic>? user,
  String? key,
  List<ReactNode> children = const []
}) {
  final props = (classes: classes, lessons: lessons, onNavigate: onNavigate, onToast: onToast, syllabuses: syllabuses, templates: templates, units: units, user: user);
  return Component(idDashboardPage, props, key: key, children: children);
}

