import 'package:react_router/react_router.dart';
import 'package:react_router/react_router_hooks.dart';
import 'package:react_web/react_web.dart';

import 'route_item.react.dart';

/// Renders the current route's location and the matched route element.
@reactComponent
ReactNode RouteContent(({bool hidden}) props) {
  final location = useLocation();

  return div(
    key: 'router-content',
    className: 'router-content',
    children: [
      div(
        key: 'router-location',
        className: 'router-location',
        children: [Text('location: ${location.fullPath}')],
      ),
      reactRouterRoutes(children: [
        reactRouterRoute(
          path: '/',
          element: div(key: 'route-home', children: [
            const Text('Home route — pick a destination above.'),
          ]),
        ),
        reactRouterRoute(
          path: '/about',
          element: div(key: 'route-about', children: [
            const Text('About route — rendered by react-router-dom.'),
          ]),
        ),
        reactRouterRoute(path: '/items/:id', element: ItemDetail(hidden: true)),
        reactRouterRoute(
          path: '*',
          element: div(key: 'route-missing', children: [
            const Text('No route matched.'),
          ]),
        ),
      ]),
    ],
  );
}
