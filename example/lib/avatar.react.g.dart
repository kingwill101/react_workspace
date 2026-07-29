import 'dart:js_interop';
import 'dart:js_interop_unsafe';
import 'package:react_js/react_js.dart';
import 'avatar.dart' as impl;
import 'avatar.react.dart' show idAvatar;

JSObject _Avatar_toJS(({int size, String src}) props) {
  final o = JSObject();
  o.setProperty('size'.toJS, props.size.toJS);
  o.setProperty('src'.toJS, props.src.toJS);
  return o;
}

({int size, String src}) _Avatar_fromJS(JSObject js) {
  final size = requiredJSInt(js, "size", component: "size");
  final src = requiredJSString(js, "src", component: "src");
  return (size: size, src: src);
}

final JSFunction $Avatar =
    (() {
          JSAny? wrapper(JSObject props) {
            final dartProps = _Avatar_fromJS(props);
            return toReactJS(impl.Avatar(dartProps));
          }

          return wrapper.toJS;
        })()
        as JSFunction;
void registerAvatar() {
  ReactRegistry.register(
    idAvatar.value,
    $Avatar,
    toJS: (p) => _Avatar_toJS(p as ({int size, String src})),
    fromJS: (js) => _Avatar_fromJS(js),
  );
}
