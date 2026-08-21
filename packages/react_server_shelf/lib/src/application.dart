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

typedef ReactCacheTags = Iterable<String> Function(Request request);

/// Builds an optional partial-prerendered document for a document request.
typedef ReactPartialDocumentBuilder =
    FutureOr<ReactPartialDocument?> Function(Request request);

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

  /// Builds a shell and independently cached dynamic regions for PPR.
  final ReactPartialDocumentBuilder? partialDocument;

  /// Cache used by [partialDocument] shells and regions.
  final ReactDataCache partialDataCache;
  final bool streamingSsr;
  final ReactDocumentCache? documentCache;
  final ReactDocumentStore? documentStore;
  final ReactCacheKey cacheKey;
  final ReactCacheTags cacheTags;
  final Duration staleWhileRevalidate;
  final Duration documentTtl;
  final Object? Function(Request request)? authenticate;

  ReactServerApp({
    required this.actionRegistry,
    required this.staticHandler,
    required this.indexTemplate,
    this.actionPath = '/__react/actions',
    this.ssr,
    this.rootComponent,
    this.pageProps = _emptyPageProps,
    this.pageMetadata = _emptyPageMetadata,
    this.partialDocument,
    ReactDataCache? partialDataCache,
    this.streamingSsr = false,
    this.documentCache,
    this.documentStore,
    this.cacheKey = _defaultCacheKey,
    this.cacheTags = _emptyCacheTags,
    this.staleWhileRevalidate = Duration.zero,
    this.documentTtl = const Duration(minutes: 1),
    this.authenticate,
  }) : partialDataCache = partialDataCache ?? ReactDataCache();

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
      if (!isDocument ||
          (ssr == null || rootComponent == null) && partialDocument == null) {
        return staticHandler(request);
      }

      try {
        if (partialDocument != null) {
          final partial = await partialDocument!(request);
          if (partial != null) {
            return Response.ok(
              await partial.render(partialDataCache),
              headers: {'content-type': 'text/html; charset=utf-8'},
            );
          }
        }
        if (ssr == null || rootComponent == null) {
          return await staticHandler(request);
        }
        final key = cacheKey(request);
        final tags = cacheTags(request);
        final cached = streamingSsr ? null : documentCache?.get(key);
        if (cached != null) return Response.ok(cached.html);
        final stale = streamingSsr ? null : documentCache?.getStale(key);
        if (stale != null) {
          unawaited(_refreshDocument(request, key, tags));
          return Response.ok(stale.html);
        }
        final stored = streamingSsr ? null : await documentStore?.read(key);
        if (stored != null) {
          if (stored.stale) {
            unawaited(_refreshDocument(request, key, tags));
          }
          return Response.ok(stored.html);
        }
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
        documentCache?.put(
          key,
          html,
          staleWhileRevalidate: staleWhileRevalidate,
          tags: tags,
        );
        await documentStore?.write(
          key,
          html,
          ttl: documentTtl,
          staleWhileRevalidate: staleWhileRevalidate,
          tags: tags,
        );
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

  Future<void> _refreshDocument(
    Request request,
    String key,
    Iterable<String> tags,
  ) async {
    try {
      final props = await pageProps(request);
      final metadata = await pageMetadata(request);
      final template = injectReactPageMetadata(indexTemplate, metadata);
      final rendered = await ssr!.render(
        component: rootComponent!,
        props: props,
      );
      final html = template
          .replaceAll('{{SSR}}', rendered.html)
          .replaceAll('{{PROPS}}', jsonEncode(rendered.props));
      documentCache?.put(
        key,
        html,
        staleWhileRevalidate: staleWhileRevalidate,
        tags: tags,
      );
      await documentStore?.write(
        key,
        html,
        ttl: documentTtl,
        staleWhileRevalidate: staleWhileRevalidate,
        tags: tags,
      );
    } catch (_) {
      // Keep serving the stale entry until the stale window closes.
    }
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
Iterable<String> _emptyCacheTags(Request request) => const <String>[];
Object? _anonymous(Request request) => null;

bool _looksLikeDocument(String path) {
  if (path.isEmpty || path == '/') return true;
  if (path == 'index.html') return true;
  final segments = path.split('/').where((s) => s.isNotEmpty);
  if (segments.isEmpty) return true;
  return !segments.last.contains('.');
}
