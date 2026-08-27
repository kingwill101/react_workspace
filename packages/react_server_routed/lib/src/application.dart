import 'dart:async';
import 'dart:convert';

import 'package:react_actions/react_actions.dart';
import 'package:react_server/react_server.dart';
import 'package:routed_core/routed_core.dart' as routed;

/// Supplies the initial props for a React document request.
typedef RoutedReactPageProps =
    FutureOr<Map<String, dynamic>> Function(routed.EngineContext context);

/// Resolves the principal for a React server action request.
typedef RoutedReactAuthentication =
    Object? Function(routed.EngineContext context);

/// Builds page metadata for an SSR document request.
typedef RoutedReactPageMetadata =
    FutureOr<ReactPageMetadata?> Function(routed.EngineContext context);

/// Selects the cache key for a document request.
typedef RoutedReactCacheKey = String Function(routed.EngineContext context);

/// Supplies invalidation tags for a rendered document.
typedef RoutedReactCacheTags =
    Iterable<String> Function(routed.EngineContext context);

/// Builds an optional partial-prerendered document for a document request.
typedef RoutedReactPartialDocumentBuilder =
    FutureOr<ReactPartialDocument?> Function(routed.EngineContext context);

/// Resolves the SSR endpoint base URI for a document request.
///
/// This is useful for Fetch hosts whose portable request URI does not preserve
/// the externally visible origin. The returned URI must be a trusted absolute
/// origin; it must not be derived from an untrusted Host header.
typedef RoutedReactSsrEndpoint = Uri Function(routed.EngineContext context);

/// Composes React document and server-action handlers into a Routed handler.
///
/// Non-document requests are delegated to [staticHandler]. Document requests
/// are rendered through [ssr] when [ssr] and [rootComponent] are configured.
/// The action endpoint reuses `react_server`'s registry and
/// `react_actions`' versioned server-function protocol directly on
/// [routed.EngineContext].
final class RoutedReactApplication {
  /// Creates a Routed/React application handler composition.
  RoutedReactApplication({
    required this.actionRegistry,
    required this.staticHandler,
    required this.indexTemplate,
    this.actionPath = '/__react/actions',
    this.ssr,
    this.rootComponent,
    this.pageProps = _emptyPageProps,
    this.pageMetadata = _emptyPageMetadata,
    this.partialDocument,
    this.ssrEndpoint,
    ReactDataCache? partialDataCache,
    this.routeManifest,
    this.streamingSsr = false,
    this.documentCache,
    this.documentStore,
    this.cacheKey = _defaultCacheKey,
    this.cacheTags = _emptyCacheTags,
    this.documentTtl = const Duration(minutes: 1),
    this.staleWhileRevalidate = Duration.zero,
    this.authenticate,
    this.requestTimeout = const Duration(seconds: 30),
    this.maxActionBodySize = 1024 * 1024,
  }) : partialDataCache = partialDataCache ?? ReactDataCache();

  /// The registry used by the React server-action endpoint.
  final ServerFunctionRegistry actionRegistry;

  /// Handles assets and requests that are not React documents or actions.
  final routed.Handler staticHandler;

  /// HTML template containing `{{SSR}}` and optionally `{{PROPS}}` markers.
  final String indexTemplate;

  /// Path handled by the server-action endpoint.
  final String actionPath;

  /// Client for the Node SSR worker.
  final ReactSsrClient? ssr;

  /// Generated component name registered by the SSR bundle.
  final String? rootComponent;

  /// Builds the props passed to the SSR root component.
  final RoutedReactPageProps pageProps;

  /// Builds title, SEO, and link metadata for the document head.
  final RoutedReactPageMetadata pageMetadata;

  /// Builds a shell and independently cached dynamic regions for PPR.
  final RoutedReactPartialDocumentBuilder? partialDocument;

  /// Resolves the base URI used for relative [ssr] endpoints.
  final RoutedReactSsrEndpoint? ssrEndpoint;

  /// Cache used by [partialDocument] shells and regions.
  final ReactDataCache partialDataCache;

  /// Optional route-level ISR policies.
  final ReactRouteManifest? routeManifest;

  /// Whether document responses should be progressively streamed from React.
  ///
  /// Buffered rendering remains the default for compatibility. Streaming
  /// requires an index template containing the `{{SSR}}` marker.
  final bool streamingSsr;

  /// Optional in-process cache for completed, buffered documents.
  final ReactDocumentCache? documentCache;

