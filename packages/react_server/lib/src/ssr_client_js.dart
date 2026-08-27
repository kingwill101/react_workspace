import 'dart:convert';
import 'dart:js_interop';
import 'dart:js_interop_unsafe';

/// A rendered HTML document returned by the SSR worker.
final class ReactSsrDocument {
  const ReactSsrDocument({required this.html, required this.props});

  final String html;
  final Map<String, dynamic> props;
}

/// A chunk emitted by the generated streaming SSR worker.
final class ReactSsrStreamChunk {
  const ReactSsrStreamChunk._({
    this.html = '',
    this.props = const <String, dynamic>{},
    this.done = false,
  });

  final String html;
  final Map<String, dynamic> props;
  final bool done;

  factory ReactSsrStreamChunk.html(String html) =>
      ReactSsrStreamChunk._(html: html);

  factory ReactSsrStreamChunk.complete(Map<String, dynamic> props) =>
      ReactSsrStreamChunk._(props: props, done: true);
}

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

  Uri _resolveEndpoint(Uri? baseUri) => endpoint.isAbsolute || baseUri == null
      ? endpoint
      : baseUri.resolveUri(endpoint);
}

Future<JSAny?> _promise(JSAny? value) {
  if (value == null || !value.isA<JSPromise<JSAny?>>()) {
    throw const FormatException('JavaScript fetch did not return a Promise.');
  }
  return (value as JSPromise<JSAny?>).toDart;
}
