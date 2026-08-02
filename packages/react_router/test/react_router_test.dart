import 'package:react/react.dart';
import 'package:react_router/react_router.dart';
import 'package:test/test.dart';

void main() {
  test('link builds a typed foreign component node', () {
    final node = link('/about', children: [const Text('About')]);
    expect(node, isA<ForeignComponent>());
    final component = node as ForeignComponent;
    expect(component.name, 'reactRouter.Link');
    expect(component.props['to'], '/about');
    expect(component.children, hasLength(1));
  });

  test('navLink passes className and end', () {
    final node = navLink('/', className: 'nav', end: true) as ForeignComponent;
    expect(node.name, 'reactRouter.NavLink');
    expect(node.props['className'], 'nav');
    expect(node.props['end'], true);
  });

  test('route carries element and index flags', () {
    const element = Text('Home');
    final indexRoute = route(
      index: true,
      element: element,
    ) as ForeignComponent;
    expect(indexRoute.name, 'reactRouter.Route');
    expect(indexRoute.props['index'], true);
    expect(indexRoute.props['element'], same(element));

    final pathRoute = route(path: '/items/:id', element: element)
        as ForeignComponent;
    expect(pathRoute.props['path'], '/items/:id');
  });

  test('memoryRouter passes initialEntries', () {
    final node = memoryRouter(
      [const Text('x')],
      initialEntries: ['/', '/about'],
    ) as ForeignComponent;
    expect(node.name, 'reactRouter.MemoryRouter');
    expect(node.props['initialEntries'], ['/', '/about']);
  });

  test('outlet and navigate build nodes', () {
    final outletNode = outlet() as ForeignComponent;
    expect(outletNode.name, 'reactRouter.Outlet');

    final navigateNode = navigate('/login', replace: true)
        as ForeignComponent;
    expect(navigateNode.name, 'reactRouter.Navigate');
    expect(navigateNode.props['replace'], true);
  });
}