  /// Optional persistent or distributed document storage.
  final ReactDocumentStore? documentStore;

  /// Selects a cache key when [documentCache] is enabled.
  final RoutedReactCacheKey cacheKey;

  /// Supplies tags written to the memory and persistent document caches.
  final RoutedReactCacheTags cacheTags;

  /// Lifetime written to [documentStore] entries.
  final Duration documentTtl;

  /// How long expired documents may be served while refreshing in the
  /// background.
  final Duration staleWhileRevalidate;

  /// Resolves the principal used by server actions.
  final RoutedReactAuthentication? authenticate;

  /// Maximum time allowed for a server action.
  final Duration requestTimeout;

  /// Maximum accepted server-action request body size.
  final int maxActionBodySize;

  /// Returns the composed Routed handler.
  routed.Handler get handler => _handle;

  /// Mounts the composed handler on [engine].
  ///
  /// The fallback catches document paths and asset paths. Mount this after
  /// more specific API routes so those routes take precedence.
  void mount(routed.Engine engine) {
    final router = routed.Router();
    router.fallback(handler);
    engine.use(router);
  }

  Future<routed.Response> _handle(routed.EngineContext context) async {
    if (_samePath(context.path, actionPath)) {
      return _handleAction(context);
    }

    final isDocument =
        context.method == 'GET' && _looksLikeDocument(context.path);
    if (!isDocument ||
        (ssr == null || rootComponent == null) && partialDocument == null) {
      return staticHandler(context);
    }

    try {
      if (partialDocument != null) {
        final partial = await partialDocument!(context);
        if (partial != null) {
          return context.html(await partial.render(partialDataCache));
        }
      }
      if (ssr == null || rootComponent == null) {
        return await staticHandler(context);
      }
      final policy = routeManifest?.match(context.path);
      final key = cacheKey(context);
      final tags = <String>{...cacheTags(context), ...?policy?.tags};
      final ttl = policy?.ttl ?? documentTtl;
      final staleWindow = policy?.staleWhileRevalidate ?? staleWhileRevalidate;
      final cached = streamingSsr ? null : documentCache?.get(key);
      if (cached != null) return context.html(cached.html);
      final stale = streamingSsr ? null : documentCache?.getStale(key);
      if (stale != null) {
        unawaited(
          _refreshDocument(
            context,
            key,
            tags,
            ttl: ttl,
            staleWhileRevalidate: staleWindow,
          ),
        );
        return context.html(stale.html);
      }
      final stored = streamingSsr ? null : await documentStore?.read(key);
      if (stored != null) {
        if (stored.stale) {
          unawaited(
            _refreshDocument(
              context,
              key,
              tags,
              ttl: ttl,
              staleWhileRevalidate: staleWindow,
            ),
          );
        }
        return context.html(stored.html);
      }
      final props = await pageProps(context);
      final metadata = await pageMetadata(context);
      final template = injectReactPageMetadata(indexTemplate, metadata);
      if (streamingSsr) {
        return await _handleStreamingDocument(context, props, template);
      }
      final rendered = await ssr!.render(
        component: rootComponent!,
        props: props,
        baseUri: _ssrBaseUri(context),
      );
      final html = template
          .replaceAll('{{SSR}}', rendered.html)
          .replaceAll('{{PROPS}}', jsonEncode(rendered.props));
      documentCache?.put(
        key,
        html,
        ttl: ttl,
        staleWhileRevalidate: staleWindow,
        tags: tags,
      );
      await documentStore?.write(
        key,
        html,
        ttl: ttl,
        staleWhileRevalidate: staleWindow,
        tags: tags,
      );
      return context.html(html);
    } catch (error) {
      return context.string('SSR rendering failed: $error', statusCode: 500);
    }
  }

  Future<void> _refreshDocument(
    routed.EngineContext context,
    String key,
    Iterable<String> tags, {
    required Duration ttl,
    required Duration staleWhileRevalidate,
  }) async {
    try {
      final props = await pageProps(context);
      final metadata = await pageMetadata(context);
      final template = injectReactPageMetadata(indexTemplate, metadata);
      final rendered = await ssr!.render(
        component: rootComponent!,
        props: props,
        baseUri: _ssrBaseUri(context),
      );
      final html = template
          .replaceAll('{{SSR}}', rendered.html)
          .replaceAll('{{PROPS}}', jsonEncode(rendered.props));
      documentCache?.put(
        key,
        html,
        ttl: ttl,
        staleWhileRevalidate: staleWhileRevalidate,
        tags: tags,
      );
      await documentStore?.write(
        key,
        html,
        ttl: ttl,
        staleWhileRevalidate: staleWhileRevalidate,
        tags: tags,
      );
    } catch (_) {
      // Keep serving the stale entry until the stale window closes.
    }
  }

