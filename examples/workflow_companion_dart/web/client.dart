import 'package:react_dom/react_dom.dart';
import 'package:workflow_companion_dart/.generated/react/app.react.dart';
import 'package:workflow_companion_dart/.generated/react/app_shell.react.dart';
import 'package:workflow_companion_dart/.generated/react_components.g.dart';

void main() {
  initReact();
  registerReactComponents();
  mount(getRoot('app'), AppShell(children: [App(title: 'Workflow Companion')]));
}
