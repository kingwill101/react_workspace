import 'dart:async';
import 'dart:convert';

import 'package:react_server/react_server.dart';
import 'package:shelf/shelf.dart';

import 'shelf_handler.dart';

typedef ReactPageProps =
    FutureOr<Map<String, dynamic>> Function(Request request);

typedef ReactPageMetadataBuilder =
    FutureOr<ReactPageMetadata?> Function(Request request);

typedef ReactCacheKey = String Function(Request request);

/// Standard Shelf application host for React Dart applications.
final class ReactServerApp {
  final ServerFunctionRegistry actionRegistry;
  final FutureOr<Response> Function(Request) staticHandler;
  final String indexTemplate;
  final String actionPath;
  final ReactSsrClient? ssr;
  final String? rootComponent;
  final ReactPageProps pageProps;
  final ReactPageMetadataBuilder pageMetadata;
  final bool streamingSsr;
  final ReactDocumentCache? documentCache;
  final ReactCacheKey cacheKey;
  final Object? Function(Request request)? authenticate;

  const ReactServerApp({
    required this.actionRegistry,
    required this.staticHandler,
    required this.indexTemplate,
    this.actionPath = '/__react/actions',
    this.ssr,
    this.rootComponent,
    this.pageProps = _emptyPageProps,
    this.pageMetadata = _emptyPageMetadata,
    this.streamingSsr = false,
    this.documentCache,
    this.cacheKey = _defaultCacheKey,
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
        final key = cacheKey(request);
        final cached = streamingSsr ? null : documentCache?.get(key);
        if (cached != null) return Response.ok(cached.html);
        final props = await pageProps(request);
        final metadata = await pageMetadata(request);
        final template = injectReactPageMetadata(indexTemplate, metadata);
        if (streamingSsr && template.contains('{{SSR}}')) {
          return Response.ok(
            _documentStream(props, template),
            headers: {'content-type': 'text/html; charset=utf-8'},
          );
        }
        final rendered = await ssr!.render(
          component: rootComponent!,
          props: props,
        );
        final html = template
            .replaceAll('{{SSR}}', rendered.html)
            .replaceAll('{{PROPS}}', jsonEncode(rendered.props));
        documentCache?.put(key, html);
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

  Stream<List<int>> _documentStream(
    Map<String, dynamic> props,
    String template,
  ) async* {
    final marker = template.indexOf('{{SSR}}');
    final before = template.substring(0, marker);
    final after = template.substring(marker + '{{SSR}}'.length);
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
FutureOr<ReactPageMetadata?> _emptyPageMetadata(Request request) => null;
String _defaultCacheKey(Request request) => request.url.toString();
Object? _anonymous(Request request) => null;

bool _looksLikeDocument(String path) {
  if (path.isEmpty || path == '/') return true;
  if (path == 'index.html') return true;
  final segments = path.split('/').where((s) => s.isNotEmpty);
  if (segments.isEmpty) return true;
  return !segments.last.contains('.');
}
