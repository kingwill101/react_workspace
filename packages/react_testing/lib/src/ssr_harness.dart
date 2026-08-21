import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:react_server/react_server.dart';
import 'package:server_testing/server_testing.dart';

/// Harness for testing React SSR rendering in isolation.
///
/// Provides a mock SSR worker without selecting an HTTP server integration.
/// Compose [client] with the Shelf, Routed, or other React server application
/// under test, then adapt that application through its `server_testing`
/// package.
///
/// Example:
/// ```dart
/// final harness = SsrTestHarness();
/// harness.mockRender('<div>Hello</div>', props: {'title': 'Test'});
/// final ssr = await harness.start();
/// final rendered = await ssr.render(component: 'test.Root', props: {});
/// ```
final class SsrTestHarness {
  HttpServer? _mockWorker;
  ReactSsrClient? _ssrClient;

  String _mockHtml = '<main>Mock SSR</main>';
  Map<String, dynamic> _mockProps = const {};
  int _mockStatus = HttpStatus.ok;
  bool _shouldFail = false;

  SsrTestHarness({
    String mockHtml = '<main>Mock SSR</main>',
    Map<String, dynamic> mockProps = const {},
  }) : this._(mockHtml, mockProps);

  SsrTestHarness._(this._mockHtml, this._mockProps);

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

  /// Starts the mock worker and returns its portable SSR client.
  Future<ReactSsrClient> start() async {
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

    return _ssrClient!;
  }

  /// The started SSR client.
  ReactSsrClient get client =>
      _ssrClient ?? (throw StateError('Call start() before accessing client'));

  /// Creates a client using the server adapter selected by the test.
  TestClient createClient(
    RequestHandler handler, {
    TransportMode mode = TransportMode.inMemory,
  }) => TestClient(handler, mode: mode);

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
    final contentType = headerValue(HttpHeaders.contentTypeHeader);
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
