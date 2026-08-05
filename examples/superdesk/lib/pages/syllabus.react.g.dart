import 'dart:js_interop';
import 'dart:js_interop_unsafe';
import 'package:react_js/react_js.dart';
import 'syllabus.dart' as impl;
import 'syllabus.react.dart' show idSyllabusPage;

JSObject _SyllabusPage_toJS(({List<String> expandedUnits, dynamic Function(String) onSelect, dynamic Function(String) onToast, dynamic Function(String) onToggle, String selectedSyllabus}) props) {
  final o = JSObject();
  o.setProperty('expandedUnits'.toJS, props.expandedUnits.jsify());
  o.setProperty('onSelect'.toJS, callbackToJS(ReactCallback(
  debugName: 'SyllabusPage.onSelect',
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
    return props.onSelect(arguments[0] as String);
  },
)));
  o.setProperty('onToast'.toJS, callbackToJS(ReactCallback(
  debugName: 'SyllabusPage.onToast',
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
  o.setProperty('onToggle'.toJS, callbackToJS(ReactCallback(
  debugName: 'SyllabusPage.onToggle',
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
    return props.onToggle(arguments[0] as String);
  },
)));
  o.setProperty('selectedSyllabus'.toJS, props.selectedSyllabus.toJS);
  return o;
}

({List<String> expandedUnits, dynamic Function(String) onSelect, dynamic Function(String) onToast, dynamic Function(String) onToggle, String selectedSyllabus}) _SyllabusPage_fromJS(JSObject js) {
final expandedUnits = js.getProperty("expandedUnits".toJS).dartify() as List<String>;
final dynamic Function(String) onSelect =
    (String param0) {
      final _fn = js.getProperty(
        'onSelect'.toJS,
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
final dynamic Function(String) onToggle =
    (String param0) {
      final _fn = js.getProperty(
        'onToggle'.toJS,
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
final selectedSyllabus = requiredJSString(js, "selectedSyllabus", component: "SyllabusPage");
  return (expandedUnits: expandedUnits, onSelect: onSelect, onToast: onToast, onToggle: onToggle, selectedSyllabus: selectedSyllabus);
}

final JSFunction $SyllabusPage = (() {
  JSAny? wrapper(JSObject props) {
    final dartProps = _SyllabusPage_fromJS(props);
    return toReactJS(impl.SyllabusPage(dartProps));
  }
  return wrapper.toJS;
})() as JSFunction;
void registerSyllabusPage(){
  ReactRegistry.register(idSyllabusPage.value, $SyllabusPage,
      toJS: (p) => _SyllabusPage_toJS(p as ({List<String> expandedUnits, dynamic Function(String) onSelect, dynamic Function(String) onToast, dynamic Function(String) onToggle, String selectedSyllabus})),
      fromJS: (js) => _SyllabusPage_fromJS(js));
}

