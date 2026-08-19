import 'package:react/react.dart';

const idBuilderPage = ComponentId(
  'package:superdesk/lib/pages/builder.dart#BuilderPage',
);

ReactNode BuilderPage({
  required String lessonName,
  required dynamic Function(String) onLessonName,
  required dynamic Function(List<Map<String, dynamic>>) onPhases,
  required dynamic Function(String) onToast,
  required List<Map<String, dynamic>> phases,
  required List<Map<String, dynamic>> resources,
  required List<Map<String, dynamic>> templates,
  String? key,
  List<ReactNode> children = const [],
}) {
  final props = (
    lessonName: lessonName,
    onLessonName: onLessonName,
    onPhases: onPhases,
    onToast: onToast,
    phases: phases,
    resources: resources,
    templates: templates,
  );
  return Component(idBuilderPage, props, key: key, children: children);
}