  Future<routed.Response> _handleStreamingDocument(
    routed.EngineContext context,
    Map<String, dynamic> props,
    String template,
  ) async {
    final marker = template.indexOf('{{SSR}}');
    if (marker < 0) {
      final rendered = await ssr!.render(
        component: rootComponent!,
        props: props,
        baseUri: _ssrBaseUri(context),
      );
      return context.html(
        template
            .replaceAll('{{SSR}}', rendered.html)
            .replaceAll('{{PROPS}}', jsonEncode(rendered.props)),
      );
    }

    context.response.headers.set('content-type', 'text/html; charset=utf-8');
    await context.response.addStream(
      _documentStream(
        props,
        marker,
        template,
        _ssrBaseUri(context),
      ).map(utf8.encode),
    );
    return context.response;
  }

  Stream<String> _documentStream(
    Map<String, dynamic> props,
    int marker,
    String template,
    Uri? baseUri,
  ) async* {
    final before = template.substring(0, marker);
    final after = template.substring(marker + '{{SSR}}'.length);
    yield before.replaceAll('{{PROPS}}', jsonEncode(props));

    var finalProps = props;
    await for (final chunk in ssr!.renderStream(
      component: rootComponent!,
      props: props,
      baseUri: baseUri,
    )) {
      if (chunk.done) {
        finalProps = chunk.props;
      } else if (chunk.html.isNotEmpty) {
        yield chunk.html;
      }
    }
    yield after.replaceAll('{{PROPS}}', jsonEncode(finalProps));
  }

  Uri? _ssrBaseUri(routed.EngineContext context) => ssrEndpoint?.call(context);

  Future<routed.Response> _handleAction(routed.EngineContext context) async {
    if (context.method != 'POST') {
      return _actionError(context, 'method_not_allowed', 'POST required.', 405);
    }

    final contentType = context.request.headers.value('content-type') ?? '';
    if (_isCompactContentType(contentType)) {
      return _handleCompactAction(context);
    }
    if (!contentType.startsWith('application/json') &&
        !contentType.startsWith(serverFunctionContentType)) {
      return _actionError(
        context,
        'unsupported_media_type',
        'Unsupported content type.',
        415,
      );
    }

    late String body;
    try {
      body = utf8.decode(await _readActionBody(context, maxActionBodySize));
    } on _RequestBodyTooLarge {
      return _actionError(
        context,
        'request_too_large',
        'Request too large.',
        413,
      );
    }

    late Map<String, dynamic> payload;
    try {
      final decoded = jsonDecode(body);
      if (decoded is! Map) throw const FormatException();
      payload = Map<String, dynamic>.from(decoded);
    } on FormatException {
      return _actionError(context, 'invalid_json', 'Invalid JSON.', 400);
    } on TypeError {
      return _actionError(context, 'invalid_json', 'Invalid JSON.', 400);
    }

    final headerProtocol = context.request.headers.value(
      serverFunctionProtocolHeader,
    );
    if (headerProtocol != null && headerProtocol != '${payload['protocol']}') {
      return _actionError(
        context,
        'protocol_mismatch',
        'The protocol header does not match the request envelope.',
        400,
      );
    }
    if (payload['protocol'] != serverFunctionProtocolVersion) {
      return _actionError(
        context,
        'unsupported_protocol',
        'Unsupported protocol version.',
        400,
      );
    }

    final rawId = payload['id'];
    if (rawId is! String || rawId.isEmpty) {
      return _actionError(context, 'missing_id', 'Missing function ID.', 400);
    }
    final id = rawId;
    final headerId = context.request.headers.value(serverFunctionIdHeader);
    if (headerId != null && headerId != id) {
      return _actionError(
        context,
        'id_mismatch',
        'The action header does not match the request envelope.',
        400,
      );
    }

    final rawContract = payload['contract'];
    if (rawContract != null && rawContract is! String) {
      return _actionError(
        context,
        'invalid_contract',
        'The function contract must be a string.',
        400,
      );
    }
    final contract = rawContract as String?;
    final headerContract = context.request.headers.value(
      serverFunctionContractHeader,
    );
    if (headerContract != null && headerContract != contract) {
      return _actionError(
        context,
        'contract_mismatch',
        'The action header does not match the request envelope.',
        400,
      );
    }
    if (!payload.containsKey('arguments')) {
      return _actionError(
        context,
        'missing_arguments',
        'Missing function arguments.',
        400,
      );
    }

    final expectedHash = actionRegistry.contractHashFor(id);
    if (expectedHash != null && contract != expectedHash) {
      return _actionError(
        context,
        'contract_mismatch',
        'The action contract has changed. Please reload the page.',
        400,
      );
    }

    final requestId = _generateRequestId();
    final afterResponse = ReactAfterResponse();
    final actionContext = ServerFunctionContext(
      requestId: requestId,
      principal: authenticate?.call(context),
      headers: _stringHeaders(context),
      requestUri: context.requestedUri,
      deadline: DateTime.now().add(requestTimeout),
      cancellation: CancellationToken(),
      afterResponse: afterResponse,
    );

    try {
      final result = await actionRegistry
          .dispatch(id, payload['arguments'], actionContext)
          .timeout(requestTimeout);
      return _actionJson(
        context,
        200,
        ServerFunctionResponse.ok(result).toJson(),
      );
    } on TimeoutException {
      return _actionError(
        context,
        'timeout',
        'The action timed out.',
        504,
        requestId: requestId,
      );
    } on ServerFunctionFailure catch (error) {
      return _actionJson(
        context,
        error.statusCode,
        failureToResponse(error, requestId: requestId).toJson(),
      );
    } on UnknownServerFunctionException catch (error) {
      return _actionError(
        context,
        'unknown_function',
        'Unknown function: ${error.id}.',
        404,
      );
    } catch (_) {
      return _actionError(
        context,
        'internal_error',
        'Internal server error.',
        500,
        requestId: requestId,
      );
    } finally {
      unawaited(Future<void>.delayed(Duration.zero, afterResponse.run));
    }
  }

