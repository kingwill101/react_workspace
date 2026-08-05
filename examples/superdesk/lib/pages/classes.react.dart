import 'package:react/react.dart';

const idClassesPage = ComponentId('package:superdesk/lib/pages/classes.dart#ClassesPage');

ReactNode ClassesPage({
  required dynamic Function(String) onToast,
  String? key,
  List<ReactNode> children = const []
}) {
  final props = (onToast: onToast);
  return Component(idClassesPage, props, key: key, children: children);
}

