import 'package:react/react.dart';
import 'package:react_router/react_router.dart';
import 'package:test/test.dart';

void main() {
  test('reactRouterLink builds a typed foreign component node', () {
    final node = reactRouterLink(
      to: '/about',
      children: [const Text('About')],
    );
    expect(node, isA<ForeignComponent>());
    final component = node as ForeignComponent;
    expect(component.name, 'reactRouter.Link');
    expect(component.props['to'], '/about');
    expect(component.children, hasLength(1));
  });

  test('reactRouterNavLink passes className and end', () {
    final node = reactRouterNavLink(
      to: '/',
      className: 'nav',
      end: true,
    ) as ForeignComponent;
    expect(node.name, 'reactRouter.NavLink');
    expect(node.props['className'], 'nav');
    expect(node.props['end'], true);
  });

  test('reactRouterRoute carries element and index flags', () {
    const element = Text('Home');
    final indexRoute = reactRouterRoute(
      index: true,
      element: element,
    ) as ForeignComponent;
    expect(indexRoute.name, 'reactRouter.Route');
    expect(indexRoute.props['index'], true);
    expect(indexRoute.props['element'], same(element));

    final pathRoute = reactRouterRoute(path: '/items/:id', element: element)
        as ForeignComponent;
    expect(pathRoute.props['path'], '/items/:id');
  });

  test('reactRouterMemoryRouter passes initialEntries', () {
    final node = reactRouterMemoryRouter(
      children: [const Text('x')],
      initialEntries: ['/', '/about'],
    ) as ForeignComponent;
    expect(node.name, 'reactRouter.MemoryRouter');
    expect(node.props['initialEntries'], ['/', '/about']);
  });

  test('reactRouterOutlet and reactRouterNavigate build nodes', () {
    final outletNode = reactRouterOutlet() as ForeignComponent;
    expect(outletNode.name, 'reactRouter.Outlet');

    final navigateNode = reactRouterNavigate(
      to: '/login',
      replace: true,
    ) as ForeignComponent;
    expect(navigateNode.name, 'reactRouter.Navigate');
    expect(navigateNode.props['replace'], true);
  });

  test('reactRouterStaticRouter carries location and children', () {
    final node = reactRouterStaticRouter(
      location: '/about',
      children: [const Text('About')],
    ) as ForeignComponent;
    expect(node.name, 'reactRouter.StaticRouter');
    expect(node.props['location'], '/about');
    expect(node.children, hasLength(1));
  });

  test('helpers pass through the generated prop classes via toJson', () {
    final node = reactRouterMemoryRouter(
      future: const FutureConfig(v7_startTransition: true),
    ) as ForeignComponent;
    expect(node.props['future'], {'v7_startTransition': true});

    final linkNode = reactRouterLink(
      to: '/x',
      relative: LinkRelative.path,
    ) as ForeignComponent;
    expect(linkNode.props['relative'], 'path');
  });
}
