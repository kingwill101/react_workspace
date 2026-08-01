import 'package:react_web/react_web.dart';

import 'app_context.dart';

enum _CounterAction { increment }

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
  final (count, dispatch) = useReducer<int, _CounterAction>(
    (state, action) => switch (action) {
      _CounterAction.increment => state + 1,
    },
    props.initialCount,
  );
  final (other, setOther) = useState<bool>(false);
  final accent = useContext(appAccentContext);
  final counterId = useId();
  final countRef = useRef(count);
  countRef.current = count;
  final progress = useMemo(() => '${(count % 10) * 10}%', [count]);
  final deferredCount = useDeferredValue(count);
  final (isPending, startTransition) = useTransition();
  useDebugValue(count, (value) => 'counter: $value');

  useEffect(() {
    setOther(true);
  }, []);

  final increment = useCallback<void Function(ReactMouseEvent)>((_) {
    final newCount = count + 1;
    startTransition(() {
      dispatch(_CounterAction.increment);
    });
    props.onChange?.call(newCount);
  }, [count]);

  final inc = button(
    key: 'increment',
    className: 'primary-button',
    onClick: increment,
    children: [const Text('+1')],
  );

  final sub = props.subtitle != null ? Text(props.subtitle!) : null;

  return div(
    className: 'counter-widget',
    style: {'--counter-accent': accent, '--counter-progress': progress},
    children: [
      div(
        key: 'title',
        className: 'widget-title',
        children: [Text(props.title)],
      ),
      div(
        key: 'value',
        id: counterId,
        className: 'count-value',
        children: [Text('$deferredCount')],
      ),
      div(key: 'actions', className: 'counter-actions', children: [inc]),
      ?sub,
      div(
        key: 'effect',
        className: 'effect-note',
        children: [
          Text(
            isPending
                ? 'Transition pending…'
                : (other ? 'Effect ready' : 'Starting effect…'),
          ),
        ],
      ),
    ],
  );
}
