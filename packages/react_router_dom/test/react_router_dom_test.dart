import 'package:react_core/react.dart';
import 'package:react_router_dom/react_router_dom.dart';
import 'package:test/test.dart';

void main() {
  test('link builds a typed foreign component node', () {
    final node = link(to: '/about', children: [const Text('About')]);
    expect(node, isA<ForeignComponent>());
    final component = node as ForeignComponent;
    expect(component.name, 'reactRouter.Link');
    expect(component.props['to'], '/about');
    expect(component.children, hasLength(1));
  });

  test('navLink passes className and end', () {
    final node =
        navLink(to: '/', className: 'nav', end: true) as ForeignComponent;
    expect(node.name, 'reactRouter.NavLink');
    expect(node.props['className'], 'nav');
    expect(node.props['end'], true);
  });

  test('route carries element and index flags', () {
    const element = Text('Home');
    final indexRoute = route(index: true, element: element) as ForeignComponent;
    expect(indexRoute.name, 'reactRouter.Route');
    expect(indexRoute.props['index'], true);
    expect(indexRoute.props['element'], same(element));

    final pathRoute =
        route(path: '/items/:id', element: element) as ForeignComponent;
    expect(pathRoute.props['path'], '/items/:id');
  });

  test('memoryRouter passes initialEntries', () {
    final node =
        memoryRouter(
              children: [const Text('x')],
              initialEntries: ['/', '/about'],
            )
            as ForeignComponent;
    expect(node.name, 'reactRouter.MemoryRouter');
    expect(node.props['initialEntries'], ['/', '/about']);
  });

  test('outlet and navigate build nodes', () {
    final outletNode = outlet() as ForeignComponent;
    expect(outletNode.name, 'reactRouter.Outlet');

    final navigateNode =
        navigate(to: '/login', replace: true) as ForeignComponent;
    expect(navigateNode.name, 'reactRouter.Navigate');
    expect(navigateNode.props['replace'], true);
  });

  test('staticRouter carries location and children', () {
    final node =
        staticRouter(location: '/about', children: [const Text('About')])
            as ForeignComponent;
    expect(node.name, 'reactRouter.StaticRouter');
    expect(node.props['location'], '/about');
    expect(node.children, hasLength(1));
  });

  test('helpers pass through the generated prop classes via toJson', () {
    final node =
        memoryRouter(future: const FutureConfig(v7_startTransition: true))
            as ForeignComponent;
    expect(node.props['future'], {'v7_startTransition': true});

    final linkNode =
        link(to: '/x', relative: RelativeRoutingType.path) as ForeignComponent;
    expect(linkNode.props['relative'], 'path');
  });

  test('Location.fullPath joins the path, query, and fragment', () {
    const location = Location(
      pathname: '/items',
      search: '?page=2',
      hash: '#details',
      state: <String, Object?>{},
      elementKey: 'entry',
    );
    expect(location.fullPath, '/items?page=2#details');
  });
}
