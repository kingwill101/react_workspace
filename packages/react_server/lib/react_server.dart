/// Server-side runtime for React SSR and server function dispatch.
library;

export 'src/context.dart';
export 'src/registry.dart';
export 'src/server.dart';
export 'src/shelf_handler.dart'
    if (dart.library.io) 'src/shelf_handler_io.dart';
