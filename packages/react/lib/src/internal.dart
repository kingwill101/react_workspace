import 'node.dart';

abstract class ReactBinding {
  (T, void Function(T)) useState<T>(T initial);
  void useEffect(void Function() effect, List<Object?>? deps);
}

abstract class ReactRenderer {
  Object? render(ReactNode node);
}

class ReactInternal {
  static late ReactBinding binding;
  static late ReactRenderer renderer;
  static void init({required ReactBinding binding, required ReactRenderer renderer}) {
    ReactInternal.binding = binding;
    ReactInternal.renderer = renderer;
  }
}
