import 'package:react_web/react_web.dart';

/// Root component — client-only, no server functions.
@reactComponent
ReactNode App(({String title}) props) {
  final (message, setMessage) = useState<String?>('Hello from the client');

  return div(
    style: const {
      'fontFamily': 'system-ui, sans-serif',
      'maxWidth': '640px',
      'margin': '0 auto',
      'padding': '48px 24px',
      'textAlign': 'center',
    },
    children: [
      h1(children: [Text(props.title)]),
      p(style: const {'minHeight': '1.6em'}, children: [Text(message!)]),
      p(
        children: [const Text('Edit lib/app.dart and rebuild to see changes.')],
      ),
    ],
  );
}
