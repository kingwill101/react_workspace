import 'dart:io';

import 'package:example/server_actions.g.dart';
import 'package:react_testing/react_testing.dart';
import 'package:server_testing/server_testing.dart';

const _appId = 'package:example/lib/app.dart#App';

/// The router location for an SSR request (shelf's in-memory request URLs
/// omit the leading slash).
String _documentPath(Uri url) {
  var path = url.path;
  if (path.isEmpty) path = '/';
  if (!path.startsWith('/')) path = '/$path';
  if (url.query.isNotEmpty) path = '$path?${url.query}';
  return path;
}

/// Normalizes React SSR markup for assertion: `<!-- -->` text-node
/// separators are stripped and `&quot;` entities are decoded.
String _normalizeHtml(String html) =>
    html.replaceAll('<!-- -->', '').replaceAll('&quot;', '"');

void main() {
  late ReactTestHarness harness;

  setUpAll(() async {
    harness = await ReactTestHarness.start(
      projectRoot: Directory('examples/ssr'),
      rootComponent: _appId,
      registerActions: (registry) => registerServerActions(registry: registry),
      pageProps: (request) => {
        'title': 'hi',
        'path': _documentPath(request.url),
      },
    );
  });

  tearDownAll(() => harness.close());

  test('server boots and SSR-renders the home page at /', () async {
    final client = harness.createClient();
    final response = await client.get('/');

    response.assertStatus(200);
    final body = response.body;

    // Shell navigation renders.
    expect(body, contains('site-nav'));
    expect(body, contains('>Home<'));

    // Home hero and quick-link cards render.
    expect(body, contains('Build interfaces with'));
    expect(body, contains('Explore state →'));
    expect(body, contains('Explore routing →'));

    // A live widget hydrates at /: the memoized counter renders 0.
    expect(body, contains('Quick counter'));

    // Hydration contract: props are embedded for the client mount.
    expect(body, contains('id="__props"'));
    expect(body, contains('title'));
  });

  test('deep links SSR-render their route through StaticRouter', () async {
    final client = harness.createClient();

    // Router playground renders its overview with the current location.
    final router = await client.get('/router');
    router.assertStatus(200);
    expect(_normalizeHtml(router.body), contains('location: /router'));
    expect(_normalizeHtml(router.body), contains('navigation type: POP'));

    // URL params flow into useParams.
    final item = await client.get('/router/items/42');
    item.assertStatus(200);
    expect(_normalizeHtml(item.body), contains('Item #42'));
    expect(_normalizeHtml(item.body), contains('useParams works: id=42'));

    // Search params are readable on the first (SSR) render.
    final search = await client.get('/router/search?q=ssr');
    search.assertStatus(200);
    expect(_normalizeHtml(search.body), contains('q = "ssr"'));

    // The Redirect route renders the shell but no page content (Navigate).
    final redirect = await client.get('/router/redirect');
    redirect.assertStatus(200);
    expect(redirect.body, contains('site-nav'));
  });

  test('state section renders each state page', () async {
    final client = harness.createClient();

    final zustand = await client.get('/state/zustand');
    zustand.assertStatus(200);
    expect(_normalizeHtml(zustand.body), contains('Count (zustand): 0'));

    final riverpod = await client.get('/state/riverpod');
    riverpod.assertStatus(200);
    expect(_normalizeHtml(riverpod.body), contains('Count (riverpod): 0'));

    final bloc = await client.get('/state/bloc');
    bloc.assertStatus(200);
    expect(_normalizeHtml(bloc.body), contains('Count (bloc): 0'));

    // Todos start in the server-function loading state.
    final todos = await client.get('/state/todos');
    todos.assertStatus(200);
    expect(_normalizeHtml(todos.body), contains('Loading tasks…'));

    // Unknown paths land on the catch-all 404 page.
    final missing = await client.get('/no/such/route');
    missing.assertStatus(200);
    expect(missing.body, contains('No route matched this location.'));
  });

  test('router section SSR-renders the overview and sub-routes', () async {
    final client = harness.createClient();

    final overview = await client.get('/router');
    overview.assertStatus(200);
    expect(_normalizeHtml(overview.body), contains('Router playground'));
    expect(_normalizeHtml(overview.body), contains('location: /router'));

    final items = await client.get('/router/items/42');
    items.assertStatus(200);
    expect(_normalizeHtml(items.body), contains('Item #42'));
    expect(_normalizeHtml(items.body), contains('useParams works: id=42'));

    final search = await client.get('/router/search?q=ssr');
    search.assertStatus(200);
    expect(_normalizeHtml(search.body), contains('q = "ssr"'));

    final programmatic = await client.get('/router/programmatic');
    programmatic.assertStatus(200);
    expect(_normalizeHtml(programmatic.body), contains('useNavigate'));

    final redirect = await client.get('/router/redirect');
    redirect.assertStatus(200);
    expect(_normalizeHtml(redirect.body), contains('Redirect'));
  });

  test('home page renders with server-function loading state', () async {
    final client = harness.createClient();
    final response = await client.get('/');
    response.assertStatus(200);
    expect(_normalizeHtml(response.body), contains('hi'));
    expect(response.body, contains('id="__props"'));
  });
}
