import 'package:react_web/react_web.dart';

/// Catch-all `*` route: rendered when no page matches the current location.
@reactComponent
ReactNode NotFoundPage(({String title}) props) {
  return div(
    key: 'not-found',
    className: 'page',
    children: [
      section(
        key: 'nf-surface',
        className: 'surface',
        children: [
          div(
            key: 'kicker',
            className: 'section-kicker',
            children: [const Text('404')],
          ),
          h2(key: 'title', children: [Text(props.title)]),
          p(
            key: 'copy',
            children: [
              const Text(
                'No route matched this location. Pick a page from the '
                'navigation above.',
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
