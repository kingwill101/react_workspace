import 'package:react_web/react_web.dart';

import 'shadcn.dart';

/// Root component — client-only, no server functions.
@reactComponent
ReactNode App(({String title}) props) {
  final (message, setMessage) = useState<String?>('Hello from the client');
  final (clicks, setClicks) = useState(0);

  return div(
    children: [
      shadcnCard(
        className: 'mx-auto mt-16 max-w-lg p-6',
        children: [
          h1(children: [Text(props.title)]),
          p(children: [Text(message!)]),
          p(children: [Text('Pressed $clicks times')]),
          shadcnTextarea(
            className: 'mt-4',
            placeholder: 'Write a note...',
          ),
          shadcnButton(
            size: 'lg',
            onClick: ReactCallback.zero(() {
              setClicks(clicks + 1);
              setMessage('The click was handled by Dart.');
            }),
            children: [const Text('Try the shadcn Button')],
          ),
        ],
      ),
    ],
  );
}
