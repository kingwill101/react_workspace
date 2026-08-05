import 'dart:js_interop';
import 'dart:js_interop_unsafe';
import 'package:react_js/react_js.dart';
import 'builder.dart' as impl;
import 'builder.react.dart' show idBuilderPage;

JSObject _BuilderPage_toJS(({String lessonName, dynamic Function(String) onLessonName, dynamic Function(List<Map<String, dynamic>>) onPhases, dynamic Function(String) onToast, List<Map<String, dynamic>> phases, List<Map<String, dynamic>> resources, List<Map<String, dynamic>> templates}) props) {
  final o = JSObject();
  o.setProperty('lessonName'.toJS, props.lessonName.toJS);
  o.setProperty('onLessonName'.toJS, callbackToJS(ReactCallback(
  debugName: 'BuilderPage.onLessonName',
  signature: const (
  positional: [
    reactString,
  ],
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
    return props.onLessonName(arguments[0] as String);
  },
)));
  o.setProperty('onPhases'.toJS, callbackToJS(ReactCallback(
  debugName: 'BuilderPage.onPhases',
  signature: const (
  positional: [
    (
  kind: ReactValueKind.encodedObject,
  nullable: false,
  hostNamespace: null,
  typeId: null,
  codecId: 'null',
),
  ],
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
    return props.onPhases(arguments[0] as List<Map<String, dynamic>>);
  },
)));
  o.setProperty('onToast'.toJS, callbackToJS(ReactCallback(
  debugName: 'BuilderPage.onToast',
  signature: const (
  positional: [
    reactString,
  ],
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
)));
  o.setProperty('phases'.toJS, props.phases.jsify());
  o.setProperty('resources'.toJS, props.resources.jsify());
  o.setProperty('templates'.toJS, props.templates.jsify());
  return o;
}

({String lessonName, dynamic Function(String) onLessonName, dynamic Function(List<Map<String, dynamic>>) onPhases, dynamic Function(String) onToast, List<Map<String, dynamic>> phases, List<Map<String, dynamic>> resources, List<Map<String, dynamic>> templates}) _BuilderPage_fromJS(JSObject js) {
final lessonName = requiredJSString(js, "lessonName", component: "BuilderPage");
final dynamic Function(String) onLessonName =
    (String param0) {
      final _fn = js.getProperty(
        'onLessonName'.toJS,
      ) as JSFunction;
      final rawResult = invokeJSCallback(
  _fn,
  <JSAny?>[
    encodeReactValue(reactString, param0)
  ],
);
return decodeReactValue(
  (
  kind: ReactValueKind.encodedObject,
  nullable: false,
  hostNamespace: null,
  typeId: null,
  codecId: 'null',
),
  rawResult,
) as dynamic;
    };
final dynamic Function(List<Map<String, dynamic>>) onPhases =
    (List<Map<String, dynamic>> param0) {
      final _fn = js.getProperty(
        'onPhases'.toJS,
      ) as JSFunction;
      final rawResult = invokeJSCallback(
  _fn,
  <JSAny?>[
    encodeReactValue((
  kind: ReactValueKind.encodedObject,
  nullable: false,
  hostNamespace: null,
  typeId: null,
  codecId: 'null',
), param0)
  ],
);
return decodeReactValue(
  (
  kind: ReactValueKind.encodedObject,
  nullable: false,
  hostNamespace: null,
  typeId: null,
  codecId: 'null',
),
  rawResult,
) as dynamic;
    };
final dynamic Function(String) onToast =
    (String param0) {
      final _fn = js.getProperty(
        'onToast'.toJS,
      ) as JSFunction;
      final rawResult = invokeJSCallback(
  _fn,
  <JSAny?>[
    encodeReactValue(reactString, param0)
  ],
);
return decodeReactValue(
  (
  kind: ReactValueKind.encodedObject,
  nullable: false,
  hostNamespace: null,
  typeId: null,
  codecId: 'null',
),
  rawResult,
) as dynamic;
    };
final phases = js.getProperty("phases".toJS).dartify() as List<Map<String, dynamic>>;
final resources = js.getProperty("resources".toJS).dartify() as List<Map<String, dynamic>>;
final templates = js.getProperty("templates".toJS).dartify() as List<Map<String, dynamic>>;
  return (lessonName: lessonName, onLessonName: onLessonName, onPhases: onPhases, onToast: onToast, phases: phases, resources: resources, templates: templates);
}

final JSFunction $BuilderPage = (() {
  JSAny? wrapper(JSObject props) {
    final dartProps = _BuilderPage_fromJS(props);
    return toReactJS(impl.BuilderPage(dartProps));
  }
  return wrapper.toJS;
})() as JSFunction;
void registerBuilderPage(){
  ReactRegistry.register(idBuilderPage.value, $BuilderPage,
      toJS: (p) => _BuilderPage_toJS(p as ({String lessonName, dynamic Function(String) onLessonName, dynamic Function(List<Map<String, dynamic>>) onPhases, dynamic Function(String) onToast, List<Map<String, dynamic>> phases, List<Map<String, dynamic>> resources, List<Map<String, dynamic>> templates})),
      fromJS: (js) => _BuilderPage_fromJS(js));
}

