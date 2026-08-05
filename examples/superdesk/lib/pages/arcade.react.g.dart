import 'dart:js_interop';
import 'dart:js_interop_unsafe';
import 'package:react_js/react_js.dart';
import 'arcade.dart' as impl;
import 'arcade.react.dart' show idArcadePage;

JSObject _ArcadePage_toJS(({String arcadeGame, dynamic Function(String) onGame, dynamic Function(int) onScore, dynamic Function(String) onToast, dynamic Function(bool) onWordPop, int score, bool wordPopActive}) props) {
  final o = JSObject();
  o.setProperty('arcadeGame'.toJS, props.arcadeGame.toJS);
  o.setProperty('onGame'.toJS, callbackToJS(ReactCallback(
  debugName: 'ArcadePage.onGame',
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
    return props.onGame(arguments[0] as String);
  },
)));
  o.setProperty('onScore'.toJS, callbackToJS(ReactCallback(
  debugName: 'ArcadePage.onScore',
  signature: const (
  positional: [
    reactInt,
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
    return props.onScore(arguments[0] as int);
  },
)));
  o.setProperty('onToast'.toJS, callbackToJS(ReactCallback(
  debugName: 'ArcadePage.onToast',
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
  o.setProperty('onWordPop'.toJS, callbackToJS(ReactCallback(
  debugName: 'ArcadePage.onWordPop',
  signature: const (
  positional: [
    reactBool,
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
    return props.onWordPop(arguments[0] as bool);
  },
)));
  o.setProperty('score'.toJS, props.score.toJS);
  o.setProperty('wordPopActive'.toJS, props.wordPopActive.toJS);
  return o;
}

({String arcadeGame, dynamic Function(String) onGame, dynamic Function(int) onScore, dynamic Function(String) onToast, dynamic Function(bool) onWordPop, int score, bool wordPopActive}) _ArcadePage_fromJS(JSObject js) {
final arcadeGame = requiredJSString(js, "arcadeGame", component: "ArcadePage");
final dynamic Function(String) onGame =
    (String param0) {
      final _fn = js.getProperty(
        'onGame'.toJS,
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
final dynamic Function(int) onScore =
    (int param0) {
      final _fn = js.getProperty(
        'onScore'.toJS,
      ) as JSFunction;
      final rawResult = invokeJSCallback(
  _fn,
  <JSAny?>[
    encodeReactValue(reactInt, param0)
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
final dynamic Function(bool) onWordPop =
    (bool param0) {
      final _fn = js.getProperty(
        'onWordPop'.toJS,
      ) as JSFunction;
      final rawResult = invokeJSCallback(
  _fn,
  <JSAny?>[
    encodeReactValue(reactBool, param0)
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
final score = requiredJSInt(js, "score", component: "ArcadePage");
final wordPopActive = requiredJSBool(js, "wordPopActive", component: "ArcadePage");
  return (arcadeGame: arcadeGame, onGame: onGame, onScore: onScore, onToast: onToast, onWordPop: onWordPop, score: score, wordPopActive: wordPopActive);
}

final JSFunction $ArcadePage = (() {
  JSAny? wrapper(JSObject props) {
    final dartProps = _ArcadePage_fromJS(props);
    return toReactJS(impl.ArcadePage(dartProps));
  }
  return wrapper.toJS;
})() as JSFunction;
void registerArcadePage(){
  ReactRegistry.register(idArcadePage.value, $ArcadePage,
      toJS: (p) => _ArcadePage_toJS(p as ({String arcadeGame, dynamic Function(String) onGame, dynamic Function(int) onScore, dynamic Function(String) onToast, dynamic Function(bool) onWordPop, int score, bool wordPopActive})),
      fromJS: (js) => _ArcadePage_fromJS(js));
}

