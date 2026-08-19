import 'package:react_web/react_web.dart';

import '.generated/counter.react.dart';

typedef CounterProps = ({
  String title,
  int initialCount,
  String? subtitle,
  void Function(int)? onChange,
});

typedef ForwardedMarkerProps = ({String label});
typedef LazyMarkerProps = ({String label});

final forwardedMarker = forwardRef<ForwardedMarkerProps, dynamic>(
  (props, ref) => div(
    className: 'section-kicker',
    ref: (element) => ref.current = element,
    children: [Text(props.label)],
  ),
);

final lazyMarker = lazy<LazyMarkerProps>(
  () async =>
      (props) =>
          div(className: 'section-kicker', children: [Text(props.label)]),
);

final memoizedCounter = memo<CounterProps>(
  (props) => Counter(
    title: props.title,
    initialCount: props.initialCount,
    subtitle: props.subtitle,
    onChange: props.onChange,
  ),
  arePropsEqual: (previous, next) =>
      previous.title == next.title &&
      previous.initialCount == next.initialCount &&
      previous.subtitle == next.subtitle,
);

/// Interactive hooks: forwardRef, lazy (Suspense), memo, and a full counter
/// built on Dart hooks rendered through React.
@reactComponent
ReactNode HooksPage(({String title}) props) {
  final markerRef = useRef<dynamic>();
  final (showLazy, setShowLazy) = useState(false);

  // renderToString cannot wait for lazy promises. Delay the browser-only
  // transition until hydration has committed so SSR and the first client
  // render have identical markup. See https://react.dev/reference/react/lazy.
  useEffect(() {
    setShowLazy(true);
  }, []);

  return div(
    key: 'hooks-page',
    className: 'page',
    children: [
      section(
        key: 'hooks-surface',
        className: 'surface hooks-surface',
        children: [
          div(
            key: 'kicker',
            className: 'section-kicker',
            children: [const Text('INTERACTIVE STATE')],
          ),
          h2(key: 'title', children: [Text(props.title)]),
          forwardedMarker((label: 'FORWARDED REF'), ref: markerRef),
          if (showLazy)
            suspense(
              fallback: div(
                className: 'section-kicker',
                children: [const Text('LAZY COMPONENT')],
              ),
              children: [lazyMarker((label: 'LAZY COMPONENT'))],
            )
          else
            div(
              className: 'section-kicker',
              children: [const Text('LAZY COMPONENT')],
            ),
          memoizedCounter((
            title: 'Counter',
            initialCount: 0,
            subtitle: 'Dart hooks rendered through React',
            onChange: (_) => print('Counter changed'),
          )),
        ],
      ),
    ],
  );
}
