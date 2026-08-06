import 'package:react/react.dart';

/// Valid component — single named-record param, returns ReactNode.
/// Plugin: no `invalid_react_component`. Generator: emits `.react.dart` pair.
@ReactComponent()
ReactNode Greeting(({String name}) props) {
  return Text('Hello ${props.name}');
}

/// Valid component with children and optional prop.
@ReactComponent()
ReactNode Card(({String title, String? subtitle, ReactNode? children}) props) {
  return Text(props.title);
}
