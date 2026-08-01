/// Server-side runtime for React SSR and server function dispatch.
///
/// The JavaScript SSR bridge is excluded from native builds so a Dart VM
/// action server can import this public library without `dart:js_interop`.
library;

export 'src/application_stub.dart'
    if (dart.library.io) 'src/application_io.dart';
export 'src/context.dart';
export 'src/registry.dart';
export 'src/server.dart' if (dart.library.io) 'src/server_stub.dart';
export 'src/shelf_handler.dart'
    if (dart.library.io) 'src/shelf_handler_io.dart';
