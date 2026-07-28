import 'internal.dart';

typedef EffectCallback = void Function();
(T, void Function(T)) useState<T>(T initial) =>
    currentReactRuntime.binding.useState(initial);
void useEffect(EffectCallback e, [List<Object?>? deps]) =>
    currentReactRuntime.binding.useEffect(e, deps);
