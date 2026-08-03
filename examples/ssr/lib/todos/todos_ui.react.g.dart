import 'dart:js_interop';
import 'dart:js_interop_unsafe';
import 'package:react_js/react_js.dart';
import 'todos_ui.dart' as impl;
import 'todos_ui.react.dart' show idTodoApp;

JSObject _TodoApp_toJS(({String title}) props) {
  final o = JSObject();
  o.setProperty('title'.toJS, props.title.toJS);
  return o;
}

({String title}) _TodoApp_fromJS(JSObject js) {
final title = requiredJSString(js, "title", component: "TodoApp");
  return (title: title);
}

final JSFunction $TodoApp = (() {
  JSAny? wrapper(JSObject props) {
    final dartProps = _TodoApp_fromJS(props);
    return toReactJS(impl.TodoApp(dartProps));
  }
  return wrapper.toJS;
})() as JSFunction;
void registerTodoApp(){
  ReactRegistry.register(idTodoApp.value, $TodoApp,
      toJS: (p) => _TodoApp_toJS(p as ({String title})),
      fromJS: (js) => _TodoApp_fromJS(js));
}

