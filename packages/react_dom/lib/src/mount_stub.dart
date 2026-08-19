import 'package:react/react.dart';

/// Browser mounting is unavailable in VM and SSR/test builds.
void initReact() {
  throw UnsupportedError('React DOM mounting requires a browser runtime.');
}

Object getRoot(String id) =>
    throw UnsupportedError('React DOM mounting requires a browser runtime.');

bool hasSSRContent(Object root) =>
    throw UnsupportedError('React DOM mounting requires a browser runtime.');

Map<String, dynamic> getInitialProps() =>
    throw UnsupportedError('React DOM mounting requires a browser runtime.');

void mount(Object root, ReactNode node) {
  throw UnsupportedError('React DOM mounting requires a browser runtime.');
}

void hydrate(Object root, ReactNode node) {
  throw UnsupportedError('React DOM mounting requires a browser runtime.');
}
