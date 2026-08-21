import 'callback.dart';
import 'node.dart';

const _divHost = HostType<Map<String, Object?>>('web', 'div');
const _buttonHost = HostType<Map<String, Object?>>('web', 'button');

ReactNode div({
  Map<String, Object?> props = const {},
  ReactChildren children = const [],
  String? key,
}) {
  return HostNode<Map<String, Object?>>(
    _divHost,
    props,
    children: normalizeChildren(children),
    key: key,
  );
}

ReactNode button({
  void Function()? onClick,
  bool? disabled,
  String? className,
  ReactChildren children = const [],
  String? key,
}) {
  return HostNode<Map<String, Object?>>(
    _buttonHost,
    {
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
      'disabled': ?disabled,
      'className': ?className,
    },
    children: normalizeChildren(children),
    key: key,
  );
}
