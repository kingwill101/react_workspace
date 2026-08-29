import 'dart:convert';
import 'dart:js_interop';
import 'dart:js_interop_unsafe';
import 'ssr_types.dart';

/// Fetch-based client for an SSR service on JavaScript runtimes.
///
/// This is the client used when the Routed application itself is compiled for
/// Bun, Node, or Cloudflare Workers. It calls an SSR endpoint over Fetch; it
/// does not start or manage a child process. The endpoint can be the generated
/// Node SSR worker produced by `react_tool`.
final class ReactSsrClient {
  ReactSsrClient({required this.endpoint});

  final Uri endpoint;

  Future<ReactSsrDocument> render({
    required String component,
    required Map<String, dynamic> props,
    Uri? baseUri,
  }) async {
    final fetch = globalContext.getProperty('fetch'.toJS);
    if (fetch == null || !fetch.isA<JSFunction>()) {
      throw UnsupportedError('The JavaScript runtime does not provide fetch.');
    }

    final init = JSObject()
      ..setProperty('method'.toJS, 'POST'.toJS)
      ..setProperty(
        'headers'.toJS,
        JSObject()..setProperty('content-type'.toJS, 'application/json'.toJS),
      )
      ..setProperty(
        'body'.toJS,
        jsonEncode({'component': component, 'props': props}).toJS,
      );
    final responseValue = await _promise(
      (fetch as JSFunction).callAsFunction(
        null,
        _resolveEndpoint(baseUri).toString().toJS,
        init,
      ),
    );
    if (responseValue == null || !responseValue.isA<JSObject>()) {
      throw const FormatException('SSR fetch returned an invalid response.');
    }
    final response = responseValue as JSObject;
    final status = (response.getProperty('status'.toJS) as JSNumber).toDartInt;
    final text = response.getProperty('text'.toJS);
    if (text == null || !text.isA<JSFunction>()) {
      throw const FormatException('SSR response has no text() method.');
    }
    final body =
        (await _promise((text as JSFunction).callAsFunction(response))
                as JSString)
            .toDart;
    if (status < 200 || status >= 300) {
      throw StateError('SSR worker returned HTTP $status: $body');
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

  Stream<ReactSsrStreamChunk> renderStream({
    required String component,
    required Map<String, dynamic> props,
    Uri? baseUri,
  }) => throw UnsupportedError(
    'Streaming SSR over Fetch is not implemented yet. Use render().',
  );

  void close() {}

  Uri _resolveEndpoint(Uri? baseUri) {
    if (endpoint.isAbsolute) return endpoint;
    if (baseUri == null || !baseUri.isAbsolute || baseUri.host.isEmpty) {
      throw ArgumentError(
        'A relative SSR endpoint requires a trusted absolute base URI.',
      );
    }
    return baseUri.resolveUri(endpoint);
  }
}

Future<JSAny?> _promise(JSAny? value) {
  if (value == null || !value.isA<JSPromise<JSAny?>>()) {
    throw const FormatException('JavaScript fetch did not return a Promise.');
  }
  return (value as JSPromise<JSAny?>).toDart;
}
