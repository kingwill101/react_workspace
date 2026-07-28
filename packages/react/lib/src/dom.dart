import 'callback.dart';
import 'node.dart';

ReactNode div({
  Map<String, Object?> props = const {},
  List<ReactNode> children = const [],
  String? key,
}) {
  return Intrinsic(
    'div',
    props: props,
    children: children,
    key: key,
  );
}

ReactNode button({
  void Function()? onClick,
  bool? disabled,
  String? className,
  List<ReactNode> children = const [],
  String? key,
}) {
  return Intrinsic(
    'button',
    props: {
      if (onClick != null)
        'onClick': ReactCallback(
          debugName: 'button.onClick',
          signature: const (
            positional: [],
            result: reactVoid,
            asynchronous: false,
          ),
          invoke: (_) {
            onClick();
            return null;
          },
        ),
      if (disabled != null) // ignore: use_null_aware_elements
        'disabled': disabled,
      if (className != null) // ignore: use_null_aware_elements
        'className': className,
    },
    children: children,
    key: key,
  );
}