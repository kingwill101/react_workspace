import 'internal.dart';

typedef EffectCallback = void Function();
(T, void Function(T)) useState<T>(T initial) => ReactInternal.binding.useState(initial);
void useEffect(EffectCallback e, [List<Object?>? deps]) => ReactInternal.binding.useEffect(e, deps);
