import 'package:react_router/react_router.dart';
import 'package:react_web/react_web.dart';

import '.generated/site_layout.react.dart';

/// Root component: renders the site shell inside a router.
///
/// The server passes the request path as `path`, so the SSR worker renders
/// the matching route through `StaticRouter`. The browser ignores that value
/// (`web/client.dart` passes `path: null`) and uses `BrowserRouter` instead,
/// so navigation follows the real URL while initial markup still matches the
/// server's render at the deep link.
@reactComponent
ReactNode App(({String title, String? path}) props) {
  final site = SiteLayout(title: props.title);
  if (props.path != null) {
    return staticRouter(location: props.path!, children: [site]);
  }
  return browserRouter(children: [site]);
}
