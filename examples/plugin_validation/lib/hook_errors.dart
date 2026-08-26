import 'package:react_core/react.dart';

// ignore_for_file: unused_local_variable

/// Hook inside conditional — `invalid_hook_call` (`hookInConditional`).
@ReactComponent()
ReactNode HookInConditional(({bool flag}) props) {
  if (props.flag) {
    final state = useState(0); // expect: invalid_hook_call — inside conditional
  }
  return const Text('hi');
}

/// Hook inside loop — `invalid_hook_call` (`hookInLoop`).
@ReactComponent()
ReactNode HookInLoop(({int count}) props) {
  // Using plain Dart loop to keep example simple; analyzer still flags
  // hook ordering via `Block` traversal.
  for (var i = 0; i < props.count; i++) {
    final s = useState(i); // expect: invalid_hook_call — inside loop
  }
  return const Text('hi');
}

/// Hook after early return — `invalid_hook_call` (`hookAfterEarlyReturn`).
@ReactComponent()
ReactNode HookAfterReturn(({bool early}) props) {
  if (props.early) return const Text('early');
  final s = useState(
    0,
  ); // expect: invalid_hook_call — after early return (if early return counted)
  return const Text('hi');
}

/// Hook outside component — `invalid_hook_call` (`hookOutsideComponent`).
void notAComponent() {
  final s = useState(0); // expect: invalid_hook_call — outside component
}

/// Custom hook name check — `customHookInvalidName` if annotated `@ReactHook`
/// but name does not start with `use`.
@ReactHook()
int badHookName() => 0; // expect: customHookInvalidName (when hook annotation present)

/// Correct hook placement — no diagnostic.
@ReactComponent()
ReactNode HookCorrect(({String? placeholder}) props) {
  final count = useState(0);
  final memo = useMemo(() => count.$1 * 2, [count.$1]);
  return Text('$memo');
}
