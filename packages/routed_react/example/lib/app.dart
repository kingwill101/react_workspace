import 'dart:async';

import 'package:react_dom/react_dom.dart';

import 'greeting.client.g.dart' show greetAction;

/// Root component. `title` is supplied by the server during SSR.
///
/// Uses the typed host elements from `package:react_dom` so the same component
/// is used by the browser and SSR builds.
@reactComponent
ReactNode App(({String title}) props) {
  final (message, setMessage) = useState<String?>(null);
  final (requestPending, setRequestPending) = useState(false);

  void callGreeting() {
    if (requestPending) return;
    setRequestPending(true);
    unawaited(() async {
      try {
        final response = await greetAction(name: 'Dart');
        setMessage(response);
      } catch (error) {
        setMessage('Request failed: $error');
      } finally {
        setRequestPending(false);
      }
    }());
  }

  return div(
    style: const {
      'fontFamily': 'system-ui, sans-serif',
      'maxWidth': '640px',
      'margin': '0 auto',
      'padding': '48px 24px',
      'textAlign': 'center',
      'color': 'red',
    },
    children: [
      div(key: 'title', children: [Text(props.title)]),
      div(
        key: 'welcome',
        children: [const Text('Hello! — edit lib/app.dart to get started.')],
      ),
      div(
        key: 'instructions',
        children: [const Text('Edit lib/app.dart and rebuild to see changes.')],
      ),
      div(
        key: 'action',
        children: [
          button(
            key: 'greet',
            onClick: (_) => callGreeting(),
            disabled: requestPending,
            children: [
              span(
                children: [
                  Text(
                    requestPending ? 'Asking the server…' : 'Ask the server',
                  ),
                ],
                key: 'button-label',
              ),
            ],
          ),
          div(
            key: 'response',
            children: [
              Text(message ?? 'The server response will appear here.'),
            ],
          ),
        ],
      ),
    ],
  );
}
