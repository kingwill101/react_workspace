import 'dart:js_interop';
import 'package:react/react.dart';

/// Counter component demonstrating useState, useEffect, and props.
/// Inline callbacks in Intrinsic props must be explicitly converted with
/// `.toJS` so dart2js retains `get$toJS()` on the closure class.
/// Without the explicit `.toJS`, the tree-shaker removes the method
/// because `toReactJS` calls it through `(f as dynamic).toJS`, which
/// erases the closure type information at compile time.
@reactComponent
ReactNode Counter(({String title, int initialCount, String? subtitle, void Function(int)? onChange}) props)
{
  final (count, setCount) = useState(props.initialCount);
  final (other, setOther) = useState(false);

  useEffect(() {
    setOther(true);
  }, []);

  // Explicit `.toJS` forces dart2js to keep `get$toJS()` on this closure.
  void onClick() {
    final newCount = count + 1;
    setCount(newCount);
    props.onChange?.call(newCount);
  }
  final inc = Intrinsic('button', props: {'onClick': onClick.toJS}, children: [const Text('+1')]);

  final sub = props.subtitle != null ? Text(props.subtitle!) : null;

  return div(children: [
    Text(props.title),
    Text('Count: $count'),
    inc,
    if (sub != null) sub,
    Text(other ? 'effect:ran' : 'effect:pending'),
  ]);
}
