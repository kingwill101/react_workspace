import 'package:react_web/react_web.dart';
import 'avatar.react.dart';
import 'badge.react.dart';
import 'counter.react.dart';

@reactComponent
ReactNode App(({String title}) props) => div(
  children: [
    Badge(label: props.title),
    Avatar(src: 'user.png', size: 48),
    Counter(
      title: props.title,
      initialCount: 0,
      subtitle: 'from App',
      onChange: (_) {
        print("Something happened");
      },
    ),
  ],
);
