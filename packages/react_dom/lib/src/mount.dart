import 'dart:js_interop';
import 'dart:js_interop_unsafe';
import 'package:react/react.dart';

sealed class MountMode {
  const MountMode();
}

final class Attach extends MountMode {
  const Attach();
}

final class Hydrate extends MountMode {
  const Hydrate();
}

void mount(JSObject root, ReactNode node, MountMode mode) => switch (mode) {
      Attach() => _createRoot(root)
          .callMethod('render'.toJS, ReactInternal.renderer.render(node) as JSAny),
      Hydrate() => _hydrateRoot(root, ReactInternal.renderer.render(node) as JSAny),
    };

@JS('document.getElementById')
external JSObject? findRoot(String id);

@JS('ReactDOM.createRoot')
external JSObject _createRoot(JSObject e);

@JS('ReactDOM.hydrateRoot')
external void _hydrateRoot(JSObject e, JSAny n);