  Future<routed.Response> _handleCompactAction(
    routed.EngineContext context,
  ) async {
    late CompactServerFunctionRequest request;
    try {
      final declaredLength = context.request.headers.contentLength;
      if (declaredLength > maxActionBodySize) {
        return _actionError(
          context,
          'request_too_large',
          'Request too large.',
          413,
        );
      }
      final bytes = await _readActionBody(context, maxActionBodySize);
      request = CompactServerFunctionRequest.decode(bytes);
    } on _RequestBodyTooLarge {
      return _actionError(
        context,
        'request_too_large',
        'Request too large.',
        413,
      );
    } on FormatException catch (error) {
      return _actionError(context, 'invalid_frame', error.message, 400);
    }

    final headerProtocol = context.request.headers.value(
      serverFunctionProtocolHeader,
    );
    if (headerProtocol != null && headerProtocol != '$compactProtocolVersion') {
      return _compactActionError(
        context,
        request,
        'protocol_mismatch',
        'The protocol header does not match the frame.',
        400,
      );
    }
    final headerId = context.request.headers.value(serverFunctionIdHeader);
    if (headerId != null && headerId != request.id) {
      return _compactActionError(
        context,
        request,
        'id_mismatch',
        'The action header does not match the frame.',
        400,
      );
    }
    final headerContract = context.request.headers.value(
      serverFunctionContractHeader,
    );
    if (headerContract != null && headerContract != request.contract) {
      return _compactActionError(
        context,
        request,
        'contract_mismatch',
        'The contract header does not match the frame.',
        400,
      );
    }

    final expectedHash = actionRegistry.contractHashFor(request.id);
    if (expectedHash != null && request.contract != expectedHash) {
      return _compactActionError(
        context,
        request,
        'contract_mismatch',
        'The action contract has changed. Please reload the page.',
        400,
      );
    }

    final afterResponse = ReactAfterResponse();
    final actionContext = ServerFunctionContext(
      requestId: _generateRequestId(),
      principal: authenticate?.call(context),
      headers: _stringHeaders(context),
      requestUri: context.requestedUri,
      deadline: DateTime.now().add(requestTimeout),
      cancellation: CancellationToken(),
      afterResponse: afterResponse,
    );
    try {
      final result = await actionRegistry
          .dispatch(request.id, request.arguments, actionContext)
          .timeout(requestTimeout);
      return _compactActionResponse(context, 200, request.success(result));
    } on TimeoutException {
      return _compactActionError(
        context,
        request,
        'timeout',
        'The action timed out.',
        504,
        requestId: actionContext.requestId,
      );
    } on ServerFunctionFailure catch (error) {
      return _compactActionResponse(
        context,
        error.statusCode,
        request.failure(
          ServerFunctionError(
            code: error.code,
            message: error.message,
            details: error.details,
            requestId: actionContext.requestId,
          ),
        ),
      );
    } on UnknownServerFunctionException catch (error) {
      return _compactActionError(
        context,
        request,
        'unknown_function',
        'Unknown function: ${error.id}.',
        404,
      );
    } catch (_) {
      return _compactActionError(
        context,
        request,
        'internal_error',
        'Internal server error.',
        500,
        requestId: actionContext.requestId,
      );
    } finally {
      unawaited(Future<void>.delayed(Duration.zero, afterResponse.run));
    }
  }

