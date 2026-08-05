import 'dart:js_interop';
import 'dart:js_interop_unsafe';
import 'package:react_js/react_js.dart';
import 'resources.dart' as impl;
import 'resources.react.dart' show idResourcesPage;

JSObject _ResourcesPage_toJS(({String filter, dynamic Function() onAdd, dynamic Function(Map<String, dynamic>) onDelete, dynamic Function(Map<String, dynamic>) onDuplicate, dynamic Function(Map<String, dynamic>) onEdit, dynamic Function(String) onFilter, dynamic Function(String) onSearch, dynamic Function(String) onToast, List<Map<String, dynamic>> resources, String search}) props) {
  final o = JSObject();
  o.setProperty('filter'.toJS, props.filter.toJS);
  o.setProperty('onAdd'.toJS, callbackToJS(ReactCallback(
  debugName: 'ResourcesPage.onAdd',
  signature: const (
  positional: [
    
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
    return props.onAdd();
  },
)));
  o.setProperty('onDelete'.toJS, callbackToJS(ReactCallback(
  debugName: 'ResourcesPage.onDelete',
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
    return props.onDelete(arguments[0] as Map<String, dynamic>);
  },
)));
  o.setProperty('onDuplicate'.toJS, callbackToJS(ReactCallback(
  debugName: 'ResourcesPage.onDuplicate',
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
    return props.onDuplicate(arguments[0] as Map<String, dynamic>);
  },
)));
  o.setProperty('onEdit'.toJS, callbackToJS(ReactCallback(
  debugName: 'ResourcesPage.onEdit',
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
    return props.onEdit(arguments[0] as Map<String, dynamic>);
  },
)));
  o.setProperty('onFilter'.toJS, callbackToJS(ReactCallback(
  debugName: 'ResourcesPage.onFilter',
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
    return props.onFilter(arguments[0] as String);
  },
)));
  o.setProperty('onSearch'.toJS, callbackToJS(ReactCallback(
  debugName: 'ResourcesPage.onSearch',
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
    return props.onSearch(arguments[0] as String);
  },
)));
  o.setProperty('onToast'.toJS, callbackToJS(ReactCallback(
  debugName: 'ResourcesPage.onToast',
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
  o.setProperty('resources'.toJS, props.resources.jsify());
  o.setProperty('search'.toJS, props.search.toJS);
  return o;
}

({String filter, dynamic Function() onAdd, dynamic Function(Map<String, dynamic>) onDelete, dynamic Function(Map<String, dynamic>) onDuplicate, dynamic Function(Map<String, dynamic>) onEdit, dynamic Function(String) onFilter, dynamic Function(String) onSearch, dynamic Function(String) onToast, List<Map<String, dynamic>> resources, String search}) _ResourcesPage_fromJS(JSObject js) {
final filter = requiredJSString(js, "filter", component: "ResourcesPage");
final dynamic Function() onAdd =
    () {
      final _fn = js.getProperty(
        'onAdd'.toJS,
      ) as JSFunction;
      final rawResult = invokeJSCallback(
  _fn,
  <JSAny?>[
    
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
final dynamic Function(Map<String, dynamic>) onDelete =
    (Map<String, dynamic> param0) {
      final _fn = js.getProperty(
        'onDelete'.toJS,
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
final dynamic Function(Map<String, dynamic>) onDuplicate =
    (Map<String, dynamic> param0) {
      final _fn = js.getProperty(
        'onDuplicate'.toJS,
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
final dynamic Function(Map<String, dynamic>) onEdit =
    (Map<String, dynamic> param0) {
      final _fn = js.getProperty(
        'onEdit'.toJS,
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
final dynamic Function(String) onFilter =
    (String param0) {
      final _fn = js.getProperty(
        'onFilter'.toJS,
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
final dynamic Function(String) onSearch =
    (String param0) {
      final _fn = js.getProperty(
        'onSearch'.toJS,
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
final resources = js.getProperty("resources".toJS).dartify() as List<Map<String, dynamic>>;
final search = requiredJSString(js, "search", component: "ResourcesPage");
  return (filter: filter, onAdd: onAdd, onDelete: onDelete, onDuplicate: onDuplicate, onEdit: onEdit, onFilter: onFilter, onSearch: onSearch, onToast: onToast, resources: resources, search: search);
}

final JSFunction $ResourcesPage = (() {
  JSAny? wrapper(JSObject props) {
    final dartProps = _ResourcesPage_fromJS(props);
    return toReactJS(impl.ResourcesPage(dartProps));
  }
  return wrapper.toJS;
})() as JSFunction;
void registerResourcesPage(){
  ReactRegistry.register(idResourcesPage.value, $ResourcesPage,
      toJS: (p) => _ResourcesPage_toJS(p as ({String filter, dynamic Function() onAdd, dynamic Function(Map<String, dynamic>) onDelete, dynamic Function(Map<String, dynamic>) onDuplicate, dynamic Function(Map<String, dynamic>) onEdit, dynamic Function(String) onFilter, dynamic Function(String) onSearch, dynamic Function(String) onToast, List<Map<String, dynamic>> resources, String search})),
      fromJS: (js) => _ResourcesPage_fromJS(js));
}

