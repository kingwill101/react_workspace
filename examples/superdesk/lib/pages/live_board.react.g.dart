import 'dart:js_interop';
import 'dart:js_interop_unsafe';
import 'package:react_js/react_js.dart';
import 'package:react_js/src/codec_registry.dart' show ReactCodecRegistry;
import 'live_board.dart' as impl;
import 'live_board.react.dart' show idLiveBoardPage;

JSObject _LiveBoardPage_toJS(({String liveCode, int liveJoined, dynamic Function() onJoin, dynamic Function(String) onToast, List<Map<String, dynamic>> phases}) props) {
  final o = JSObject();
  o.setProperty('liveCode'.toJS, props.liveCode.toJS);
  o.setProperty('liveJoined'.toJS, props.liveJoined.toJS);
  o.setProperty('onJoin'.toJS, callbackToJS(ReactCallback(
  debugName: 'LiveBoardPage.onJoin',
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
    return props.onJoin();
  },
)));
  o.setProperty('onToast'.toJS, callbackToJS(ReactCallback(
  debugName: 'LiveBoardPage.onToast',
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
  return o;
}

({String liveCode, int liveJoined, dynamic Function() onJoin, dynamic Function(String) onToast, List<Map<String, dynamic>> phases}) _LiveBoardPage_fromJS(JSObject js) {
final liveCode = requiredJSString(js, "liveCode", component: "LiveBoardPage");
final liveJoined = requiredJSInt(js, "liveJoined", component: "LiveBoardPage");
final dynamic Function() onJoin =
    () {
      final _fn = js.getProperty(
        'onJoin'.toJS,
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
  return (liveCode: liveCode, liveJoined: liveJoined, onJoin: onJoin, onToast: onToast, phases: phases);
}

final JSFunction $LiveBoardPage = (() {
  JSAny? wrapper(JSObject props) {
    final dartProps = _LiveBoardPage_fromJS(props);
    return toReactJS(impl.LiveBoardPage(dartProps));
  }
  return wrapper.toJS;
})() as JSFunction;
void registerLiveBoardPage(){
  ReactRegistry.register(idLiveBoardPage.value, $LiveBoardPage,
      toJS: (p) => _LiveBoardPage_toJS(p as ({String liveCode, int liveJoined, dynamic Function() onJoin, dynamic Function(String) onToast, List<Map<String, dynamic>> phases})),
      fromJS: (js) => _LiveBoardPage_fromJS(js));
}

