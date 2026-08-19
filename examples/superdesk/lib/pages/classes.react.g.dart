import 'dart:js_interop';
import 'dart:js_interop_unsafe';
import 'package:react_js/react_js.dart';
import 'package:react_js/src/codec_registry.dart' show ReactCodecRegistry;
import 'classes.dart' as impl;
import 'classes.react.dart' show idClassesPage;

JSObject _ClassesPage_toJS(
  ({List<Map<String, dynamic>> classes, dynamic Function(String) onToast})
  props,
) {
  final o = JSObject();
  o.setProperty('classes'.toJS, props.classes.jsify());
  o.setProperty(
    'onToast'.toJS,
    callbackToJS(
      ReactCallback(
        debugName: 'ClassesPage.onToast',
        signature: const (
          positional: [reactString],
          result: (
            kind: ReactValueKind.encodedObject,
            nullable: false,
            hostNamespace: null,
            typeId: null,
            codecId: 'null',
          ),
          asynchronous: false,
        ),
        invoke: (arguments) {
          return props.onToast(arguments[0] as String);
        },
      ),
    ),
  );
  return o;
}

({List<Map<String, dynamic>> classes, dynamic Function(String) onToast})
_ClassesPage_fromJS(JSObject js) {
  final classes =
      js.getProperty("classes".toJS).dartify() as List<Map<String, dynamic>>;
  final dynamic Function(String) onToast = (String param0) {
    final _fn = js.getProperty('onToast'.toJS) as JSFunction;
    final rawResult = invokeJSCallback(_fn, <JSAny?>[
      encodeReactValue(reactString, param0),
    ]);
    return decodeReactValue((
          kind: ReactValueKind.encodedObject,
          nullable: false,
          hostNamespace: null,
          typeId: null,
          codecId: 'null',
        ), rawResult)
        as dynamic;
  };
  return (classes: classes, onToast: onToast);
}

final JSFunction $ClassesPage =
    (() {
          JSAny? wrapper(JSObject props) {
            final dartProps = _ClassesPage_fromJS(props);
            return toReactJS(impl.ClassesPage(dartProps));
          }

          return wrapper.toJS;
        })()
        as JSFunction;
void registerClassesPage() {
  ReactRegistry.register(
    idClassesPage.value,
    $ClassesPage,
    toJS: (p) => _ClassesPage_toJS(
      p
          as ({
            List<Map<String, dynamic>> classes,
            dynamic Function(String) onToast,
          }),
    ),
    fromJS: (js) => _ClassesPage_fromJS(js),
  );
}
