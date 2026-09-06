import 'package:react_dom/react_dom.dart';

import '../router.dart' as router;

/// Fallback page for routes that are not in the dashboard route table.
@reactComponent
// ignore: non_constant_identifier_names
ReactNode NotFoundPage(({String? scope}) props) => div(
  className: 'flex min-h-screen items-center justify-center bg-muted',
  children: [
    div(
      className: 'text-center',
      children: [
        h1(className: 'mb-4 text-4xl font-bold', children: const [Text('404')]),
        p(
          className: 'mb-4 text-xl text-muted-foreground',
          children: const [Text('Oops! Page not found')],
        ),
        router.navLink(
          to: '/',
          className: 'text-primary underline hover:no-underline',
          children: const [Text('Return to home')],
        ),
      ],
    ),
  ],
);
