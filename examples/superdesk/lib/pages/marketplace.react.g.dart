import 'dart:js_interop';
import 'dart:js_interop_unsafe';
import 'package:react_js/react_js.dart';
import 'package:react_js/src/codec_registry.dart' show ReactCodecRegistry;
import 'marketplace.dart' as impl;
import 'marketplace.react.dart' show idMarketplacePage;

JSObject _MarketplacePage_toJS(({dynamic Function(String) onToast}) props) {
  final o = JSObject();
  o.setProperty(
    'onToast'.toJS,
    callbackToJS(
      ReactCallback(
        debugName: 'MarketplacePage.onToast',
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

({dynamic Function(String) onToast}) _MarketplacePage_fromJS(JSObject js) {
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
  return (onToast: onToast);
}

final JSFunction $MarketplacePage =
    (() {
          JSAny? wrapper(JSObject props) {
            final dartProps = _MarketplacePage_fromJS(props);
            return toReactJS(impl.MarketplacePage(dartProps));
          }

          return wrapper.toJS;
        })()
        as JSFunction;
void registerMarketplacePage() {
  ReactRegistry.register(
    idMarketplacePage.value,
    $MarketplacePage,
    toJS: (p) =>
        _MarketplacePage_toJS(p as ({dynamic Function(String) onToast})),
    fromJS: (js) => _MarketplacePage_fromJS(js),
  );
}
