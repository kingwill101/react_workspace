/// Native placeholder for the JavaScript SSR bridge.
///
/// The SSR bridge in `server.dart` is only available to the JavaScript build.
/// Native server-function consumers can import the public `react_server.dart`
/// library without pulling `dart:js_interop` into their VM binary.
library;
