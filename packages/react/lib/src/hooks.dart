import 'internal.dart';
import 'node.dart';
typedef EffectCallback = void Function();
(T, void Function(T)) useState<T>(T initial) => ReactInternal.binding.useState(initial);
void useEffect(EffectCallback e, [List<Object?>? deps]) => ReactInternal.binding.useEffect(e, deps);
ReactNode div({Map<String, Object?> props = const {}, List<ReactNode> children = const [], String? key}) =>
    Intrinsic('div', props: props, children: children, key: key);
