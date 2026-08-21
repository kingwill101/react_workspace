import 'dart:async';
import 'dart:convert';

import 'package:react_server/react_server.dart';
import 'package:shelf/shelf.dart';

import 'shelf_handler.dart';

typedef ReactPageProps =
    FutureOr<Map<String, dynamic>> Function(Request request);

/// Standard Shelf application host for React Dart applications.
final class ReactServerApp {
  final ServerFunctionRegistry actionRegistry;
  final FutureOr<Response> Function(Request) staticHandler;
  final String indexTemplate;
  final String actionPath;
  final ReactSsrClient? ssr;
  final String? rootComponent;
  final ReactPageProps pageProps;
  final bool streamingSsr;
  final Object? Function(Request request)? authenticate;

  const ReactServerApp({
    required this.actionRegistry,
    required this.staticHandler,
    required this.indexTemplate,
    this.actionPath = '/__react/actions',
    this.ssr,
    this.rootComponent,
    this.pageProps = _emptyPageProps,
    this.streamingSsr = false,
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
          request.method == 'GET' && _looksLikeDocument(request.url.path);
      if (!isDocument || ssr == null || rootComponent == null) {
        return staticHandler(request);
      }

      try {
        final props = await pageProps(request);
        if (streamingSsr && indexTemplate.contains('{{SSR}}')) {
          return Response.ok(
            _documentStream(props),
            headers: {'content-type': 'text/html; charset=utf-8'},
          );
        }
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

  Stream<List<int>> _documentStream(Map<String, dynamic> props) async* {
    final marker = indexTemplate.indexOf('{{SSR}}');
    final before = indexTemplate.substring(0, marker);
    final after = indexTemplate.substring(marker + '{{SSR}}'.length);
    yield utf8.encode(before.replaceAll('{{PROPS}}', jsonEncode(props)));

    var finalProps = props;
    await for (final chunk in ssr!.renderStream(
      component: rootComponent!,
      props: props,
    )) {
      if (chunk.done) {
        finalProps = chunk.props;
      } else if (chunk.html.isNotEmpty) {
        yield utf8.encode(chunk.html);
      }
    }
    yield utf8.encode(after.replaceAll('{{PROPS}}', jsonEncode(finalProps)));
  }
}

FutureOr<Map<String, dynamic>> _emptyPageProps(Request request) => {};
Object? _anonymous(Request request) => null;

bool _looksLikeDocument(String path) {
  if (path.isEmpty || path == '/') return true;
  if (path == 'index.html') return true;
  final segments = path.split('/').where((s) => s.isNotEmpty);
  if (segments.isEmpty) return true;
  return !segments.last.contains('.');
}
