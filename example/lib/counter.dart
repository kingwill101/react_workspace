import 'package:react_web/react_web.dart';

@reactComponent
ReactNode Counter(
  ({
    String title,
    int initialCount,
    String? subtitle,
    void Function(int)? onChange,
  })
  props,
) {
  final (count, setCount) = useState(props.initialCount);
  final (other, setOther) = useState(false);

  useEffect(() {
    setOther(true);
  }, []);

  final inc = button(
    key: 'increment',
    className: 'primary-button',
    onClick: (_) {
      final newCount = count + 1;
      setCount(newCount);
      props.onChange?.call(newCount);
    },
    children: [const Text('+1')],
  );

  final sub = props.subtitle != null ? Text(props.subtitle!) : null;

  return div(
    className: 'counter-widget',
    style: {
      '--counter-accent': count.isEven ? '#7257ff' : '#1bb7b0',
      '--counter-progress': '${(count % 10) * 10}%',
    },
    children: [
      div(
        key: 'title',
        className: 'widget-title',
        children: [Text(props.title)],
      ),
      div(key: 'value', className: 'count-value', children: [Text('$count')]),
      div(key: 'actions', className: 'counter-actions', children: [inc]),
      ?sub,
      div(
        key: 'effect',
        className: 'effect-note',
        children: [Text(other ? 'Effect ready' : 'Starting effect…')],
      ),
    ],
  );
}
