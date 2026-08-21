import 'package:react_bloc/react_bloc.dart' show blocProvider;
import 'package:react_router/react_router.dart';
import 'package:react_riverpod/react_riverpod.dart' show riverpodScope;
import 'package:react_web/react_web.dart' hide link;

import '.generated/bloc_demo.react.dart';
import 'bloc_demo.dart' show blocCounterBloc;
import '.generated/riverpod_demo.react.dart';
import 'riverpod_demo.dart' show riverpodContainer;
import '.generated/todos/todos_ui.react.dart';
import '.generated/zustand_demo.react.dart';

/// `/state/*` section layout: heading, sub-navigation, and an `Outlet` that
/// renders the matched child route.
@reactComponent
ReactNode StateSection(({String title}) props) {
  return div(
    key: 'state-section',
    className: 'section-page',
    children: [
      div(
        key: 'section-head',
        className: 'section-head',
        children: [
          div(
            key: 'kicker',
            className: 'section-kicker',
            children: [const Text('STATE MANAGEMENT')],
          ),
          h2(key: 'section-title', children: [Text(props.title)]),
        ],
      ),
      nav(
        key: 'state-nav',
        className: 'sub-nav',
        children: [
          navLink(
            to: '/state',
            className: 'router-link',
            end: true,
            children: [const Text('Overview')],
          ),
          navLink(
            to: '/state/hooks',
            className: 'router-link',
            children: [const Text('Hooks')],
          ),
          navLink(
            to: '/state/zustand',
            className: 'router-link',
            children: [const Text('Zustand')],
          ),
          navLink(
            to: '/state/riverpod',
            className: 'router-link',
            children: [const Text('Riverpod')],
          ),
          navLink(
            to: '/state/bloc',
            className: 'router-link',
            children: [const Text('Bloc')],
          ),
          navLink(
            to: '/state/todos',
            className: 'router-link',
            children: [const Text('Todos')],
          ),
        ],
      ),
      div(
        key: 'section-outlet',
        className: 'section-outlet',
        children: [outlet()],
      ),
    ],
  );
}

@reactComponent
ReactNode StateOverview(({String title}) props) {
  return div(
    key: 'state-overview',
    className: 'page',
    children: [
      section(
        key: 'overview-copy',
        className: 'surface',
        children: [
          div(
            key: 'kicker',
            className: 'section-kicker',
            children: [const Text('FOUR STRATEGIES')],
          ),
          h2(key: 'title', children: [Text(props.title)]),
          p(
            key: 'copy',
            children: [
              const Text(
                'Each page renders a counter with a different state strategy: '
                'plain React hooks, a zustand store, a Riverpod notifier, and '
                'a bloc. The Todos page persists changes through typed server '
                'actions.',
              ),
            ],
          ),
          div(
            key: 'mini-links',
            className: 'mini-links',
            children: [
              link(to: '/state/hooks', children: [const Text('Hooks →')]),
              link(to: '/state/zustand', children: [const Text('Zustand →')]),
              link(to: '/state/riverpod', children: [const Text('Riverpod →')]),
              link(to: '/state/bloc', children: [const Text('Bloc →')]),
              link(to: '/state/todos', children: [const Text('Todos →')]),
            ],
          ),
        ],
      ),
    ],
  );
}

@reactComponent
ReactNode ZustandPage(({String title}) props) {
  return div(
    key: 'zustand-page',
    className: 'page',
    children: [
      section(
        key: 'zustand-surface',
        className: 'surface demo-surface',
        children: [
          div(
            key: 'kicker',
            className: 'section-kicker',
            children: [const Text('ZUSTAND STORE')],
          ),
          h2(key: 'title', children: [Text(props.title)]),
          ZustandDemo(hidden: true, key: 'zustand'),
        ],
      ),
    ],
  );
}

@reactComponent
ReactNode RiverpodPage(({String title}) props) {
  return div(
    key: 'riverpod-page',
    className: 'page',
    children: [
      section(
        key: 'riverpod-surface',
        className: 'surface demo-surface',
        children: [
          div(
            key: 'kicker',
            className: 'section-kicker',
            children: [const Text('RIVERPOD NOTIFIER')],
          ),
          h2(key: 'title', children: [Text(props.title)]),
          riverpodScope(riverpodContainer, [
            RiverpodDemo(hidden: true, key: 'riverpod'),
          ]),
        ],
      ),
    ],
  );
}

@reactComponent
ReactNode BlocPage(({String title}) props) {
  return div(
    key: 'bloc-page',
    className: 'page',
    children: [
      section(
        key: 'bloc-surface',
        className: 'surface demo-surface',
        children: [
          div(
            key: 'kicker',
            className: 'section-kicker',
            children: [const Text('BLOC')],
          ),
          h2(key: 'title', children: [Text(props.title)]),
          blocProvider(blocCounterBloc, [BlocDemo(hidden: true, key: 'bloc')]),
        ],
      ),
    ],
  );
}

@reactComponent
ReactNode TodosPage(({String title}) props) {
  return div(
    key: 'todos-page',
    className: 'page',
    children: [
      section(
        key: 'todos-surface',
        className: 'surface todos-surface',
        children: [
          errorBoundary(
            onError: (error, _) => print('Todo boundary: $error'),
            fallback: section(
              className: 'surface counter-surface',
              children: [const Text('The todo panel failed to render.')],
            ),
            children: [TodoApp(key: 'todos', title: props.title)],
          ),
        ],
      ),
    ],
  );
}
