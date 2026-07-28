import 'package:react_web/react_web.dart';

@reactComponent
ReactNode Counter(({String title, int initialCount, String? subtitle, void Function(int)? onChange}) props)
{
  final (count, setCount) = useState(props.initialCount);
  final (other, setOther) = useState(false);

  useEffect(() {
    setOther(true);
  }, []);

  final inc = button(onClick: (_) {
    final newCount = count + 1;
    setCount(newCount);
    props.onChange?.call(newCount);
  }, children: [const Text('+1')]);

  final sub = props.subtitle != null ? Text(props.subtitle!) : null;

  return div(children: [
    Text(props.title),
    Text('Count: $count'),
    inc,
    ?sub,
    Text(other ? 'effect:ran' : 'effect:pending'),
  ]);
}
