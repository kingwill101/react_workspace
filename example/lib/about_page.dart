import 'package:react_web/react_web.dart';

/// About page: what lives in Dart, what stays in npm, and how the two sides
/// share one React runtime.
@reactComponent
ReactNode AboutPage(({String title}) props) {
  return div(
    key: 'about',
    className: 'page',
    children: [
      section(
        key: 'about-hero',
        className: 'hero',
        children: [
          div(
            key: 'eyebrow',
            className: 'eyebrow',
            children: [const Text('ABOUT THIS WORKSPACE')],
          ),
          h1(key: 'headline', children: [Text(props.title)]),
        ],
      ),
      section(
        key: 'about-body',
        className: 'surface',
        children: [
          h2(
            key: 'dart-side',
            children: [const Text('Everything you write is Dart')],
          ),
          p(
            key: 'dart-copy',
            children: [
              const Text(
                'Components, hooks, and event handlers are plain Dart. '
                'react_codegen turns each @reactComponent into a registerable '
                'component, and dart2js compiles the app for both the browser '
                'client and the Node SSR worker from the same sources.',
              ),
            ],
          ),
          h2(
            key: 'npm-side',
            children: [const Text('The DOM and the router are real npm')],
          ),
          p(
            key: 'npm-copy',
            children: [
              const Text(
                'react, react-dom, and react-router-dom are resolved from a '
                'managed npm environment, bundled by esbuild (or Rolldown), '
                'and tree-shaken to exactly the components and hooks the '
                'compiled Dart actually uses.',
              ),
            ],
          ),
          h2(
            key: 'bridge-side',
            children: [const Text('One React runtime, two processes')],
          ),
          p(
            key: 'bridge-copy',
            children: [
              const Text(
                'The server renders each route through StaticRouter, embeds '
                'the markup and initial props, and the client hydrates the '
                'same tree through BrowserRouter so navigation never reloads '
                'the page.',
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
