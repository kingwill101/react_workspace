import 'dart:async';

import 'package:shelf/shelf.dart';

import 'registry.dart';

/// Browser placeholder for the native React server host.
final class ReactSsrDocument {
  final String html;
  final Map<String, dynamic> props;

  const ReactSsrDocument({required this.html, required this.props});
}

/// Browser placeholder for the native SSR worker client.
final class ReactSsrClient {
  ReactSsrClient({required Uri endpoint});

  Future<ReactSsrDocument> render({
    required String component,
    required Map<String, dynamic> props,
  }) => throw UnsupportedError(
    'ReactSsrClient is only available on native Dart.',
  );

  void close() {}
}

typedef ReactPageProps =
    FutureOr<Map<String, dynamic>> Function(Request request);

/// Browser placeholder for the native HTTP application host.
final class ReactServerApp {
  ReactServerApp({
    required ServerFunctionRegistry actionRegistry,
    required FutureOr<Response> Function(Request) staticHandler,
    required String indexTemplate,
    String actionPath = '/__react/actions',
    ReactSsrClient? ssr,
    String? rootComponent,
    ReactPageProps pageProps = _emptyPageProps,
    Object? Function(Request request)? authenticate,
  });

  Handler get handler => throw UnsupportedError(
    'ReactServerApp is only available on native Dart.',
  );
}

FutureOr<Map<String, dynamic>> _emptyPageProps(Request request) => {};
