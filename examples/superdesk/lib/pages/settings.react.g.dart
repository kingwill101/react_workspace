import 'dart:js_interop';
import 'dart:js_interop_unsafe';
import 'package:react_js/react_js.dart';
import 'package:react_js/src/codec_registry.dart' show ReactCodecRegistry;
import 'settings.dart' as impl;
import 'settings.react.dart' show idSettingsPage;

JSObject _SettingsPage_toJS(
  ({
    dynamic Function() onExport,
    dynamic Function(String) onImport,
    dynamic Function() onLogout,
    dynamic Function() onReset,
    dynamic Function(String) onToast,
    Map<String, dynamic>? user,
  })
  props,
) {
  final o = JSObject();
  o.setProperty(
    'onExport'.toJS,
    callbackToJS(
      ReactCallback(
        debugName: 'SettingsPage.onExport',
        signature: const (
          positional: [],
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
          return props.onExport();
        },
      ),
    ),
  );
  o.setProperty(
    'onImport'.toJS,
    callbackToJS(
      ReactCallback(
        debugName: 'SettingsPage.onImport',
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
          return props.onImport(arguments[0] as String);
        },
      ),
    ),
  );
  o.setProperty(
    'onLogout'.toJS,
    callbackToJS(
      ReactCallback(
        debugName: 'SettingsPage.onLogout',
        signature: const (
          positional: [],
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
          return props.onLogout();
        },
      ),
    ),
  );
  o.setProperty(
    'onReset'.toJS,
    callbackToJS(
      ReactCallback(
        debugName: 'SettingsPage.onReset',
        signature: const (
          positional: [],
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
          return props.onReset();
        },
      ),
    ),
  );
  o.setProperty(
    'onToast'.toJS,
    callbackToJS(
      ReactCallback(
        debugName: 'SettingsPage.onToast',
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
  o.setProperty('user'.toJS, props.user == null ? null : props.user!.jsify());
  return o;
}

({
  dynamic Function() onExport,
  dynamic Function(String) onImport,
  dynamic Function() onLogout,
  dynamic Function() onReset,
  dynamic Function(String) onToast,
  Map<String, dynamic>? user,
})
_SettingsPage_fromJS(JSObject js) {
  final dynamic Function() onExport = () {
    final _fn = js.getProperty('onExport'.toJS) as JSFunction;
    final rawResult = invokeJSCallback(_fn, <JSAny?>[]);
    return decodeReactValue((
          kind: ReactValueKind.encodedObject,
          nullable: false,
          hostNamespace: null,
          typeId: null,
          codecId: 'null',
        ), rawResult)
        as dynamic;
  };
  final dynamic Function(String) onImport = (String param0) {
    final _fn = js.getProperty('onImport'.toJS) as JSFunction;
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
  final dynamic Function() onLogout = () {
    final _fn = js.getProperty('onLogout'.toJS) as JSFunction;
    final rawResult = invokeJSCallback(_fn, <JSAny?>[]);
    return decodeReactValue((
          kind: ReactValueKind.encodedObject,
          nullable: false,
          hostNamespace: null,
          typeId: null,
          codecId: 'null',
        ), rawResult)
        as dynamic;
  };
  final dynamic Function() onReset = () {
    final _fn = js.getProperty('onReset'.toJS) as JSFunction;
    final rawResult = invokeJSCallback(_fn, <JSAny?>[]);
    return decodeReactValue((
          kind: ReactValueKind.encodedObject,
          nullable: false,
          hostNamespace: null,
          typeId: null,
          codecId: 'null',
        ), rawResult)
        as dynamic;
  };
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
  final user = js.getProperty("user".toJS).dartify() as Map<String, dynamic>?;
  return (
    onExport: onExport,
    onImport: onImport,
    onLogout: onLogout,
    onReset: onReset,
    onToast: onToast,
    user: user,
  );
}

final JSFunction $SettingsPage =
    (() {
          JSAny? wrapper(JSObject props) {
            final dartProps = _SettingsPage_fromJS(props);
            return toReactJS(impl.SettingsPage(dartProps));
          }

          return wrapper.toJS;
        })()
        as JSFunction;
void registerSettingsPage() {
  ReactRegistry.register(
    idSettingsPage.value,
    $SettingsPage,
    toJS: (p) => _SettingsPage_toJS(
      p
          as ({
            dynamic Function() onExport,
            dynamic Function(String) onImport,
            dynamic Function() onLogout,
            dynamic Function() onReset,
            dynamic Function(String) onToast,
            Map<String, dynamic>? user,
          }),
    ),
    fromJS: (js) => _SettingsPage_fromJS(js),
  );
}
