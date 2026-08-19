import 'package:react/react.dart';

const idSettingsPage = ComponentId(
  'package:superdesk/lib/pages/settings.dart#SettingsPage',
);

ReactNode SettingsPage({
  required dynamic Function() onExport,
  required dynamic Function(String) onImport,
  required dynamic Function() onLogout,
  required dynamic Function() onReset,
  required dynamic Function(String) onToast,
  Map<String, dynamic>? user,
  String? key,
  List<ReactNode> children = const [],
}) {
  final props = (
    onExport: onExport,
    onImport: onImport,
    onLogout: onLogout,
    onReset: onReset,
    onToast: onToast,
    user: user,
  );
  return Component(idSettingsPage, props, key: key, children: children);
}
