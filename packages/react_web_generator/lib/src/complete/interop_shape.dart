/// Interop shape descriptors for Web IDL → Dart/JS boundary.
/// Each parameter and return value is assigned a shape so the browser adapter
/// can convert without guessing from a small string-kind table.
library;

sealed class InteropShape {
  const InteropShape();
}

final class PrimitiveShape extends InteropShape {
  final String name;
  const PrimitiveShape(this.name);
  static const string = PrimitiveShape('String');
  static const int_ = PrimitiveShape('int');
  static const double_ = PrimitiveShape('double');
  static const bool_ = PrimitiveShape('bool');
  static const void_ = PrimitiveShape('void');
}

final class InterfaceShape extends InteropShape {
  final String interfaceName;
  const InterfaceShape(this.interfaceName);
}

final class PromiseShape extends InteropShape {
  final InteropShape inner;
  const PromiseShape(this.inner);
}

final class SequenceShape extends InteropShape {
  final InteropShape element;
  const SequenceShape(this.element);
}

final class FrozenArrayShape extends InteropShape {
  final InteropShape element;
  const FrozenArrayShape(this.element);
}

final class RecordShape extends InteropShape {
  final InteropShape key;
  final InteropShape value;
  const RecordShape(this.key, this.value);
}

final class DictionaryShape extends InteropShape {
  final String dictionaryName;
  const DictionaryShape(this.dictionaryName);
}

final class CallbackShape extends InteropShape {
  final List<InteropShape> parameters;
  final InteropShape result;
  const CallbackShape(this.parameters, this.result);
}

final class UnionShape extends InteropShape {
  final List<InteropShape> options;
  const UnionShape(this.options);
}

final class NullableShape extends InteropShape {
  final InteropShape inner;
  const NullableShape(this.inner);
}

final class TypedArrayShape extends InteropShape {
  final String name;
  const TypedArrayShape(this.name);
}
