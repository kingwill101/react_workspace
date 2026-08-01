import 'package:react_web/react_web.dart';
import 'app_context.dart';
import 'counter.react.dart';
import 'todos/todos_ui.react.dart';

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

@reactComponent
ReactNode App(({String title}) props) {
  final markerRef = useRef<dynamic>();
  final (showLazy, setShowLazy) = useState(false);

  // renderToString cannot wait for lazy promises. Delay the browser-only
  // transition until hydration has committed so SSR and the first client
  // render have identical markup. See https://react.dev/reference/react/lazy.
  useEffect(() {
    setShowLazy(true);
  }, []);

  return appAccentContext.provider('#7257ff', [
    div(
      className: 'app-shell',
      children: [
        header(
          key: 'header',
          className: 'app-header',
          children: [
            div(
              key: 'brand',
              className: 'brand-lockup',
              children: [
                div(
                  key: 'brand-mark',
                  className: 'brand-mark',
                  children: [const Text('RD')],
                ),
                div(
                  key: 'brand-copy',
                  children: [
                    strong(
                      key: 'brand-name',
                      children: [const Text('React Dart')],
                    ),
                    div(
                      key: 'brand-caption',
                      className: 'brand-caption',
                      children: [
                        const Text('server functions · SSR · typed DOM'),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            span(
              key: 'status',
              className: 'status-pill',
              children: [const Text('LIVE DEMO')],
            ),
          ],
        ),
        main(
          key: 'main',
          children: [
            section(
              key: 'hero',
              className: 'hero',
              children: [
                div(
                  key: 'eyebrow',
                  className: 'eyebrow',
                  children: [const Text('A Dart-first React workspace')],
                ),
                h1(
                  key: 'headline',
                  children: [
                    const Text('Build interfaces with '),
                    span(
                      key: 'hero-accent',
                      className: 'hero-accent',
                      children: [const Text('real React')],
                    ),
                    const Text('.'),
                  ],
                ),
                p(
                  key: 'hero-copy',
                  className: 'hero-copy',
                  children: [
                    const Text(
                      'Typed server actions, streaming-ready SSR, and familiar web styling in one small project.',
                    ),
                  ],
                ),
              ],
            ),
            div(
              key: 'dashboard',
              className: 'dashboard-grid',
              children: [
                section(
                  key: 'counter',
                  className: 'surface counter-surface',
                  children: [
                    div(
                      key: 'counter-kicker',
                      className: 'section-kicker',
                      children: [const Text('INTERACTIVE STATE')],
                    ),
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
                    strictMode([
                      memoizedCounter((
                        title: 'Counter',
                        initialCount: 0,
                        subtitle: 'Dart hooks rendered through React',
                        onChange: (_) => print('Counter changed'),
                      )),
                    ]),
                  ],
                ),
                errorBoundary(
                  onError: (error, _) => print('Todo boundary: $error'),
                  fallback: section(
                    className: 'surface counter-surface',
                    children: [const Text('The todo panel failed to render.')],
                  ),
                  children: [TodoApp(key: 'todos', title: 'Todos')],
                ),
              ],
            ),
          ],
        ),
        footer(
          key: 'footer',
          className: 'app-footer',
          children: [
            const Text('Rendered with React Dart'),
            span(key: 'footer-separator', children: [const Text('•')]),
            const Text('Actions execute on the server'),
          ],
        ),
      ],
    ),
  ]);
}
