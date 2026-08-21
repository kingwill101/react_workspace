/// Portable server-side runtime for React SSR and server function dispatch.
library;

export 'src/context.dart';
export 'src/metadata.dart';
export 'src/registry.dart';
export 'src/server.dart' if (dart.library.io) 'src/server_stub.dart';
export 'src/ssr_client_stub.dart' if (dart.library.io) 'src/ssr_client.dart';
