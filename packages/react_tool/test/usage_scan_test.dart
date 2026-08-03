import 'package:test/test.dart';

import 'package:react_tool/src/bundler/usage_scan.dart';

void main() {
  group('usedComponentsIn', () {
    test('matches quoted component keys in dev dart2js output', () {
      const dartJs = '''
foreignComponent("reactRouter.MemoryRouter", children, null, t1)
foreignComponent("reactRouter.Route", B.List_empty, null, t1)
return new A.aZ("reactRouter.Link", r, o, p)
''';
      expect(
        usedComponentsIn(dartJs, [
          'reactRouter.BrowserRouter',
          'reactRouter.Route',
          'reactRouter.Link',
        ]),
        ['reactRouter.Route', 'reactRouter.Link'],
      );
    });

    test('ignores keys the application never references', () {
      const dartJs = 'foreignComponent("reactRouter.Routes", c, null, k)';
      expect(
        usedComponentsIn(dartJs, ['reactRouter.Routes', 'reactRouter.Outlet']),
        ['reactRouter.Routes'],
      );
    });

    test('returns an empty list for an empty retained surface', () {
      expect(usedComponentsIn('any code', const []), isEmpty);
    });
  });

  group('usedHooksIn', () {
    test('matches the JS-interop dot-access path', () {
      const dartJs = r'''
globalThis.__reactDartBindings.reactRouter.useLocation()
v.G.globalThis.__reactDartBindings.reactRouter.useParams()
''';
      expect(
        usedHooksIn(dartJs, const ['reactRouter']),
        ['reactRouter.useLocation', 'reactRouter.useParams'],
      );
    });

    test('matches bracket-access compiled output', () {
      const dartJs = r'__reactDartBindings["reactRouter"]["useMatches"]()'
          r"__reactDartBindings['reactRouter']['useNavigate']()";
      expect(
        usedHooksIn(dartJs, const ['reactRouter']),
        ['reactRouter.useMatches', 'reactRouter.useNavigate'],
      );
    });

    test('matches the legacy __reactDartHooks bridge', () {
      const dartJs = 'globalThis.__reactDartHooks.useThing()';
      expect(usedHooksIn(dartJs, const ['reactRouter']), ['useThing']);
    });
  });
}
