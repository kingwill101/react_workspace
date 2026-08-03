import 'package:react_router/react_router.dart';
import 'package:react_router/react_router_hooks.dart'; // JS-only hooks
import 'package:react_web/react_web.dart' hide link; // <link> collides with router Link

import 'route_item.react.dart';

/// `/router/*` section layout: heading, sub-navigation, and an `Outlet` that
/// renders the matched child route.
@reactComponent
ReactNode RouterSection(({String title}) props) {
  return div(
    key: 'router-section',
    className: 'section-page',
    children: [
      div(
        key: 'section-head',
        className: 'section-head',
        children: [
          div(
            key: 'kicker',
            className: 'section-kicker',
            children: [const Text('ROUTING')],
          ),
          h2(key: 'section-title', children: [Text(props.title)]),
        ],
      ),
      nav(
        key: 'router-nav',
        className: 'sub-nav',
        children: [
          navLink(
            to: '/router',
            className: 'router-link',
            end: true,
            children: [const Text('Overview')],
          ),
          navLink(to: '/router/items/7', className: 'router-link', children: [
            const Text('Item 7'),
          ]),
          navLink(
            to: '/router/search?q=hydrated',
            className: 'router-link',
            children: [const Text('Search')],
          ),
          navLink(
            to: '/router/programmatic',
            className: 'router-link',
            children: [const Text('Programmatic')],
          ),
          navLink(
            to: '/router/redirect',
            className: 'router-link',
            children: [const Text('Redirect')],
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
ReactNode RouterOverview(({String title}) props) {
  final location = useLocation();
  final navigationType = useNavigationType();

  return div(
    key: 'router-overview',
    className: 'page',
    children: [
      section(
        key: 'overview-surface',
        className: 'surface',
        children: [
          div(
            key: 'kicker',
            className: 'section-kicker',
            children: [const Text('CURRENT LOCATION')],
          ),
          h2(key: 'title', children: [Text(props.title)]),
          div(
            key: 'location',
            className: 'router-location',
            children: [Text('location: ${location.fullPath}')],
          ),
          p(
            key: 'nav-type',
            children: [Text('navigation type: ${navigationType.value}')],
          ),
          div(
            key: 'mini-links',
            className: 'mini-links',
            children: [
              link(to: '/router/items/42', children: [
                const Text('View item 42 →'),
              ]),
              link(to: '/router/search?q=dart', children: [
                const Text('Search for "dart" →'),
              ]),
              link(to: '/router/programmatic', children: [
                const Text('Programmatic navigation →'),
              ]),
            ],
          ),
        ],
      ),
    ],
  );
}

@reactComponent
ReactNode ItemPage(({String title}) props) {
  return div(
    key: 'item-page',
    className: 'page',
    children: [
      section(
        key: 'item-surface',
        className: 'surface',
        children: [
          div(
            key: 'kicker',
            className: 'section-kicker',
            children: [const Text('URL PARAMS')],
          ),
          h2(key: 'title', children: [Text(props.title)]),
          ItemDetail(hidden: true),
        ],
      ),
    ],
  );
}

@reactComponent
ReactNode SearchDemo(({String title}) props) {
  final (params, setParams) = useSearchParams();
  final q = params['q'] ?? '';

  return div(
    key: 'search-page',
    className: 'page',
    children: [
      section(
        key: 'search-surface',
        className: 'surface',
        children: [
          div(
            key: 'kicker',
            className: 'section-kicker',
            children: [const Text('SEARCH PARAMS')],
          ),
          h2(key: 'title', children: [Text(props.title)]),
          div(
            key: 'query',
            className: 'router-location',
            children: [Text('q = "${q.isEmpty ? '(empty)' : q}"')],
          ),
          div(
            key: 'controls',
            className: 'counter-actions',
            children: [
              button(
                key: 'q-dart',
                className: 'primary-button',
                onClick: (_) => setParams(<String, String>{'q': 'dart'}),
                children: const [Text('Set q=dart')],
              ),
              button(
                key: 'q-react',
                className: 'primary-button',
                onClick: (_) => setParams(<String, String>{'q': 'react'}),
                children: const [Text('Set q=react')],
              ),
              button(
                key: 'q-clear',
                className: 'primary-button',
                onClick: (_) => setParams(<String, String>{'q': ''}),
                children: const [Text('Clear')],
              ),
            ],
          ),
          div(
            key: 'hint',
            className: 'section-kicker',
            children: [
              const Text('State lives in the URL — refresh keeps it.'),
            ],
          ),
        ],
      ),
    ],
  );
}

@reactComponent
ReactNode RedirectDemo(({String title}) props) {
  final navigate = useNavigate();

  return div(
    key: 'programmatic-page',
    className: 'page',
    children: [
      section(
        key: 'programmatic-surface',
        className: 'surface',
        children: [
          div(
            key: 'kicker',
            className: 'section-kicker',
            children: [const Text('PROGRAMMATIC NAVIGATION')],
          ),
          h2(key: 'title', children: [Text(props.title)]),
          p(
            key: 'copy',
            children: [
              const Text(
                'useNavigate() returns a function; the buttons below push, '
                'replace, or step back through history.',
              ),
            ],
          ),
          div(
            key: 'controls',
            className: 'counter-actions',
            children: [
              button(
                key: 'push',
                className: 'primary-button',
                onClick: (_) => navigate('/router/search?q=pushed'),
                children: const [Text('Push /router/search')],
              ),
              button(
                key: 'replace',
                className: 'primary-button',
                onClick: (_) => navigate('/router/items/99', replace: true),
                children: const [Text('Replace with item 99')],
              ),
              button(
                key: 'back',
                className: 'primary-button',
                onClick: (_) => navigate(-1),
                children: const [Text('Go back')],
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
