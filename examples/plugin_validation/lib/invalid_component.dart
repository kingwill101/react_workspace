import 'package:react_core/react.dart';

// ignore_for_file: unused_element

/// Each function below should trigger `invalid_react_component` live.
/// The same diagnostics are thrown by `react_codegen` via the shared
/// `ReactComponentAnalyzer` — plugin and generator never diverge.

// 1. Must return ReactNode.
// expect: invalid_react_component — must return ReactNode
@ReactComponent()
String BadReturn(({String name}) props) => 'Hello ${props.name}';

// 2. Cannot be generic.
// expect: invalid_react_component — cannot be generic
@ReactComponent()
ReactNode BadGeneric<T>(({T value}) props) => Text('${props.value}');

// 3. Must accept exactly one record param.
// expect: invalid_react_component — must accept exactly one record parameter
@ReactComponent()
ReactNode BadArity(String name, int count) => Text(name);

// 4. Props must use named fields.
// expect: invalid_react_component — must use named record fields
@ReactComponent()
ReactNode BadPositional((String, int) props) => Text(props.$1);

// 5. Duplicate component ID would also flag `duplicate_component_id`
// (library-scoped check in `ReactComponentAnalyzer`).

// Quick fix: add `@ReactComponent()` or change return to `ReactNode`.
// Assist: ConvertToReactComponentAssist
ReactNode PlainFunction(({String name}) props) => Text(props.name);
