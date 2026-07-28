import 'internal.dart';
import 'node.dart';
import 'callback.dart';

typedef EffectCallback = void Function();
(T, void Function(T)) useState<T>(T initial) => ReactInternal.binding.useState(initial);
void useEffect(EffectCallback e, [List<Object?>? deps]) => ReactInternal.binding.useEffect(e, deps);
ReactNode div({Map<String, Object?> props = const {}, List<ReactNode> children = const [], String? key}) =>
    Intrinsic('div', props: props, children: children, key: key);
ReactNode button({
  void Function(SyntheticEvent event)? onClick,
  List<ReactNode> children = const [],
  String? key,
}) =>
    Intrinsic(
      'button',
      props: {
        if (onClick != null)
          'onClick': ReactCallback(
            debugName: 'button.onClick',
            signature: const (
              positional: [reactSyntheticEvent],
              result: reactVoid,
              asynchronous: false,
            ),
            invoke: (arguments) {
              onClick(arguments[0] as SyntheticEvent);
              return null;
            },
          ),
      },
      children: children,
      key: key,
    );
