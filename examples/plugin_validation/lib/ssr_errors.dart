import 'package:react_core/react.dart';
import 'package:react_web/react_web.dart' show window;

// ignore_for_file: unused_local_variable

/// Browser-only API during SSR render — `browser_api_during_ssr`.
@ReactComponent()
ReactNode SsrBadRead(({String? placeholder}) props) {
  final theme = window.localStorage.getItem(
    'theme',
  ); // expect: browser_api_during_ssr
  return Text(theme ?? 'light');
}

/// Same API inside useEffect — allowed (effect is not SSR render).
@ReactComponent()
ReactNode SsrGoodRead(({String? placeholder}) props) {
  String? theme;
  useEffect(() {
    theme = window.localStorage.getItem('theme'); // ok
  }, const []);
  return Text(theme ?? 'light');
}

/// Marked @ClientOnly — also allowed, fallback used during SSR.
/// Fix `browser_api_during_ssr` offers to insert this annotation.
@ReactComponent()
@ClientOnly()
ReactNode SsrClientOnly(({String? placeholder}) props) {
  final theme = window.localStorage.getItem('theme'); // ok — client only
  return Text(theme ?? 'light');
}

/// Direct document access — also SSR-sensitive.
@ReactComponent()
ReactNode SsrDocumentRead(({String? placeholder}) props) {
  final title =
      window.document.title; // expect: browser_api_during_ssr (heuristics)
  return Text(title);
}