  static Map<String, String> _stringHeaders(routed.EngineContext context) {
    final headers = <String, String>{};
    context.request.headers.forEach((name, values) {
      headers[name] = values.join(',');
    });
    return headers;
  }

  static routed.Response _actionJson(
    routed.EngineContext context,
    int statusCode,
    Map<String, dynamic> payload,
  ) {
    context.response.statusCode = statusCode;
    context.response.headers.set('content-type', serverFunctionContentType);
    context.response.write(jsonEncode(payload));
    return context.response;
  }

  static routed.Response _compactActionResponse(
    routed.EngineContext context,
    int statusCode,
    ReactFrame frame,
  ) {
    context.response.statusCode = statusCode;
    context.response.headers.set('content-type', compactProtocolContentType);
    context.response.writeBytes(frame.encode());
    return context.response;
  }

  static routed.Response _compactActionError(
    routed.EngineContext context,
    CompactServerFunctionRequest request,
    String code,
    String message,
    int statusCode, {
    String? requestId,
  }) => _compactActionResponse(
    context,
    statusCode,
    request.failure(
      ServerFunctionError(code: code, message: message, requestId: requestId),
    ),
  );

  static routed.Response _actionError(
    routed.EngineContext context,
    String code,
    String message,
    int statusCode, {
    String? requestId,
  }) => _actionJson(
    context,
    statusCode,
    ServerFunctionResponse.error(
      ServerFunctionError(code: code, message: message, requestId: requestId),
    ).toJson(),
  );

  static int _requestCounter = 0;

  static String _generateRequestId() =>
      'req_${DateTime.now().millisecondsSinceEpoch}_${_requestCounter++}';

  static bool _samePath(String actual, String expected) =>
      _normalizedPath(actual) == _normalizedPath(expected);

  static String _normalizedPath(String path) {
    if (path.isEmpty) return '/';
    return path.startsWith('/') ? path : '/$path';
  }

  static bool _looksLikeDocument(String path) {
    final normalized = _normalizedPath(path);
    if (normalized == '/' || normalized == '/index.html') return true;
    final segments = normalized
        .split('/')
        .where((segment) => segment.isNotEmpty);
    if (segments.isEmpty) return true;
    return !segments.last.contains('.');
  }

  static FutureOr<Map<String, dynamic>> _emptyPageProps(
    routed.EngineContext context,
  ) => {};

  static FutureOr<ReactPageMetadata?> _emptyPageMetadata(
    routed.EngineContext context,
  ) => null;

  static String _defaultCacheKey(routed.EngineContext context) =>
      context.request.uri.toString();

  static Iterable<String> _emptyCacheTags(routed.EngineContext context) =>
      const <String>[];
}

bool _isCompactContentType(String contentType) =>
    contentType.split(';').first.trim().toLowerCase() ==
    compactProtocolContentType;

final class _RequestBodyTooLarge implements Exception {
  const _RequestBodyTooLarge();
}

Future<List<int>> _readActionBody(
  routed.EngineContext context,
  int maxBodySize,
) async {
  if (!context.request.hasNativeHttpRequest) {
    final bytes = await context.bodyBytes;
    if (bytes.length > maxBodySize) throw const _RequestBodyTooLarge();
    return bytes;
  }

  final bytes = <int>[];
  // ignore: deprecated_member_use
  await for (final chunk in context.request.httpRequest) {
    bytes.addAll(chunk);
    if (bytes.length > maxBodySize) throw const _RequestBodyTooLarge();
  }
  return bytes;
}
