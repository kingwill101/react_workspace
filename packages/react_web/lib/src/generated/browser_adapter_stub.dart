/// Portable placeholders for the browser adapter API.
///
/// The real adapter is selected automatically for JavaScript builds. Keeping
/// the names available on VM lets portable component and SSR tests import the
/// public `react_web` surface without loading `dart:js_interop`.
void registerBrowserAdapters() {}

void installBrowserWebRuntime() {}
