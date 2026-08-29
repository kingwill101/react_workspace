import 'package:react_router_dom/react_router_dom.dart';
import 'package:react_web/react_web.dart' hide link;

import 'hooks_page.dart' show memoizedCounter;

/// Landing page: hero, quick-link cards to each section, and a live counter
/// to prove the browser bundle mounts and hydrates at `/`.
@reactComponent
ReactNode HomePage(({String title}) props) {
  return div(
    key: 'home',
    className: 'page',
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
                'Typed server actions, streaming-ready SSR, and multi-page '
                'routing — every page rendered by react-router-dom and '
                'hydrated by the client bundle.',
              ),
            ],
          ),
        ],
      ),
      div(
        key: 'explore',
        className: 'explore-grid',
        children: [
          section(
            key: 'card-state',
            className: 'surface explore-card',
            children: [
              div(
                key: 'card-kicker',
                className: 'section-kicker',
                children: [const Text('STATE MANAGEMENT')],
              ),
              h2(
                key: 'card-title',
                children: [const Text('Hooks, zustand, riverpod, bloc')],
              ),
              p(
                key: 'card-copy',
                children: [
                  const Text(
                    'Interact with four state strategies and a full '
                    'server-action todos board.',
                  ),
                ],
              ),
              link(
                to: '/state',
                className: 'card-link',
                children: [const Text('Explore state →')],
              ),
            ],
          ),
          section(
            key: 'card-router',
            className: 'surface explore-card',
            children: [
              div(
                key: 'card-kicker',
                className: 'section-kicker',
                children: [const Text('ROUTING')],
              ),
              h2(
                key: 'card-title',
                children: [const Text('URL params, search, navigation')],
              ),
              p(
                key: 'card-copy',
                children: [
                  const Text(
                    'A router playground exercising useParams, '
                    'useSearchParams, and useNavigate.',
                  ),
                ],
              ),
              link(
                to: '/router',
                className: 'card-link',
                children: [const Text('Explore routing →')],
              ),
            ],
          ),
          section(
            key: 'card-about',
            className: 'surface explore-card',
            children: [
              div(
                key: 'card-kicker',
                className: 'section-kicker',
                children: [const Text('THE TOOLCHAIN')],
              ),
              h2(
                key: 'card-title',
                children: [const Text('How the pieces fit together')],
              ),
              p(
                key: 'card-copy',
                children: [
                  const Text(
                    'What lives in Dart, what stays in npm, and how the two '
                    'sides share one React runtime.',
                  ),
                ],
              ),
              link(
                to: '/about',
                className: 'card-link',
                children: [const Text('Read about →')],
              ),
            ],
          ),
        ],
      ),
      section(
        key: 'home-counter',
        className: 'surface home-counter',
        children: [
          div(
            key: 'counter-kicker',
            className: 'section-kicker',
            children: [const Text('LIVE WIDGET')],
          ),
          memoizedCounter((
            title: 'Quick counter',
            initialCount: 0,
            subtitle: props.title,
            onChange: null,
          )),
        ],
      ),
    ],
  );
}
