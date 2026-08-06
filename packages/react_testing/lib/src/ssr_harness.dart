import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:react_server/react_server.dart';
import 'package:server_testing/server_testing.dart';
import 'package:server_testing_shelf/server_testing_shelf.dart';
import 'package:shelf/shelf.dart';

/// Harness for testing React SSR rendering in isolation.
///
/// Provides helpers to create a mock SSR worker, build a [ReactServerApp]
/// without needing a real Node process, and assert on the rendered
/// document output. This complements [ReactTestHarness] for cases where
/// the full build pipeline is not needed.
///
/// Example:
/// ```dart
/// final harness = SsrTestHarness(
///   indexTemplate: '<html>{{SSR}}<script>{{PROPS}}</script></html>',
/// );
/// harness.mockRender('<div>Hello</div>', props: {'title': 'Test'});
///
/// final client = harness.createClient();
/// final response = await client.get('/');
/// response.assertStatus(200).assertBodyContains('Hello');
/// ```
final class SsrTestHarness {
  final String indexTemplate;
  final String actionPath;
  final ServerFunctionRegistry actionRegistry;
  Object Function(Request request)? authenticate;

  HttpServer? _mockWorker;
  ReactSsrClient? _ssrClient;
  ReactServerApp? _app;

  String _mockHtml = '<main>Mock SSR</main>';
  Map<String, dynamic> _mockProps = const {};
  int _mockStatus = HttpStatus.ok;
  bool _shouldFail = false;

  SsrTestHarness({
    required this.indexTemplate,
    this.actionPath = '/__react/actions',
    ServerFunctionRegistry? actionRegistry,
    this.authenticate,
    String mockHtml = '<main>Mock SSR</main>',
    Map<String, dynamic> mockProps = const {},
  })  : actionRegistry = actionRegistry ?? ServerFunctionRegistry(),
        _mockHtml = mockHtml,
        _mockProps = mockProps;

  /// Configures the mock SSR worker to return [html] and [props].
  void mockRender(String html, {Map<String, dynamic> props = const {}}) {
    _mockHtml = html;
    _mockProps = props;
    _shouldFail = false;
    _mockStatus = HttpStatus.ok;
  }

  /// Configures the mock SSR worker to return an error.
  void mockFailure({int status = HttpStatus.internalServerError}) {
    _shouldFail = true;
    _mockStatus = status;
  }

  /// Starts a mock SSR worker and builds the application.
  Future<ReactServerApp> start({
    String rootComponent = 'test.root',
    Map<String, dynamic> Function(Request request)? pageProps,
  }) async {
    _mockWorker = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    _mockWorker!.listen((request) async {
      final response = request.response;
      if (_shouldFail) {
        response.statusCode = _mockStatus;
        response.write('SSR failure');
        await response.close();
        return;
      }
      response.headers.contentType = ContentType.json;
      response.write(jsonEncode({'html': _mockHtml, 'props': _mockProps}));
      await response.close();
    });

    _ssrClient = ReactSsrClient(
      endpoint: Uri.parse('http://127.0.0.1:${_mockWorker!.port}/'),
    );

    _app = ReactServerApp(
      actionRegistry: actionRegistry,
      staticHandler: (request) => Response.ok('static:${request.url.path}'),
      indexTemplate: indexTemplate,
      ssr: _ssrClient,
      rootComponent: rootComponent,
      pageProps: pageProps ?? (_) => {'title': 'Test'},
      authenticate: authenticate,
    );

    return _app!;
  }

  /// Creates an in-memory test client for the current app.
  TestClient createClient() {
    if (_app == null) {
      throw StateError('Call start() before createClient()');
    }
    return TestClient.inMemory(ShelfRequestHandler(_app!.handler));
  }

  /// Returns the current app handler.
  Handler get handler {
    if (_app == null) throw StateError('Call start() before accessing handler');
    return _app!.handler;
  }

  Future<void> close() async {
    _ssrClient?.close();
    if (_mockWorker != null) {
      await _mockWorker!.close(force: true);
    }
  }
}

/// Assertions for SSR document responses.
extension SsrResponseAssertions on TestResponse {
  /// Asserts the body contains SSR HTML.
  TestResponse assertSsrHtml(String html) {
    assertBodyContains(html);
    return this;
  }

  /// Asserts the body contains the props JSON.
  TestResponse assertPropsContains(String substring) {
    assertBodyContains(substring);
    return this;
  }

  /// Asserts the response is HTML.
  TestResponse assertIsHtml() {
    final contentType = headers['content-type']?.first ?? '';
    if (!contentType.contains('text/html')) {
      throw TestFailure('Expected HTML content-type but got "$contentType"');
    }
    return this;
  }
}

/// Simple in-memory SSR harness that does not require HTTP.
final class InMemorySsrHarness {
  final String indexTemplate;

  InMemorySsrHarness({required this.indexTemplate});

  /// Renders [renderedHtml] into [indexTemplate] using [props].
  String render({
    required String renderedHtml,
    Map<String, dynamic> props = const {},
  }) => indexTemplate
      .replaceAll('{{SSR}}', renderedHtml)
      .replaceAll('{{PROPS}}', jsonEncode(props));

  /// Asserts that a rendered document contains expected fragments.
  void assertDocument(
    String document, {
    String? containsHtml,
    Map<String, dynamic>? containsProps,
  }) {
    if (containsHtml != null && !document.contains(containsHtml)) {
      throw TestFailure('Document missing expected HTML: $containsHtml');
    }
    if (containsProps != null) {
      final encoded = jsonEncode(containsProps);
      if (!document.contains(encoded)) {
        throw TestFailure('Document missing expected props: $encoded');
      }
    }
  }
}

class TestFailure implements Exception {
  final String message;
  TestFailure(this.message);
  @override
  String toString() => 'TestFailure: $message';
}
