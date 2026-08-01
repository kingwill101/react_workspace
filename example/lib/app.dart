import 'package:react_web/react_web.dart';
import 'counter.react.dart';
import 'todos/todos_ui.react.dart';

@reactComponent
ReactNode App(({String title}) props) => div(
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
                strong(key: 'brand-name', children: [const Text('React Dart')]),
                div(
                  key: 'brand-caption',
                  className: 'brand-caption',
                  children: [const Text('server functions · SSR · typed DOM')],
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
                Counter(
                  key: 'counter-component',
                  title: 'Counter',
                  initialCount: 0,
                  subtitle: 'Dart hooks rendered through React',
                  onChange: (_) => print('Counter changed'),
                ),
              ],
            ),
            TodoApp(key: 'todos', title: 'Todos'),
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
);
