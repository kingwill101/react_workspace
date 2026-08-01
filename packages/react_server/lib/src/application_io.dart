import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:shelf/shelf.dart';

import 'registry.dart';
import 'shelf_handler_io.dart';

/// A function that provides the props for an SSR page request.
typedef ReactPageProps =
    FutureOr<Map<String, dynamic>> Function(Request request);

/// A rendered HTML document returned by the SSR worker.
final class ReactSsrDocument {
  final String html;
  final Map<String, dynamic> props;

  const ReactSsrDocument({required this.html, required this.props});
}

/// Native client for the generated Node SSR worker.
final class ReactSsrClient {
  final Uri endpoint;
  final HttpClient _client;

  ReactSsrClient({required this.endpoint, HttpClient? client})
    : _client = client ?? HttpClient();

  Future<ReactSsrDocument> render({
    required String component,
    required Map<String, dynamic> props,
  }) async {
    final request = await _client.postUrl(endpoint);
    request.headers.contentType = ContentType.json;
    request.write(jsonEncode({'component': component, 'props': props}));
    final response = await request.close();
    final body = await response.transform(utf8.decoder).join();

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw HttpException(
        'SSR worker returned HTTP ${response.statusCode}: $body',
        uri: endpoint,
      );
    }

    final decoded = jsonDecode(body);
    if (decoded is! Map || decoded['html'] is! String) {
      throw const FormatException('Invalid SSR worker response.');
    }
    final rawProps = decoded['props'];
    return ReactSsrDocument(
      html: decoded['html'] as String,
      props: rawProps is Map
          ? Map<String, dynamic>.from(rawProps)
          : <String, dynamic>{},
    );
  }

  void close() => _client.close(force: true);
}

/// Standard native HTTP application host for React Dart applications.
///
/// It owns the two framework routes:
///
/// * the versioned server-function endpoint; and
/// * the document route, optionally rendered through the SSR worker.
///
/// Static assets and application-specific routes remain supplied by the
/// application, which keeps the framework independent of a particular file
/// server or router package.
final class ReactServerApp {
  final ServerFunctionRegistry actionRegistry;
  final FutureOr<Response> Function(Request) staticHandler;
  final String indexTemplate;
  final String actionPath;
  final ReactSsrClient? ssr;
  final String? rootComponent;
  final ReactPageProps pageProps;
  final Object? Function(Request request)? authenticate;

  const ReactServerApp({
    required this.actionRegistry,
    required this.staticHandler,
    required this.indexTemplate,
    this.actionPath = '/__react/actions',
    this.ssr,
    this.rootComponent,
    this.pageProps = _emptyPageProps,
    this.authenticate,
  });

  Handler get handler {
    final actionHandler = createServerActionHandler(
      actionRegistry,
      authenticate: authenticate ?? _anonymous,
    );

    return (Request request) async {
      if (request.url.path == actionPath ||
          '/${request.url.path}' == actionPath) {
        return actionHandler(request);
      }

      final isDocument =
          request.method == 'GET' &&
          (request.url.path.isEmpty ||
              request.url.path == '/' ||
              request.url.path == 'index.html');
      if (!isDocument || ssr == null || rootComponent == null) {
        return staticHandler(request);
      }

      try {
        final props = await pageProps(request);
        final rendered = await ssr!.render(
          component: rootComponent!,
          props: props,
        );
        final html = indexTemplate
            .replaceAll('{{SSR}}', rendered.html)
            .replaceAll('{{PROPS}}', jsonEncode(rendered.props));
        return Response.ok(
          html,
          headers: {'content-type': 'text/html; charset=utf-8'},
        );
      } catch (error) {
        return Response.internalServerError(
          body: 'SSR rendering failed: $error',
        );
      }
    };
  }
}

FutureOr<Map<String, dynamic>> _emptyPageProps(Request request) => {};
Object? _anonymous(Request request) => null;
