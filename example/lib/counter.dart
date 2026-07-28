import 'package:react/react.dart';

/// Counter component demonstrating useState, useEffect, and props.
/// Note: inline callbacks (onClick) in Intrinsic props are only useful
/// for client-side hydration. dart2js tree-shakes the .toJS conversion
/// from closures during SSR compilation (the `get$toJS` method is
/// not retained). Callbacks still work in the browser via the
/// generated JS bridge.
@reactComponent
ReactNode Counter(({String title, int initialCount, String? subtitle, void Function(int)? onChange}) props)
{
  final (count, setCount) = useState(props.initialCount);
  final (other, setOther) = useState(false);

  useEffect(() {
    setOther(true);
  }, []);

  final inc = Intrinsic('button', children: [Text('+1')]);

  final sub = props.subtitle != null ? Text(props.subtitle!) : null;

  return div(children: [
    Text(props.title),
    Text('Count: $count'),
    inc,
    if (sub != null) sub,
    Text(other ? 'effect:ran' : 'effect:pending'),
  ]);
}
