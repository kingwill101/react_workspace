import 'package:react/react.dart';

const idSettingsPage = ComponentId('package:superdesk/lib/pages/settings.dart#SettingsPage');

ReactNode SettingsPage({
  required dynamic Function() onLogout,
  required dynamic Function() onReset,
  Map<String, dynamic>? user,
  String? key,
  List<ReactNode> children = const []
}) {
  final props = (onLogout: onLogout, onReset: onReset, user: user);
  return Component(idSettingsPage, props, key: key, children: children);
}

