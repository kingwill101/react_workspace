import 'dart:js_interop';
import 'dart:js_interop_unsafe';
import 'package:react_js/react_js.dart';
import 'package:react_js/src/codec_registry.dart' show ReactCodecRegistry;
import 'dashboard.dart' as impl;
import 'dashboard.react.dart' show idDashboardPage;

JSObject _DashboardPage_toJS(
  ({
    List<Map<String, dynamic>> classes,
    List<Map<String, dynamic>> lessons,
    dynamic Function(String) onNavigate,
    dynamic Function(String) onToast,
    List<Map<String, dynamic>> syllabuses,
    List<Map<String, dynamic>> templates,
    List<Map<String, dynamic>> units,
    Map<String, dynamic>? user,
  })
  props,
) {
  final o = JSObject();
  o.setProperty('classes'.toJS, props.classes.jsify());
  o.setProperty('lessons'.toJS, props.lessons.jsify());
  o.setProperty(
    'onNavigate'.toJS,
    callbackToJS(
      ReactCallback(
        debugName: 'DashboardPage.onNavigate',
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
          return props.onNavigate(arguments[0] as String);
        },
      ),
    ),
  );
  o.setProperty(
    'onToast'.toJS,
    callbackToJS(
      ReactCallback(
        debugName: 'DashboardPage.onToast',
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
  o.setProperty('syllabuses'.toJS, props.syllabuses.jsify());
  o.setProperty('templates'.toJS, props.templates.jsify());
  o.setProperty('units'.toJS, props.units.jsify());
  o.setProperty('user'.toJS, props.user == null ? null : props.user!.jsify());
  return o;
}

({
  List<Map<String, dynamic>> classes,
  List<Map<String, dynamic>> lessons,
  dynamic Function(String) onNavigate,
  dynamic Function(String) onToast,
  List<Map<String, dynamic>> syllabuses,
  List<Map<String, dynamic>> templates,
  List<Map<String, dynamic>> units,
  Map<String, dynamic>? user,
})
_DashboardPage_fromJS(JSObject js) {
  final classes =
      js.getProperty("classes".toJS).dartify() as List<Map<String, dynamic>>;
  final lessons =
      js.getProperty("lessons".toJS).dartify() as List<Map<String, dynamic>>;
  final dynamic Function(String) onNavigate = (String param0) {
    final _fn = js.getProperty('onNavigate'.toJS) as JSFunction;
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
  final syllabuses =
      js.getProperty("syllabuses".toJS).dartify() as List<Map<String, dynamic>>;
  final templates =
      js.getProperty("templates".toJS).dartify() as List<Map<String, dynamic>>;
  final units =
      js.getProperty("units".toJS).dartify() as List<Map<String, dynamic>>;
  final user = js.getProperty("user".toJS).dartify() as Map<String, dynamic>?;
  return (
    classes: classes,
    lessons: lessons,
    onNavigate: onNavigate,
    onToast: onToast,
    syllabuses: syllabuses,
    templates: templates,
    units: units,
    user: user,
  );
}

final JSFunction $DashboardPage =
    (() {
          JSAny? wrapper(JSObject props) {
            final dartProps = _DashboardPage_fromJS(props);
            return toReactJS(impl.DashboardPage(dartProps));
          }

          return wrapper.toJS;
        })()
        as JSFunction;
void registerDashboardPage() {
  ReactRegistry.register(
    idDashboardPage.value,
    $DashboardPage,
    toJS: (p) => _DashboardPage_toJS(
      p
          as ({
            List<Map<String, dynamic>> classes,
            List<Map<String, dynamic>> lessons,
            dynamic Function(String) onNavigate,
            dynamic Function(String) onToast,
            List<Map<String, dynamic>> syllabuses,
            List<Map<String, dynamic>> templates,
            List<Map<String, dynamic>> units,
            Map<String, dynamic>? user,
          }),
    ),
    fromJS: (js) => _DashboardPage_fromJS(js),
  );
}
