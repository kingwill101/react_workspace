import 'package:react_router_dom/react_router_dom.dart';
import 'package:react_web/react_web.dart' hide link;

import '.generated/about_page.react.dart';
import 'app_context.dart';
import '.generated/home_page.react.dart';
import '.generated/hooks_page.react.dart';
import '.generated/not_found_page.react.dart';
import '.generated/router_pages.react.dart';
import '.generated/state_pages.react.dart';

/// Persistent application shell: brand, top navigation, and the routed page
/// tree.
///
/// The shell is rendered *inside* a router (StaticRouter on the server,
/// BrowserRouter on the client), so navigation primitives (`NavLink`, `Link`,
/// `Routes`, `Outlet`) work here. The top-level `Routes` matches the current
/// location against the pages; nested sections render their own `Outlet`.
@reactComponent
ReactNode SiteLayout(({String title}) props) {
  return appAccentContext.provider('#7257ff', [
    div(
      key: 'site-shell',
      className: 'app-shell',
      children: [
        header(
          key: 'site-header',
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
                      children: [Text(props.title)],
                    ),
                  ],
                ),
              ],
            ),
            nav(
              key: 'site-nav',
              className: 'site-nav',
              children: [
                navLink(
                  to: '/',
                  className: 'nav-link',
                  end: true,
                  children: [const Text('Home')],
                ),
                navLink(
                  to: '/state',
                  className: 'nav-link',
                  children: [const Text('State')],
                ),
                navLink(
                  to: '/router',
                  className: 'nav-link',
                  children: [const Text('Router')],
                ),
                navLink(
                  to: '/about',
                  className: 'nav-link',
                  children: [const Text('About')],
                ),
              ],
            ),
          ],
        ),
        main(
          key: 'site-main',
          className: 'site-main',
          children: [
            routes(
              key: 'app-routes',
              children: [
                route(
                  path: '/',
                  element: HomePage(title: props.title),
                ),
                route(
                  path: 'state',
                  element: StateSection(title: 'State management'),
                  children: [
                    route(
                      index: true,
                      element: StateOverview(title: 'State management'),
                    ),
                    route(
                      path: 'hooks',
                      element: HooksPage(title: 'Hooks'),
                    ),
                    route(
                      path: 'zustand',
                      element: ZustandPage(title: 'Zustand'),
                    ),
                    route(
                      path: 'riverpod',
                      element: RiverpodPage(title: 'Riverpod'),
                    ),
                    route(
                      path: 'bloc',
                      element: BlocPage(title: 'Bloc'),
                    ),
                    route(
                      path: 'todos',
                      element: TodosPage(title: 'Todos'),
                    ),
                  ],
                ),
                route(
                  path: 'router',
                  element: RouterSection(title: 'Router playground'),
                  children: [
                    route(
                      index: true,
                      element: RouterOverview(title: 'Router playground'),
                    ),
                    route(
                      path: 'items/:id',
                      element: ItemPage(title: 'Item detail'),
                    ),
                    route(
                      path: 'search',
                      element: SearchDemo(title: 'Search params'),
                    ),
                    route(
                      path: 'programmatic',
                      element: RedirectDemo(title: 'Programmatic navigation'),
                    ),
                    route(
                      path: 'redirect',
                      element: navigate(
                        to: '/router/search?q=auto',
                        replace: true,
                      ),
                    ),
                  ],
                ),
                route(
                  path: 'about',
                  element: AboutPage(title: 'About'),
                ),
                route(
                  path: '*',
                  element: NotFoundPage(title: 'Page not found'),
                ),
              ],
            ),
          ],
        ),
        footer(
          key: 'site-footer',
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
