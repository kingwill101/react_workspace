import 'package:react_web/react_web.dart';
import 'package:react_zustand/react_zustand.dart';

/// Renders a counter backed by a zustand store (see the wrapper package
/// `react_zustand`). SSR renders the store's initial state; the +1 button
/// mutates the store through the hook bridge.
@reactComponent
ReactNode ZustandDemo(({bool hidden}) props) {
  final count = useCount();
  final doubled = useDoubled();

  return div(
    key: 'zustand-demo',
    children: [
      const Text('Count (zustand): '),
      Text('$count'),
      const Text(' — doubled: '),
      Text('$doubled'),
      button(
        key: 'zustand-inc',
        onClick: (_) => inc(),
        children: const [Text('+1')],
      ),
    ],
  );
}
