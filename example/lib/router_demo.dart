import 'package:react_router/react_router.dart';
import 'package:react_web/react_web.dart';

import 'route_content.react.dart';

/// Demonstrates the `react_router` wrapper: typed components, links, params,
/// and location hooks — all over real react-router-dom.
@reactComponent
ReactNode RouterDemo(({String path}) props) {
  return memoryRouter(
    children: [
      nav(
        key: 'router-nav',
        className: 'router-nav',
        children: [
          navLink(to: '/', className: 'router-link', end: true, children: [
            const Text('Home'),
          ]),
          navLink(to: '/about', className: 'router-link', children: [
            const Text('About'),
          ]),
          navLink(to: '/items/7', className: 'router-link', children: [
            const Text('Item 7'),
          ]),
        ],
      ),
      RouteContent(hidden: true),
    ],
    initialEntries: [props.path],
  );
}
