import 'dart:async';

import 'package:react_dom/react_dom.dart';
import 'package:react_web/web.dart' show HTMLInputElement;

import '.generated/greeting.client.g.dart' show greetAction;

/// Root component. `title` is supplied by the server during SSR.
///
/// Uses the typed host elements from `package:react_dom` so the same component
/// is used by the browser and SSR builds.
@reactComponent
ReactNode App(({String title}) props) {
  final (message, setMessage) = useState<String?>(null);
  final (requestPending, setRequestPending) = useState(false);
  final (name, setName) = useState('Dart');
  final inputId = useId();
  final inputRef = useRef<Object>();

  void callGreeting() {
    if (requestPending) return;
    setRequestPending(true);
    unawaited(() async {
      try {
        final response = await greetAction(name: name.trim());
        setMessage(response);
      } catch (error) {
        setMessage('Request failed: $error');
      } finally {
        setRequestPending(false);
      }
    }());
  }

  return div(
    className: classNames('app-shell', {'app-shell--pending': requestPending}),
    additionalProps: dataAttributes({
      'state': requestPending ? 'busy' : 'idle',
    }),
    children: [
      div(
        key: 'header',
        className: 'app-header',
        children: [
          div(key: 'brand', className: 'brand-mark'),
          div(key: 'wordmark', children: ['Routed × React']),
        ],
      ),
      div(
        key: 'content',
        className: 'app-content',
        children: [
          div(
            key: 'eyebrow',
            className: 'eyebrow',
            children: ['Edge-rendered interface'],
          ),
          h1(key: 'title', children: [props.title]),
          div(
            key: 'lede',
            className: 'lede',
            children: [
              'A Dart React surface rendered at the edge, with static assets '
                  'served by Cloudflare and actions handled by Routed.',
            ],
          ),
        ],
      ),
      label(
        key: 'name-label',
        htmlFor: inputId,
        children: ['Who should the server greet?'],
      ),
      input(
        key: 'name-input',
        id: inputId,
        value: name,
        disabled: requestPending,
        ref: (element) => inputRef.current = element,
        onChange: (event) {
          final element = event.currentTarget as HTMLInputElement;
          setName(element.value);
        },
        additionalProps: aria(label: 'Greeting name'),
      ),
      div(
        key: 'action',
        className: 'action-panel',
        children: [
          button(
            key: 'greet',
            onClick: (_) => callGreeting(),
            disabled: requestPending,
            children: [
              requestPending ? 'Asking the server…' : 'Ask the server',
            ],
            additionalProps: aria(
              label: 'Ask the server',
              busy: requestPending,
            ),
          ),
          div(
            key: 'response',
            className: 'server-response',
            children: [message ?? 'The server response will appear here.'],
          ),
          div(
            key: 'asset-note',
            className: 'asset-note',
            children: ['Static SVG assets are served from /assets/.'],
          ),
        ],
      ),
    ],
  );
}
