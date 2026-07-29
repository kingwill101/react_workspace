library;

/// Platform-conditional exports.
///
/// On VM/dart:io platforms, [createServerActionHandler] provides the Shelf
/// request handler for `/__react/actions`. On web this file is replaced by
/// the `if (dart.library.io)` redirect in the barrel export.
///
/// See [shelf_handler_io.dart] for the implementation.
