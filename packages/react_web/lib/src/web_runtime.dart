/// Neutral runtime support for the generated full Web surface.
///
/// Browser and SSR entry points both install a [WebRuntime]. Generated globals
/// (`window`, `document`, `navigator`, `localStorage`, …) route through
/// [WebRuntime.current] so we never depend on whatever globals happen to exist
/// in the current Node version.
library;

import 'generated/web/web.dart';

/// Thrown by generated SSR members for Web APIs that exist in the surface but
/// are not executable on the server. Never return `null` where the IDL type is
/// non-null just to accommodate SSR.
final class UnsupportedWebApiError extends UnsupportedError {
  final String api;
  final String? exposed;

  UnsupportedWebApiError(this.api, {this.exposed})
    : super(
        '$api is unavailable during SSR'
        '${exposed == null ? '' : ' (Exposed=$exposed)'}.',
      );
}

/// Opaque marker implemented by neutral types that are lowered opaquely (a
/// visible, documented lowering rather than a silent omission).
abstract interface class WebOpaqueObject {}

/// Opaque value used for an unsupported parameter/return type position.
/// Prefer a strongly-typed lowering; this is the "opaque but present" fallback.
typedef WebOpaqueValue = Object;

/// The runtime backend installed by a browser or SSR entry point.
abstract interface class WebRuntime {
  /// The global [Window] proxy.
  Window get window;
  Document get document;
  Navigator get navigator;

  static WebRuntime get current =>
      _current ?? (throw StateError('WebRuntime has not been installed.'));

  static WebRuntime? _current;

  static void install(WebRuntime runtime) {
    _current = runtime;
  }
}
