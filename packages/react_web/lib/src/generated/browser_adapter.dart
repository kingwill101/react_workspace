// GENERATED CODE — DO NOT EDIT
// ignore_for_file: type=lint
// ignore_for_file: constant_identifier_names, non_constant_identifier_names, avoid_renaming_method_parameters, invalid_runtime_check_with_js_interop_types

import 'dart:js_interop';
import 'dart:js_interop_unsafe';

import 'package:react_js/react_js.dart' show ReactCodecRegistry;
import 'package:react_web/src/generated/react_events.dart';
import 'package:react_web/src/generated/web/web.dart';
import 'package:react_web/src/web_runtime.dart';
import 'package:web/web.dart' as web;

/// Browser proxy base: forwards interface members to the
/// underlying JS object via [noSuchMethod].
abstract class BrowserObjectAdapter {
  BrowserObjectAdapter(this._element);

  /// The underlying JS object.
  final JSObject _element;

  @override
  dynamic noSuchMethod(Invocation invocation) {
    final className = _baseClassName(runtimeType.toString());
    final name = _memberName(invocation);
    final key = '$className.$name';
    final jsName = _jsNames[key] ?? name;
    if (invocation.isGetter) {
      return _convert(_element.getProperty(jsName.toJS), _kinds[key] ?? 'wrap');
    }
    if (invocation.isSetter) {
      final arg = invocation.positionalArguments.first;
      _element.setProperty(
        jsName.toJS,
        arg is Function ? _handlerToJs(arg) : _toJs(arg),
      );
      return null;
    }
    if (invocation.isMethod) {
      final args = [
        for (final a in invocation.positionalArguments)
          a is Function ? _handlerToJs(a) : _toJs(a),
      ];
      return _convert(
        _element.callMethodVarArgs(jsName.toJS, args),
        _kinds[key] ?? 'wrap',
      );
    }
    return super.noSuchMethod(invocation);
  }
}

final class _UnknownObject extends BrowserObjectAdapter {
  _UnknownObject(super.element);
}

/// Strips type arguments from `runtimeType` string forms so
/// generic proxies (e.g. `BrowserReactMouseEvent<EventTarget>`)
/// still hit their kind-table entries.
String _baseClassName(String runtimeTypeName) {
  final i = runtimeTypeName.indexOf('<');
  return i < 0 ? runtimeTypeName : runtimeTypeName.substring(0, i);
}

String _memberName(Invocation invocation) {
  final symbol = invocation.memberName.toString();
  final open = symbol.indexOf('"');
  final close = symbol.lastIndexOf('"');
  var name = open < 0 ? symbol : symbol.substring(open + 1, close);
  if (name.endsWith('=')) name = name.substring(0, name.length - 1);
  return name;
}

JSAny? _toJs(Object? value) {
  if (value == null) return null;
  if (value is BrowserObjectAdapter) return value._element;
  if (value is JSAny) return value;
  if (value is String) return value.toJS;
  if (value is bool) return value.toJS;
  if (value is int) return value.toJS;
  if (value is double) return value.toJS;
  if (value is List)
    return [for (final e in value) _toJs(e)].toJS;
  if (value is Function) return _handlerToJs(value);
  throw ArgumentError('Unsupported JS argument type: ${value.runtimeType}.');
}

/// Creates a JS function that invokes the Dart handler [reference]
/// through the module-level [_dispatchDartHandler] trampoline.
/// Uses the same `__dartReactCallbacks.create` machinery as the React
/// callback bridge (see `package:react_js`), which dart2js always
/// compiles into a real JS function.
@JS('__dartReactCallbacks.create')
external JSFunction _createDartHandler(
  ExternalDartReference<Function> reference,
  JSExportedDartFunction dispatcher,
);

/// Module-level trampoline: decodes the raw JS arguments, wraps the
/// event object in a `Browser*` proxy, and forwards it to the
/// Dart handler. Top-level (not a closure) so that `.toJS` compiles
/// into a real JS function, exactly like `_dispatchReactCallback`.
JSAny? _dispatchDartHandler(
  ExternalDartReference<Function> reference,
  JSArray<JSAny?> rawArguments,
) {
  final handler = reference.toDartObject;
  Object? event;
  final raw = rawArguments.length > 0 ? rawArguments[0] : null;
  if (raw != null && !raw.isNull && !raw.isUndefined) {
    if (raw is JSString) {
      event = raw.toDart;
    } else if (raw is JSBoolean) {
      event = raw.toDart;
    } else if (raw is JSNumber) {
      event = raw.toDartDouble;
    } else {
      event = _wrapObject(raw as JSObject);
    }
  }
  final result = handler(event);
  if (result == null) return null;
  if (result is JSAny) return result;
  return _toJs(result);
}

final JSExportedDartFunction _dispatchDartHandlerJS =
    _dispatchDartHandler.toJS;

/// Bridges a Dart callback (e.g. an `onmessage` handler) into a
/// JS function. The callback travels to JS as an opaque
/// [ExternalDartReference]; the actual JS function is created by the
/// `__dartReactCallbacks.create` trampoline.
JSFunction? _handlerToJs(Object? value) {
  if (value == null) return null;
  return _createDartHandler(
    (value as Function).toExternalReference,
    _dispatchDartHandlerJS,
  );
}

dynamic _convert(JSAny? value, String kind) {
  if (value == null || value.isNull || value.isUndefined) return null;
  if (kind == "promise" && value is JSPromise) {
    return (value as JSPromise<JSAny?>).toDart;
  }
  if (kind == "list" && value is JSArray) {
    return (value as JSArray<JSAny?>).toDart.map((e) => _convert(e, "wrap")).toList();
  }
  if (kind == "map" && value is JSObject) {
    // record<K,V> → JS object with string keys; best-effort map view.
    return _wrapObject(value as JSObject);
  }
  return switch (kind) {
    'bool' => (value as JSBoolean).toDart,
    'int' => (value as JSNumber).toDartInt,
    'double' => (value as JSNumber).toDartDouble,
    'string' => (value as JSString).toDart,
    'void' => null,
    'jsfunction' => value,
    'promise' => (value is JSPromise ? (value as JSPromise<JSAny?>).toDart : _wrapObject(value as JSObject)),
    'list' => (value is JSArray ? (value as JSArray<JSAny?>).toDart.map((e) => _convert(e, 'wrap')).toList() : _wrapObject(value as JSObject)),
    'typedArray' => value,
    _ => value is JSString
        ? (value as JSString).toDart
        : value is JSBoolean
            ? (value as JSBoolean).toDart
            : value is JSNumber
                ? (value as JSNumber).toDartDouble
                : _wrapObject(value as JSObject),
  };
}

/// Wraps a JS object in the proxy matching its constructor
/// name, or an opaque fallback proxy when unknown.
BrowserObjectAdapter _wrapObject(JSObject object) {
  final factory = _wrapFactories[_ctorName(object)];
  return factory != null ? factory(object) : _UnknownObject(object);
}

String _ctorName(JSObject object) {
  try {
    final constructor = object.getProperty('constructor'.toJS);
    if (constructor is JSObject) {
      final name = constructor.getProperty('name'.toJS);
      if (name is JSString) return name.toDart;
    }
  } on Object {
    // Exotic prototypes wrap opaquely.
  }
  return '';
}

/// Member kinds by `ClassName.member`, mirroring the neutral
/// surface member types for [BrowserObjectAdapter] delegation.
const Map<String, String> _kinds = {
  'BrowserAbortController.abort': 'void',
  'BrowserAbortController.signal': 'wrap',
  'BrowserAbortSignal.aborted': 'bool',
  'BrowserAbortSignal.onabort': 'jsfunction',
  'BrowserAbortSignal.reason': 'wrap',
  'BrowserAbortSignal.throwIfAborted': 'void',
  'BrowserAnalyserNode.fftSize': 'int',
  'BrowserAnalyserNode.frequencyBinCount': 'int',
  'BrowserAnalyserNode.getByteFrequencyData': 'void',
  'BrowserAnalyserNode.getByteTimeDomainData': 'void',
  'BrowserAnalyserNode.getFloatFrequencyData': 'void',
  'BrowserAnalyserNode.getFloatTimeDomainData': 'void',
  'BrowserAnalyserNode.maxDecibels': 'double',
  'BrowserAnalyserNode.minDecibels': 'double',
  'BrowserAnalyserNode.smoothingTimeConstant': 'double',
  'BrowserAnimation.cancel': 'void',
  'BrowserAnimation.commitStyles': 'void',
  'BrowserAnimation.currentTime': 'wrap',
  'BrowserAnimation.effect': 'wrap',
  'BrowserAnimation.finish': 'void',
  'BrowserAnimation.finished': 'wrap',
  'BrowserAnimation.id': 'string',
  'BrowserAnimation.oncancel': 'jsfunction',
  'BrowserAnimation.onfinish': 'jsfunction',
  'BrowserAnimation.onremove': 'jsfunction',
  'BrowserAnimation.pause': 'void',
  'BrowserAnimation.pending': 'bool',
  'BrowserAnimation.persist': 'void',
  'BrowserAnimation.play': 'void',
  'BrowserAnimation.playState': 'wrap',
  'BrowserAnimation.playbackRate': 'double',
  'BrowserAnimation.ready': 'wrap',
  'BrowserAnimation.replaceState': 'wrap',
  'BrowserAnimation.reverse': 'void',
  'BrowserAnimation.startTime': 'wrap',
  'BrowserAnimation.timeline': 'wrap',
  'BrowserAnimation.updatePlaybackRate': 'void',
  'BrowserAnimationEffect.getComputedTiming': 'wrap',
  'BrowserAnimationEffect.getTiming': 'wrap',
  'BrowserAnimationEffect.updateTiming': 'void',
  'BrowserAnimationEvent.animationName': 'wrap',
  'BrowserAnimationEvent.elapsedTime': 'double',
  'BrowserAnimationEvent.pseudoElement': 'wrap',
  'BrowserAnimationPlaybackEvent.currentTime': 'wrap',
  'BrowserAnimationPlaybackEvent.timelineTime': 'wrap',
  'BrowserAnimationTimeline.currentTime': 'wrap',
  'BrowserAttr.localName': 'string',
  'BrowserAttr.name': 'string',
  'BrowserAttr.namespaceURI': 'string',
  'BrowserAttr.ownerElement': 'wrap',
  'BrowserAttr.prefix': 'string',
  'BrowserAttr.specified': 'bool',
  'BrowserAttr.value': 'string',
  'BrowserAudioBuffer.copyFromChannel': 'void',
  'BrowserAudioBuffer.copyToChannel': 'void',
  'BrowserAudioBuffer.duration': 'double',
  'BrowserAudioBuffer.getChannelData': 'typedArray',
  'BrowserAudioBuffer.length': 'int',
  'BrowserAudioBuffer.numberOfChannels': 'int',
  'BrowserAudioBuffer.sampleRate': 'double',
  'BrowserAudioBufferSourceNode.buffer': 'wrap',
  'BrowserAudioBufferSourceNode.detune': 'wrap',
  'BrowserAudioBufferSourceNode.loop': 'bool',
  'BrowserAudioBufferSourceNode.loopEnd': 'double',
  'BrowserAudioBufferSourceNode.loopStart': 'double',
  'BrowserAudioBufferSourceNode.playbackRate': 'wrap',
  'BrowserAudioBufferSourceNode.start': 'void',
  'BrowserAudioContext.baseLatency': 'double',
  'BrowserAudioContext.close': 'wrap',
  'BrowserAudioContext.createMediaElementSource': 'wrap',
  'BrowserAudioContext.createMediaStreamDestination': 'wrap',
  'BrowserAudioContext.createMediaStreamSource': 'wrap',
  'BrowserAudioContext.createMediaStreamTrackSource': 'wrap',
  'BrowserAudioContext.getOutputTimestamp': 'wrap',
  'BrowserAudioContext.outputLatency': 'double',
  'BrowserAudioContext.resume': 'wrap',
  'BrowserAudioContext.suspend': 'wrap',
  'BrowserAudioParam.automationRate': 'wrap',
  'BrowserAudioParam.cancelAndHoldAtTime': 'wrap',
  'BrowserAudioParam.cancelScheduledValues': 'wrap',
  'BrowserAudioParam.defaultValue': 'double',
  'BrowserAudioParam.exponentialRampToValueAtTime': 'wrap',
  'BrowserAudioParam.linearRampToValueAtTime': 'wrap',
  'BrowserAudioParam.maxValue': 'double',
  'BrowserAudioParam.minValue': 'double',
  'BrowserAudioParam.setTargetAtTime': 'wrap',
  'BrowserAudioParam.setValueAtTime': 'wrap',
  'BrowserAudioParam.setValueCurveAtTime': 'wrap',
  'BrowserAudioParam.value': 'double',
  'BrowserAudioProcessingEvent.inputBuffer': 'wrap',
  'BrowserAudioProcessingEvent.outputBuffer': 'wrap',
  'BrowserAudioProcessingEvent.playbackTime': 'double',
  'BrowserAudioTrack.enabled': 'bool',
  'BrowserAudioTrack.id': 'string',
  'BrowserAudioTrack.kind': 'string',
  'BrowserAudioTrack.label': 'string',
  'BrowserAudioTrack.language': 'string',
  'BrowserAudioTrack.sourceBuffer': 'wrap',
  'BrowserAudioTrackList.getTrackById': 'wrap',
  'BrowserAudioTrackList.length': 'int',
  'BrowserAudioTrackList.onaddtrack': 'jsfunction',
  'BrowserAudioTrackList.onchange': 'jsfunction',
  'BrowserAudioTrackList.onremovetrack': 'jsfunction',
  'BrowserAudioWorkletNode.onprocessorerror': 'jsfunction',
  'BrowserAudioWorkletNode.parameters': 'wrap',
  'BrowserAudioWorkletNode.port': 'wrap',
  'BrowserAudioWorkletProcessor.port': 'wrap',
  'BrowserBarProp.visible': 'bool',
  'BrowserBiquadFilterNode.detune': 'wrap',
  'BrowserBiquadFilterNode.frequency': 'wrap',
  'BrowserBiquadFilterNode.gain': 'wrap',
  'BrowserBiquadFilterNode.getFrequencyResponse': 'void',
  'BrowserBiquadFilterNode.q': 'wrap',
  'BrowserBiquadFilterNode.type': 'wrap',
  'BrowserBlob.arrayBuffer': 'wrap',
  'BrowserBlob.size': 'int',
  'BrowserBlob.slice': 'wrap',
  'BrowserBlob.stream': 'wrap',
  'BrowserBlob.text': 'wrap',
  'BrowserBlob.type': 'string',
  'BrowserBlobEvent.data': 'wrap',
  'BrowserBlobEvent.timecode': 'wrap',
  'BrowserBroadcastChannel.close': 'void',
  'BrowserBroadcastChannel.name': 'string',
  'BrowserBroadcastChannel.onmessage': 'jsfunction',
  'BrowserBroadcastChannel.onmessageerror': 'jsfunction',
  'BrowserBroadcastChannel.postMessage': 'void',
  'BrowserByteLengthQueuingStrategy.highWaterMark': 'double',
  'BrowserByteLengthQueuingStrategy.size': 'jsfunction',
  'BrowserCSSKeywordValue.value': 'string',
  'BrowserCSSMathClamp.lower': 'wrap',
  'BrowserCSSMathClamp.upper': 'wrap',
  'BrowserCSSMathClamp.value': 'wrap',
  'BrowserCSSMathInvert.value': 'wrap',
  'BrowserCSSMathMax.values': 'wrap',
  'BrowserCSSMathMin.values': 'wrap',
  'BrowserCSSMathNegate.value': 'wrap',
  'BrowserCSSMathProduct.values': 'wrap',
  'BrowserCSSMathSum.values': 'wrap',
  'BrowserCSSMatrixComponent.matrix': 'wrap',
  'BrowserCSSNumericArray.length': 'int',
  'BrowserCSSNumericValue.add': 'wrap',
  'BrowserCSSNumericValue.div': 'wrap',
  'BrowserCSSNumericValue.equals': 'bool',
  'BrowserCSSNumericValue.max': 'wrap',
  'BrowserCSSNumericValue.min': 'wrap',
  'BrowserCSSNumericValue.mul': 'wrap',
  'BrowserCSSNumericValue.sub': 'wrap',
  'BrowserCSSNumericValue.to': 'wrap',
  'BrowserCSSNumericValue.toSum': 'wrap',
  'BrowserCSSNumericValue.type': 'wrap',
  'BrowserCSSPerspective.length': 'wrap',
  'BrowserCSSRotate.angle': 'wrap',
  'BrowserCSSRotate.x': 'wrap',
  'BrowserCSSRotate.y': 'wrap',
  'BrowserCSSRotate.z': 'wrap',
  'BrowserCSSRule.cssText': 'wrap',
  'BrowserCSSRule.parentRule': 'wrap',
  'BrowserCSSRule.parentStyleSheet': 'wrap',
  'BrowserCSSRule.type': 'int',
  'BrowserCSSRuleList.item': 'wrap',
  'BrowserCSSRuleList.length': 'int',
  'BrowserCSSScale.x': 'wrap',
  'BrowserCSSScale.y': 'wrap',
  'BrowserCSSScale.z': 'wrap',
  'BrowserCSSSkew.ax': 'wrap',
  'BrowserCSSSkew.ay': 'wrap',
  'BrowserCSSSkewX.ax': 'wrap',
  'BrowserCSSSkewY.ay': 'wrap',
  'BrowserCSSStyleDeclaration.cssText': 'wrap',
  'BrowserCSSStyleDeclaration.getPropertyPriority': 'wrap',
  'BrowserCSSStyleDeclaration.getPropertyValue': 'wrap',
  'BrowserCSSStyleDeclaration.item': 'wrap',
  'BrowserCSSStyleDeclaration.length': 'int',
  'BrowserCSSStyleDeclaration.parentRule': 'wrap',
  'BrowserCSSStyleDeclaration.removeProperty': 'wrap',
  'BrowserCSSStyleDeclaration.setProperty': 'void',
  'BrowserCSSStyleSheet.addRule': 'int',
  'BrowserCSSStyleSheet.cssRules': 'wrap',
  'BrowserCSSStyleSheet.deleteRule': 'void',
  'BrowserCSSStyleSheet.insertRule': 'int',
  'BrowserCSSStyleSheet.ownerRule': 'wrap',
  'BrowserCSSStyleSheet.removeRule': 'void',
  'BrowserCSSStyleSheet.replace': 'wrap',
  'BrowserCSSStyleSheet.replaceSync': 'void',
  'BrowserCSSStyleSheet.rules': 'wrap',
  'BrowserCSSTransformValue.is2D': 'bool',
  'BrowserCSSTransformValue.length': 'int',
  'BrowserCSSTransformValue.toMatrix': 'wrap',
  'BrowserCSSTranslate.x': 'wrap',
  'BrowserCSSTranslate.y': 'wrap',
  'BrowserCSSTranslate.z': 'wrap',
  'BrowserCSSUnitValue.unit': 'string',
  'BrowserCSSUnitValue.value': 'double',
  'BrowserCSSUnparsedValue.length': 'int',
  'BrowserCSSVariableReferenceValue.fallback': 'wrap',
  'BrowserCSSVariableReferenceValue.variable': 'string',
  'BrowserCacheStorage.delete': 'wrap',
  'BrowserCacheStorage.has': 'wrap',
  'BrowserCacheStorage.keys': 'wrap',
  'BrowserCacheStorage.match': 'wrap',
  'BrowserCacheStorage.open': 'wrap',
  'BrowserClient.frameType': 'wrap',
  'BrowserClient.id': 'string',
  'BrowserClient.postMessage': 'void',
  'BrowserClient.type': 'wrap',
  'BrowserClient.url': 'string',
  'BrowserClipboard.read': 'wrap',
  'BrowserClipboard.readText': 'wrap',
  'BrowserClipboard.write': 'wrap',
  'BrowserClipboard.writeText': 'wrap',
  'BrowserClipboardEvent.clipboardData': 'wrap',
  'BrowserClipboardItem.getType': 'wrap',
  'BrowserClipboardItem.presentationStyle': 'wrap',
  'BrowserClipboardItem.types': 'wrap',
  'BrowserCloseEvent.code': 'int',
  'BrowserCloseEvent.reason': 'string',
  'BrowserCloseEvent.wasClean': 'bool',
  'BrowserCompositionEvent.data': 'string',
  'BrowserCompositionEvent.initCompositionEvent': 'void',
  'BrowserCompressionStream.readable': 'wrap',
  'BrowserCompressionStream.writable': 'wrap',
  'BrowserConstantSourceNode.offset': 'wrap',
  'BrowserContentVisibilityAutoStateChangeEvent.skipped': 'bool',
  'BrowserConvolverNode.buffer': 'wrap',
  'BrowserConvolverNode.normalize': 'bool',
  'BrowserCookieChangeEvent.changed': 'wrap',
  'BrowserCookieChangeEvent.deleted': 'wrap',
  'BrowserCountQueuingStrategy.highWaterMark': 'double',
  'BrowserCountQueuingStrategy.size': 'jsfunction',
  'BrowserCredential.id': 'string',
  'BrowserCredential.type': 'string',
  'BrowserCredentialsContainer.create': 'wrap',
  'BrowserCredentialsContainer.get_': 'wrap',
  'BrowserCredentialsContainer.preventSilentAccess': 'wrap',
  'BrowserCredentialsContainer.store': 'wrap',
  'BrowserCrypto.getRandomValues': 'wrap',
  'BrowserCrypto.randomUUID': 'string',
  'BrowserCrypto.subtle': 'wrap',
  'BrowserCryptoKey.algorithm': 'wrap',
  'BrowserCryptoKey.extractable': 'bool',
  'BrowserCryptoKey.type': 'wrap',
  'BrowserCryptoKey.usages': 'wrap',
  'BrowserCustomElementRegistry.define': 'void',
  'BrowserCustomElementRegistry.getName': 'string',
  'BrowserCustomElementRegistry.get_': 'jsfunction',
  'BrowserCustomElementRegistry.upgrade': 'void',
  'BrowserCustomElementRegistry.whenDefined': 'wrap',
  'BrowserCustomEvent.detail': 'wrap',
  'BrowserCustomEvent.initCustomEvent': 'void',
  'BrowserDOMException.code': 'int',
  'BrowserDOMException.message': 'string',
  'BrowserDOMException.name': 'string',
  'BrowserDOMImplementation.createDocument': 'wrap',
  'BrowserDOMImplementation.createDocumentType': 'wrap',
  'BrowserDOMImplementation.createHTMLDocument': 'wrap',
  'BrowserDOMImplementation.hasFeature': 'bool',
  'BrowserDOMMatrix.a': 'double',
  'BrowserDOMMatrix.b': 'double',
  'BrowserDOMMatrix.c': 'double',
  'BrowserDOMMatrix.d': 'double',
  'BrowserDOMMatrix.e': 'double',
  'BrowserDOMMatrix.f': 'double',
  'BrowserDOMMatrix.invertSelf': 'wrap',
  'BrowserDOMMatrix.m11': 'double',
  'BrowserDOMMatrix.m12': 'double',
  'BrowserDOMMatrix.m13': 'double',
  'BrowserDOMMatrix.m14': 'double',
  'BrowserDOMMatrix.m21': 'double',
  'BrowserDOMMatrix.m22': 'double',
  'BrowserDOMMatrix.m23': 'double',
  'BrowserDOMMatrix.m24': 'double',
  'BrowserDOMMatrix.m31': 'double',
  'BrowserDOMMatrix.m32': 'double',
  'BrowserDOMMatrix.m33': 'double',
  'BrowserDOMMatrix.m34': 'double',
  'BrowserDOMMatrix.m41': 'double',
  'BrowserDOMMatrix.m42': 'double',
  'BrowserDOMMatrix.m43': 'double',
  'BrowserDOMMatrix.m44': 'double',
  'BrowserDOMMatrix.multiplySelf': 'wrap',
  'BrowserDOMMatrix.preMultiplySelf': 'wrap',
  'BrowserDOMMatrix.rotateAxisAngleSelf': 'wrap',
  'BrowserDOMMatrix.rotateFromVectorSelf': 'wrap',
  'BrowserDOMMatrix.rotateSelf': 'wrap',
  'BrowserDOMMatrix.scale3dSelf': 'wrap',
  'BrowserDOMMatrix.scaleSelf': 'wrap',
  'BrowserDOMMatrix.setMatrixValue': 'wrap',
  'BrowserDOMMatrix.skewXSelf': 'wrap',
  'BrowserDOMMatrix.skewYSelf': 'wrap',
  'BrowserDOMMatrix.translateSelf': 'wrap',
  'BrowserDOMMatrixReadOnly.a': 'double',
  'BrowserDOMMatrixReadOnly.b': 'double',
  'BrowserDOMMatrixReadOnly.c': 'double',
  'BrowserDOMMatrixReadOnly.d': 'double',
  'BrowserDOMMatrixReadOnly.e': 'double',
  'BrowserDOMMatrixReadOnly.f': 'double',
  'BrowserDOMMatrixReadOnly.flipX': 'wrap',
  'BrowserDOMMatrixReadOnly.flipY': 'wrap',
  'BrowserDOMMatrixReadOnly.inverse': 'wrap',
  'BrowserDOMMatrixReadOnly.is2D': 'bool',
  'BrowserDOMMatrixReadOnly.isIdentity': 'bool',
  'BrowserDOMMatrixReadOnly.m11': 'double',
  'BrowserDOMMatrixReadOnly.m12': 'double',
  'BrowserDOMMatrixReadOnly.m13': 'double',
  'BrowserDOMMatrixReadOnly.m14': 'double',
  'BrowserDOMMatrixReadOnly.m21': 'double',
  'BrowserDOMMatrixReadOnly.m22': 'double',
  'BrowserDOMMatrixReadOnly.m23': 'double',
  'BrowserDOMMatrixReadOnly.m24': 'double',
  'BrowserDOMMatrixReadOnly.m31': 'double',
  'BrowserDOMMatrixReadOnly.m32': 'double',
  'BrowserDOMMatrixReadOnly.m33': 'double',
  'BrowserDOMMatrixReadOnly.m34': 'double',
  'BrowserDOMMatrixReadOnly.m41': 'double',
  'BrowserDOMMatrixReadOnly.m42': 'double',
  'BrowserDOMMatrixReadOnly.m43': 'double',
  'BrowserDOMMatrixReadOnly.m44': 'double',
  'BrowserDOMMatrixReadOnly.multiply': 'wrap',
  'BrowserDOMMatrixReadOnly.rotate': 'wrap',
  'BrowserDOMMatrixReadOnly.rotateAxisAngle': 'wrap',
  'BrowserDOMMatrixReadOnly.rotateFromVector': 'wrap',
  'BrowserDOMMatrixReadOnly.scale': 'wrap',
  'BrowserDOMMatrixReadOnly.scale3d': 'wrap',
  'BrowserDOMMatrixReadOnly.scaleNonUniform': 'wrap',
  'BrowserDOMMatrixReadOnly.skewX': 'wrap',
  'BrowserDOMMatrixReadOnly.skewY': 'wrap',
  'BrowserDOMMatrixReadOnly.toFloat32Array': 'typedArray',
  'BrowserDOMMatrixReadOnly.toFloat64Array': 'typedArray',
  'BrowserDOMMatrixReadOnly.toJSON': 'wrap',
  'BrowserDOMMatrixReadOnly.transformPoint': 'wrap',
  'BrowserDOMMatrixReadOnly.translate': 'wrap',
  'BrowserDOMParser.parseFromString': 'wrap',
  'BrowserDOMPoint.w': 'double',
  'BrowserDOMPoint.x': 'double',
  'BrowserDOMPoint.y': 'double',
  'BrowserDOMPoint.z': 'double',
  'BrowserDOMPointReadOnly.matrixTransform': 'wrap',
  'BrowserDOMPointReadOnly.toJSON': 'wrap',
  'BrowserDOMPointReadOnly.w': 'double',
  'BrowserDOMPointReadOnly.x': 'double',
  'BrowserDOMPointReadOnly.y': 'double',
  'BrowserDOMPointReadOnly.z': 'double',
  'BrowserDOMQuad.getBounds': 'wrap',
  'BrowserDOMQuad.p1': 'wrap',
  'BrowserDOMQuad.p2': 'wrap',
  'BrowserDOMQuad.p3': 'wrap',
  'BrowserDOMQuad.p4': 'wrap',
  'BrowserDOMQuad.toJSON': 'wrap',
  'BrowserDOMRect.height': 'double',
  'BrowserDOMRect.width': 'double',
  'BrowserDOMRect.x': 'double',
  'BrowserDOMRect.y': 'double',
  'BrowserDOMRectList.item': 'wrap',
  'BrowserDOMRectList.length': 'int',
  'BrowserDOMRectReadOnly.bottom': 'double',
  'BrowserDOMRectReadOnly.height': 'double',
  'BrowserDOMRectReadOnly.left': 'double',
  'BrowserDOMRectReadOnly.right': 'double',
  'BrowserDOMRectReadOnly.toJSON': 'wrap',
  'BrowserDOMRectReadOnly.top': 'double',
  'BrowserDOMRectReadOnly.width': 'double',
  'BrowserDOMRectReadOnly.x': 'double',
  'BrowserDOMRectReadOnly.y': 'double',
  'BrowserDOMStringList.contains': 'bool',
  'BrowserDOMStringList.item': 'string',
  'BrowserDOMStringList.length': 'int',
  'BrowserDOMTokenList.add': 'void',
  'BrowserDOMTokenList.contains': 'bool',
  'BrowserDOMTokenList.item': 'string',
  'BrowserDOMTokenList.length': 'int',
  'BrowserDOMTokenList.remove': 'void',
  'BrowserDOMTokenList.replace': 'bool',
  'BrowserDOMTokenList.supports': 'bool',
  'BrowserDOMTokenList.toggle': 'bool',
  'BrowserDOMTokenList.value': 'string',
  'BrowserDataTransfer.clearData': 'void',
  'BrowserDataTransfer.dropEffect': 'string',
  'BrowserDataTransfer.effectAllowed': 'string',
  'BrowserDataTransfer.files': 'wrap',
  'BrowserDataTransfer.getData': 'string',
  'BrowserDataTransfer.items': 'wrap',
  'BrowserDataTransfer.setData': 'void',
  'BrowserDataTransfer.setDragImage': 'void',
  'BrowserDataTransfer.types': 'wrap',
  'BrowserDataTransferItem.getAsFile': 'wrap',
  'BrowserDataTransferItem.getAsString': 'void',
  'BrowserDataTransferItem.kind': 'string',
  'BrowserDataTransferItem.type': 'string',
  'BrowserDataTransferItem.webkitGetAsEntry': 'wrap',
  'BrowserDataTransferItemList.add': 'wrap',
  'BrowserDataTransferItemList.clear': 'void',
  'BrowserDataTransferItemList.length': 'int',
  'BrowserDataTransferItemList.remove': 'void',
  'BrowserDecompressionStream.readable': 'wrap',
  'BrowserDecompressionStream.writable': 'wrap',
  'BrowserDelayNode.delayTime': 'wrap',
  'BrowserDeviceMotionEvent.acceleration': 'wrap',
  'BrowserDeviceMotionEvent.accelerationIncludingGravity': 'wrap',
  'BrowserDeviceMotionEvent.interval': 'double',
  'BrowserDeviceMotionEvent.rotationRate': 'wrap',
  'BrowserDeviceMotionEventAcceleration.x': 'double',
  'BrowserDeviceMotionEventAcceleration.y': 'double',
  'BrowserDeviceMotionEventAcceleration.z': 'double',
  'BrowserDeviceMotionEventRotationRate.alpha': 'double',
  'BrowserDeviceMotionEventRotationRate.beta': 'double',
  'BrowserDeviceMotionEventRotationRate.gamma': 'double',
  'BrowserDeviceOrientationEvent.absolute': 'bool',
  'BrowserDeviceOrientationEvent.alpha': 'double',
  'BrowserDeviceOrientationEvent.beta': 'double',
  'BrowserDeviceOrientationEvent.gamma': 'double',
  'BrowserDocument.activeElement': 'wrap',
  'BrowserDocument.adoptNode': 'wrap',
  'BrowserDocument.adoptedStyleSheets': 'list',
  'BrowserDocument.alinkColor': 'string',
  'BrowserDocument.all': 'wrap',
  'BrowserDocument.anchors': 'wrap',
  'BrowserDocument.append': 'void',
  'BrowserDocument.applets': 'wrap',
  'BrowserDocument.bgColor': 'string',
  'BrowserDocument.body': 'wrap',
  'BrowserDocument.captureEvents': 'void',
  'BrowserDocument.caretPositionFromPoint': 'wrap',
  'BrowserDocument.characterSet': 'string',
  'BrowserDocument.childElementCount': 'int',
  'BrowserDocument.children': 'wrap',
  'BrowserDocument.clear': 'void',
  'BrowserDocument.close': 'void',
  'BrowserDocument.compatMode': 'string',
  'BrowserDocument.contentType': 'string',
  'BrowserDocument.convertPointFromNode': 'wrap',
  'BrowserDocument.convertQuadFromNode': 'wrap',
  'BrowserDocument.convertRectFromNode': 'wrap',
  'BrowserDocument.cookie': 'string',
  'BrowserDocument.createAttribute': 'wrap',
  'BrowserDocument.createAttributeNS': 'wrap',
  'BrowserDocument.createCDATASection': 'wrap',
  'BrowserDocument.createComment': 'wrap',
  'BrowserDocument.createDocumentFragment': 'wrap',
  'BrowserDocument.createElement': 'wrap',
  'BrowserDocument.createElementNS': 'wrap',
  'BrowserDocument.createEvent': 'wrap',
  'BrowserDocument.createExpression': 'wrap',
  'BrowserDocument.createNSResolver': 'wrap',
  'BrowserDocument.createNodeIterator': 'wrap',
  'BrowserDocument.createProcessingInstruction': 'wrap',
  'BrowserDocument.createRange': 'wrap',
  'BrowserDocument.createTextNode': 'wrap',
  'BrowserDocument.createTreeWalker': 'wrap',
  'BrowserDocument.currentScript': 'wrap',
  'BrowserDocument.defaultView': 'wrap',
  'BrowserDocument.designMode': 'string',
  'BrowserDocument.dir': 'string',
  'BrowserDocument.doctype': 'wrap',
  'BrowserDocument.documentElement': 'wrap',
  'BrowserDocument.documentURI': 'string',
  'BrowserDocument.domain': 'string',
  'BrowserDocument.elementFromPoint': 'wrap',
  'BrowserDocument.elementsFromPoint': 'wrap',
  'BrowserDocument.embeds': 'wrap',
  'BrowserDocument.evaluate': 'wrap',
  'BrowserDocument.execCommand': 'bool',
  'BrowserDocument.exitFullscreen': 'wrap',
  'BrowserDocument.exitPictureInPicture': 'wrap',
  'BrowserDocument.exitPointerLock': 'void',
  'BrowserDocument.fgColor': 'string',
  'BrowserDocument.firstElementChild': 'wrap',
  'BrowserDocument.fonts': 'wrap',
  'BrowserDocument.forms': 'wrap',
  'BrowserDocument.fullscreen': 'bool',
  'BrowserDocument.fullscreenElement': 'wrap',
  'BrowserDocument.fullscreenEnabled': 'bool',
  'BrowserDocument.getAnimations': 'wrap',
  'BrowserDocument.getBoxQuads': 'wrap',
  'BrowserDocument.getElementById': 'wrap',
  'BrowserDocument.getElementsByClassName': 'wrap',
  'BrowserDocument.getElementsByName': 'wrap',
  'BrowserDocument.getElementsByTagName': 'wrap',
  'BrowserDocument.getElementsByTagNameNS': 'wrap',
  'BrowserDocument.getSelection': 'wrap',
  'BrowserDocument.hasFocus': 'bool',
  'BrowserDocument.hasStorageAccess': 'wrap',
  'BrowserDocument.hasUnpartitionedCookieAccess': 'wrap',
  'BrowserDocument.head': 'wrap',
  'BrowserDocument.hidden': 'bool',
  'BrowserDocument.images': 'wrap',
  'BrowserDocument.implementation': 'wrap',
  'BrowserDocument.importNode': 'wrap',
  'BrowserDocument.lastElementChild': 'wrap',
  'BrowserDocument.lastModified': 'string',
  'BrowserDocument.linkColor': 'string',
  'BrowserDocument.links': 'wrap',
  'BrowserDocument.location': 'wrap',
  'BrowserDocument.onabort': 'jsfunction',
  'BrowserDocument.onanimationcancel': 'jsfunction',
  'BrowserDocument.onanimationend': 'jsfunction',
  'BrowserDocument.onanimationiteration': 'jsfunction',
  'BrowserDocument.onanimationstart': 'jsfunction',
  'BrowserDocument.onauxclick': 'jsfunction',
  'BrowserDocument.onbeforeinput': 'jsfunction',
  'BrowserDocument.onbeforematch': 'jsfunction',
  'BrowserDocument.onbeforetoggle': 'jsfunction',
  'BrowserDocument.onbeforexrselect': 'jsfunction',
  'BrowserDocument.onblur': 'jsfunction',
  'BrowserDocument.oncancel': 'jsfunction',
  'BrowserDocument.oncanplay': 'jsfunction',
  'BrowserDocument.oncanplaythrough': 'jsfunction',
  'BrowserDocument.onchange': 'jsfunction',
  'BrowserDocument.onclick': 'jsfunction',
  'BrowserDocument.onclose': 'jsfunction',
  'BrowserDocument.oncontextlost': 'jsfunction',
  'BrowserDocument.oncontextmenu': 'jsfunction',
  'BrowserDocument.oncontextrestored': 'jsfunction',
  'BrowserDocument.oncopy': 'jsfunction',
  'BrowserDocument.oncuechange': 'jsfunction',
  'BrowserDocument.oncut': 'jsfunction',
  'BrowserDocument.ondblclick': 'jsfunction',
  'BrowserDocument.ondrag': 'jsfunction',
  'BrowserDocument.ondragend': 'jsfunction',
  'BrowserDocument.ondragenter': 'jsfunction',
  'BrowserDocument.ondragleave': 'jsfunction',
  'BrowserDocument.ondragover': 'jsfunction',
  'BrowserDocument.ondragstart': 'jsfunction',
  'BrowserDocument.ondrop': 'jsfunction',
  'BrowserDocument.ondurationchange': 'jsfunction',
  'BrowserDocument.onemptied': 'jsfunction',
  'BrowserDocument.onended': 'jsfunction',
  'BrowserDocument.onerror': 'jsfunction',
  'BrowserDocument.onfocus': 'jsfunction',
  'BrowserDocument.onformdata': 'jsfunction',
  'BrowserDocument.onfullscreenchange': 'jsfunction',
  'BrowserDocument.onfullscreenerror': 'jsfunction',
  'BrowserDocument.ongotpointercapture': 'jsfunction',
  'BrowserDocument.oninput': 'jsfunction',
  'BrowserDocument.oninvalid': 'jsfunction',
  'BrowserDocument.onkeydown': 'jsfunction',
  'BrowserDocument.onkeypress': 'jsfunction',
  'BrowserDocument.onkeyup': 'jsfunction',
  'BrowserDocument.onload': 'jsfunction',
  'BrowserDocument.onloadeddata': 'jsfunction',
  'BrowserDocument.onloadedmetadata': 'jsfunction',
  'BrowserDocument.onloadstart': 'jsfunction',
  'BrowserDocument.onlostpointercapture': 'jsfunction',
  'BrowserDocument.onmousedown': 'jsfunction',
  'BrowserDocument.onmouseenter': 'jsfunction',
  'BrowserDocument.onmouseleave': 'jsfunction',
  'BrowserDocument.onmousemove': 'jsfunction',
  'BrowserDocument.onmouseout': 'jsfunction',
  'BrowserDocument.onmouseover': 'jsfunction',
  'BrowserDocument.onmouseup': 'jsfunction',
  'BrowserDocument.onpaste': 'jsfunction',
  'BrowserDocument.onpause': 'jsfunction',
  'BrowserDocument.onplay': 'jsfunction',
  'BrowserDocument.onplaying': 'jsfunction',
  'BrowserDocument.onpointercancel': 'jsfunction',
  'BrowserDocument.onpointerdown': 'jsfunction',
  'BrowserDocument.onpointerenter': 'jsfunction',
  'BrowserDocument.onpointerleave': 'jsfunction',
  'BrowserDocument.onpointerlockchange': 'jsfunction',
  'BrowserDocument.onpointerlockerror': 'jsfunction',
  'BrowserDocument.onpointermove': 'jsfunction',
  'BrowserDocument.onpointerout': 'jsfunction',
  'BrowserDocument.onpointerover': 'jsfunction',
  'BrowserDocument.onpointerrawupdate': 'jsfunction',
  'BrowserDocument.onpointerup': 'jsfunction',
  'BrowserDocument.onprogress': 'jsfunction',
  'BrowserDocument.onratechange': 'jsfunction',
  'BrowserDocument.onreadystatechange': 'jsfunction',
  'BrowserDocument.onreset': 'jsfunction',
  'BrowserDocument.onresize': 'jsfunction',
  'BrowserDocument.onresume': 'jsfunction',
  'BrowserDocument.onscroll': 'jsfunction',
  'BrowserDocument.onscrollend': 'jsfunction',
  'BrowserDocument.onsecuritypolicyviolation': 'jsfunction',
  'BrowserDocument.onseeked': 'jsfunction',
  'BrowserDocument.onseeking': 'jsfunction',
  'BrowserDocument.onselect': 'jsfunction',
  'BrowserDocument.onselectionchange': 'jsfunction',
  'BrowserDocument.onselectstart': 'jsfunction',
  'BrowserDocument.onslotchange': 'jsfunction',
  'BrowserDocument.onsnapchanged': 'jsfunction',
  'BrowserDocument.onsnapchanging': 'jsfunction',
  'BrowserDocument.onstalled': 'jsfunction',
  'BrowserDocument.onsubmit': 'jsfunction',
  'BrowserDocument.onsuspend': 'jsfunction',
  'BrowserDocument.ontimeupdate': 'jsfunction',
  'BrowserDocument.ontoggle': 'jsfunction',
  'BrowserDocument.ontouchcancel': 'jsfunction',
  'BrowserDocument.ontouchend': 'jsfunction',
  'BrowserDocument.ontouchmove': 'jsfunction',
  'BrowserDocument.ontouchstart': 'jsfunction',
  'BrowserDocument.ontransitioncancel': 'jsfunction',
  'BrowserDocument.ontransitionend': 'jsfunction',
  'BrowserDocument.ontransitionrun': 'jsfunction',
  'BrowserDocument.ontransitionstart': 'jsfunction',
  'BrowserDocument.onvisibilitychange': 'jsfunction',
  'BrowserDocument.onvolumechange': 'jsfunction',
  'BrowserDocument.onwaiting': 'jsfunction',
  'BrowserDocument.onwebkitanimationend': 'jsfunction',
  'BrowserDocument.onwebkitanimationiteration': 'jsfunction',
  'BrowserDocument.onwebkitanimationstart': 'jsfunction',
  'BrowserDocument.onwebkittransitionend': 'jsfunction',
  'BrowserDocument.onwheel': 'jsfunction',
  'BrowserDocument.open': 'wrap',
  'BrowserDocument.pictureInPictureElement': 'wrap',
  'BrowserDocument.pictureInPictureEnabled': 'bool',
  'BrowserDocument.plugins': 'wrap',
  'BrowserDocument.pointerLockElement': 'wrap',
  'BrowserDocument.prepend': 'void',
  'BrowserDocument.queryCommandIndeterm': 'bool',
  'BrowserDocument.queryCommandValue': 'string',
  'BrowserDocument.querySelector': 'wrap',
  'BrowserDocument.querySelectorAll': 'wrap',
  'BrowserDocument.readyState': 'wrap',
  'BrowserDocument.referrer': 'string',
  'BrowserDocument.releaseEvents': 'void',
  'BrowserDocument.replaceChildren': 'void',
  'BrowserDocument.requestStorageAccess': 'wrap',
  'BrowserDocument.rootElement': 'wrap',
  'BrowserDocument.scripts': 'wrap',
  'BrowserDocument.scrollingElement': 'wrap',
  'BrowserDocument.startViewTransition': 'wrap',
  'BrowserDocument.styleSheets': 'wrap',
  'BrowserDocument.timeline': 'wrap',
  'BrowserDocument.title': 'string',
  'BrowserDocument.url': 'string',
  'BrowserDocument.visibilityState': 'wrap',
  'BrowserDocument.vlinkColor': 'string',
  'BrowserDocument.write': 'void',
  'BrowserDocument.writeln': 'void',
  'BrowserDocumentFragment.append': 'void',
  'BrowserDocumentFragment.childElementCount': 'int',
  'BrowserDocumentFragment.children': 'wrap',
  'BrowserDocumentFragment.firstElementChild': 'wrap',
  'BrowserDocumentFragment.getElementById': 'wrap',
  'BrowserDocumentFragment.lastElementChild': 'wrap',
  'BrowserDocumentFragment.prepend': 'void',
  'BrowserDocumentFragment.querySelector': 'wrap',
  'BrowserDocumentFragment.querySelectorAll': 'wrap',
  'BrowserDocumentFragment.replaceChildren': 'void',
  'BrowserDocumentType.after': 'void',
  'BrowserDocumentType.before': 'void',
  'BrowserDocumentType.name': 'string',
  'BrowserDocumentType.publicId': 'string',
  'BrowserDocumentType.remove': 'void',
  'BrowserDocumentType.replaceWith': 'void',
  'BrowserDocumentType.systemId': 'string',
  'BrowserDragEvent.dataTransfer': 'wrap',
  'BrowserDynamicsCompressorNode.attack': 'wrap',
  'BrowserDynamicsCompressorNode.knee': 'wrap',
  'BrowserDynamicsCompressorNode.ratio': 'wrap',
  'BrowserDynamicsCompressorNode.reduction': 'double',
  'BrowserDynamicsCompressorNode.release': 'wrap',
  'BrowserDynamicsCompressorNode.threshold': 'wrap',
  'BrowserElement.after': 'void',
  'BrowserElement.animate': 'wrap',
  'BrowserElement.append': 'void',
  'BrowserElement.ariaActiveDescendantElement': 'wrap',
  'BrowserElement.ariaAtomic': 'string',
  'BrowserElement.ariaAutoComplete': 'string',
  'BrowserElement.ariaBrailleLabel': 'string',
  'BrowserElement.ariaBrailleRoleDescription': 'string',
  'BrowserElement.ariaBusy': 'string',
  'BrowserElement.ariaChecked': 'string',
  'BrowserElement.ariaColCount': 'string',
  'BrowserElement.ariaColIndex': 'string',
  'BrowserElement.ariaColIndexText': 'string',
  'BrowserElement.ariaColSpan': 'string',
  'BrowserElement.ariaControlsElements': 'wrap',
  'BrowserElement.ariaCurrent': 'string',
  'BrowserElement.ariaDescribedByElements': 'wrap',
  'BrowserElement.ariaDescription': 'string',
  'BrowserElement.ariaDetailsElements': 'wrap',
  'BrowserElement.ariaDisabled': 'string',
  'BrowserElement.ariaErrorMessageElements': 'wrap',
  'BrowserElement.ariaExpanded': 'string',
  'BrowserElement.ariaFlowToElements': 'wrap',
  'BrowserElement.ariaHasPopup': 'string',
  'BrowserElement.ariaHidden': 'string',
  'BrowserElement.ariaInvalid': 'string',
  'BrowserElement.ariaKeyShortcuts': 'string',
  'BrowserElement.ariaLabel': 'string',
  'BrowserElement.ariaLabelledByElements': 'wrap',
  'BrowserElement.ariaLevel': 'string',
  'BrowserElement.ariaLive': 'string',
  'BrowserElement.ariaModal': 'string',
  'BrowserElement.ariaMultiLine': 'string',
  'BrowserElement.ariaMultiSelectable': 'string',
  'BrowserElement.ariaOrientation': 'string',
  'BrowserElement.ariaOwnsElements': 'wrap',
  'BrowserElement.ariaPlaceholder': 'string',
  'BrowserElement.ariaPosInSet': 'string',
  'BrowserElement.ariaPressed': 'string',
  'BrowserElement.ariaReadOnly': 'string',
  'BrowserElement.ariaRequired': 'string',
  'BrowserElement.ariaRoleDescription': 'string',
  'BrowserElement.ariaRowCount': 'string',
  'BrowserElement.ariaRowIndex': 'string',
  'BrowserElement.ariaRowIndexText': 'string',
  'BrowserElement.ariaRowSpan': 'string',
  'BrowserElement.ariaSelected': 'string',
  'BrowserElement.ariaSetSize': 'string',
  'BrowserElement.ariaSort': 'string',
  'BrowserElement.ariaValueMax': 'string',
  'BrowserElement.ariaValueMin': 'string',
  'BrowserElement.ariaValueNow': 'string',
  'BrowserElement.ariaValueText': 'string',
  'BrowserElement.assignedSlot': 'wrap',
  'BrowserElement.attachShadow': 'wrap',
  'BrowserElement.attributes': 'wrap',
  'BrowserElement.before': 'void',
  'BrowserElement.checkVisibility': 'bool',
  'BrowserElement.childElementCount': 'int',
  'BrowserElement.children': 'wrap',
  'BrowserElement.classList': 'wrap',
  'BrowserElement.className': 'string',
  'BrowserElement.clientHeight': 'int',
  'BrowserElement.clientLeft': 'int',
  'BrowserElement.clientTop': 'int',
  'BrowserElement.clientWidth': 'int',
  'BrowserElement.closest': 'wrap',
  'BrowserElement.computedStyleMap': 'wrap',
  'BrowserElement.convertPointFromNode': 'wrap',
  'BrowserElement.convertQuadFromNode': 'wrap',
  'BrowserElement.convertRectFromNode': 'wrap',
  'BrowserElement.firstElementChild': 'wrap',
  'BrowserElement.getAnimations': 'wrap',
  'BrowserElement.getAttribute': 'string',
  'BrowserElement.getAttributeNS': 'string',
  'BrowserElement.getAttributeNames': 'wrap',
  'BrowserElement.getAttributeNode': 'wrap',
  'BrowserElement.getAttributeNodeNS': 'wrap',
  'BrowserElement.getBoundingClientRect': 'wrap',
  'BrowserElement.getBoxQuads': 'wrap',
  'BrowserElement.getClientRects': 'wrap',
  'BrowserElement.getElementsByClassName': 'wrap',
  'BrowserElement.getElementsByTagName': 'wrap',
  'BrowserElement.getElementsByTagNameNS': 'wrap',
  'BrowserElement.getHTML': 'string',
  'BrowserElement.getRegionFlowRanges': 'wrap',
  'BrowserElement.hasAttribute': 'bool',
  'BrowserElement.hasAttributeNS': 'bool',
  'BrowserElement.hasAttributes': 'bool',
  'BrowserElement.hasPointerCapture': 'bool',
  'BrowserElement.id': 'string',
  'BrowserElement.innerHTML': 'wrap',
  'BrowserElement.insertAdjacentElement': 'wrap',
  'BrowserElement.insertAdjacentHTML': 'void',
  'BrowserElement.insertAdjacentText': 'void',
  'BrowserElement.lastElementChild': 'wrap',
  'BrowserElement.localName': 'string',
  'BrowserElement.matches': 'bool',
  'BrowserElement.namespaceURI': 'string',
  'BrowserElement.nextElementSibling': 'wrap',
  'BrowserElement.onfullscreenchange': 'jsfunction',
  'BrowserElement.onfullscreenerror': 'jsfunction',
  'BrowserElement.outerHTML': 'wrap',
  'BrowserElement.part_': 'wrap',
  'BrowserElement.prefix': 'string',
  'BrowserElement.prepend': 'void',
  'BrowserElement.previousElementSibling': 'wrap',
  'BrowserElement.querySelector': 'wrap',
  'BrowserElement.querySelectorAll': 'wrap',
  'BrowserElement.regionOverset': 'wrap',
  'BrowserElement.releasePointerCapture': 'void',
  'BrowserElement.remove': 'void',
  'BrowserElement.removeAttribute': 'void',
  'BrowserElement.removeAttributeNS': 'void',
  'BrowserElement.removeAttributeNode': 'wrap',
  'BrowserElement.replaceChildren': 'void',
  'BrowserElement.replaceWith': 'void',
  'BrowserElement.requestFullscreen': 'wrap',
  'BrowserElement.requestPointerLock': 'wrap',
  'BrowserElement.role': 'string',
  'BrowserElement.scroll': 'void',
  'BrowserElement.scrollBy': 'void',
  'BrowserElement.scrollHeight': 'int',
  'BrowserElement.scrollIntoView': 'void',
  'BrowserElement.scrollLeft': 'double',
  'BrowserElement.scrollTo': 'void',
  'BrowserElement.scrollTop': 'double',
  'BrowserElement.scrollWidth': 'int',
  'BrowserElement.setAttribute': 'void',
  'BrowserElement.setAttributeNS': 'void',
  'BrowserElement.setAttributeNode': 'wrap',
  'BrowserElement.setAttributeNodeNS': 'wrap',
  'BrowserElement.setHTMLUnsafe': 'void',
  'BrowserElement.setPointerCapture': 'void',
  'BrowserElement.shadowRoot': 'wrap',
  'BrowserElement.slot': 'string',
  'BrowserElement.tagName': 'string',
  'BrowserElement.toggleAttribute': 'bool',
  'BrowserElementInternals.ariaActiveDescendantElement': 'wrap',
  'BrowserElementInternals.ariaAtomic': 'string',
  'BrowserElementInternals.ariaAutoComplete': 'string',
  'BrowserElementInternals.ariaBrailleLabel': 'string',
  'BrowserElementInternals.ariaBrailleRoleDescription': 'string',
  'BrowserElementInternals.ariaBusy': 'string',
  'BrowserElementInternals.ariaChecked': 'string',
  'BrowserElementInternals.ariaColCount': 'string',
  'BrowserElementInternals.ariaColIndex': 'string',
  'BrowserElementInternals.ariaColIndexText': 'string',
  'BrowserElementInternals.ariaColSpan': 'string',
  'BrowserElementInternals.ariaControlsElements': 'wrap',
  'BrowserElementInternals.ariaCurrent': 'string',
  'BrowserElementInternals.ariaDescribedByElements': 'wrap',
  'BrowserElementInternals.ariaDescription': 'string',
  'BrowserElementInternals.ariaDetailsElements': 'wrap',
  'BrowserElementInternals.ariaDisabled': 'string',
  'BrowserElementInternals.ariaErrorMessageElements': 'wrap',
  'BrowserElementInternals.ariaExpanded': 'string',
  'BrowserElementInternals.ariaFlowToElements': 'wrap',
  'BrowserElementInternals.ariaHasPopup': 'string',
  'BrowserElementInternals.ariaHidden': 'string',
  'BrowserElementInternals.ariaInvalid': 'string',
  'BrowserElementInternals.ariaKeyShortcuts': 'string',
  'BrowserElementInternals.ariaLabel': 'string',
  'BrowserElementInternals.ariaLabelledByElements': 'wrap',
  'BrowserElementInternals.ariaLevel': 'string',
  'BrowserElementInternals.ariaLive': 'string',
  'BrowserElementInternals.ariaModal': 'string',
  'BrowserElementInternals.ariaMultiLine': 'string',
  'BrowserElementInternals.ariaMultiSelectable': 'string',
  'BrowserElementInternals.ariaOrientation': 'string',
  'BrowserElementInternals.ariaOwnsElements': 'wrap',
  'BrowserElementInternals.ariaPlaceholder': 'string',
  'BrowserElementInternals.ariaPosInSet': 'string',
  'BrowserElementInternals.ariaPressed': 'string',
  'BrowserElementInternals.ariaReadOnly': 'string',
  'BrowserElementInternals.ariaRequired': 'string',
  'BrowserElementInternals.ariaRoleDescription': 'string',
  'BrowserElementInternals.ariaRowCount': 'string',
  'BrowserElementInternals.ariaRowIndex': 'string',
  'BrowserElementInternals.ariaRowIndexText': 'string',
  'BrowserElementInternals.ariaRowSpan': 'string',
  'BrowserElementInternals.ariaSelected': 'string',
  'BrowserElementInternals.ariaSetSize': 'string',
  'BrowserElementInternals.ariaSort': 'string',
  'BrowserElementInternals.ariaValueMax': 'string',
  'BrowserElementInternals.ariaValueMin': 'string',
  'BrowserElementInternals.ariaValueNow': 'string',
  'BrowserElementInternals.ariaValueText': 'string',
  'BrowserElementInternals.checkValidity': 'bool',
  'BrowserElementInternals.form': 'wrap',
  'BrowserElementInternals.labels': 'wrap',
  'BrowserElementInternals.reportValidity': 'bool',
  'BrowserElementInternals.role': 'string',
  'BrowserElementInternals.setFormValue': 'void',
  'BrowserElementInternals.setValidity': 'void',
  'BrowserElementInternals.shadowRoot': 'wrap',
  'BrowserElementInternals.states': 'wrap',
  'BrowserElementInternals.validationMessage': 'string',
  'BrowserElementInternals.validity': 'wrap',
  'BrowserElementInternals.willValidate': 'bool',
  'BrowserEncodedVideoChunk.byteLength': 'int',
  'BrowserEncodedVideoChunk.copyTo': 'void',
  'BrowserEncodedVideoChunk.duration': 'int',
  'BrowserEncodedVideoChunk.timestamp': 'int',
  'BrowserEncodedVideoChunk.type': 'wrap',
  'BrowserErrorEvent.colno': 'int',
  'BrowserErrorEvent.error': 'wrap',
  'BrowserErrorEvent.filename': 'string',
  'BrowserErrorEvent.lineno': 'int',
  'BrowserErrorEvent.message': 'string',
  'BrowserEvent.bubbles': 'bool',
  'BrowserEvent.cancelBubble': 'bool',
  'BrowserEvent.cancelable': 'bool',
  'BrowserEvent.composed': 'bool',
  'BrowserEvent.composedPath': 'wrap',
  'BrowserEvent.currentTarget': 'wrap',
  'BrowserEvent.defaultPrevented': 'bool',
  'BrowserEvent.eventPhase': 'int',
  'BrowserEvent.initEvent': 'void',
  'BrowserEvent.isTrusted': 'bool',
  'BrowserEvent.preventDefault': 'void',
  'BrowserEvent.returnValue': 'bool',
  'BrowserEvent.srcElement': 'wrap',
  'BrowserEvent.stopImmediatePropagation': 'void',
  'BrowserEvent.stopPropagation': 'void',
  'BrowserEvent.target': 'wrap',
  'BrowserEvent.timeStamp': 'wrap',
  'BrowserEvent.type': 'string',
  'BrowserEventSource.close': 'void',
  'BrowserEventSource.onerror': 'jsfunction',
  'BrowserEventSource.onmessage': 'jsfunction',
  'BrowserEventSource.onopen': 'jsfunction',
  'BrowserEventSource.readyState': 'int',
  'BrowserEventSource.url': 'string',
  'BrowserEventSource.withCredentials': 'bool',
  'BrowserEventTarget.addEventListener': 'void',
  'BrowserEventTarget.dispatchEvent': 'bool',
  'BrowserEventTarget.removeEventListener': 'void',
  'BrowserExtendableCookieChangeEvent.changed': 'wrap',
  'BrowserExtendableCookieChangeEvent.deleted': 'wrap',
  'BrowserExtendableEvent.waitUntil': 'void',
  'BrowserExtendableMessageEvent.data': 'wrap',
  'BrowserExtendableMessageEvent.lastEventId': 'string',
  'BrowserExtendableMessageEvent.origin': 'string',
  'BrowserExtendableMessageEvent.ports': 'wrap',
  'BrowserExtendableMessageEvent.source': 'wrap',
  'BrowserExternal.addSearchProvider': 'void',
  'BrowserExternal.isSearchProviderInstalled': 'void',
  'BrowserFetchEvent.clientId': 'string',
  'BrowserFetchEvent.handled': 'wrap',
  'BrowserFetchEvent.preloadResponse': 'wrap',
  'BrowserFetchEvent.replacesClientId': 'string',
  'BrowserFetchEvent.request': 'wrap',
  'BrowserFetchEvent.respondWith': 'void',
  'BrowserFetchEvent.resultingClientId': 'string',
  'BrowserFile.lastModified': 'int',
  'BrowserFile.name': 'string',
  'BrowserFile.webkitRelativePath': 'string',
  'BrowserFileList.item': 'wrap',
  'BrowserFileList.length': 'int',
  'BrowserFileReader.abort': 'void',
  'BrowserFileReader.error': 'wrap',
  'BrowserFileReader.onabort': 'jsfunction',
  'BrowserFileReader.onerror': 'jsfunction',
  'BrowserFileReader.onload': 'jsfunction',
  'BrowserFileReader.onloadend': 'jsfunction',
  'BrowserFileReader.onloadstart': 'jsfunction',
  'BrowserFileReader.onprogress': 'jsfunction',
  'BrowserFileReader.readAsArrayBuffer': 'void',
  'BrowserFileReader.readAsBinaryString': 'void',
  'BrowserFileReader.readAsDataURL': 'void',
  'BrowserFileReader.readAsText': 'void',
  'BrowserFileReader.readyState': 'int',
  'BrowserFileReader.result': 'wrap',
  'BrowserFileReaderSync.readAsArrayBuffer': 'wrap',
  'BrowserFileReaderSync.readAsBinaryString': 'string',
  'BrowserFileReaderSync.readAsDataURL': 'string',
  'BrowserFileReaderSync.readAsText': 'string',
  'BrowserFileSystem.name': 'string',
  'BrowserFileSystem.root': 'wrap',
  'BrowserFileSystemDirectoryEntry.createReader': 'wrap',
  'BrowserFileSystemDirectoryEntry.getDirectory': 'void',
  'BrowserFileSystemDirectoryEntry.getFile': 'void',
  'BrowserFileSystemDirectoryReader.readEntries': 'void',
  'BrowserFileSystemEntry.filesystem': 'wrap',
  'BrowserFileSystemEntry.fullPath': 'string',
  'BrowserFileSystemEntry.getParent': 'void',
  'BrowserFileSystemEntry.isDirectory': 'bool',
  'BrowserFileSystemEntry.isFile': 'bool',
  'BrowserFileSystemEntry.name': 'string',
  'BrowserFocusEvent.relatedTarget': 'wrap',
  'BrowserFontFace.ascentOverride': 'wrap',
  'BrowserFontFace.descentOverride': 'wrap',
  'BrowserFontFace.display': 'wrap',
  'BrowserFontFace.family': 'wrap',
  'BrowserFontFace.featureSettings': 'wrap',
  'BrowserFontFace.lineGapOverride': 'wrap',
  'BrowserFontFace.load': 'wrap',
  'BrowserFontFace.loaded': 'wrap',
  'BrowserFontFace.status': 'wrap',
  'BrowserFontFace.stretch': 'wrap',
  'BrowserFontFace.style': 'wrap',
  'BrowserFontFace.unicodeRange': 'wrap',
  'BrowserFontFace.weight': 'wrap',
  'BrowserFontFaceSet.add': 'wrap',
  'BrowserFontFaceSet.check': 'bool',
  'BrowserFontFaceSet.clear': 'void',
  'BrowserFontFaceSet.delete': 'bool',
  'BrowserFontFaceSet.load': 'wrap',
  'BrowserFontFaceSet.onloading': 'jsfunction',
  'BrowserFontFaceSet.onloadingdone': 'jsfunction',
  'BrowserFontFaceSet.onloadingerror': 'jsfunction',
  'BrowserFontFaceSet.ready': 'wrap',
  'BrowserFontFaceSet.status': 'wrap',
  'BrowserFontFaceSetLoadEvent.fontfaces': 'wrap',
  'BrowserFormData.append': 'void',
  'BrowserFormData.delete': 'void',
  'BrowserFormData.getAll': 'wrap',
  'BrowserFormData.get_': 'wrap',
  'BrowserFormData.has': 'bool',
  'BrowserFormData.set_': 'void',
  'BrowserFormDataEvent.formData': 'wrap',
  'BrowserGainNode.gain': 'wrap',
  'BrowserGamepad.axes': 'wrap',
  'BrowserGamepad.buttons': 'wrap',
  'BrowserGamepad.connected': 'bool',
  'BrowserGamepad.id': 'string',
  'BrowserGamepad.index': 'int',
  'BrowserGamepad.mapping': 'wrap',
  'BrowserGamepad.timestamp': 'wrap',
  'BrowserGamepadEvent.gamepad': 'wrap',
  'BrowserGeolocation.clearWatch': 'void',
  'BrowserGeolocation.getCurrentPosition': 'void',
  'BrowserGeolocation.watchPosition': 'int',
  'BrowserGyroscope.x': 'double',
  'BrowserGyroscope.y': 'double',
  'BrowserGyroscope.z': 'double',
  'BrowserHTMLAllCollection.item': 'wrap',
  'BrowserHTMLAllCollection.length': 'int',
  'BrowserHTMLAllCollection.namedItem': 'wrap',
  'BrowserHTMLAnchorElement.attributionSrc': 'string',
  'BrowserHTMLAnchorElement.charset': 'string',
  'BrowserHTMLAnchorElement.coords': 'string',
  'BrowserHTMLAnchorElement.download': 'string',
  'BrowserHTMLAnchorElement.hash': 'string',
  'BrowserHTMLAnchorElement.host': 'string',
  'BrowserHTMLAnchorElement.hostname': 'string',
  'BrowserHTMLAnchorElement.href': 'string',
  'BrowserHTMLAnchorElement.hreflang': 'string',
  'BrowserHTMLAnchorElement.name': 'string',
  'BrowserHTMLAnchorElement.origin': 'string',
  'BrowserHTMLAnchorElement.password': 'string',
  'BrowserHTMLAnchorElement.pathname': 'string',
  'BrowserHTMLAnchorElement.ping': 'string',
  'BrowserHTMLAnchorElement.port': 'string',
  'BrowserHTMLAnchorElement.protocol': 'string',
  'BrowserHTMLAnchorElement.referrerPolicy': 'string',
  'BrowserHTMLAnchorElement.rel': 'string',
  'BrowserHTMLAnchorElement.relList': 'wrap',
  'BrowserHTMLAnchorElement.rev': 'string',
  'BrowserHTMLAnchorElement.search': 'string',
  'BrowserHTMLAnchorElement.shape': 'string',
  'BrowserHTMLAnchorElement.target': 'string',
  'BrowserHTMLAnchorElement.text': 'string',
  'BrowserHTMLAnchorElement.type': 'string',
  'BrowserHTMLAnchorElement.username': 'string',
  'BrowserHTMLAreaElement.alt': 'string',
  'BrowserHTMLAreaElement.coords': 'string',
  'BrowserHTMLAreaElement.download': 'string',
  'BrowserHTMLAreaElement.hash': 'string',
  'BrowserHTMLAreaElement.host': 'string',
  'BrowserHTMLAreaElement.hostname': 'string',
  'BrowserHTMLAreaElement.href': 'string',
  'BrowserHTMLAreaElement.noHref': 'bool',
  'BrowserHTMLAreaElement.origin': 'string',
  'BrowserHTMLAreaElement.password': 'string',
  'BrowserHTMLAreaElement.pathname': 'string',
  'BrowserHTMLAreaElement.ping': 'string',
  'BrowserHTMLAreaElement.port': 'string',
  'BrowserHTMLAreaElement.protocol': 'string',
  'BrowserHTMLAreaElement.referrerPolicy': 'string',
  'BrowserHTMLAreaElement.rel': 'string',
  'BrowserHTMLAreaElement.relList': 'wrap',
  'BrowserHTMLAreaElement.search': 'string',
  'BrowserHTMLAreaElement.shape': 'string',
  'BrowserHTMLAreaElement.target': 'string',
  'BrowserHTMLAreaElement.username': 'string',
  'BrowserHTMLBRElement.clear': 'string',
  'BrowserHTMLBaseElement.href': 'string',
  'BrowserHTMLBaseElement.target': 'string',
  'BrowserHTMLBodyElement.aLink': 'string',
  'BrowserHTMLBodyElement.background': 'string',
  'BrowserHTMLBodyElement.bgColor': 'string',
  'BrowserHTMLBodyElement.link': 'string',
  'BrowserHTMLBodyElement.onafterprint': 'jsfunction',
  'BrowserHTMLBodyElement.onbeforeprint': 'jsfunction',
  'BrowserHTMLBodyElement.onbeforeunload': 'jsfunction',
  'BrowserHTMLBodyElement.ongamepadconnected': 'jsfunction',
  'BrowserHTMLBodyElement.ongamepaddisconnected': 'jsfunction',
  'BrowserHTMLBodyElement.onhashchange': 'jsfunction',
  'BrowserHTMLBodyElement.onlanguagechange': 'jsfunction',
  'BrowserHTMLBodyElement.onmessage': 'jsfunction',
  'BrowserHTMLBodyElement.onmessageerror': 'jsfunction',
  'BrowserHTMLBodyElement.onoffline': 'jsfunction',
  'BrowserHTMLBodyElement.ononline': 'jsfunction',
  'BrowserHTMLBodyElement.onorientationchange': 'jsfunction',
  'BrowserHTMLBodyElement.onpagehide': 'jsfunction',
  'BrowserHTMLBodyElement.onpagereveal': 'jsfunction',
  'BrowserHTMLBodyElement.onpageshow': 'jsfunction',
  'BrowserHTMLBodyElement.onpageswap': 'jsfunction',
  'BrowserHTMLBodyElement.onpopstate': 'jsfunction',
  'BrowserHTMLBodyElement.onportalactivate': 'jsfunction',
  'BrowserHTMLBodyElement.onrejectionhandled': 'jsfunction',
  'BrowserHTMLBodyElement.onstorage': 'jsfunction',
  'BrowserHTMLBodyElement.onunhandledrejection': 'jsfunction',
  'BrowserHTMLBodyElement.onunload': 'jsfunction',
  'BrowserHTMLBodyElement.text': 'string',
  'BrowserHTMLBodyElement.vLink': 'string',
  'BrowserHTMLButtonElement.checkValidity': 'bool',
  'BrowserHTMLButtonElement.disabled': 'bool',
  'BrowserHTMLButtonElement.form': 'wrap',
  'BrowserHTMLButtonElement.formAction': 'string',
  'BrowserHTMLButtonElement.formEnctype': 'string',
  'BrowserHTMLButtonElement.formMethod': 'string',
  'BrowserHTMLButtonElement.formNoValidate': 'bool',
  'BrowserHTMLButtonElement.formTarget': 'string',
  'BrowserHTMLButtonElement.labels': 'wrap',
  'BrowserHTMLButtonElement.name': 'string',
  'BrowserHTMLButtonElement.popoverTargetAction': 'string',
  'BrowserHTMLButtonElement.popoverTargetElement': 'wrap',
  'BrowserHTMLButtonElement.reportValidity': 'bool',
  'BrowserHTMLButtonElement.setCustomValidity': 'void',
  'BrowserHTMLButtonElement.type': 'string',
  'BrowserHTMLButtonElement.validationMessage': 'string',
  'BrowserHTMLButtonElement.validity': 'wrap',
  'BrowserHTMLButtonElement.value': 'string',
  'BrowserHTMLButtonElement.willValidate': 'bool',
  'BrowserHTMLCanvasElement.captureStream': 'wrap',
  'BrowserHTMLCanvasElement.getContext': 'wrap',
  'BrowserHTMLCanvasElement.height': 'int',
  'BrowserHTMLCanvasElement.toBlob': 'void',
  'BrowserHTMLCanvasElement.toDataURL': 'string',
  'BrowserHTMLCanvasElement.transferControlToOffscreen': 'wrap',
  'BrowserHTMLCanvasElement.width': 'int',
  'BrowserHTMLCollection.item': 'wrap',
  'BrowserHTMLCollection.length': 'int',
  'BrowserHTMLCollection.namedItem': 'wrap',
  'BrowserHTMLDListElement.compact': 'bool',
  'BrowserHTMLDataElement.value': 'string',
  'BrowserHTMLDataListElement.options': 'wrap',
  'BrowserHTMLDetailsElement.name': 'string',
  'BrowserHTMLDetailsElement.open': 'bool',
  'BrowserHTMLDialogElement.close': 'void',
  'BrowserHTMLDialogElement.open': 'bool',
  'BrowserHTMLDialogElement.returnValue': 'string',
  'BrowserHTMLDialogElement.showModal': 'void',
  'BrowserHTMLDialogElement.show_': 'void',
  'BrowserHTMLDirectoryElement.compact': 'bool',
  'BrowserHTMLDivElement.align': 'string',
  'BrowserHTMLElement.accessKey': 'string',
  'BrowserHTMLElement.accessKeyLabel': 'string',
  'BrowserHTMLElement.attachInternals': 'wrap',
  'BrowserHTMLElement.attributeStyleMap': 'wrap',
  'BrowserHTMLElement.autocapitalize': 'string',
  'BrowserHTMLElement.autofocus': 'bool',
  'BrowserHTMLElement.blur': 'void',
  'BrowserHTMLElement.click': 'void',
  'BrowserHTMLElement.contentEditable': 'string',
  'BrowserHTMLElement.dataset': 'wrap',
  'BrowserHTMLElement.dir': 'string',
  'BrowserHTMLElement.draggable': 'bool',
  'BrowserHTMLElement.enterKeyHint': 'string',
  'BrowserHTMLElement.focus': 'void',
  'BrowserHTMLElement.hidden': 'wrap',
  'BrowserHTMLElement.hidePopover': 'void',
  'BrowserHTMLElement.inert': 'bool',
  'BrowserHTMLElement.innerText': 'string',
  'BrowserHTMLElement.inputMode': 'string',
  'BrowserHTMLElement.isContentEditable': 'bool',
  'BrowserHTMLElement.lang': 'string',
  'BrowserHTMLElement.nonce': 'string',
  'BrowserHTMLElement.offsetHeight': 'int',
  'BrowserHTMLElement.offsetLeft': 'int',
  'BrowserHTMLElement.offsetParent': 'wrap',
  'BrowserHTMLElement.offsetTop': 'int',
  'BrowserHTMLElement.offsetWidth': 'int',
  'BrowserHTMLElement.onabort': 'jsfunction',
  'BrowserHTMLElement.onanimationcancel': 'jsfunction',
  'BrowserHTMLElement.onanimationend': 'jsfunction',
  'BrowserHTMLElement.onanimationiteration': 'jsfunction',
  'BrowserHTMLElement.onanimationstart': 'jsfunction',
  'BrowserHTMLElement.onauxclick': 'jsfunction',
  'BrowserHTMLElement.onbeforeinput': 'jsfunction',
  'BrowserHTMLElement.onbeforematch': 'jsfunction',
  'BrowserHTMLElement.onbeforetoggle': 'jsfunction',
  'BrowserHTMLElement.onbeforexrselect': 'jsfunction',
  'BrowserHTMLElement.onblur': 'jsfunction',
  'BrowserHTMLElement.oncancel': 'jsfunction',
  'BrowserHTMLElement.oncanplay': 'jsfunction',
  'BrowserHTMLElement.oncanplaythrough': 'jsfunction',
  'BrowserHTMLElement.onchange': 'jsfunction',
  'BrowserHTMLElement.onclick': 'jsfunction',
  'BrowserHTMLElement.onclose': 'jsfunction',
  'BrowserHTMLElement.oncontextlost': 'jsfunction',
  'BrowserHTMLElement.oncontextmenu': 'jsfunction',
  'BrowserHTMLElement.oncontextrestored': 'jsfunction',
  'BrowserHTMLElement.oncopy': 'jsfunction',
  'BrowserHTMLElement.oncuechange': 'jsfunction',
  'BrowserHTMLElement.oncut': 'jsfunction',
  'BrowserHTMLElement.ondblclick': 'jsfunction',
  'BrowserHTMLElement.ondrag': 'jsfunction',
  'BrowserHTMLElement.ondragend': 'jsfunction',
  'BrowserHTMLElement.ondragenter': 'jsfunction',
  'BrowserHTMLElement.ondragleave': 'jsfunction',
  'BrowserHTMLElement.ondragover': 'jsfunction',
  'BrowserHTMLElement.ondragstart': 'jsfunction',
  'BrowserHTMLElement.ondrop': 'jsfunction',
  'BrowserHTMLElement.ondurationchange': 'jsfunction',
  'BrowserHTMLElement.onemptied': 'jsfunction',
  'BrowserHTMLElement.onended': 'jsfunction',
  'BrowserHTMLElement.onerror': 'jsfunction',
  'BrowserHTMLElement.onfocus': 'jsfunction',
  'BrowserHTMLElement.onformdata': 'jsfunction',
  'BrowserHTMLElement.ongotpointercapture': 'jsfunction',
  'BrowserHTMLElement.oninput': 'jsfunction',
  'BrowserHTMLElement.oninvalid': 'jsfunction',
  'BrowserHTMLElement.onkeydown': 'jsfunction',
  'BrowserHTMLElement.onkeypress': 'jsfunction',
  'BrowserHTMLElement.onkeyup': 'jsfunction',
  'BrowserHTMLElement.onload': 'jsfunction',
  'BrowserHTMLElement.onloadeddata': 'jsfunction',
  'BrowserHTMLElement.onloadedmetadata': 'jsfunction',
  'BrowserHTMLElement.onloadstart': 'jsfunction',
  'BrowserHTMLElement.onlostpointercapture': 'jsfunction',
  'BrowserHTMLElement.onmousedown': 'jsfunction',
  'BrowserHTMLElement.onmouseenter': 'jsfunction',
  'BrowserHTMLElement.onmouseleave': 'jsfunction',
  'BrowserHTMLElement.onmousemove': 'jsfunction',
  'BrowserHTMLElement.onmouseout': 'jsfunction',
  'BrowserHTMLElement.onmouseover': 'jsfunction',
  'BrowserHTMLElement.onmouseup': 'jsfunction',
  'BrowserHTMLElement.onpaste': 'jsfunction',
  'BrowserHTMLElement.onpause': 'jsfunction',
  'BrowserHTMLElement.onplay': 'jsfunction',
  'BrowserHTMLElement.onplaying': 'jsfunction',
  'BrowserHTMLElement.onpointercancel': 'jsfunction',
  'BrowserHTMLElement.onpointerdown': 'jsfunction',
  'BrowserHTMLElement.onpointerenter': 'jsfunction',
  'BrowserHTMLElement.onpointerleave': 'jsfunction',
  'BrowserHTMLElement.onpointermove': 'jsfunction',
  'BrowserHTMLElement.onpointerout': 'jsfunction',
  'BrowserHTMLElement.onpointerover': 'jsfunction',
  'BrowserHTMLElement.onpointerrawupdate': 'jsfunction',
  'BrowserHTMLElement.onpointerup': 'jsfunction',
  'BrowserHTMLElement.onprogress': 'jsfunction',
  'BrowserHTMLElement.onratechange': 'jsfunction',
  'BrowserHTMLElement.onreset': 'jsfunction',
  'BrowserHTMLElement.onresize': 'jsfunction',
  'BrowserHTMLElement.onscroll': 'jsfunction',
  'BrowserHTMLElement.onscrollend': 'jsfunction',
  'BrowserHTMLElement.onsecuritypolicyviolation': 'jsfunction',
  'BrowserHTMLElement.onseeked': 'jsfunction',
  'BrowserHTMLElement.onseeking': 'jsfunction',
  'BrowserHTMLElement.onselect': 'jsfunction',
  'BrowserHTMLElement.onselectionchange': 'jsfunction',
  'BrowserHTMLElement.onselectstart': 'jsfunction',
  'BrowserHTMLElement.onslotchange': 'jsfunction',
  'BrowserHTMLElement.onsnapchanged': 'jsfunction',
  'BrowserHTMLElement.onsnapchanging': 'jsfunction',
  'BrowserHTMLElement.onstalled': 'jsfunction',
  'BrowserHTMLElement.onsubmit': 'jsfunction',
  'BrowserHTMLElement.onsuspend': 'jsfunction',
  'BrowserHTMLElement.ontimeupdate': 'jsfunction',
  'BrowserHTMLElement.ontoggle': 'jsfunction',
  'BrowserHTMLElement.ontouchcancel': 'jsfunction',
  'BrowserHTMLElement.ontouchend': 'jsfunction',
  'BrowserHTMLElement.ontouchmove': 'jsfunction',
  'BrowserHTMLElement.ontouchstart': 'jsfunction',
  'BrowserHTMLElement.ontransitioncancel': 'jsfunction',
  'BrowserHTMLElement.ontransitionend': 'jsfunction',
  'BrowserHTMLElement.ontransitionrun': 'jsfunction',
  'BrowserHTMLElement.ontransitionstart': 'jsfunction',
  'BrowserHTMLElement.onvolumechange': 'jsfunction',
  'BrowserHTMLElement.onwaiting': 'jsfunction',
  'BrowserHTMLElement.onwebkitanimationend': 'jsfunction',
  'BrowserHTMLElement.onwebkitanimationiteration': 'jsfunction',
  'BrowserHTMLElement.onwebkitanimationstart': 'jsfunction',
  'BrowserHTMLElement.onwebkittransitionend': 'jsfunction',
  'BrowserHTMLElement.onwheel': 'jsfunction',
  'BrowserHTMLElement.outerText': 'string',
  'BrowserHTMLElement.popover': 'string',
  'BrowserHTMLElement.showPopover': 'void',
  'BrowserHTMLElement.spellcheck': 'bool',
  'BrowserHTMLElement.style': 'wrap',
  'BrowserHTMLElement.tabIndex': 'int',
  'BrowserHTMLElement.title': 'string',
  'BrowserHTMLElement.togglePopover': 'bool',
  'BrowserHTMLElement.translate': 'bool',
  'BrowserHTMLElement.virtualKeyboardPolicy': 'string',
  'BrowserHTMLEmbedElement.align': 'string',
  'BrowserHTMLEmbedElement.getSVGDocument': 'wrap',
  'BrowserHTMLEmbedElement.height': 'string',
  'BrowserHTMLEmbedElement.name': 'string',
  'BrowserHTMLEmbedElement.src': 'string',
  'BrowserHTMLEmbedElement.type': 'string',
  'BrowserHTMLEmbedElement.width': 'string',
  'BrowserHTMLFieldSetElement.checkValidity': 'bool',
  'BrowserHTMLFieldSetElement.disabled': 'bool',
  'BrowserHTMLFieldSetElement.elements': 'wrap',
  'BrowserHTMLFieldSetElement.form': 'wrap',
  'BrowserHTMLFieldSetElement.name': 'string',
  'BrowserHTMLFieldSetElement.reportValidity': 'bool',
  'BrowserHTMLFieldSetElement.setCustomValidity': 'void',
  'BrowserHTMLFieldSetElement.type': 'string',
  'BrowserHTMLFieldSetElement.validationMessage': 'string',
  'BrowserHTMLFieldSetElement.validity': 'wrap',
  'BrowserHTMLFieldSetElement.willValidate': 'bool',
  'BrowserHTMLFontElement.color': 'string',
  'BrowserHTMLFontElement.face': 'string',
  'BrowserHTMLFontElement.size': 'string',
  'BrowserHTMLFormControlsCollection.namedItem': 'wrap',
  'BrowserHTMLFormElement.acceptCharset': 'string',
  'BrowserHTMLFormElement.action': 'string',
  'BrowserHTMLFormElement.autocomplete': 'string',
  'BrowserHTMLFormElement.checkValidity': 'bool',
  'BrowserHTMLFormElement.elements': 'wrap',
  'BrowserHTMLFormElement.encoding': 'string',
  'BrowserHTMLFormElement.enctype': 'string',
  'BrowserHTMLFormElement.length': 'int',
  'BrowserHTMLFormElement.method': 'string',
  'BrowserHTMLFormElement.name': 'string',
  'BrowserHTMLFormElement.noValidate': 'bool',
  'BrowserHTMLFormElement.rel': 'string',
  'BrowserHTMLFormElement.relList': 'wrap',
  'BrowserHTMLFormElement.reportValidity': 'bool',
  'BrowserHTMLFormElement.requestSubmit': 'void',
  'BrowserHTMLFormElement.reset': 'void',
  'BrowserHTMLFormElement.submit': 'void',
  'BrowserHTMLFormElement.target': 'string',
  'BrowserHTMLFrameElement.contentDocument': 'wrap',
  'BrowserHTMLFrameElement.contentWindow': 'wrap',
  'BrowserHTMLFrameElement.frameBorder': 'string',
  'BrowserHTMLFrameElement.longDesc': 'string',
  'BrowserHTMLFrameElement.marginHeight': 'string',
  'BrowserHTMLFrameElement.marginWidth': 'string',
  'BrowserHTMLFrameElement.name': 'string',
  'BrowserHTMLFrameElement.noResize': 'bool',
  'BrowserHTMLFrameElement.scrolling': 'string',
  'BrowserHTMLFrameElement.src': 'string',
  'BrowserHTMLFrameSetElement.cols': 'string',
  'BrowserHTMLFrameSetElement.onafterprint': 'jsfunction',
  'BrowserHTMLFrameSetElement.onbeforeprint': 'jsfunction',
  'BrowserHTMLFrameSetElement.onbeforeunload': 'jsfunction',
  'BrowserHTMLFrameSetElement.ongamepadconnected': 'jsfunction',
  'BrowserHTMLFrameSetElement.ongamepaddisconnected': 'jsfunction',
  'BrowserHTMLFrameSetElement.onhashchange': 'jsfunction',
  'BrowserHTMLFrameSetElement.onlanguagechange': 'jsfunction',
  'BrowserHTMLFrameSetElement.onmessage': 'jsfunction',
  'BrowserHTMLFrameSetElement.onmessageerror': 'jsfunction',
  'BrowserHTMLFrameSetElement.onoffline': 'jsfunction',
  'BrowserHTMLFrameSetElement.ononline': 'jsfunction',
  'BrowserHTMLFrameSetElement.onpagehide': 'jsfunction',
  'BrowserHTMLFrameSetElement.onpagereveal': 'jsfunction',
  'BrowserHTMLFrameSetElement.onpageshow': 'jsfunction',
  'BrowserHTMLFrameSetElement.onpageswap': 'jsfunction',
  'BrowserHTMLFrameSetElement.onpopstate': 'jsfunction',
  'BrowserHTMLFrameSetElement.onportalactivate': 'jsfunction',
  'BrowserHTMLFrameSetElement.onrejectionhandled': 'jsfunction',
  'BrowserHTMLFrameSetElement.onstorage': 'jsfunction',
  'BrowserHTMLFrameSetElement.onunhandledrejection': 'jsfunction',
  'BrowserHTMLFrameSetElement.onunload': 'jsfunction',
  'BrowserHTMLFrameSetElement.rows': 'string',
  'BrowserHTMLHRElement.align': 'string',
  'BrowserHTMLHRElement.color': 'string',
  'BrowserHTMLHRElement.noShade': 'bool',
  'BrowserHTMLHRElement.size': 'string',
  'BrowserHTMLHRElement.width': 'string',
  'BrowserHTMLHeadingElement.align': 'string',
  'BrowserHTMLHtmlElement.version': 'string',
  'BrowserHTMLIFrameElement.align': 'string',
  'BrowserHTMLIFrameElement.allow': 'string',
  'BrowserHTMLIFrameElement.allowFullscreen': 'bool',
  'BrowserHTMLIFrameElement.contentDocument': 'wrap',
  'BrowserHTMLIFrameElement.contentWindow': 'wrap',
  'BrowserHTMLIFrameElement.frameBorder': 'string',
  'BrowserHTMLIFrameElement.getSVGDocument': 'wrap',
  'BrowserHTMLIFrameElement.height': 'string',
  'BrowserHTMLIFrameElement.loading': 'string',
  'BrowserHTMLIFrameElement.longDesc': 'string',
  'BrowserHTMLIFrameElement.marginHeight': 'string',
  'BrowserHTMLIFrameElement.marginWidth': 'string',
  'BrowserHTMLIFrameElement.name': 'string',
  'BrowserHTMLIFrameElement.referrerPolicy': 'string',
  'BrowserHTMLIFrameElement.sandbox': 'wrap',
  'BrowserHTMLIFrameElement.scrolling': 'string',
  'BrowserHTMLIFrameElement.sharedStorageWritable': 'bool',
  'BrowserHTMLIFrameElement.src': 'string',
  'BrowserHTMLIFrameElement.srcdoc': 'wrap',
  'BrowserHTMLIFrameElement.width': 'string',
  'BrowserHTMLImageElement.align': 'string',
  'BrowserHTMLImageElement.alt': 'string',
  'BrowserHTMLImageElement.attributionSrc': 'string',
  'BrowserHTMLImageElement.border': 'string',
  'BrowserHTMLImageElement.complete': 'bool',
  'BrowserHTMLImageElement.crossOrigin': 'string',
  'BrowserHTMLImageElement.currentSrc': 'string',
  'BrowserHTMLImageElement.decode': 'wrap',
  'BrowserHTMLImageElement.decoding': 'string',
  'BrowserHTMLImageElement.fetchPriority': 'string',
  'BrowserHTMLImageElement.height': 'int',
  'BrowserHTMLImageElement.hspace': 'int',
  'BrowserHTMLImageElement.isMap': 'bool',
  'BrowserHTMLImageElement.loading': 'string',
  'BrowserHTMLImageElement.longDesc': 'string',
  'BrowserHTMLImageElement.lowsrc': 'string',
  'BrowserHTMLImageElement.name': 'string',
  'BrowserHTMLImageElement.naturalHeight': 'int',
  'BrowserHTMLImageElement.naturalWidth': 'int',
  'BrowserHTMLImageElement.referrerPolicy': 'string',
  'BrowserHTMLImageElement.sharedStorageWritable': 'bool',
  'BrowserHTMLImageElement.sizes': 'string',
  'BrowserHTMLImageElement.src': 'string',
  'BrowserHTMLImageElement.srcset': 'string',
  'BrowserHTMLImageElement.useMap': 'string',
  'BrowserHTMLImageElement.vspace': 'int',
  'BrowserHTMLImageElement.width': 'int',
  'BrowserHTMLImageElement.x': 'int',
  'BrowserHTMLImageElement.y': 'int',
  'BrowserHTMLInputElement.accept': 'string',
  'BrowserHTMLInputElement.align': 'string',
  'BrowserHTMLInputElement.alt': 'string',
  'BrowserHTMLInputElement.autocomplete': 'string',
  'BrowserHTMLInputElement.capture': 'string',
  'BrowserHTMLInputElement.checkValidity': 'bool',
  'BrowserHTMLInputElement.checked': 'bool',
  'BrowserHTMLInputElement.defaultChecked': 'bool',
  'BrowserHTMLInputElement.defaultValue': 'string',
  'BrowserHTMLInputElement.dirName': 'string',
  'BrowserHTMLInputElement.disabled': 'bool',
  'BrowserHTMLInputElement.files': 'wrap',
  'BrowserHTMLInputElement.form': 'wrap',
  'BrowserHTMLInputElement.formAction': 'string',
  'BrowserHTMLInputElement.formEnctype': 'string',
  'BrowserHTMLInputElement.formMethod': 'string',
  'BrowserHTMLInputElement.formNoValidate': 'bool',
  'BrowserHTMLInputElement.formTarget': 'string',
  'BrowserHTMLInputElement.height': 'int',
  'BrowserHTMLInputElement.indeterminate': 'bool',
  'BrowserHTMLInputElement.labels': 'wrap',
  'BrowserHTMLInputElement.list': 'wrap',
  'BrowserHTMLInputElement.max': 'string',
  'BrowserHTMLInputElement.maxLength': 'int',
  'BrowserHTMLInputElement.min': 'string',
  'BrowserHTMLInputElement.minLength': 'int',
  'BrowserHTMLInputElement.multiple': 'bool',
  'BrowserHTMLInputElement.name': 'string',
  'BrowserHTMLInputElement.pattern': 'string',
  'BrowserHTMLInputElement.placeholder': 'string',
  'BrowserHTMLInputElement.popoverTargetAction': 'string',
  'BrowserHTMLInputElement.popoverTargetElement': 'wrap',
  'BrowserHTMLInputElement.readOnly': 'bool',
  'BrowserHTMLInputElement.reportValidity': 'bool',
  'BrowserHTMLInputElement.required_': 'bool',
  'BrowserHTMLInputElement.select': 'void',
  'BrowserHTMLInputElement.selectionDirection': 'string',
  'BrowserHTMLInputElement.selectionEnd': 'int',
  'BrowserHTMLInputElement.selectionStart': 'int',
  'BrowserHTMLInputElement.setCustomValidity': 'void',
  'BrowserHTMLInputElement.setRangeText': 'void',
  'BrowserHTMLInputElement.setSelectionRange': 'void',
  'BrowserHTMLInputElement.showPicker': 'void',
  'BrowserHTMLInputElement.size': 'int',
  'BrowserHTMLInputElement.src': 'string',
  'BrowserHTMLInputElement.step': 'string',
  'BrowserHTMLInputElement.stepDown': 'void',
  'BrowserHTMLInputElement.stepUp': 'void',
  'BrowserHTMLInputElement.type': 'string',
  'BrowserHTMLInputElement.useMap': 'string',
  'BrowserHTMLInputElement.validationMessage': 'string',
  'BrowserHTMLInputElement.validity': 'wrap',
  'BrowserHTMLInputElement.value': 'string',
  'BrowserHTMLInputElement.valueAsDate': 'wrap',
  'BrowserHTMLInputElement.valueAsNumber': 'double',
  'BrowserHTMLInputElement.webkitEntries': 'wrap',
  'BrowserHTMLInputElement.webkitdirectory': 'bool',
  'BrowserHTMLInputElement.width': 'int',
  'BrowserHTMLInputElement.willValidate': 'bool',
  'BrowserHTMLLIElement.type': 'string',
  'BrowserHTMLLIElement.value': 'int',
  'BrowserHTMLLabelElement.control': 'wrap',
  'BrowserHTMLLabelElement.form': 'wrap',
  'BrowserHTMLLabelElement.htmlFor': 'string',
  'BrowserHTMLLegendElement.align': 'string',
  'BrowserHTMLLegendElement.form': 'wrap',
  'BrowserHTMLLinkElement.as_': 'string',
  'BrowserHTMLLinkElement.charset': 'string',
  'BrowserHTMLLinkElement.crossOrigin': 'string',
  'BrowserHTMLLinkElement.disabled': 'bool',
  'BrowserHTMLLinkElement.fetchPriority': 'string',
  'BrowserHTMLLinkElement.href': 'string',
  'BrowserHTMLLinkElement.hreflang': 'string',
  'BrowserHTMLLinkElement.imageSizes': 'string',
  'BrowserHTMLLinkElement.imageSrcset': 'string',
  'BrowserHTMLLinkElement.integrity': 'string',
  'BrowserHTMLLinkElement.media': 'string',
  'BrowserHTMLLinkElement.referrerPolicy': 'string',
  'BrowserHTMLLinkElement.rel': 'string',
  'BrowserHTMLLinkElement.relList': 'wrap',
  'BrowserHTMLLinkElement.rev': 'string',
  'BrowserHTMLLinkElement.sheet': 'wrap',
  'BrowserHTMLLinkElement.sizes': 'wrap',
  'BrowserHTMLLinkElement.target': 'string',
  'BrowserHTMLLinkElement.type': 'string',
  'BrowserHTMLMapElement.areas': 'wrap',
  'BrowserHTMLMapElement.name': 'string',
  'BrowserHTMLMarqueeElement.behavior': 'string',
  'BrowserHTMLMarqueeElement.bgColor': 'string',
  'BrowserHTMLMarqueeElement.direction': 'string',
  'BrowserHTMLMarqueeElement.height': 'string',
  'BrowserHTMLMarqueeElement.hspace': 'int',
  'BrowserHTMLMarqueeElement.loop': 'int',
  'BrowserHTMLMarqueeElement.scrollAmount': 'int',
  'BrowserHTMLMarqueeElement.scrollDelay': 'int',
  'BrowserHTMLMarqueeElement.start': 'void',
  'BrowserHTMLMarqueeElement.stop': 'void',
  'BrowserHTMLMarqueeElement.trueSpeed': 'bool',
  'BrowserHTMLMarqueeElement.vspace': 'int',
  'BrowserHTMLMarqueeElement.width': 'string',
  'BrowserHTMLMediaElement.addTextTrack': 'wrap',
  'BrowserHTMLMediaElement.audioTracks': 'wrap',
  'BrowserHTMLMediaElement.autoplay': 'bool',
  'BrowserHTMLMediaElement.buffered': 'wrap',
  'BrowserHTMLMediaElement.canPlayType': 'wrap',
  'BrowserHTMLMediaElement.captureStream': 'wrap',
  'BrowserHTMLMediaElement.controls': 'bool',
  'BrowserHTMLMediaElement.crossOrigin': 'string',
  'BrowserHTMLMediaElement.currentSrc': 'string',
  'BrowserHTMLMediaElement.currentTime': 'double',
  'BrowserHTMLMediaElement.defaultMuted': 'bool',
  'BrowserHTMLMediaElement.defaultPlaybackRate': 'double',
  'BrowserHTMLMediaElement.disableRemotePlayback': 'bool',
  'BrowserHTMLMediaElement.duration': 'double',
  'BrowserHTMLMediaElement.ended': 'bool',
  'BrowserHTMLMediaElement.error': 'wrap',
  'BrowserHTMLMediaElement.fastSeek': 'void',
  'BrowserHTMLMediaElement.getStartDate': 'wrap',
  'BrowserHTMLMediaElement.load': 'void',
  'BrowserHTMLMediaElement.loop': 'bool',
  'BrowserHTMLMediaElement.mediaKeys': 'wrap',
  'BrowserHTMLMediaElement.muted': 'bool',
  'BrowserHTMLMediaElement.networkState': 'int',
  'BrowserHTMLMediaElement.onencrypted': 'jsfunction',
  'BrowserHTMLMediaElement.onwaitingforkey': 'jsfunction',
  'BrowserHTMLMediaElement.pause': 'void',
  'BrowserHTMLMediaElement.paused': 'bool',
  'BrowserHTMLMediaElement.play': 'wrap',
  'BrowserHTMLMediaElement.playbackRate': 'double',
  'BrowserHTMLMediaElement.played': 'wrap',
  'BrowserHTMLMediaElement.preload': 'string',
  'BrowserHTMLMediaElement.preservesPitch': 'bool',
  'BrowserHTMLMediaElement.readyState': 'int',
  'BrowserHTMLMediaElement.remote': 'wrap',
  'BrowserHTMLMediaElement.seekable': 'wrap',
  'BrowserHTMLMediaElement.seeking': 'bool',
  'BrowserHTMLMediaElement.setMediaKeys': 'wrap',
  'BrowserHTMLMediaElement.setSinkId': 'wrap',
  'BrowserHTMLMediaElement.sinkId': 'string',
  'BrowserHTMLMediaElement.src': 'string',
  'BrowserHTMLMediaElement.srcObject': 'wrap',
  'BrowserHTMLMediaElement.textTracks': 'wrap',
  'BrowserHTMLMediaElement.videoTracks': 'wrap',
  'BrowserHTMLMediaElement.volume': 'double',
  'BrowserHTMLMenuElement.compact': 'bool',
  'BrowserHTMLMetaElement.content': 'string',
  'BrowserHTMLMetaElement.httpEquiv': 'string',
  'BrowserHTMLMetaElement.media': 'string',
  'BrowserHTMLMetaElement.name': 'string',
  'BrowserHTMLMetaElement.scheme': 'string',
  'BrowserHTMLMeterElement.high': 'double',
  'BrowserHTMLMeterElement.labels': 'wrap',
  'BrowserHTMLMeterElement.low': 'double',
  'BrowserHTMLMeterElement.max': 'double',
  'BrowserHTMLMeterElement.min': 'double',
  'BrowserHTMLMeterElement.optimum': 'double',
  'BrowserHTMLMeterElement.value': 'double',
  'BrowserHTMLModElement.cite': 'string',
  'BrowserHTMLModElement.dateTime': 'string',
  'BrowserHTMLOListElement.compact': 'bool',
  'BrowserHTMLOListElement.reversed': 'bool',
  'BrowserHTMLOListElement.start': 'int',
  'BrowserHTMLOListElement.type': 'string',
  'BrowserHTMLObjectElement.align': 'string',
  'BrowserHTMLObjectElement.archive': 'string',
  'BrowserHTMLObjectElement.border': 'string',
  'BrowserHTMLObjectElement.checkValidity': 'bool',
  'BrowserHTMLObjectElement.code': 'string',
  'BrowserHTMLObjectElement.codeBase': 'string',
  'BrowserHTMLObjectElement.codeType': 'string',
  'BrowserHTMLObjectElement.contentDocument': 'wrap',
  'BrowserHTMLObjectElement.contentWindow': 'wrap',
  'BrowserHTMLObjectElement.data': 'string',
  'BrowserHTMLObjectElement.declare': 'bool',
  'BrowserHTMLObjectElement.form': 'wrap',
  'BrowserHTMLObjectElement.getSVGDocument': 'wrap',
  'BrowserHTMLObjectElement.height': 'string',
  'BrowserHTMLObjectElement.hspace': 'int',
  'BrowserHTMLObjectElement.name': 'string',
  'BrowserHTMLObjectElement.reportValidity': 'bool',
  'BrowserHTMLObjectElement.setCustomValidity': 'void',
  'BrowserHTMLObjectElement.standby': 'string',
  'BrowserHTMLObjectElement.type': 'string',
  'BrowserHTMLObjectElement.useMap': 'string',
  'BrowserHTMLObjectElement.validationMessage': 'string',
  'BrowserHTMLObjectElement.validity': 'wrap',
  'BrowserHTMLObjectElement.vspace': 'int',
  'BrowserHTMLObjectElement.width': 'string',
  'BrowserHTMLObjectElement.willValidate': 'bool',
  'BrowserHTMLOptGroupElement.disabled': 'bool',
  'BrowserHTMLOptGroupElement.label': 'string',
  'BrowserHTMLOptionElement.defaultSelected': 'bool',
  'BrowserHTMLOptionElement.disabled': 'bool',
  'BrowserHTMLOptionElement.form': 'wrap',
  'BrowserHTMLOptionElement.index': 'int',
  'BrowserHTMLOptionElement.label': 'string',
  'BrowserHTMLOptionElement.selected': 'bool',
  'BrowserHTMLOptionElement.text': 'string',
  'BrowserHTMLOptionElement.value': 'string',
  'BrowserHTMLOptionsCollection.add': 'void',
  'BrowserHTMLOptionsCollection.length': 'int',
  'BrowserHTMLOptionsCollection.remove': 'void',
  'BrowserHTMLOptionsCollection.selectedIndex': 'int',
  'BrowserHTMLOutputElement.checkValidity': 'bool',
  'BrowserHTMLOutputElement.defaultValue': 'string',
  'BrowserHTMLOutputElement.form': 'wrap',
  'BrowserHTMLOutputElement.htmlFor': 'wrap',
  'BrowserHTMLOutputElement.labels': 'wrap',
  'BrowserHTMLOutputElement.name': 'string',
  'BrowserHTMLOutputElement.reportValidity': 'bool',
  'BrowserHTMLOutputElement.setCustomValidity': 'void',
  'BrowserHTMLOutputElement.type': 'string',
  'BrowserHTMLOutputElement.validationMessage': 'string',
  'BrowserHTMLOutputElement.validity': 'wrap',
  'BrowserHTMLOutputElement.value': 'string',
  'BrowserHTMLOutputElement.willValidate': 'bool',
  'BrowserHTMLParagraphElement.align': 'string',
  'BrowserHTMLParamElement.name': 'string',
  'BrowserHTMLParamElement.type': 'string',
  'BrowserHTMLParamElement.value': 'string',
  'BrowserHTMLParamElement.valueType': 'string',
  'BrowserHTMLPreElement.width': 'int',
  'BrowserHTMLProgressElement.labels': 'wrap',
  'BrowserHTMLProgressElement.max': 'double',
  'BrowserHTMLProgressElement.position': 'double',
  'BrowserHTMLProgressElement.value': 'double',
  'BrowserHTMLQuoteElement.cite': 'string',
  'BrowserHTMLScriptElement.async_': 'bool',
  'BrowserHTMLScriptElement.attributionSrc': 'string',
  'BrowserHTMLScriptElement.charset': 'string',
  'BrowserHTMLScriptElement.crossOrigin': 'string',
  'BrowserHTMLScriptElement.defer': 'bool',
  'BrowserHTMLScriptElement.event': 'string',
  'BrowserHTMLScriptElement.fetchPriority': 'string',
  'BrowserHTMLScriptElement.htmlFor': 'string',
  'BrowserHTMLScriptElement.integrity': 'string',
  'BrowserHTMLScriptElement.noModule': 'bool',
  'BrowserHTMLScriptElement.referrerPolicy': 'string',
  'BrowserHTMLScriptElement.src': 'string',
  'BrowserHTMLScriptElement.text': 'string',
  'BrowserHTMLScriptElement.type': 'string',
  'BrowserHTMLSelectElement.add': 'void',
  'BrowserHTMLSelectElement.autocomplete': 'string',
  'BrowserHTMLSelectElement.checkValidity': 'bool',
  'BrowserHTMLSelectElement.disabled': 'bool',
  'BrowserHTMLSelectElement.form': 'wrap',
  'BrowserHTMLSelectElement.item': 'wrap',
  'BrowserHTMLSelectElement.labels': 'wrap',
  'BrowserHTMLSelectElement.length': 'int',
  'BrowserHTMLSelectElement.multiple': 'bool',
  'BrowserHTMLSelectElement.name': 'string',
  'BrowserHTMLSelectElement.namedItem': 'wrap',
  'BrowserHTMLSelectElement.options': 'wrap',
  'BrowserHTMLSelectElement.remove': 'void',
  'BrowserHTMLSelectElement.reportValidity': 'bool',
  'BrowserHTMLSelectElement.required_': 'bool',
  'BrowserHTMLSelectElement.selectedIndex': 'int',
  'BrowserHTMLSelectElement.selectedOptions': 'wrap',
  'BrowserHTMLSelectElement.setCustomValidity': 'void',
  'BrowserHTMLSelectElement.showPicker': 'void',
  'BrowserHTMLSelectElement.size': 'int',
  'BrowserHTMLSelectElement.type': 'string',
  'BrowserHTMLSelectElement.validationMessage': 'string',
  'BrowserHTMLSelectElement.validity': 'wrap',
  'BrowserHTMLSelectElement.value': 'string',
  'BrowserHTMLSelectElement.willValidate': 'bool',
  'BrowserHTMLSlotElement.assign': 'void',
  'BrowserHTMLSlotElement.assignedElements': 'wrap',
  'BrowserHTMLSlotElement.assignedNodes': 'wrap',
  'BrowserHTMLSlotElement.name': 'string',
  'BrowserHTMLSourceElement.height': 'int',
  'BrowserHTMLSourceElement.media': 'string',
  'BrowserHTMLSourceElement.sizes': 'string',
  'BrowserHTMLSourceElement.src': 'string',
  'BrowserHTMLSourceElement.srcset': 'string',
  'BrowserHTMLSourceElement.type': 'string',
  'BrowserHTMLSourceElement.width': 'int',
  'BrowserHTMLStyleElement.disabled': 'bool',
  'BrowserHTMLStyleElement.media': 'string',
  'BrowserHTMLStyleElement.sheet': 'wrap',
  'BrowserHTMLStyleElement.type': 'string',
  'BrowserHTMLTableCaptionElement.align': 'string',
  'BrowserHTMLTableCellElement.abbr': 'string',
  'BrowserHTMLTableCellElement.align': 'string',
  'BrowserHTMLTableCellElement.axis': 'string',
  'BrowserHTMLTableCellElement.bgColor': 'string',
  'BrowserHTMLTableCellElement.cellIndex': 'int',
  'BrowserHTMLTableCellElement.ch': 'string',
  'BrowserHTMLTableCellElement.chOff': 'string',
  'BrowserHTMLTableCellElement.colSpan': 'int',
  'BrowserHTMLTableCellElement.headers': 'string',
  'BrowserHTMLTableCellElement.height': 'string',
  'BrowserHTMLTableCellElement.noWrap': 'bool',
  'BrowserHTMLTableCellElement.rowSpan': 'int',
  'BrowserHTMLTableCellElement.scope': 'string',
  'BrowserHTMLTableCellElement.vAlign': 'string',
  'BrowserHTMLTableCellElement.width': 'string',
  'BrowserHTMLTableColElement.align': 'string',
  'BrowserHTMLTableColElement.ch': 'string',
  'BrowserHTMLTableColElement.chOff': 'string',
  'BrowserHTMLTableColElement.span': 'int',
  'BrowserHTMLTableColElement.vAlign': 'string',
  'BrowserHTMLTableColElement.width': 'string',
  'BrowserHTMLTableElement.align': 'string',
  'BrowserHTMLTableElement.bgColor': 'string',
  'BrowserHTMLTableElement.border': 'string',
  'BrowserHTMLTableElement.caption': 'wrap',
  'BrowserHTMLTableElement.cellPadding': 'string',
  'BrowserHTMLTableElement.cellSpacing': 'string',
  'BrowserHTMLTableElement.createCaption': 'wrap',
  'BrowserHTMLTableElement.createTBody': 'wrap',
  'BrowserHTMLTableElement.createTFoot': 'wrap',
  'BrowserHTMLTableElement.createTHead': 'wrap',
  'BrowserHTMLTableElement.deleteCaption': 'void',
  'BrowserHTMLTableElement.deleteRow': 'void',
  'BrowserHTMLTableElement.deleteTFoot': 'void',
  'BrowserHTMLTableElement.deleteTHead': 'void',
  'BrowserHTMLTableElement.frame': 'string',
  'BrowserHTMLTableElement.insertRow': 'wrap',
  'BrowserHTMLTableElement.rows': 'wrap',
  'BrowserHTMLTableElement.rules': 'string',
  'BrowserHTMLTableElement.summary': 'string',
  'BrowserHTMLTableElement.tBodies': 'wrap',
  'BrowserHTMLTableElement.tFoot': 'wrap',
  'BrowserHTMLTableElement.tHead': 'wrap',
  'BrowserHTMLTableElement.width': 'string',
  'BrowserHTMLTableRowElement.align': 'string',
  'BrowserHTMLTableRowElement.bgColor': 'string',
  'BrowserHTMLTableRowElement.cells': 'wrap',
  'BrowserHTMLTableRowElement.ch': 'string',
  'BrowserHTMLTableRowElement.chOff': 'string',
  'BrowserHTMLTableRowElement.deleteCell': 'void',
  'BrowserHTMLTableRowElement.insertCell': 'wrap',
  'BrowserHTMLTableRowElement.rowIndex': 'int',
  'BrowserHTMLTableRowElement.sectionRowIndex': 'int',
  'BrowserHTMLTableRowElement.vAlign': 'string',
  'BrowserHTMLTableSectionElement.align': 'string',
  'BrowserHTMLTableSectionElement.ch': 'string',
  'BrowserHTMLTableSectionElement.chOff': 'string',
  'BrowserHTMLTableSectionElement.deleteRow': 'void',
  'BrowserHTMLTableSectionElement.insertRow': 'wrap',
  'BrowserHTMLTableSectionElement.rows': 'wrap',
  'BrowserHTMLTableSectionElement.vAlign': 'string',
  'BrowserHTMLTemplateElement.content': 'wrap',
  'BrowserHTMLTemplateElement.shadowRootClonable': 'bool',
  'BrowserHTMLTemplateElement.shadowRootDelegatesFocus': 'bool',
  'BrowserHTMLTemplateElement.shadowRootMode': 'string',
  'BrowserHTMLTemplateElement.shadowRootSerializable': 'bool',
  'BrowserHTMLTextAreaElement.autocomplete': 'string',
  'BrowserHTMLTextAreaElement.checkValidity': 'bool',
  'BrowserHTMLTextAreaElement.cols': 'int',
  'BrowserHTMLTextAreaElement.defaultValue': 'string',
  'BrowserHTMLTextAreaElement.dirName': 'string',
  'BrowserHTMLTextAreaElement.disabled': 'bool',
  'BrowserHTMLTextAreaElement.form': 'wrap',
  'BrowserHTMLTextAreaElement.labels': 'wrap',
  'BrowserHTMLTextAreaElement.maxLength': 'int',
  'BrowserHTMLTextAreaElement.minLength': 'int',
  'BrowserHTMLTextAreaElement.name': 'string',
  'BrowserHTMLTextAreaElement.placeholder': 'string',
  'BrowserHTMLTextAreaElement.readOnly': 'bool',
  'BrowserHTMLTextAreaElement.reportValidity': 'bool',
  'BrowserHTMLTextAreaElement.required_': 'bool',
  'BrowserHTMLTextAreaElement.rows': 'int',
  'BrowserHTMLTextAreaElement.select': 'void',
  'BrowserHTMLTextAreaElement.selectionDirection': 'string',
  'BrowserHTMLTextAreaElement.selectionEnd': 'int',
  'BrowserHTMLTextAreaElement.selectionStart': 'int',
  'BrowserHTMLTextAreaElement.setCustomValidity': 'void',
  'BrowserHTMLTextAreaElement.setRangeText': 'void',
  'BrowserHTMLTextAreaElement.setSelectionRange': 'void',
  'BrowserHTMLTextAreaElement.textLength': 'int',
  'BrowserHTMLTextAreaElement.type': 'string',
  'BrowserHTMLTextAreaElement.validationMessage': 'string',
  'BrowserHTMLTextAreaElement.validity': 'wrap',
  'BrowserHTMLTextAreaElement.value': 'string',
  'BrowserHTMLTextAreaElement.willValidate': 'bool',
  'BrowserHTMLTextAreaElement.wrap': 'string',
  'BrowserHTMLTimeElement.dateTime': 'string',
  'BrowserHTMLTitleElement.text': 'string',
  'BrowserHTMLTrackElement.default_': 'bool',
  'BrowserHTMLTrackElement.kind': 'string',
  'BrowserHTMLTrackElement.label': 'string',
  'BrowserHTMLTrackElement.readyState': 'int',
  'BrowserHTMLTrackElement.src': 'string',
  'BrowserHTMLTrackElement.srclang': 'string',
  'BrowserHTMLTrackElement.track': 'wrap',
  'BrowserHTMLUListElement.compact': 'bool',
  'BrowserHTMLUListElement.type': 'string',
  'BrowserHTMLVideoElement.cancelVideoFrameCallback': 'void',
  'BrowserHTMLVideoElement.disablePictureInPicture': 'bool',
  'BrowserHTMLVideoElement.getVideoPlaybackQuality': 'wrap',
  'BrowserHTMLVideoElement.height': 'int',
  'BrowserHTMLVideoElement.onenterpictureinpicture': 'jsfunction',
  'BrowserHTMLVideoElement.onleavepictureinpicture': 'jsfunction',
  'BrowserHTMLVideoElement.playsInline': 'bool',
  'BrowserHTMLVideoElement.poster': 'string',
  'BrowserHTMLVideoElement.requestPictureInPicture': 'wrap',
  'BrowserHTMLVideoElement.requestVideoFrameCallback': 'int',
  'BrowserHTMLVideoElement.videoHeight': 'int',
  'BrowserHTMLVideoElement.videoWidth': 'int',
  'BrowserHTMLVideoElement.width': 'int',
  'BrowserHashChangeEvent.newURL': 'string',
  'BrowserHashChangeEvent.oldURL': 'string',
  'BrowserHeaders.append': 'void',
  'BrowserHeaders.delete': 'void',
  'BrowserHeaders.getSetCookie': 'wrap',
  'BrowserHeaders.get_': 'string',
  'BrowserHeaders.has': 'bool',
  'BrowserHeaders.set_': 'void',
  'BrowserHighlight.priority': 'int',
  'BrowserHighlight.type': 'wrap',
  'BrowserHistory.back': 'void',
  'BrowserHistory.forward': 'void',
  'BrowserHistory.go': 'void',
  'BrowserHistory.length': 'int',
  'BrowserHistory.pushState': 'void',
  'BrowserHistory.replaceState': 'void',
  'BrowserHistory.scrollRestoration': 'wrap',
  'BrowserHistory.state': 'wrap',
  'BrowserIDBFactory.cmp': 'int',
  'BrowserIDBFactory.databases': 'wrap',
  'BrowserIDBFactory.deleteDatabase': 'wrap',
  'BrowserIDBFactory.open': 'wrap',
  'BrowserIDBOpenDBRequest.onblocked': 'jsfunction',
  'BrowserIDBOpenDBRequest.onupgradeneeded': 'jsfunction',
  'BrowserIDBVersionChangeEvent.newVersion': 'int',
  'BrowserIDBVersionChangeEvent.oldVersion': 'int',
  'BrowserIIRFilterNode.getFrequencyResponse': 'void',
  'BrowserImageBitmap.close': 'void',
  'BrowserImageBitmap.height': 'int',
  'BrowserImageBitmap.width': 'int',
  'BrowserImageData.colorSpace': 'wrap',
  'BrowserImageData.data': 'typedArray',
  'BrowserImageData.height': 'int',
  'BrowserImageData.width': 'int',
  'BrowserInputEvent.data': 'string',
  'BrowserInputEvent.dataTransfer': 'wrap',
  'BrowserInputEvent.getTargetRanges': 'wrap',
  'BrowserInputEvent.inputType': 'string',
  'BrowserInputEvent.isComposing': 'bool',
  'BrowserIntersectionObserver.disconnect': 'void',
  'BrowserIntersectionObserver.observe': 'void',
  'BrowserIntersectionObserver.root': 'wrap',
  'BrowserIntersectionObserver.rootMargin': 'string',
  'BrowserIntersectionObserver.takeRecords': 'wrap',
  'BrowserIntersectionObserver.thresholds': 'wrap',
  'BrowserIntersectionObserver.unobserve': 'void',
  'BrowserIntersectionObserverEntry.boundingClientRect': 'wrap',
  'BrowserIntersectionObserverEntry.intersectionRatio': 'double',
  'BrowserIntersectionObserverEntry.intersectionRect': 'wrap',
  'BrowserIntersectionObserverEntry.isIntersecting': 'bool',
  'BrowserIntersectionObserverEntry.rootBounds': 'wrap',
  'BrowserIntersectionObserverEntry.target': 'wrap',
  'BrowserIntersectionObserverEntry.time': 'wrap',
  'BrowserKeyboardEvent.altKey': 'bool',
  'BrowserKeyboardEvent.charCode': 'int',
  'BrowserKeyboardEvent.code': 'string',
  'BrowserKeyboardEvent.ctrlKey': 'bool',
  'BrowserKeyboardEvent.getModifierState': 'bool',
  'BrowserKeyboardEvent.initKeyboardEvent': 'void',
  'BrowserKeyboardEvent.isComposing': 'bool',
  'BrowserKeyboardEvent.key': 'string',
  'BrowserKeyboardEvent.keyCode': 'int',
  'BrowserKeyboardEvent.location': 'int',
  'BrowserKeyboardEvent.metaKey': 'bool',
  'BrowserKeyboardEvent.repeat': 'bool',
  'BrowserKeyboardEvent.shiftKey': 'bool',
  'BrowserKeyframeEffect.composite': 'wrap',
  'BrowserKeyframeEffect.getKeyframes': 'wrap',
  'BrowserKeyframeEffect.iterationComposite': 'wrap',
  'BrowserKeyframeEffect.pseudoElement': 'wrap',
  'BrowserKeyframeEffect.setKeyframes': 'void',
  'BrowserKeyframeEffect.target': 'wrap',
  'BrowserLocation.ancestorOrigins': 'wrap',
  'BrowserLocation.assign': 'void',
  'BrowserLocation.hash': 'string',
  'BrowserLocation.host': 'string',
  'BrowserLocation.hostname': 'string',
  'BrowserLocation.href': 'string',
  'BrowserLocation.origin': 'string',
  'BrowserLocation.pathname': 'string',
  'BrowserLocation.port': 'string',
  'BrowserLocation.protocol': 'string',
  'BrowserLocation.reload': 'void',
  'BrowserLocation.replace': 'void',
  'BrowserLocation.search': 'string',
  'BrowserLockManager.query': 'wrap',
  'BrowserLockManager.request': 'wrap',
  'BrowserMIDIConnectionEvent.port': 'wrap',
  'BrowserMIDIMessageEvent.data': 'typedArray',
  'BrowserMIDIPort.close': 'wrap',
  'BrowserMIDIPort.connection': 'wrap',
  'BrowserMIDIPort.id': 'string',
  'BrowserMIDIPort.manufacturer': 'string',
  'BrowserMIDIPort.name': 'string',
  'BrowserMIDIPort.onstatechange': 'jsfunction',
  'BrowserMIDIPort.open': 'wrap',
  'BrowserMIDIPort.state': 'wrap',
  'BrowserMIDIPort.type': 'wrap',
  'BrowserMIDIPort.version': 'string',
  'BrowserMathMLElement.attributeStyleMap': 'wrap',
  'BrowserMathMLElement.autofocus': 'bool',
  'BrowserMathMLElement.blur': 'void',
  'BrowserMathMLElement.dataset': 'wrap',
  'BrowserMathMLElement.focus': 'void',
  'BrowserMathMLElement.nonce': 'string',
  'BrowserMathMLElement.onabort': 'jsfunction',
  'BrowserMathMLElement.onanimationcancel': 'jsfunction',
  'BrowserMathMLElement.onanimationend': 'jsfunction',
  'BrowserMathMLElement.onanimationiteration': 'jsfunction',
  'BrowserMathMLElement.onanimationstart': 'jsfunction',
  'BrowserMathMLElement.onauxclick': 'jsfunction',
  'BrowserMathMLElement.onbeforeinput': 'jsfunction',
  'BrowserMathMLElement.onbeforematch': 'jsfunction',
  'BrowserMathMLElement.onbeforetoggle': 'jsfunction',
  'BrowserMathMLElement.onbeforexrselect': 'jsfunction',
  'BrowserMathMLElement.onblur': 'jsfunction',
  'BrowserMathMLElement.oncancel': 'jsfunction',
  'BrowserMathMLElement.oncanplay': 'jsfunction',
  'BrowserMathMLElement.oncanplaythrough': 'jsfunction',
  'BrowserMathMLElement.onchange': 'jsfunction',
  'BrowserMathMLElement.onclick': 'jsfunction',
  'BrowserMathMLElement.onclose': 'jsfunction',
  'BrowserMathMLElement.oncontextlost': 'jsfunction',
  'BrowserMathMLElement.oncontextmenu': 'jsfunction',
  'BrowserMathMLElement.oncontextrestored': 'jsfunction',
  'BrowserMathMLElement.oncopy': 'jsfunction',
  'BrowserMathMLElement.oncuechange': 'jsfunction',
  'BrowserMathMLElement.oncut': 'jsfunction',
  'BrowserMathMLElement.ondblclick': 'jsfunction',
  'BrowserMathMLElement.ondrag': 'jsfunction',
  'BrowserMathMLElement.ondragend': 'jsfunction',
  'BrowserMathMLElement.ondragenter': 'jsfunction',
  'BrowserMathMLElement.ondragleave': 'jsfunction',
  'BrowserMathMLElement.ondragover': 'jsfunction',
  'BrowserMathMLElement.ondragstart': 'jsfunction',
  'BrowserMathMLElement.ondrop': 'jsfunction',
  'BrowserMathMLElement.ondurationchange': 'jsfunction',
  'BrowserMathMLElement.onemptied': 'jsfunction',
  'BrowserMathMLElement.onended': 'jsfunction',
  'BrowserMathMLElement.onerror': 'jsfunction',
  'BrowserMathMLElement.onfocus': 'jsfunction',
  'BrowserMathMLElement.onformdata': 'jsfunction',
  'BrowserMathMLElement.ongotpointercapture': 'jsfunction',
  'BrowserMathMLElement.oninput': 'jsfunction',
  'BrowserMathMLElement.oninvalid': 'jsfunction',
  'BrowserMathMLElement.onkeydown': 'jsfunction',
  'BrowserMathMLElement.onkeypress': 'jsfunction',
  'BrowserMathMLElement.onkeyup': 'jsfunction',
  'BrowserMathMLElement.onload': 'jsfunction',
  'BrowserMathMLElement.onloadeddata': 'jsfunction',
  'BrowserMathMLElement.onloadedmetadata': 'jsfunction',
  'BrowserMathMLElement.onloadstart': 'jsfunction',
  'BrowserMathMLElement.onlostpointercapture': 'jsfunction',
  'BrowserMathMLElement.onmousedown': 'jsfunction',
  'BrowserMathMLElement.onmouseenter': 'jsfunction',
  'BrowserMathMLElement.onmouseleave': 'jsfunction',
  'BrowserMathMLElement.onmousemove': 'jsfunction',
  'BrowserMathMLElement.onmouseout': 'jsfunction',
  'BrowserMathMLElement.onmouseover': 'jsfunction',
  'BrowserMathMLElement.onmouseup': 'jsfunction',
  'BrowserMathMLElement.onpaste': 'jsfunction',
  'BrowserMathMLElement.onpause': 'jsfunction',
  'BrowserMathMLElement.onplay': 'jsfunction',
  'BrowserMathMLElement.onplaying': 'jsfunction',
  'BrowserMathMLElement.onpointercancel': 'jsfunction',
  'BrowserMathMLElement.onpointerdown': 'jsfunction',
  'BrowserMathMLElement.onpointerenter': 'jsfunction',
  'BrowserMathMLElement.onpointerleave': 'jsfunction',
  'BrowserMathMLElement.onpointermove': 'jsfunction',
  'BrowserMathMLElement.onpointerout': 'jsfunction',
  'BrowserMathMLElement.onpointerover': 'jsfunction',
  'BrowserMathMLElement.onpointerrawupdate': 'jsfunction',
  'BrowserMathMLElement.onpointerup': 'jsfunction',
  'BrowserMathMLElement.onprogress': 'jsfunction',
  'BrowserMathMLElement.onratechange': 'jsfunction',
  'BrowserMathMLElement.onreset': 'jsfunction',
  'BrowserMathMLElement.onresize': 'jsfunction',
  'BrowserMathMLElement.onscroll': 'jsfunction',
  'BrowserMathMLElement.onscrollend': 'jsfunction',
  'BrowserMathMLElement.onsecuritypolicyviolation': 'jsfunction',
  'BrowserMathMLElement.onseeked': 'jsfunction',
  'BrowserMathMLElement.onseeking': 'jsfunction',
  'BrowserMathMLElement.onselect': 'jsfunction',
  'BrowserMathMLElement.onselectionchange': 'jsfunction',
  'BrowserMathMLElement.onselectstart': 'jsfunction',
  'BrowserMathMLElement.onslotchange': 'jsfunction',
  'BrowserMathMLElement.onsnapchanged': 'jsfunction',
  'BrowserMathMLElement.onsnapchanging': 'jsfunction',
  'BrowserMathMLElement.onstalled': 'jsfunction',
  'BrowserMathMLElement.onsubmit': 'jsfunction',
  'BrowserMathMLElement.onsuspend': 'jsfunction',
  'BrowserMathMLElement.ontimeupdate': 'jsfunction',
  'BrowserMathMLElement.ontoggle': 'jsfunction',
  'BrowserMathMLElement.ontouchcancel': 'jsfunction',
  'BrowserMathMLElement.ontouchend': 'jsfunction',
  'BrowserMathMLElement.ontouchmove': 'jsfunction',
  'BrowserMathMLElement.ontouchstart': 'jsfunction',
  'BrowserMathMLElement.ontransitioncancel': 'jsfunction',
  'BrowserMathMLElement.ontransitionend': 'jsfunction',
  'BrowserMathMLElement.ontransitionrun': 'jsfunction',
  'BrowserMathMLElement.ontransitionstart': 'jsfunction',
  'BrowserMathMLElement.onvolumechange': 'jsfunction',
  'BrowserMathMLElement.onwaiting': 'jsfunction',
  'BrowserMathMLElement.onwebkitanimationend': 'jsfunction',
  'BrowserMathMLElement.onwebkitanimationiteration': 'jsfunction',
  'BrowserMathMLElement.onwebkitanimationstart': 'jsfunction',
  'BrowserMathMLElement.onwebkittransitionend': 'jsfunction',
  'BrowserMathMLElement.onwheel': 'jsfunction',
  'BrowserMathMLElement.style': 'wrap',
  'BrowserMathMLElement.tabIndex': 'int',
  'BrowserMediaCapabilities.decodingInfo': 'wrap',
  'BrowserMediaCapabilities.encodingInfo': 'wrap',
  'BrowserMediaDevices.enumerateDevices': 'wrap',
  'BrowserMediaDevices.getDisplayMedia': 'wrap',
  'BrowserMediaDevices.getSupportedConstraints': 'wrap',
  'BrowserMediaDevices.getUserMedia': 'wrap',
  'BrowserMediaDevices.ondevicechange': 'jsfunction',
  'BrowserMediaElementAudioSourceNode.mediaElement': 'wrap',
  'BrowserMediaEncryptedEvent.initData': 'wrap',
  'BrowserMediaEncryptedEvent.initDataType': 'string',
  'BrowserMediaError.code': 'int',
  'BrowserMediaError.message': 'string',
  'BrowserMediaKeyMessageEvent.message': 'wrap',
  'BrowserMediaKeyMessageEvent.messageType': 'wrap',
  'BrowserMediaKeySession.close': 'wrap',
  'BrowserMediaKeySession.closed': 'wrap',
  'BrowserMediaKeySession.expiration': 'double',
  'BrowserMediaKeySession.generateRequest': 'wrap',
  'BrowserMediaKeySession.keyStatuses': 'wrap',
  'BrowserMediaKeySession.load': 'wrap',
  'BrowserMediaKeySession.onkeystatuseschange': 'jsfunction',
  'BrowserMediaKeySession.onmessage': 'jsfunction',
  'BrowserMediaKeySession.remove': 'wrap',
  'BrowserMediaKeySession.sessionId': 'string',
  'BrowserMediaKeySession.update': 'wrap',
  'BrowserMediaKeyStatusMap.get_': 'wrap',
  'BrowserMediaKeyStatusMap.has': 'bool',
  'BrowserMediaKeyStatusMap.size': 'int',
  'BrowserMediaKeys.createSession': 'wrap',
  'BrowserMediaKeys.getStatusForPolicy': 'wrap',
  'BrowserMediaKeys.setServerCertificate': 'wrap',
  'BrowserMediaMetadata.album': 'string',
  'BrowserMediaMetadata.artist': 'string',
  'BrowserMediaMetadata.artwork': 'wrap',
  'BrowserMediaMetadata.title': 'string',
  'BrowserMediaQueryList.addListener': 'void',
  'BrowserMediaQueryList.matches': 'bool',
  'BrowserMediaQueryList.media': 'wrap',
  'BrowserMediaQueryList.onchange': 'jsfunction',
  'BrowserMediaQueryList.removeListener': 'void',
  'BrowserMediaQueryListEvent.matches': 'bool',
  'BrowserMediaQueryListEvent.media': 'wrap',
  'BrowserMediaRecorder.audioBitsPerSecond': 'int',
  'BrowserMediaRecorder.mimeType': 'string',
  'BrowserMediaRecorder.ondataavailable': 'jsfunction',
  'BrowserMediaRecorder.onerror': 'jsfunction',
  'BrowserMediaRecorder.onpause': 'jsfunction',
  'BrowserMediaRecorder.onresume': 'jsfunction',
  'BrowserMediaRecorder.onstart': 'jsfunction',
  'BrowserMediaRecorder.onstop': 'jsfunction',
  'BrowserMediaRecorder.pause': 'void',
  'BrowserMediaRecorder.requestData': 'void',
  'BrowserMediaRecorder.resume': 'void',
  'BrowserMediaRecorder.start': 'void',
  'BrowserMediaRecorder.state': 'wrap',
  'BrowserMediaRecorder.stop': 'void',
  'BrowserMediaRecorder.stream': 'wrap',
  'BrowserMediaRecorder.videoBitsPerSecond': 'int',
  'BrowserMediaSession.metadata': 'wrap',
  'BrowserMediaSession.playbackState': 'wrap',
  'BrowserMediaSession.setActionHandler': 'void',
  'BrowserMediaSession.setPositionState': 'void',
  'BrowserMediaSource.activeSourceBuffers': 'wrap',
  'BrowserMediaSource.addSourceBuffer': 'wrap',
  'BrowserMediaSource.clearLiveSeekableRange': 'void',
  'BrowserMediaSource.duration': 'double',
  'BrowserMediaSource.endOfStream': 'void',
  'BrowserMediaSource.handle': 'wrap',
  'BrowserMediaSource.onsourceclose': 'jsfunction',
  'BrowserMediaSource.onsourceended': 'jsfunction',
  'BrowserMediaSource.onsourceopen': 'jsfunction',
  'BrowserMediaSource.readyState': 'wrap',
  'BrowserMediaSource.removeSourceBuffer': 'void',
  'BrowserMediaSource.setLiveSeekableRange': 'void',
  'BrowserMediaSource.sourceBuffers': 'wrap',
  'BrowserMediaStream.active': 'bool',
  'BrowserMediaStream.addTrack': 'void',
  'BrowserMediaStream.clone': 'wrap',
  'BrowserMediaStream.getAudioTracks': 'wrap',
  'BrowserMediaStream.getTrackById': 'wrap',
  'BrowserMediaStream.getTracks': 'wrap',
  'BrowserMediaStream.getVideoTracks': 'wrap',
  'BrowserMediaStream.id': 'string',
  'BrowserMediaStream.onaddtrack': 'jsfunction',
  'BrowserMediaStream.onremovetrack': 'jsfunction',
  'BrowserMediaStream.removeTrack': 'void',
  'BrowserMediaStreamAudioDestinationNode.stream': 'wrap',
  'BrowserMediaStreamAudioSourceNode.mediaStream': 'wrap',
  'BrowserMediaStreamTrack.applyConstraints': 'wrap',
  'BrowserMediaStreamTrack.clone': 'wrap',
  'BrowserMediaStreamTrack.contentHint': 'string',
  'BrowserMediaStreamTrack.enabled': 'bool',
  'BrowserMediaStreamTrack.getCapabilities': 'wrap',
  'BrowserMediaStreamTrack.getConstraints': 'wrap',
  'BrowserMediaStreamTrack.getSettings': 'wrap',
  'BrowserMediaStreamTrack.id': 'string',
  'BrowserMediaStreamTrack.kind': 'string',
  'BrowserMediaStreamTrack.label': 'string',
  'BrowserMediaStreamTrack.muted': 'bool',
  'BrowserMediaStreamTrack.onended': 'jsfunction',
  'BrowserMediaStreamTrack.onmute': 'jsfunction',
  'BrowserMediaStreamTrack.onunmute': 'jsfunction',
  'BrowserMediaStreamTrack.readyState': 'wrap',
  'BrowserMediaStreamTrack.stop': 'void',
  'BrowserMediaStreamTrackEvent.track': 'wrap',
  'BrowserMediaStreamTrackProcessor.readable': 'wrap',
  'BrowserMessageChannel.port1': 'wrap',
  'BrowserMessageChannel.port2': 'wrap',
  'BrowserMessageEvent.data': 'wrap',
  'BrowserMessageEvent.initMessageEvent': 'void',
  'BrowserMessageEvent.lastEventId': 'string',
  'BrowserMessageEvent.origin': 'string',
  'BrowserMessageEvent.ports': 'wrap',
  'BrowserMessageEvent.source': 'wrap',
  'BrowserMessagePort.close': 'void',
  'BrowserMessagePort.onclose': 'jsfunction',
  'BrowserMessagePort.onmessage': 'jsfunction',
  'BrowserMessagePort.onmessageerror': 'jsfunction',
  'BrowserMessagePort.postMessage': 'void',
  'BrowserMessagePort.start': 'void',
  'BrowserMimeType.description': 'string',
  'BrowserMimeType.enabledPlugin': 'wrap',
  'BrowserMimeType.suffixes': 'string',
  'BrowserMimeType.type': 'string',
  'BrowserMimeTypeArray.item': 'wrap',
  'BrowserMimeTypeArray.length': 'int',
  'BrowserMimeTypeArray.namedItem': 'wrap',
  'BrowserMouseEvent.altKey': 'bool',
  'BrowserMouseEvent.button': 'int',
  'BrowserMouseEvent.buttons': 'int',
  'BrowserMouseEvent.clientX': 'int',
  'BrowserMouseEvent.clientY': 'int',
  'BrowserMouseEvent.ctrlKey': 'bool',
  'BrowserMouseEvent.getModifierState': 'bool',
  'BrowserMouseEvent.initMouseEvent': 'void',
  'BrowserMouseEvent.metaKey': 'bool',
  'BrowserMouseEvent.movementX': 'double',
  'BrowserMouseEvent.movementY': 'double',
  'BrowserMouseEvent.offsetX': 'double',
  'BrowserMouseEvent.offsetY': 'double',
  'BrowserMouseEvent.pageX': 'double',
  'BrowserMouseEvent.pageY': 'double',
  'BrowserMouseEvent.relatedTarget': 'wrap',
  'BrowserMouseEvent.screenX': 'int',
  'BrowserMouseEvent.screenY': 'int',
  'BrowserMouseEvent.shiftKey': 'bool',
  'BrowserMouseEvent.x': 'double',
  'BrowserMouseEvent.y': 'double',
  'BrowserMutationObserver.disconnect': 'void',
  'BrowserMutationObserver.observe': 'void',
  'BrowserMutationObserver.takeRecords': 'wrap',
  'BrowserNamedNodeMap.getNamedItem': 'wrap',
  'BrowserNamedNodeMap.getNamedItemNS': 'wrap',
  'BrowserNamedNodeMap.item': 'wrap',
  'BrowserNamedNodeMap.length': 'int',
  'BrowserNamedNodeMap.removeNamedItem': 'wrap',
  'BrowserNamedNodeMap.removeNamedItemNS': 'wrap',
  'BrowserNamedNodeMap.setNamedItem': 'wrap',
  'BrowserNamedNodeMap.setNamedItemNS': 'wrap',
  'BrowserNavigator.appCodeName': 'string',
  'BrowserNavigator.appName': 'string',
  'BrowserNavigator.appVersion': 'string',
  'BrowserNavigator.canShare': 'bool',
  'BrowserNavigator.clearAppBadge': 'wrap',
  'BrowserNavigator.clipboard': 'wrap',
  'BrowserNavigator.connection': 'wrap',
  'BrowserNavigator.cookieEnabled': 'bool',
  'BrowserNavigator.credentials': 'wrap',
  'BrowserNavigator.deviceMemory': 'double',
  'BrowserNavigator.geolocation': 'wrap',
  'BrowserNavigator.getBattery': 'wrap',
  'BrowserNavigator.getGamepads': 'wrap',
  'BrowserNavigator.gpu': 'wrap',
  'BrowserNavigator.hardwareConcurrency': 'int',
  'BrowserNavigator.javaEnabled': 'bool',
  'BrowserNavigator.language': 'string',
  'BrowserNavigator.languages': 'wrap',
  'BrowserNavigator.locks': 'wrap',
  'BrowserNavigator.maxTouchPoints': 'int',
  'BrowserNavigator.mediaCapabilities': 'wrap',
  'BrowserNavigator.mediaDevices': 'wrap',
  'BrowserNavigator.mediaSession': 'wrap',
  'BrowserNavigator.mimeTypes': 'wrap',
  'BrowserNavigator.ml': 'wrap',
  'BrowserNavigator.onLine': 'bool',
  'BrowserNavigator.oscpu': 'string',
  'BrowserNavigator.pdfViewerEnabled': 'bool',
  'BrowserNavigator.permissions': 'wrap',
  'BrowserNavigator.platform': 'string',
  'BrowserNavigator.plugins': 'wrap',
  'BrowserNavigator.presentation': 'wrap',
  'BrowserNavigator.product': 'string',
  'BrowserNavigator.productSub': 'string',
  'BrowserNavigator.registerProtocolHandler': 'void',
  'BrowserNavigator.requestMIDIAccess': 'wrap',
  'BrowserNavigator.requestMediaKeySystemAccess': 'wrap',
  'BrowserNavigator.sendBeacon': 'bool',
  'BrowserNavigator.serviceWorker': 'wrap',
  'BrowserNavigator.setAppBadge': 'wrap',
  'BrowserNavigator.share': 'wrap',
  'BrowserNavigator.storage': 'wrap',
  'BrowserNavigator.storageBuckets': 'wrap',
  'BrowserNavigator.taintEnabled': 'bool',
  'BrowserNavigator.unregisterProtocolHandler': 'void',
  'BrowserNavigator.usb': 'wrap',
  'BrowserNavigator.userActivation': 'wrap',
  'BrowserNavigator.userAgent': 'string',
  'BrowserNavigator.userAgentData': 'wrap',
  'BrowserNavigator.vendor': 'string',
  'BrowserNavigator.vendorSub': 'string',
  'BrowserNavigator.vibrate': 'bool',
  'BrowserNavigator.wakeLock': 'wrap',
  'BrowserNavigator.webdriver': 'bool',
  'BrowserNavigator.windowControlsOverlay': 'wrap',
  'BrowserNetworkInformation.downlink': 'wrap',
  'BrowserNetworkInformation.effectiveType': 'wrap',
  'BrowserNetworkInformation.onchange': 'jsfunction',
  'BrowserNetworkInformation.rtt': 'wrap',
  'BrowserNetworkInformation.saveData': 'bool',
  'BrowserNode.appendChild': 'wrap',
  'BrowserNode.baseURI': 'string',
  'BrowserNode.childNodes': 'wrap',
  'BrowserNode.cloneNode': 'wrap',
  'BrowserNode.compareDocumentPosition': 'int',
  'BrowserNode.contains': 'bool',
  'BrowserNode.firstChild': 'wrap',
  'BrowserNode.getRootNode': 'wrap',
  'BrowserNode.hasChildNodes': 'bool',
  'BrowserNode.insertBefore': 'wrap',
  'BrowserNode.isConnected': 'bool',
  'BrowserNode.isDefaultNamespace': 'bool',
  'BrowserNode.isEqualNode': 'bool',
  'BrowserNode.isSameNode': 'bool',
  'BrowserNode.lastChild': 'wrap',
  'BrowserNode.lookupNamespaceURI': 'string',
  'BrowserNode.lookupPrefix': 'string',
  'BrowserNode.nextSibling': 'wrap',
  'BrowserNode.nodeName': 'string',
  'BrowserNode.nodeType': 'int',
  'BrowserNode.nodeValue': 'string',
  'BrowserNode.normalize': 'void',
  'BrowserNode.ownerDocument': 'wrap',
  'BrowserNode.parentElement': 'wrap',
  'BrowserNode.parentNode': 'wrap',
  'BrowserNode.previousSibling': 'wrap',
  'BrowserNode.removeChild': 'wrap',
  'BrowserNode.replaceChild': 'wrap',
  'BrowserNode.textContent': 'string',
  'BrowserNodeIterator.detach': 'void',
  'BrowserNodeIterator.filter': 'wrap',
  'BrowserNodeIterator.nextNode': 'wrap',
  'BrowserNodeIterator.pointerBeforeReferenceNode': 'bool',
  'BrowserNodeIterator.previousNode': 'wrap',
  'BrowserNodeIterator.referenceNode': 'wrap',
  'BrowserNodeIterator.root': 'wrap',
  'BrowserNodeIterator.whatToShow': 'int',
  'BrowserNodeList.item': 'wrap',
  'BrowserNodeList.length': 'int',
  'BrowserNotification.badge': 'string',
  'BrowserNotification.body': 'string',
  'BrowserNotification.close': 'void',
  'BrowserNotification.data': 'wrap',
  'BrowserNotification.dir': 'wrap',
  'BrowserNotification.icon': 'string',
  'BrowserNotification.lang': 'string',
  'BrowserNotification.onclick': 'jsfunction',
  'BrowserNotification.onclose': 'jsfunction',
  'BrowserNotification.onerror': 'jsfunction',
  'BrowserNotification.onshow': 'jsfunction',
  'BrowserNotification.requireInteraction': 'bool',
  'BrowserNotification.silent': 'bool',
  'BrowserNotification.tag': 'string',
  'BrowserNotification.title': 'string',
  'BrowserNotificationEvent.action': 'string',
  'BrowserNotificationEvent.notification': 'wrap',
  'BrowserOfflineAudioCompletionEvent.renderedBuffer': 'wrap',
  'BrowserOfflineAudioContext.length': 'int',
  'BrowserOfflineAudioContext.oncomplete': 'jsfunction',
  'BrowserOfflineAudioContext.resume': 'wrap',
  'BrowserOfflineAudioContext.startRendering': 'wrap',
  'BrowserOfflineAudioContext.suspend': 'wrap',
  'BrowserOffscreenCanvas.convertToBlob': 'wrap',
  'BrowserOffscreenCanvas.getContext': 'wrap',
  'BrowserOffscreenCanvas.height': 'int',
  'BrowserOffscreenCanvas.oncontextlost': 'jsfunction',
  'BrowserOffscreenCanvas.oncontextrestored': 'jsfunction',
  'BrowserOffscreenCanvas.transferToImageBitmap': 'wrap',
  'BrowserOffscreenCanvas.width': 'int',
  'BrowserOscillatorNode.detune': 'wrap',
  'BrowserOscillatorNode.frequency': 'wrap',
  'BrowserOscillatorNode.setPeriodicWave': 'void',
  'BrowserOscillatorNode.type': 'wrap',
  'BrowserOverconstrainedError.constraint': 'string',
  'BrowserPageTransitionEvent.persisted': 'bool',
  'BrowserPannerNode.coneInnerAngle': 'double',
  'BrowserPannerNode.coneOuterAngle': 'double',
  'BrowserPannerNode.coneOuterGain': 'double',
  'BrowserPannerNode.distanceModel': 'wrap',
  'BrowserPannerNode.maxDistance': 'double',
  'BrowserPannerNode.orientationX': 'wrap',
  'BrowserPannerNode.orientationY': 'wrap',
  'BrowserPannerNode.orientationZ': 'wrap',
  'BrowserPannerNode.panningModel': 'wrap',
  'BrowserPannerNode.positionX': 'wrap',
  'BrowserPannerNode.positionY': 'wrap',
  'BrowserPannerNode.positionZ': 'wrap',
  'BrowserPannerNode.refDistance': 'double',
  'BrowserPannerNode.rolloffFactor': 'double',
  'BrowserPannerNode.setOrientation': 'void',
  'BrowserPannerNode.setPosition': 'void',
  'BrowserPath2D.addPath': 'void',
  'BrowserPath2D.arc': 'void',
  'BrowserPath2D.arcTo': 'void',
  'BrowserPath2D.bezierCurveTo': 'void',
  'BrowserPath2D.closePath': 'void',
  'BrowserPath2D.ellipse': 'void',
  'BrowserPath2D.lineTo': 'void',
  'BrowserPath2D.moveTo': 'void',
  'BrowserPath2D.quadraticCurveTo': 'void',
  'BrowserPath2D.rect': 'void',
  'BrowserPath2D.roundRect': 'void',
  'BrowserPaymentMethodChangeEvent.methodDetails': 'wrap',
  'BrowserPaymentMethodChangeEvent.methodName': 'string',
  'BrowserPaymentRequest.abort': 'wrap',
  'BrowserPaymentRequest.canMakePayment': 'wrap',
  'BrowserPaymentRequest.id': 'string',
  'BrowserPaymentRequest.onpaymentmethodchange': 'jsfunction',
  'BrowserPaymentRequest.show_': 'wrap',
  'BrowserPaymentRequestUpdateEvent.updateWith': 'void',
  'BrowserPerformance.clearMarks': 'void',
  'BrowserPerformance.clearMeasures': 'void',
  'BrowserPerformance.clearResourceTimings': 'void',
  'BrowserPerformance.eventCounts': 'wrap',
  'BrowserPerformance.getEntries': 'wrap',
  'BrowserPerformance.getEntriesByName': 'wrap',
  'BrowserPerformance.getEntriesByType': 'wrap',
  'BrowserPerformance.mark': 'wrap',
  'BrowserPerformance.measure': 'wrap',
  'BrowserPerformance.navigation': 'wrap',
  'BrowserPerformance.now': 'wrap',
  'BrowserPerformance.onresourcetimingbufferfull': 'jsfunction',
  'BrowserPerformance.setResourceTimingBufferSize': 'void',
  'BrowserPerformance.timeOrigin': 'wrap',
  'BrowserPerformance.timing': 'wrap',
  'BrowserPerformance.toJSON': 'wrap',
  'BrowserPerformanceMark.detail': 'wrap',
  'BrowserPerformanceMeasure.detail': 'wrap',
  'BrowserPerformanceNavigation.redirectCount': 'int',
  'BrowserPerformanceNavigation.toJSON': 'wrap',
  'BrowserPerformanceNavigation.type': 'int',
  'BrowserPerformanceObserver.disconnect': 'void',
  'BrowserPerformanceObserver.observe': 'void',
  'BrowserPerformanceObserver.takeRecords': 'wrap',
  'BrowserPerformanceTiming.connectEnd': 'int',
  'BrowserPerformanceTiming.connectStart': 'int',
  'BrowserPerformanceTiming.domComplete': 'int',
  'BrowserPerformanceTiming.domContentLoadedEventEnd': 'int',
  'BrowserPerformanceTiming.domContentLoadedEventStart': 'int',
  'BrowserPerformanceTiming.domInteractive': 'int',
  'BrowserPerformanceTiming.domLoading': 'int',
  'BrowserPerformanceTiming.domainLookupEnd': 'int',
  'BrowserPerformanceTiming.domainLookupStart': 'int',
  'BrowserPerformanceTiming.fetchStart': 'int',
  'BrowserPerformanceTiming.loadEventEnd': 'int',
  'BrowserPerformanceTiming.loadEventStart': 'int',
  'BrowserPerformanceTiming.navigationStart': 'int',
  'BrowserPerformanceTiming.redirectEnd': 'int',
  'BrowserPerformanceTiming.redirectStart': 'int',
  'BrowserPerformanceTiming.requestStart': 'int',
  'BrowserPerformanceTiming.responseEnd': 'int',
  'BrowserPerformanceTiming.responseStart': 'int',
  'BrowserPerformanceTiming.secureConnectionStart': 'int',
  'BrowserPerformanceTiming.toJSON': 'wrap',
  'BrowserPerformanceTiming.unloadEventEnd': 'int',
  'BrowserPerformanceTiming.unloadEventStart': 'int',
  'BrowserPermissions.query': 'wrap',
  'BrowserPermissions.revoke': 'wrap',
  'BrowserPictureInPictureEvent.pictureInPictureWindow': 'wrap',
  'BrowserPictureInPictureWindow.height': 'int',
  'BrowserPictureInPictureWindow.onresize': 'jsfunction',
  'BrowserPictureInPictureWindow.width': 'int',
  'BrowserPlugin.description': 'string',
  'BrowserPlugin.filename': 'string',
  'BrowserPlugin.item': 'wrap',
  'BrowserPlugin.length': 'int',
  'BrowserPlugin.name': 'string',
  'BrowserPlugin.namedItem': 'wrap',
  'BrowserPluginArray.item': 'wrap',
  'BrowserPluginArray.length': 'int',
  'BrowserPluginArray.namedItem': 'wrap',
  'BrowserPluginArray.refresh': 'void',
  'BrowserPointerEvent.getCoalescedEvents': 'wrap',
  'BrowserPointerEvent.getPredictedEvents': 'wrap',
  'BrowserPointerEvent.height': 'double',
  'BrowserPointerEvent.isPrimary': 'bool',
  'BrowserPointerEvent.pointerId': 'int',
  'BrowserPointerEvent.pointerType': 'string',
  'BrowserPointerEvent.pressure': 'double',
  'BrowserPointerEvent.tangentialPressure': 'double',
  'BrowserPointerEvent.tiltX': 'int',
  'BrowserPointerEvent.tiltY': 'int',
  'BrowserPointerEvent.twist': 'int',
  'BrowserPointerEvent.width': 'double',
  'BrowserPopStateEvent.hasUAVisualTransition': 'bool',
  'BrowserPopStateEvent.state': 'wrap',
  'BrowserProcessingInstruction.sheet': 'wrap',
  'BrowserProcessingInstruction.target': 'string',
  'BrowserProgressEvent.lengthComputable': 'bool',
  'BrowserProgressEvent.loaded': 'int',
  'BrowserProgressEvent.total': 'int',
  'BrowserPromiseRejectionEvent.promise': 'wrap',
  'BrowserPromiseRejectionEvent.reason': 'wrap',
  'BrowserPushEvent.data': 'wrap',
  'BrowserPushMessageData.arrayBuffer': 'wrap',
  'BrowserPushMessageData.blob': 'wrap',
  'BrowserPushMessageData.json': 'wrap',
  'BrowserPushMessageData.text': 'string',
  'BrowserPushSubscription.endpoint': 'string',
  'BrowserPushSubscription.expirationTime': 'wrap',
  'BrowserPushSubscription.getKey': 'wrap',
  'BrowserPushSubscription.options': 'wrap',
  'BrowserPushSubscription.toJSON': 'wrap',
  'BrowserPushSubscription.unsubscribe': 'wrap',
  'BrowserPushSubscriptionChangeEvent.newSubscription': 'wrap',
  'BrowserPushSubscriptionChangeEvent.oldSubscription': 'wrap',
  'BrowserPushSubscriptionOptions.applicationServerKey': 'wrap',
  'BrowserPushSubscriptionOptions.userVisibleOnly': 'bool',
  'BrowserRTCDTMFSender.canInsertDTMF': 'bool',
  'BrowserRTCDTMFSender.insertDTMF': 'void',
  'BrowserRTCDTMFSender.ontonechange': 'jsfunction',
  'BrowserRTCDTMFSender.toneBuffer': 'string',
  'BrowserRTCDTMFToneChangeEvent.tone': 'string',
  'BrowserRTCDataChannel.binaryType': 'wrap',
  'BrowserRTCDataChannel.bufferedAmount': 'int',
  'BrowserRTCDataChannel.bufferedAmountLowThreshold': 'int',
  'BrowserRTCDataChannel.close': 'void',
  'BrowserRTCDataChannel.id': 'int',
  'BrowserRTCDataChannel.label': 'string',
  'BrowserRTCDataChannel.maxPacketLifeTime': 'int',
  'BrowserRTCDataChannel.maxRetransmits': 'int',
  'BrowserRTCDataChannel.negotiated': 'bool',
  'BrowserRTCDataChannel.onbufferedamountlow': 'jsfunction',
  'BrowserRTCDataChannel.onclose': 'jsfunction',
  'BrowserRTCDataChannel.onclosing': 'jsfunction',
  'BrowserRTCDataChannel.onerror': 'jsfunction',
  'BrowserRTCDataChannel.onmessage': 'jsfunction',
  'BrowserRTCDataChannel.onopen': 'jsfunction',
  'BrowserRTCDataChannel.ordered': 'bool',
  'BrowserRTCDataChannel.protocol': 'string',
  'BrowserRTCDataChannel.readyState': 'wrap',
  'BrowserRTCDataChannel.send': 'void',
  'BrowserRTCDataChannelEvent.channel': 'wrap',
  'BrowserRTCDtlsTransport.getRemoteCertificates': 'wrap',
  'BrowserRTCDtlsTransport.iceTransport': 'wrap',
  'BrowserRTCDtlsTransport.onerror': 'jsfunction',
  'BrowserRTCDtlsTransport.onstatechange': 'jsfunction',
  'BrowserRTCDtlsTransport.state': 'wrap',
  'BrowserRTCEncodedAudioFrame.data': 'wrap',
  'BrowserRTCEncodedAudioFrame.getMetadata': 'wrap',
  'BrowserRTCEncodedVideoFrame.data': 'wrap',
  'BrowserRTCEncodedVideoFrame.getMetadata': 'wrap',
  'BrowserRTCEncodedVideoFrame.type': 'wrap',
  'BrowserRTCError.errorDetail': 'wrap',
  'BrowserRTCError.httpRequestStatusCode': 'int',
  'BrowserRTCError.receivedAlert': 'int',
  'BrowserRTCError.sctpCauseCode': 'int',
  'BrowserRTCError.sdpLineNumber': 'int',
  'BrowserRTCError.sentAlert': 'int',
  'BrowserRTCErrorEvent.error': 'wrap',
  'BrowserRTCIceCandidate.address': 'string',
  'BrowserRTCIceCandidate.candidate': 'string',
  'BrowserRTCIceCandidate.component': 'wrap',
  'BrowserRTCIceCandidate.foundation': 'string',
  'BrowserRTCIceCandidate.port': 'int',
  'BrowserRTCIceCandidate.priority': 'int',
  'BrowserRTCIceCandidate.protocol': 'wrap',
  'BrowserRTCIceCandidate.relatedAddress': 'string',
  'BrowserRTCIceCandidate.relatedPort': 'int',
  'BrowserRTCIceCandidate.sdpMLineIndex': 'int',
  'BrowserRTCIceCandidate.sdpMid': 'string',
  'BrowserRTCIceCandidate.tcpType': 'wrap',
  'BrowserRTCIceCandidate.toJSON': 'wrap',
  'BrowserRTCIceCandidate.type': 'wrap',
  'BrowserRTCIceCandidate.usernameFragment': 'string',
  'BrowserRTCIceTransport.gatheringState': 'wrap',
  'BrowserRTCIceTransport.getLocalCandidates': 'wrap',
  'BrowserRTCIceTransport.getLocalParameters': 'wrap',
  'BrowserRTCIceTransport.getRemoteCandidates': 'wrap',
  'BrowserRTCIceTransport.getRemoteParameters': 'wrap',
  'BrowserRTCIceTransport.getSelectedCandidatePair': 'wrap',
  'BrowserRTCIceTransport.onerror': 'jsfunction',
  'BrowserRTCIceTransport.ongatheringstatechange': 'jsfunction',
  'BrowserRTCIceTransport.onicecandidate': 'jsfunction',
  'BrowserRTCIceTransport.onselectedcandidatepairchange': 'jsfunction',
  'BrowserRTCIceTransport.onstatechange': 'jsfunction',
  'BrowserRTCIceTransport.role': 'wrap',
  'BrowserRTCIceTransport.state': 'wrap',
  'BrowserRTCPeerConnection.addIceCandidate': 'wrap',
  'BrowserRTCPeerConnection.addTrack': 'wrap',
  'BrowserRTCPeerConnection.addTransceiver': 'wrap',
  'BrowserRTCPeerConnection.canTrickleIceCandidates': 'bool',
  'BrowserRTCPeerConnection.close': 'void',
  'BrowserRTCPeerConnection.connectionState': 'wrap',
  'BrowserRTCPeerConnection.createAnswer': 'wrap',
  'BrowserRTCPeerConnection.createDataChannel': 'wrap',
  'BrowserRTCPeerConnection.createOffer': 'wrap',
  'BrowserRTCPeerConnection.currentLocalDescription': 'wrap',
  'BrowserRTCPeerConnection.currentRemoteDescription': 'wrap',
  'BrowserRTCPeerConnection.getConfiguration': 'wrap',
  'BrowserRTCPeerConnection.getIdentityAssertion': 'wrap',
  'BrowserRTCPeerConnection.getReceivers': 'wrap',
  'BrowserRTCPeerConnection.getSenders': 'wrap',
  'BrowserRTCPeerConnection.getStats': 'wrap',
  'BrowserRTCPeerConnection.getTransceivers': 'wrap',
  'BrowserRTCPeerConnection.iceConnectionState': 'wrap',
  'BrowserRTCPeerConnection.iceGatheringState': 'wrap',
  'BrowserRTCPeerConnection.idpLoginUrl': 'string',
  'BrowserRTCPeerConnection.localDescription': 'wrap',
  'BrowserRTCPeerConnection.onconnectionstatechange': 'jsfunction',
  'BrowserRTCPeerConnection.ondatachannel': 'jsfunction',
  'BrowserRTCPeerConnection.onicecandidate': 'jsfunction',
  'BrowserRTCPeerConnection.onicecandidateerror': 'jsfunction',
  'BrowserRTCPeerConnection.oniceconnectionstatechange': 'jsfunction',
  'BrowserRTCPeerConnection.onicegatheringstatechange': 'jsfunction',
  'BrowserRTCPeerConnection.onnegotiationneeded': 'jsfunction',
  'BrowserRTCPeerConnection.onsignalingstatechange': 'jsfunction',
  'BrowserRTCPeerConnection.ontrack': 'jsfunction',
  'BrowserRTCPeerConnection.peerIdentity': 'wrap',
  'BrowserRTCPeerConnection.pendingLocalDescription': 'wrap',
  'BrowserRTCPeerConnection.pendingRemoteDescription': 'wrap',
  'BrowserRTCPeerConnection.remoteDescription': 'wrap',
  'BrowserRTCPeerConnection.removeTrack': 'void',
  'BrowserRTCPeerConnection.restartIce': 'void',
  'BrowserRTCPeerConnection.sctp': 'wrap',
  'BrowserRTCPeerConnection.setConfiguration': 'void',
  'BrowserRTCPeerConnection.setIdentityProvider': 'void',
  'BrowserRTCPeerConnection.setLocalDescription': 'wrap',
  'BrowserRTCPeerConnection.setRemoteDescription': 'wrap',
  'BrowserRTCPeerConnection.signalingState': 'wrap',
  'BrowserRTCPeerConnectionIceErrorEvent.address': 'string',
  'BrowserRTCPeerConnectionIceErrorEvent.errorCode': 'int',
  'BrowserRTCPeerConnectionIceErrorEvent.errorText': 'string',
  'BrowserRTCPeerConnectionIceErrorEvent.port': 'int',
  'BrowserRTCPeerConnectionIceErrorEvent.url': 'string',
  'BrowserRTCPeerConnectionIceEvent.candidate': 'wrap',
  'BrowserRTCPeerConnectionIceEvent.url': 'string',
  'BrowserRTCRtpReceiver.getContributingSources': 'wrap',
  'BrowserRTCRtpReceiver.getParameters': 'wrap',
  'BrowserRTCRtpReceiver.getStats': 'wrap',
  'BrowserRTCRtpReceiver.getSynchronizationSources': 'wrap',
  'BrowserRTCRtpReceiver.jitterBufferTarget': 'wrap',
  'BrowserRTCRtpReceiver.track': 'wrap',
  'BrowserRTCRtpReceiver.transform': 'wrap',
  'BrowserRTCRtpReceiver.transport': 'wrap',
  'BrowserRTCRtpSender.dtmf': 'wrap',
  'BrowserRTCRtpSender.getParameters': 'wrap',
  'BrowserRTCRtpSender.getStats': 'wrap',
  'BrowserRTCRtpSender.replaceTrack': 'wrap',
  'BrowserRTCRtpSender.setParameters': 'wrap',
  'BrowserRTCRtpSender.setStreams': 'void',
  'BrowserRTCRtpSender.track': 'wrap',
  'BrowserRTCRtpSender.transform': 'wrap',
  'BrowserRTCRtpSender.transport': 'wrap',
  'BrowserRTCRtpTransceiver.currentDirection': 'wrap',
  'BrowserRTCRtpTransceiver.direction': 'wrap',
  'BrowserRTCRtpTransceiver.mid': 'string',
  'BrowserRTCRtpTransceiver.receiver': 'wrap',
  'BrowserRTCRtpTransceiver.sender': 'wrap',
  'BrowserRTCRtpTransceiver.setCodecPreferences': 'void',
  'BrowserRTCRtpTransceiver.stop': 'void',
  'BrowserRTCSctpTransport.maxChannels': 'int',
  'BrowserRTCSctpTransport.maxMessageSize': 'double',
  'BrowserRTCSctpTransport.onstatechange': 'jsfunction',
  'BrowserRTCSctpTransport.state': 'wrap',
  'BrowserRTCSctpTransport.transport': 'wrap',
  'BrowserRTCSessionDescription.sdp': 'string',
  'BrowserRTCSessionDescription.toJSON': 'wrap',
  'BrowserRTCSessionDescription.type': 'wrap',
  'BrowserRTCTrackEvent.receiver': 'wrap',
  'BrowserRTCTrackEvent.streams': 'wrap',
  'BrowserRTCTrackEvent.track': 'wrap',
  'BrowserRTCTrackEvent.transceiver': 'wrap',
  'BrowserRadioNodeList.value': 'string',
  'BrowserRange.cloneContents': 'wrap',
  'BrowserRange.cloneRange': 'wrap',
  'BrowserRange.collapse': 'void',
  'BrowserRange.commonAncestorContainer': 'wrap',
  'BrowserRange.compareBoundaryPoints': 'int',
  'BrowserRange.comparePoint': 'int',
  'BrowserRange.createContextualFragment': 'wrap',
  'BrowserRange.deleteContents': 'void',
  'BrowserRange.detach': 'void',
  'BrowserRange.extractContents': 'wrap',
  'BrowserRange.getBoundingClientRect': 'wrap',
  'BrowserRange.getClientRects': 'wrap',
  'BrowserRange.insertNode': 'void',
  'BrowserRange.intersectsNode': 'bool',
  'BrowserRange.isPointInRange': 'bool',
  'BrowserRange.selectNode': 'void',
  'BrowserRange.selectNodeContents': 'void',
  'BrowserRange.setEnd': 'void',
  'BrowserRange.setEndAfter': 'void',
  'BrowserRange.setEndBefore': 'void',
  'BrowserRange.setStart': 'void',
  'BrowserRange.setStartAfter': 'void',
  'BrowserRange.setStartBefore': 'void',
  'BrowserRange.surroundContents': 'void',
  'BrowserReactChangeEvent.bubbles': 'bool',
  'BrowserReactChangeEvent.cancelable': 'bool',
  'BrowserReactChangeEvent.currentTarget': 'wrap',
  'BrowserReactChangeEvent.defaultPrevented': 'bool',
  'BrowserReactChangeEvent.preventDefault': 'void',
  'BrowserReactChangeEvent.stopPropagation': 'void',
  'BrowserReactChangeEvent.target': 'wrap',
  'BrowserReactCompositionEvent.bubbles': 'bool',
  'BrowserReactCompositionEvent.cancelable': 'bool',
  'BrowserReactCompositionEvent.currentTarget': 'wrap',
  'BrowserReactCompositionEvent.defaultPrevented': 'bool',
  'BrowserReactCompositionEvent.preventDefault': 'void',
  'BrowserReactCompositionEvent.stopPropagation': 'void',
  'BrowserReactCompositionEvent.target': 'wrap',
  'BrowserReactDragEvent.bubbles': 'bool',
  'BrowserReactDragEvent.cancelable': 'bool',
  'BrowserReactDragEvent.currentTarget': 'wrap',
  'BrowserReactDragEvent.defaultPrevented': 'bool',
  'BrowserReactDragEvent.preventDefault': 'void',
  'BrowserReactDragEvent.stopPropagation': 'void',
  'BrowserReactDragEvent.target': 'wrap',
  'BrowserReactFocusEvent.bubbles': 'bool',
  'BrowserReactFocusEvent.cancelable': 'bool',
  'BrowserReactFocusEvent.currentTarget': 'wrap',
  'BrowserReactFocusEvent.defaultPrevented': 'bool',
  'BrowserReactFocusEvent.preventDefault': 'void',
  'BrowserReactFocusEvent.relatedTarget': 'wrap',
  'BrowserReactFocusEvent.stopPropagation': 'void',
  'BrowserReactFocusEvent.target': 'wrap',
  'BrowserReactFormEvent.bubbles': 'bool',
  'BrowserReactFormEvent.cancelable': 'bool',
  'BrowserReactFormEvent.currentTarget': 'wrap',
  'BrowserReactFormEvent.defaultPrevented': 'bool',
  'BrowserReactFormEvent.preventDefault': 'void',
  'BrowserReactFormEvent.stopPropagation': 'void',
  'BrowserReactFormEvent.target': 'wrap',
  'BrowserReactInputEvent.bubbles': 'bool',
  'BrowserReactInputEvent.cancelable': 'bool',
  'BrowserReactInputEvent.currentTarget': 'wrap',
  'BrowserReactInputEvent.data': 'string',
  'BrowserReactInputEvent.defaultPrevented': 'bool',
  'BrowserReactInputEvent.preventDefault': 'void',
  'BrowserReactInputEvent.stopPropagation': 'void',
  'BrowserReactInputEvent.target': 'wrap',
  'BrowserReactKeyboardEvent.altKey': 'bool',
  'BrowserReactKeyboardEvent.bubbles': 'bool',
  'BrowserReactKeyboardEvent.cancelable': 'bool',
  'BrowserReactKeyboardEvent.ctrlKey': 'bool',
  'BrowserReactKeyboardEvent.currentTarget': 'wrap',
  'BrowserReactKeyboardEvent.defaultPrevented': 'bool',
  'BrowserReactKeyboardEvent.key': 'string',
  'BrowserReactKeyboardEvent.keyCode': 'int',
  'BrowserReactKeyboardEvent.preventDefault': 'void',
  'BrowserReactKeyboardEvent.shiftKey': 'bool',
  'BrowserReactKeyboardEvent.stopPropagation': 'void',
  'BrowserReactKeyboardEvent.target': 'wrap',
  'BrowserReactMouseEvent.altKey': 'bool',
  'BrowserReactMouseEvent.bubbles': 'bool',
  'BrowserReactMouseEvent.button': 'int',
  'BrowserReactMouseEvent.cancelable': 'bool',
  'BrowserReactMouseEvent.clientX': 'double',
  'BrowserReactMouseEvent.clientY': 'double',
  'BrowserReactMouseEvent.ctrlKey': 'bool',
  'BrowserReactMouseEvent.currentTarget': 'wrap',
  'BrowserReactMouseEvent.defaultPrevented': 'bool',
  'BrowserReactMouseEvent.preventDefault': 'void',
  'BrowserReactMouseEvent.shiftKey': 'bool',
  'BrowserReactMouseEvent.stopPropagation': 'void',
  'BrowserReactMouseEvent.target': 'wrap',
  'BrowserReactPointerEvent.bubbles': 'bool',
  'BrowserReactPointerEvent.cancelable': 'bool',
  'BrowserReactPointerEvent.currentTarget': 'wrap',
  'BrowserReactPointerEvent.defaultPrevented': 'bool',
  'BrowserReactPointerEvent.preventDefault': 'void',
  'BrowserReactPointerEvent.stopPropagation': 'void',
  'BrowserReactPointerEvent.target': 'wrap',
  'BrowserReactSyntheticEvent.bubbles': 'bool',
  'BrowserReactSyntheticEvent.cancelable': 'bool',
  'BrowserReactSyntheticEvent.currentTarget': 'wrap',
  'BrowserReactSyntheticEvent.defaultPrevented': 'bool',
  'BrowserReactSyntheticEvent.preventDefault': 'void',
  'BrowserReactSyntheticEvent.stopPropagation': 'void',
  'BrowserReactSyntheticEvent.target': 'wrap',
  'BrowserReactTouchEvent.bubbles': 'bool',
  'BrowserReactTouchEvent.cancelable': 'bool',
  'BrowserReactTouchEvent.currentTarget': 'wrap',
  'BrowserReactTouchEvent.defaultPrevented': 'bool',
  'BrowserReactTouchEvent.preventDefault': 'void',
  'BrowserReactTouchEvent.stopPropagation': 'void',
  'BrowserReactTouchEvent.target': 'wrap',
  'BrowserReactWheelEvent.bubbles': 'bool',
  'BrowserReactWheelEvent.cancelable': 'bool',
  'BrowserReactWheelEvent.currentTarget': 'wrap',
  'BrowserReactWheelEvent.defaultPrevented': 'bool',
  'BrowserReactWheelEvent.preventDefault': 'void',
  'BrowserReactWheelEvent.stopPropagation': 'void',
  'BrowserReactWheelEvent.target': 'wrap',
  'BrowserReadableStream.cancel': 'wrap',
  'BrowserReadableStream.getReader': 'wrap',
  'BrowserReadableStream.locked': 'bool',
  'BrowserReadableStream.pipeThrough': 'wrap',
  'BrowserReadableStream.pipeTo': 'wrap',
  'BrowserReadableStream.tee': 'wrap',
  'BrowserReadableStreamBYOBReader.cancel': 'wrap',
  'BrowserReadableStreamBYOBReader.closed': 'wrap',
  'BrowserReadableStreamBYOBReader.read': 'wrap',
  'BrowserReadableStreamBYOBReader.releaseLock': 'void',
  'BrowserReadableStreamDefaultReader.cancel': 'wrap',
  'BrowserReadableStreamDefaultReader.closed': 'wrap',
  'BrowserReadableStreamDefaultReader.read': 'wrap',
  'BrowserReadableStreamDefaultReader.releaseLock': 'void',
  'BrowserRemotePlayback.cancelWatchAvailability': 'wrap',
  'BrowserRemotePlayback.onconnect': 'jsfunction',
  'BrowserRemotePlayback.onconnecting': 'jsfunction',
  'BrowserRemotePlayback.ondisconnect': 'jsfunction',
  'BrowserRemotePlayback.prompt': 'wrap',
  'BrowserRemotePlayback.state': 'wrap',
  'BrowserRemotePlayback.watchAvailability': 'wrap',
  'BrowserReportingObserver.disconnect': 'void',
  'BrowserReportingObserver.observe': 'void',
  'BrowserReportingObserver.takeRecords': 'wrap',
  'BrowserRequest.arrayBuffer': 'wrap',
  'BrowserRequest.blob': 'wrap',
  'BrowserRequest.body': 'wrap',
  'BrowserRequest.bodyUsed': 'bool',
  'BrowserRequest.bytes': 'wrap',
  'BrowserRequest.cache': 'wrap',
  'BrowserRequest.clone': 'wrap',
  'BrowserRequest.credentials': 'wrap',
  'BrowserRequest.destination': 'wrap',
  'BrowserRequest.formData': 'wrap',
  'BrowserRequest.headers': 'wrap',
  'BrowserRequest.integrity': 'string',
  'BrowserRequest.isHistoryNavigation': 'bool',
  'BrowserRequest.json': 'wrap',
  'BrowserRequest.keepalive': 'bool',
  'BrowserRequest.method': 'string',
  'BrowserRequest.mode': 'wrap',
  'BrowserRequest.redirect': 'wrap',
  'BrowserRequest.referrer': 'string',
  'BrowserRequest.referrerPolicy': 'wrap',
  'BrowserRequest.signal': 'wrap',
  'BrowserRequest.text': 'wrap',
  'BrowserRequest.url': 'string',
  'BrowserResizeObserver.disconnect': 'void',
  'BrowserResizeObserver.observe': 'void',
  'BrowserResizeObserver.unobserve': 'void',
  'BrowserResponse.arrayBuffer': 'wrap',
  'BrowserResponse.blob': 'wrap',
  'BrowserResponse.body': 'wrap',
  'BrowserResponse.bodyUsed': 'bool',
  'BrowserResponse.bytes': 'wrap',
  'BrowserResponse.clone': 'wrap',
  'BrowserResponse.formData': 'wrap',
  'BrowserResponse.headers': 'wrap',
  'BrowserResponse.json': 'wrap',
  'BrowserResponse.ok': 'bool',
  'BrowserResponse.redirected': 'bool',
  'BrowserResponse.status': 'int',
  'BrowserResponse.statusText': 'string',
  'BrowserResponse.text': 'wrap',
  'BrowserResponse.type': 'wrap',
  'BrowserResponse.url': 'string',
  'BrowserSVGAElement.download': 'string',
  'BrowserSVGAElement.href': 'wrap',
  'BrowserSVGAElement.hreflang': 'string',
  'BrowserSVGAElement.ping': 'string',
  'BrowserSVGAElement.referrerPolicy': 'string',
  'BrowserSVGAElement.rel': 'string',
  'BrowserSVGAElement.relList': 'wrap',
  'BrowserSVGAElement.target': 'wrap',
  'BrowserSVGAElement.text': 'string',
  'BrowserSVGAElement.type': 'string',
  'BrowserSVGAngle.convertToSpecifiedUnits': 'void',
  'BrowserSVGAngle.newValueSpecifiedUnits': 'void',
  'BrowserSVGAngle.unitType': 'int',
  'BrowserSVGAngle.value': 'double',
  'BrowserSVGAngle.valueAsString': 'string',
  'BrowserSVGAngle.valueInSpecifiedUnits': 'double',
  'BrowserSVGAnimatedAngle.animVal': 'wrap',
  'BrowserSVGAnimatedAngle.baseVal': 'wrap',
  'BrowserSVGAnimatedBoolean.animVal': 'bool',
  'BrowserSVGAnimatedBoolean.baseVal': 'bool',
  'BrowserSVGAnimatedEnumeration.animVal': 'int',
  'BrowserSVGAnimatedEnumeration.baseVal': 'int',
  'BrowserSVGAnimatedInteger.animVal': 'int',
  'BrowserSVGAnimatedInteger.baseVal': 'int',
  'BrowserSVGAnimatedLength.animVal': 'wrap',
  'BrowserSVGAnimatedLength.baseVal': 'wrap',
  'BrowserSVGAnimatedLengthList.animVal': 'wrap',
  'BrowserSVGAnimatedLengthList.baseVal': 'wrap',
  'BrowserSVGAnimatedNumber.animVal': 'double',
  'BrowserSVGAnimatedNumber.baseVal': 'double',
  'BrowserSVGAnimatedNumberList.animVal': 'wrap',
  'BrowserSVGAnimatedNumberList.baseVal': 'wrap',
  'BrowserSVGAnimatedPreserveAspectRatio.animVal': 'wrap',
  'BrowserSVGAnimatedPreserveAspectRatio.baseVal': 'wrap',
  'BrowserSVGAnimatedRect.animVal': 'wrap',
  'BrowserSVGAnimatedRect.baseVal': 'wrap',
  'BrowserSVGAnimatedString.animVal': 'string',
  'BrowserSVGAnimatedString.baseVal': 'string',
  'BrowserSVGAnimatedTransformList.animVal': 'wrap',
  'BrowserSVGAnimatedTransformList.baseVal': 'wrap',
  'BrowserSVGAnimationElement.beginElement': 'void',
  'BrowserSVGAnimationElement.beginElementAt': 'void',
  'BrowserSVGAnimationElement.endElement': 'void',
  'BrowserSVGAnimationElement.endElementAt': 'void',
  'BrowserSVGAnimationElement.getCurrentTime': 'double',
  'BrowserSVGAnimationElement.getSimpleDuration': 'double',
  'BrowserSVGAnimationElement.getStartTime': 'double',
  'BrowserSVGAnimationElement.onend': 'jsfunction',
  'BrowserSVGAnimationElement.requiredExtensions': 'wrap',
  'BrowserSVGAnimationElement.systemLanguage': 'wrap',
  'BrowserSVGAnimationElement.targetElement': 'wrap',
  'BrowserSVGCircleElement.cx': 'wrap',
  'BrowserSVGCircleElement.cy': 'wrap',
  'BrowserSVGCircleElement.r': 'wrap',
  'BrowserSVGClipPathElement.clipPathUnits': 'wrap',
  'BrowserSVGClipPathElement.transform': 'wrap',
  'BrowserSVGComponentTransferFunctionElement.amplitude': 'wrap',
  'BrowserSVGComponentTransferFunctionElement.exponent': 'wrap',
  'BrowserSVGComponentTransferFunctionElement.intercept': 'wrap',
  'BrowserSVGComponentTransferFunctionElement.offset': 'wrap',
  'BrowserSVGComponentTransferFunctionElement.slope': 'wrap',
  'BrowserSVGComponentTransferFunctionElement.tableValues': 'wrap',
  'BrowserSVGComponentTransferFunctionElement.type': 'wrap',
  'BrowserSVGElement.attributeStyleMap': 'wrap',
  'BrowserSVGElement.autofocus': 'bool',
  'BrowserSVGElement.blur': 'void',
  'BrowserSVGElement.className': 'wrap',
  'BrowserSVGElement.correspondingElement': 'wrap',
  'BrowserSVGElement.correspondingUseElement': 'wrap',
  'BrowserSVGElement.dataset': 'wrap',
  'BrowserSVGElement.focus': 'void',
  'BrowserSVGElement.nonce': 'string',
  'BrowserSVGElement.onabort': 'jsfunction',
  'BrowserSVGElement.onanimationcancel': 'jsfunction',
  'BrowserSVGElement.onanimationend': 'jsfunction',
  'BrowserSVGElement.onanimationiteration': 'jsfunction',
  'BrowserSVGElement.onanimationstart': 'jsfunction',
  'BrowserSVGElement.onauxclick': 'jsfunction',
  'BrowserSVGElement.onbeforeinput': 'jsfunction',
  'BrowserSVGElement.onbeforematch': 'jsfunction',
  'BrowserSVGElement.onbeforetoggle': 'jsfunction',
  'BrowserSVGElement.onbeforexrselect': 'jsfunction',
  'BrowserSVGElement.onblur': 'jsfunction',
  'BrowserSVGElement.oncancel': 'jsfunction',
  'BrowserSVGElement.oncanplay': 'jsfunction',
  'BrowserSVGElement.oncanplaythrough': 'jsfunction',
  'BrowserSVGElement.onchange': 'jsfunction',
  'BrowserSVGElement.onclick': 'jsfunction',
  'BrowserSVGElement.onclose': 'jsfunction',
  'BrowserSVGElement.oncontextlost': 'jsfunction',
  'BrowserSVGElement.oncontextmenu': 'jsfunction',
  'BrowserSVGElement.oncontextrestored': 'jsfunction',
  'BrowserSVGElement.oncopy': 'jsfunction',
  'BrowserSVGElement.oncuechange': 'jsfunction',
  'BrowserSVGElement.oncut': 'jsfunction',
  'BrowserSVGElement.ondblclick': 'jsfunction',
  'BrowserSVGElement.ondrag': 'jsfunction',
  'BrowserSVGElement.ondragend': 'jsfunction',
  'BrowserSVGElement.ondragenter': 'jsfunction',
  'BrowserSVGElement.ondragleave': 'jsfunction',
  'BrowserSVGElement.ondragover': 'jsfunction',
  'BrowserSVGElement.ondragstart': 'jsfunction',
  'BrowserSVGElement.ondrop': 'jsfunction',
  'BrowserSVGElement.ondurationchange': 'jsfunction',
  'BrowserSVGElement.onemptied': 'jsfunction',
  'BrowserSVGElement.onended': 'jsfunction',
  'BrowserSVGElement.onerror': 'jsfunction',
  'BrowserSVGElement.onfocus': 'jsfunction',
  'BrowserSVGElement.onformdata': 'jsfunction',
  'BrowserSVGElement.ongotpointercapture': 'jsfunction',
  'BrowserSVGElement.oninput': 'jsfunction',
  'BrowserSVGElement.oninvalid': 'jsfunction',
  'BrowserSVGElement.onkeydown': 'jsfunction',
  'BrowserSVGElement.onkeypress': 'jsfunction',
  'BrowserSVGElement.onkeyup': 'jsfunction',
  'BrowserSVGElement.onload': 'jsfunction',
  'BrowserSVGElement.onloadeddata': 'jsfunction',
  'BrowserSVGElement.onloadedmetadata': 'jsfunction',
  'BrowserSVGElement.onloadstart': 'jsfunction',
  'BrowserSVGElement.onlostpointercapture': 'jsfunction',
  'BrowserSVGElement.onmousedown': 'jsfunction',
  'BrowserSVGElement.onmouseenter': 'jsfunction',
  'BrowserSVGElement.onmouseleave': 'jsfunction',
  'BrowserSVGElement.onmousemove': 'jsfunction',
  'BrowserSVGElement.onmouseout': 'jsfunction',
  'BrowserSVGElement.onmouseover': 'jsfunction',
  'BrowserSVGElement.onmouseup': 'jsfunction',
  'BrowserSVGElement.onpaste': 'jsfunction',
  'BrowserSVGElement.onpause': 'jsfunction',
  'BrowserSVGElement.onplay': 'jsfunction',
  'BrowserSVGElement.onplaying': 'jsfunction',
  'BrowserSVGElement.onpointercancel': 'jsfunction',
  'BrowserSVGElement.onpointerdown': 'jsfunction',
  'BrowserSVGElement.onpointerenter': 'jsfunction',
  'BrowserSVGElement.onpointerleave': 'jsfunction',
  'BrowserSVGElement.onpointermove': 'jsfunction',
  'BrowserSVGElement.onpointerout': 'jsfunction',
  'BrowserSVGElement.onpointerover': 'jsfunction',
  'BrowserSVGElement.onpointerrawupdate': 'jsfunction',
  'BrowserSVGElement.onpointerup': 'jsfunction',
  'BrowserSVGElement.onprogress': 'jsfunction',
  'BrowserSVGElement.onratechange': 'jsfunction',
  'BrowserSVGElement.onreset': 'jsfunction',
  'BrowserSVGElement.onresize': 'jsfunction',
  'BrowserSVGElement.onscroll': 'jsfunction',
  'BrowserSVGElement.onscrollend': 'jsfunction',
  'BrowserSVGElement.onsecuritypolicyviolation': 'jsfunction',
  'BrowserSVGElement.onseeked': 'jsfunction',
  'BrowserSVGElement.onseeking': 'jsfunction',
  'BrowserSVGElement.onselect': 'jsfunction',
  'BrowserSVGElement.onselectionchange': 'jsfunction',
  'BrowserSVGElement.onselectstart': 'jsfunction',
  'BrowserSVGElement.onslotchange': 'jsfunction',
  'BrowserSVGElement.onsnapchanged': 'jsfunction',
  'BrowserSVGElement.onsnapchanging': 'jsfunction',
  'BrowserSVGElement.onstalled': 'jsfunction',
  'BrowserSVGElement.onsubmit': 'jsfunction',
  'BrowserSVGElement.onsuspend': 'jsfunction',
  'BrowserSVGElement.ontimeupdate': 'jsfunction',
  'BrowserSVGElement.ontoggle': 'jsfunction',
  'BrowserSVGElement.ontouchcancel': 'jsfunction',
  'BrowserSVGElement.ontouchend': 'jsfunction',
  'BrowserSVGElement.ontouchmove': 'jsfunction',
  'BrowserSVGElement.ontouchstart': 'jsfunction',
  'BrowserSVGElement.ontransitioncancel': 'jsfunction',
  'BrowserSVGElement.ontransitionend': 'jsfunction',
  'BrowserSVGElement.ontransitionrun': 'jsfunction',
  'BrowserSVGElement.ontransitionstart': 'jsfunction',
  'BrowserSVGElement.onvolumechange': 'jsfunction',
  'BrowserSVGElement.onwaiting': 'jsfunction',
  'BrowserSVGElement.onwebkitanimationend': 'jsfunction',
  'BrowserSVGElement.onwebkitanimationiteration': 'jsfunction',
  'BrowserSVGElement.onwebkitanimationstart': 'jsfunction',
  'BrowserSVGElement.onwebkittransitionend': 'jsfunction',
  'BrowserSVGElement.onwheel': 'jsfunction',
  'BrowserSVGElement.ownerSVGElement': 'wrap',
  'BrowserSVGElement.style': 'wrap',
  'BrowserSVGElement.tabIndex': 'int',
  'BrowserSVGElement.viewportElement': 'wrap',
  'BrowserSVGEllipseElement.cx': 'wrap',
  'BrowserSVGEllipseElement.cy': 'wrap',
  'BrowserSVGEllipseElement.rx': 'wrap',
  'BrowserSVGEllipseElement.ry': 'wrap',
  'BrowserSVGFEBlendElement.height': 'wrap',
  'BrowserSVGFEBlendElement.in1': 'wrap',
  'BrowserSVGFEBlendElement.in2': 'wrap',
  'BrowserSVGFEBlendElement.mode': 'wrap',
  'BrowserSVGFEBlendElement.result': 'wrap',
  'BrowserSVGFEBlendElement.width': 'wrap',
  'BrowserSVGFEBlendElement.x': 'wrap',
  'BrowserSVGFEBlendElement.y': 'wrap',
  'BrowserSVGFEColorMatrixElement.height': 'wrap',
  'BrowserSVGFEColorMatrixElement.in1': 'wrap',
  'BrowserSVGFEColorMatrixElement.result': 'wrap',
  'BrowserSVGFEColorMatrixElement.type': 'wrap',
  'BrowserSVGFEColorMatrixElement.values': 'wrap',
  'BrowserSVGFEColorMatrixElement.width': 'wrap',
  'BrowserSVGFEColorMatrixElement.x': 'wrap',
  'BrowserSVGFEColorMatrixElement.y': 'wrap',
  'BrowserSVGFEComponentTransferElement.height': 'wrap',
  'BrowserSVGFEComponentTransferElement.in1': 'wrap',
  'BrowserSVGFEComponentTransferElement.result': 'wrap',
  'BrowserSVGFEComponentTransferElement.width': 'wrap',
  'BrowserSVGFEComponentTransferElement.x': 'wrap',
  'BrowserSVGFEComponentTransferElement.y': 'wrap',
  'BrowserSVGFECompositeElement.height': 'wrap',
  'BrowserSVGFECompositeElement.in1': 'wrap',
  'BrowserSVGFECompositeElement.in2': 'wrap',
  'BrowserSVGFECompositeElement.k1': 'wrap',
  'BrowserSVGFECompositeElement.k2': 'wrap',
  'BrowserSVGFECompositeElement.k3': 'wrap',
  'BrowserSVGFECompositeElement.k4': 'wrap',
  'BrowserSVGFECompositeElement.operator_': 'wrap',
  'BrowserSVGFECompositeElement.result': 'wrap',
  'BrowserSVGFECompositeElement.width': 'wrap',
  'BrowserSVGFECompositeElement.x': 'wrap',
  'BrowserSVGFECompositeElement.y': 'wrap',
  'BrowserSVGFEConvolveMatrixElement.bias': 'wrap',
  'BrowserSVGFEConvolveMatrixElement.divisor': 'wrap',
  'BrowserSVGFEConvolveMatrixElement.edgeMode': 'wrap',
  'BrowserSVGFEConvolveMatrixElement.height': 'wrap',
  'BrowserSVGFEConvolveMatrixElement.in1': 'wrap',
  'BrowserSVGFEConvolveMatrixElement.kernelMatrix': 'wrap',
  'BrowserSVGFEConvolveMatrixElement.kernelUnitLengthX': 'wrap',
  'BrowserSVGFEConvolveMatrixElement.kernelUnitLengthY': 'wrap',
  'BrowserSVGFEConvolveMatrixElement.orderX': 'wrap',
  'BrowserSVGFEConvolveMatrixElement.orderY': 'wrap',
  'BrowserSVGFEConvolveMatrixElement.preserveAlpha': 'wrap',
  'BrowserSVGFEConvolveMatrixElement.result': 'wrap',
  'BrowserSVGFEConvolveMatrixElement.targetX': 'wrap',
  'BrowserSVGFEConvolveMatrixElement.targetY': 'wrap',
  'BrowserSVGFEConvolveMatrixElement.width': 'wrap',
  'BrowserSVGFEConvolveMatrixElement.x': 'wrap',
  'BrowserSVGFEConvolveMatrixElement.y': 'wrap',
  'BrowserSVGFEDiffuseLightingElement.diffuseConstant': 'wrap',
  'BrowserSVGFEDiffuseLightingElement.height': 'wrap',
  'BrowserSVGFEDiffuseLightingElement.in1': 'wrap',
  'BrowserSVGFEDiffuseLightingElement.kernelUnitLengthX': 'wrap',
  'BrowserSVGFEDiffuseLightingElement.kernelUnitLengthY': 'wrap',
  'BrowserSVGFEDiffuseLightingElement.result': 'wrap',
  'BrowserSVGFEDiffuseLightingElement.surfaceScale': 'wrap',
  'BrowserSVGFEDiffuseLightingElement.width': 'wrap',
  'BrowserSVGFEDiffuseLightingElement.x': 'wrap',
  'BrowserSVGFEDiffuseLightingElement.y': 'wrap',
  'BrowserSVGFEDisplacementMapElement.height': 'wrap',
  'BrowserSVGFEDisplacementMapElement.in1': 'wrap',
  'BrowserSVGFEDisplacementMapElement.in2': 'wrap',
  'BrowserSVGFEDisplacementMapElement.result': 'wrap',
  'BrowserSVGFEDisplacementMapElement.scale': 'wrap',
  'BrowserSVGFEDisplacementMapElement.width': 'wrap',
  'BrowserSVGFEDisplacementMapElement.x': 'wrap',
  'BrowserSVGFEDisplacementMapElement.xChannelSelector': 'wrap',
  'BrowserSVGFEDisplacementMapElement.y': 'wrap',
  'BrowserSVGFEDisplacementMapElement.yChannelSelector': 'wrap',
  'BrowserSVGFEDistantLightElement.azimuth': 'wrap',
  'BrowserSVGFEDistantLightElement.elevation': 'wrap',
  'BrowserSVGFEDropShadowElement.dx': 'wrap',
  'BrowserSVGFEDropShadowElement.dy': 'wrap',
  'BrowserSVGFEDropShadowElement.height': 'wrap',
  'BrowserSVGFEDropShadowElement.in1': 'wrap',
  'BrowserSVGFEDropShadowElement.result': 'wrap',
  'BrowserSVGFEDropShadowElement.setStdDeviation': 'void',
  'BrowserSVGFEDropShadowElement.stdDeviationX': 'wrap',
  'BrowserSVGFEDropShadowElement.stdDeviationY': 'wrap',
  'BrowserSVGFEDropShadowElement.width': 'wrap',
  'BrowserSVGFEDropShadowElement.x': 'wrap',
  'BrowserSVGFEDropShadowElement.y': 'wrap',
  'BrowserSVGFEFloodElement.height': 'wrap',
  'BrowserSVGFEFloodElement.result': 'wrap',
  'BrowserSVGFEFloodElement.width': 'wrap',
  'BrowserSVGFEFloodElement.x': 'wrap',
  'BrowserSVGFEFloodElement.y': 'wrap',
  'BrowserSVGFEGaussianBlurElement.edgeMode': 'wrap',
  'BrowserSVGFEGaussianBlurElement.height': 'wrap',
  'BrowserSVGFEGaussianBlurElement.in1': 'wrap',
  'BrowserSVGFEGaussianBlurElement.result': 'wrap',
  'BrowserSVGFEGaussianBlurElement.setStdDeviation': 'void',
  'BrowserSVGFEGaussianBlurElement.stdDeviationX': 'wrap',
  'BrowserSVGFEGaussianBlurElement.stdDeviationY': 'wrap',
  'BrowserSVGFEGaussianBlurElement.width': 'wrap',
  'BrowserSVGFEGaussianBlurElement.x': 'wrap',
  'BrowserSVGFEGaussianBlurElement.y': 'wrap',
  'BrowserSVGFEImageElement.crossOrigin': 'wrap',
  'BrowserSVGFEImageElement.height': 'wrap',
  'BrowserSVGFEImageElement.href': 'wrap',
  'BrowserSVGFEImageElement.preserveAspectRatio': 'wrap',
  'BrowserSVGFEImageElement.result': 'wrap',
  'BrowserSVGFEImageElement.width': 'wrap',
  'BrowserSVGFEImageElement.x': 'wrap',
  'BrowserSVGFEImageElement.y': 'wrap',
  'BrowserSVGFEMergeElement.height': 'wrap',
  'BrowserSVGFEMergeElement.result': 'wrap',
  'BrowserSVGFEMergeElement.width': 'wrap',
  'BrowserSVGFEMergeElement.x': 'wrap',
  'BrowserSVGFEMergeElement.y': 'wrap',
  'BrowserSVGFEMergeNodeElement.in1': 'wrap',
  'BrowserSVGFEMorphologyElement.height': 'wrap',
  'BrowserSVGFEMorphologyElement.in1': 'wrap',
  'BrowserSVGFEMorphologyElement.operator_': 'wrap',
  'BrowserSVGFEMorphologyElement.radiusX': 'wrap',
  'BrowserSVGFEMorphologyElement.radiusY': 'wrap',
  'BrowserSVGFEMorphologyElement.result': 'wrap',
  'BrowserSVGFEMorphologyElement.width': 'wrap',
  'BrowserSVGFEMorphologyElement.x': 'wrap',
  'BrowserSVGFEMorphologyElement.y': 'wrap',
  'BrowserSVGFEOffsetElement.dx': 'wrap',
  'BrowserSVGFEOffsetElement.dy': 'wrap',
  'BrowserSVGFEOffsetElement.height': 'wrap',
  'BrowserSVGFEOffsetElement.in1': 'wrap',
  'BrowserSVGFEOffsetElement.result': 'wrap',
  'BrowserSVGFEOffsetElement.width': 'wrap',
  'BrowserSVGFEOffsetElement.x': 'wrap',
  'BrowserSVGFEOffsetElement.y': 'wrap',
  'BrowserSVGFEPointLightElement.x': 'wrap',
  'BrowserSVGFEPointLightElement.y': 'wrap',
  'BrowserSVGFEPointLightElement.z': 'wrap',
  'BrowserSVGFESpecularLightingElement.height': 'wrap',
  'BrowserSVGFESpecularLightingElement.in1': 'wrap',
  'BrowserSVGFESpecularLightingElement.kernelUnitLengthX': 'wrap',
  'BrowserSVGFESpecularLightingElement.kernelUnitLengthY': 'wrap',
  'BrowserSVGFESpecularLightingElement.result': 'wrap',
  'BrowserSVGFESpecularLightingElement.specularConstant': 'wrap',
  'BrowserSVGFESpecularLightingElement.specularExponent': 'wrap',
  'BrowserSVGFESpecularLightingElement.surfaceScale': 'wrap',
  'BrowserSVGFESpecularLightingElement.width': 'wrap',
  'BrowserSVGFESpecularLightingElement.x': 'wrap',
  'BrowserSVGFESpecularLightingElement.y': 'wrap',
  'BrowserSVGFESpotLightElement.limitingConeAngle': 'wrap',
  'BrowserSVGFESpotLightElement.pointsAtX': 'wrap',
  'BrowserSVGFESpotLightElement.pointsAtY': 'wrap',
  'BrowserSVGFESpotLightElement.pointsAtZ': 'wrap',
  'BrowserSVGFESpotLightElement.specularExponent': 'wrap',
  'BrowserSVGFESpotLightElement.x': 'wrap',
  'BrowserSVGFESpotLightElement.y': 'wrap',
  'BrowserSVGFESpotLightElement.z': 'wrap',
  'BrowserSVGFETileElement.height': 'wrap',
  'BrowserSVGFETileElement.in1': 'wrap',
  'BrowserSVGFETileElement.result': 'wrap',
  'BrowserSVGFETileElement.width': 'wrap',
  'BrowserSVGFETileElement.x': 'wrap',
  'BrowserSVGFETileElement.y': 'wrap',
  'BrowserSVGFETurbulenceElement.baseFrequencyX': 'wrap',
  'BrowserSVGFETurbulenceElement.baseFrequencyY': 'wrap',
  'BrowserSVGFETurbulenceElement.height': 'wrap',
  'BrowserSVGFETurbulenceElement.numOctaves': 'wrap',
  'BrowserSVGFETurbulenceElement.result': 'wrap',
  'BrowserSVGFETurbulenceElement.seed': 'wrap',
  'BrowserSVGFETurbulenceElement.stitchTiles': 'wrap',
  'BrowserSVGFETurbulenceElement.type': 'wrap',
  'BrowserSVGFETurbulenceElement.width': 'wrap',
  'BrowserSVGFETurbulenceElement.x': 'wrap',
  'BrowserSVGFETurbulenceElement.y': 'wrap',
  'BrowserSVGFilterElement.filterUnits': 'wrap',
  'BrowserSVGFilterElement.height': 'wrap',
  'BrowserSVGFilterElement.href': 'wrap',
  'BrowserSVGFilterElement.primitiveUnits': 'wrap',
  'BrowserSVGFilterElement.width': 'wrap',
  'BrowserSVGFilterElement.x': 'wrap',
  'BrowserSVGFilterElement.y': 'wrap',
  'BrowserSVGForeignObjectElement.height': 'wrap',
  'BrowserSVGForeignObjectElement.width': 'wrap',
  'BrowserSVGForeignObjectElement.x': 'wrap',
  'BrowserSVGForeignObjectElement.y': 'wrap',
  'BrowserSVGGeometryElement.getPointAtLength': 'wrap',
  'BrowserSVGGeometryElement.getTotalLength': 'double',
  'BrowserSVGGeometryElement.isPointInFill': 'bool',
  'BrowserSVGGeometryElement.isPointInStroke': 'bool',
  'BrowserSVGGeometryElement.pathLength': 'wrap',
  'BrowserSVGGradientElement.gradientTransform': 'wrap',
  'BrowserSVGGradientElement.gradientUnits': 'wrap',
  'BrowserSVGGradientElement.href': 'wrap',
  'BrowserSVGGradientElement.spreadMethod': 'wrap',
  'BrowserSVGGraphicsElement.getBBox': 'wrap',
  'BrowserSVGGraphicsElement.getCTM': 'wrap',
  'BrowserSVGGraphicsElement.getScreenCTM': 'wrap',
  'BrowserSVGGraphicsElement.requiredExtensions': 'wrap',
  'BrowserSVGGraphicsElement.systemLanguage': 'wrap',
  'BrowserSVGGraphicsElement.transform': 'wrap',
  'BrowserSVGImageElement.crossOrigin': 'string',
  'BrowserSVGImageElement.height': 'wrap',
  'BrowserSVGImageElement.href': 'wrap',
  'BrowserSVGImageElement.preserveAspectRatio': 'wrap',
  'BrowserSVGImageElement.width': 'wrap',
  'BrowserSVGImageElement.x': 'wrap',
  'BrowserSVGImageElement.y': 'wrap',
  'BrowserSVGLength.convertToSpecifiedUnits': 'void',
  'BrowserSVGLength.newValueSpecifiedUnits': 'void',
  'BrowserSVGLength.unitType': 'int',
  'BrowserSVGLength.value': 'double',
  'BrowserSVGLength.valueAsString': 'string',
  'BrowserSVGLength.valueInSpecifiedUnits': 'double',
  'BrowserSVGLengthList.appendItem': 'wrap',
  'BrowserSVGLengthList.clear': 'void',
  'BrowserSVGLengthList.getItem': 'wrap',
  'BrowserSVGLengthList.initialize': 'wrap',
  'BrowserSVGLengthList.insertItemBefore': 'wrap',
  'BrowserSVGLengthList.length': 'int',
  'BrowserSVGLengthList.numberOfItems': 'int',
  'BrowserSVGLengthList.removeItem': 'wrap',
  'BrowserSVGLengthList.replaceItem': 'wrap',
  'BrowserSVGLineElement.x1': 'wrap',
  'BrowserSVGLineElement.x2': 'wrap',
  'BrowserSVGLineElement.y1': 'wrap',
  'BrowserSVGLineElement.y2': 'wrap',
  'BrowserSVGLinearGradientElement.x1': 'wrap',
  'BrowserSVGLinearGradientElement.x2': 'wrap',
  'BrowserSVGLinearGradientElement.y1': 'wrap',
  'BrowserSVGLinearGradientElement.y2': 'wrap',
  'BrowserSVGMPathElement.href': 'wrap',
  'BrowserSVGMarkerElement.markerHeight': 'wrap',
  'BrowserSVGMarkerElement.markerUnits': 'wrap',
  'BrowserSVGMarkerElement.markerWidth': 'wrap',
  'BrowserSVGMarkerElement.orient': 'string',
  'BrowserSVGMarkerElement.orientAngle': 'wrap',
  'BrowserSVGMarkerElement.orientType': 'wrap',
  'BrowserSVGMarkerElement.preserveAspectRatio': 'wrap',
  'BrowserSVGMarkerElement.refX': 'wrap',
  'BrowserSVGMarkerElement.refY': 'wrap',
  'BrowserSVGMarkerElement.setOrientToAngle': 'void',
  'BrowserSVGMarkerElement.setOrientToAuto': 'void',
  'BrowserSVGMarkerElement.viewBox': 'wrap',
  'BrowserSVGMaskElement.height': 'wrap',
  'BrowserSVGMaskElement.maskContentUnits': 'wrap',
  'BrowserSVGMaskElement.maskUnits': 'wrap',
  'BrowserSVGMaskElement.width': 'wrap',
  'BrowserSVGMaskElement.x': 'wrap',
  'BrowserSVGMaskElement.y': 'wrap',
  'BrowserSVGNumber.value': 'double',
  'BrowserSVGNumberList.appendItem': 'wrap',
  'BrowserSVGNumberList.clear': 'void',
  'BrowserSVGNumberList.getItem': 'wrap',
  'BrowserSVGNumberList.initialize': 'wrap',
  'BrowserSVGNumberList.insertItemBefore': 'wrap',
  'BrowserSVGNumberList.length': 'int',
  'BrowserSVGNumberList.numberOfItems': 'int',
  'BrowserSVGNumberList.removeItem': 'wrap',
  'BrowserSVGNumberList.replaceItem': 'wrap',
  'BrowserSVGPatternElement.height': 'wrap',
  'BrowserSVGPatternElement.href': 'wrap',
  'BrowserSVGPatternElement.patternContentUnits': 'wrap',
  'BrowserSVGPatternElement.patternTransform': 'wrap',
  'BrowserSVGPatternElement.patternUnits': 'wrap',
  'BrowserSVGPatternElement.preserveAspectRatio': 'wrap',
  'BrowserSVGPatternElement.viewBox': 'wrap',
  'BrowserSVGPatternElement.width': 'wrap',
  'BrowserSVGPatternElement.x': 'wrap',
  'BrowserSVGPatternElement.y': 'wrap',
  'BrowserSVGPointList.appendItem': 'wrap',
  'BrowserSVGPointList.clear': 'void',
  'BrowserSVGPointList.getItem': 'wrap',
  'BrowserSVGPointList.initialize': 'wrap',
  'BrowserSVGPointList.insertItemBefore': 'wrap',
  'BrowserSVGPointList.length': 'int',
  'BrowserSVGPointList.numberOfItems': 'int',
  'BrowserSVGPointList.removeItem': 'wrap',
  'BrowserSVGPointList.replaceItem': 'wrap',
  'BrowserSVGPolygonElement.animatedPoints': 'wrap',
  'BrowserSVGPolygonElement.points': 'wrap',
  'BrowserSVGPolylineElement.animatedPoints': 'wrap',
  'BrowserSVGPolylineElement.points': 'wrap',
  'BrowserSVGPreserveAspectRatio.align': 'int',
  'BrowserSVGPreserveAspectRatio.meetOrSlice': 'int',
  'BrowserSVGRadialGradientElement.cx': 'wrap',
  'BrowserSVGRadialGradientElement.cy': 'wrap',
  'BrowserSVGRadialGradientElement.fr': 'wrap',
  'BrowserSVGRadialGradientElement.fx': 'wrap',
  'BrowserSVGRadialGradientElement.fy': 'wrap',
  'BrowserSVGRadialGradientElement.r': 'wrap',
  'BrowserSVGRectElement.height': 'wrap',
  'BrowserSVGRectElement.rx': 'wrap',
  'BrowserSVGRectElement.ry': 'wrap',
  'BrowserSVGRectElement.width': 'wrap',
  'BrowserSVGRectElement.x': 'wrap',
  'BrowserSVGRectElement.y': 'wrap',
  'BrowserSVGSVGElement.animationsPaused': 'bool',
  'BrowserSVGSVGElement.checkEnclosure': 'bool',
  'BrowserSVGSVGElement.checkIntersection': 'bool',
  'BrowserSVGSVGElement.createSVGAngle': 'wrap',
  'BrowserSVGSVGElement.createSVGLength': 'wrap',
  'BrowserSVGSVGElement.createSVGMatrix': 'wrap',
  'BrowserSVGSVGElement.createSVGNumber': 'wrap',
  'BrowserSVGSVGElement.createSVGPoint': 'wrap',
  'BrowserSVGSVGElement.createSVGRect': 'wrap',
  'BrowserSVGSVGElement.createSVGTransform': 'wrap',
  'BrowserSVGSVGElement.createSVGTransformFromMatrix': 'wrap',
  'BrowserSVGSVGElement.currentScale': 'double',
  'BrowserSVGSVGElement.currentTranslate': 'wrap',
  'BrowserSVGSVGElement.deselectAll': 'void',
  'BrowserSVGSVGElement.forceRedraw': 'void',
  'BrowserSVGSVGElement.getCurrentTime': 'double',
  'BrowserSVGSVGElement.getElementById': 'wrap',
  'BrowserSVGSVGElement.getEnclosureList': 'wrap',
  'BrowserSVGSVGElement.getIntersectionList': 'wrap',
  'BrowserSVGSVGElement.height': 'wrap',
  'BrowserSVGSVGElement.onafterprint': 'jsfunction',
  'BrowserSVGSVGElement.onbeforeprint': 'jsfunction',
  'BrowserSVGSVGElement.onbeforeunload': 'jsfunction',
  'BrowserSVGSVGElement.ongamepadconnected': 'jsfunction',
  'BrowserSVGSVGElement.ongamepaddisconnected': 'jsfunction',
  'BrowserSVGSVGElement.onhashchange': 'jsfunction',
  'BrowserSVGSVGElement.onlanguagechange': 'jsfunction',
  'BrowserSVGSVGElement.onmessage': 'jsfunction',
  'BrowserSVGSVGElement.onmessageerror': 'jsfunction',
  'BrowserSVGSVGElement.onoffline': 'jsfunction',
  'BrowserSVGSVGElement.ononline': 'jsfunction',
  'BrowserSVGSVGElement.onpagehide': 'jsfunction',
  'BrowserSVGSVGElement.onpagereveal': 'jsfunction',
  'BrowserSVGSVGElement.onpageshow': 'jsfunction',
  'BrowserSVGSVGElement.onpageswap': 'jsfunction',
  'BrowserSVGSVGElement.onpopstate': 'jsfunction',
  'BrowserSVGSVGElement.onportalactivate': 'jsfunction',
  'BrowserSVGSVGElement.onrejectionhandled': 'jsfunction',
  'BrowserSVGSVGElement.onstorage': 'jsfunction',
  'BrowserSVGSVGElement.onunhandledrejection': 'jsfunction',
  'BrowserSVGSVGElement.onunload': 'jsfunction',
  'BrowserSVGSVGElement.pauseAnimations': 'void',
  'BrowserSVGSVGElement.preserveAspectRatio': 'wrap',
  'BrowserSVGSVGElement.setCurrentTime': 'void',
  'BrowserSVGSVGElement.suspendRedraw': 'int',
  'BrowserSVGSVGElement.unpauseAnimations': 'void',
  'BrowserSVGSVGElement.unsuspendRedraw': 'void',
  'BrowserSVGSVGElement.unsuspendRedrawAll': 'void',
  'BrowserSVGSVGElement.viewBox': 'wrap',
  'BrowserSVGSVGElement.width': 'wrap',
  'BrowserSVGSVGElement.x': 'wrap',
  'BrowserSVGSVGElement.y': 'wrap',
  'BrowserSVGScriptElement.crossOrigin': 'string',
  'BrowserSVGScriptElement.href': 'wrap',
  'BrowserSVGScriptElement.type': 'string',
  'BrowserSVGStopElement.offset': 'wrap',
  'BrowserSVGStringList.appendItem': 'string',
  'BrowserSVGStringList.clear': 'void',
  'BrowserSVGStringList.getItem': 'string',
  'BrowserSVGStringList.initialize': 'string',
  'BrowserSVGStringList.insertItemBefore': 'string',
  'BrowserSVGStringList.numberOfItems': 'int',
  'BrowserSVGStringList.removeItem': 'string',
  'BrowserSVGStringList.replaceItem': 'string',
  'BrowserSVGStyleElement.media': 'string',
  'BrowserSVGStyleElement.sheet': 'wrap',
  'BrowserSVGStyleElement.title': 'string',
  'BrowserSVGStyleElement.type': 'string',
  'BrowserSVGSymbolElement.preserveAspectRatio': 'wrap',
  'BrowserSVGSymbolElement.viewBox': 'wrap',
  'BrowserSVGTextContentElement.getCharNumAtPosition': 'int',
  'BrowserSVGTextContentElement.getComputedTextLength': 'double',
  'BrowserSVGTextContentElement.getEndPositionOfChar': 'wrap',
  'BrowserSVGTextContentElement.getExtentOfChar': 'wrap',
  'BrowserSVGTextContentElement.getNumberOfChars': 'int',
  'BrowserSVGTextContentElement.getRotationOfChar': 'double',
  'BrowserSVGTextContentElement.getStartPositionOfChar': 'wrap',
  'BrowserSVGTextContentElement.getSubStringLength': 'double',
  'BrowserSVGTextContentElement.lengthAdjust': 'wrap',
  'BrowserSVGTextContentElement.selectSubString': 'void',
  'BrowserSVGTextContentElement.textLength': 'wrap',
  'BrowserSVGTextPathElement.href': 'wrap',
  'BrowserSVGTextPathElement.method': 'wrap',
  'BrowserSVGTextPathElement.spacing': 'wrap',
  'BrowserSVGTextPathElement.startOffset': 'wrap',
  'BrowserSVGTextPositioningElement.dx': 'wrap',
  'BrowserSVGTextPositioningElement.dy': 'wrap',
  'BrowserSVGTextPositioningElement.rotate': 'wrap',
  'BrowserSVGTextPositioningElement.x': 'wrap',
  'BrowserSVGTextPositioningElement.y': 'wrap',
  'BrowserSVGTransform.angle': 'double',
  'BrowserSVGTransform.matrix': 'wrap',
  'BrowserSVGTransform.setMatrix': 'void',
  'BrowserSVGTransform.setRotate': 'void',
  'BrowserSVGTransform.setScale': 'void',
  'BrowserSVGTransform.setSkewX': 'void',
  'BrowserSVGTransform.setSkewY': 'void',
  'BrowserSVGTransform.setTranslate': 'void',
  'BrowserSVGTransform.type': 'int',
  'BrowserSVGTransformList.appendItem': 'wrap',
  'BrowserSVGTransformList.clear': 'void',
  'BrowserSVGTransformList.consolidate': 'wrap',
  'BrowserSVGTransformList.createSVGTransformFromMatrix': 'wrap',
  'BrowserSVGTransformList.getItem': 'wrap',
  'BrowserSVGTransformList.initialize': 'wrap',
  'BrowserSVGTransformList.insertItemBefore': 'wrap',
  'BrowserSVGTransformList.numberOfItems': 'int',
  'BrowserSVGTransformList.removeItem': 'wrap',
  'BrowserSVGTransformList.replaceItem': 'wrap',
  'BrowserSVGUseElement.height': 'wrap',
  'BrowserSVGUseElement.href': 'wrap',
  'BrowserSVGUseElement.width': 'wrap',
  'BrowserSVGUseElement.x': 'wrap',
  'BrowserSVGUseElement.y': 'wrap',
  'BrowserSVGViewElement.preserveAspectRatio': 'wrap',
  'BrowserSVGViewElement.viewBox': 'wrap',
  'BrowserScheduler.postTask': 'wrap',
  'BrowserScreen.availHeight': 'int',
  'BrowserScreen.availWidth': 'int',
  'BrowserScreen.colorDepth': 'int',
  'BrowserScreen.height': 'int',
  'BrowserScreen.onchange': 'jsfunction',
  'BrowserScreen.orientation': 'wrap',
  'BrowserScreen.pixelDepth': 'int',
  'BrowserScreen.width': 'int',
  'BrowserScreenOrientation.angle': 'int',
  'BrowserScreenOrientation.lock': 'wrap',
  'BrowserScreenOrientation.onchange': 'jsfunction',
  'BrowserScreenOrientation.type': 'wrap',
  'BrowserScreenOrientation.unlock': 'void',
  'BrowserSecurityPolicyViolationEvent.blockedURI': 'string',
  'BrowserSecurityPolicyViolationEvent.columnNumber': 'int',
  'BrowserSecurityPolicyViolationEvent.disposition': 'wrap',
  'BrowserSecurityPolicyViolationEvent.documentURI': 'string',
  'BrowserSecurityPolicyViolationEvent.effectiveDirective': 'string',
  'BrowserSecurityPolicyViolationEvent.lineNumber': 'int',
  'BrowserSecurityPolicyViolationEvent.originalPolicy': 'string',
  'BrowserSecurityPolicyViolationEvent.referrer': 'string',
  'BrowserSecurityPolicyViolationEvent.sample': 'string',
  'BrowserSecurityPolicyViolationEvent.sourceFile': 'string',
  'BrowserSecurityPolicyViolationEvent.statusCode': 'int',
  'BrowserSecurityPolicyViolationEvent.violatedDirective': 'string',
  'BrowserSelection.addRange': 'void',
  'BrowserSelection.anchorNode': 'wrap',
  'BrowserSelection.anchorOffset': 'int',
  'BrowserSelection.collapse': 'void',
  'BrowserSelection.collapseToEnd': 'void',
  'BrowserSelection.collapseToStart': 'void',
  'BrowserSelection.containsNode': 'bool',
  'BrowserSelection.deleteFromDocument': 'void',
  'BrowserSelection.direction': 'string',
  'BrowserSelection.empty': 'void',
  'BrowserSelection.extend': 'void',
  'BrowserSelection.focusNode': 'wrap',
  'BrowserSelection.focusOffset': 'int',
  'BrowserSelection.getRangeAt': 'wrap',
  'BrowserSelection.isCollapsed': 'bool',
  'BrowserSelection.modify': 'void',
  'BrowserSelection.rangeCount': 'int',
  'BrowserSelection.removeAllRanges': 'void',
  'BrowserSelection.removeRange': 'void',
  'BrowserSelection.selectAllChildren': 'void',
  'BrowserSelection.setBaseAndExtent': 'void',
  'BrowserSelection.setPosition': 'void',
  'BrowserSelection.type': 'string',
  'BrowserSensorErrorEvent.error': 'wrap',
  'BrowserServiceWorker.onerror': 'jsfunction',
  'BrowserServiceWorker.onstatechange': 'jsfunction',
  'BrowserServiceWorker.postMessage': 'void',
  'BrowserServiceWorker.scriptURL': 'string',
  'BrowserServiceWorker.state': 'wrap',
  'BrowserServiceWorkerContainer.controller': 'wrap',
  'BrowserServiceWorkerContainer.getRegistration': 'wrap',
  'BrowserServiceWorkerContainer.getRegistrations': 'wrap',
  'BrowserServiceWorkerContainer.oncontrollerchange': 'jsfunction',
  'BrowserServiceWorkerContainer.onmessage': 'jsfunction',
  'BrowserServiceWorkerContainer.onmessageerror': 'jsfunction',
  'BrowserServiceWorkerContainer.ready': 'wrap',
  'BrowserServiceWorkerContainer.register': 'wrap',
  'BrowserServiceWorkerContainer.startMessages': 'void',
  'BrowserShadowRoot.activeElement': 'wrap',
  'BrowserShadowRoot.adoptedStyleSheets': 'list',
  'BrowserShadowRoot.clonable': 'bool',
  'BrowserShadowRoot.delegatesFocus': 'bool',
  'BrowserShadowRoot.fullscreenElement': 'wrap',
  'BrowserShadowRoot.getAnimations': 'wrap',
  'BrowserShadowRoot.getHTML': 'string',
  'BrowserShadowRoot.host': 'wrap',
  'BrowserShadowRoot.innerHTML': 'wrap',
  'BrowserShadowRoot.mode': 'wrap',
  'BrowserShadowRoot.onslotchange': 'jsfunction',
  'BrowserShadowRoot.pictureInPictureElement': 'wrap',
  'BrowserShadowRoot.pointerLockElement': 'wrap',
  'BrowserShadowRoot.serializable': 'bool',
  'BrowserShadowRoot.setHTMLUnsafe': 'void',
  'BrowserShadowRoot.slotAssignment': 'wrap',
  'BrowserShadowRoot.styleSheets': 'wrap',
  'BrowserSharedWorker.onerror': 'jsfunction',
  'BrowserSharedWorker.port': 'wrap',
  'BrowserSourceBuffer.abort': 'void',
  'BrowserSourceBuffer.appendBuffer': 'void',
  'BrowserSourceBuffer.appendWindowEnd': 'double',
  'BrowserSourceBuffer.appendWindowStart': 'double',
  'BrowserSourceBuffer.audioTracks': 'wrap',
  'BrowserSourceBuffer.buffered': 'wrap',
  'BrowserSourceBuffer.changeType': 'void',
  'BrowserSourceBuffer.mode': 'wrap',
  'BrowserSourceBuffer.onabort': 'jsfunction',
  'BrowserSourceBuffer.onerror': 'jsfunction',
  'BrowserSourceBuffer.onupdate': 'jsfunction',
  'BrowserSourceBuffer.onupdateend': 'jsfunction',
  'BrowserSourceBuffer.onupdatestart': 'jsfunction',
  'BrowserSourceBuffer.remove': 'void',
  'BrowserSourceBuffer.timestampOffset': 'double',
  'BrowserSourceBuffer.updating': 'bool',
  'BrowserSourceBuffer.videoTracks': 'wrap',
  'BrowserSourceBufferList.length': 'int',
  'BrowserSourceBufferList.onaddsourcebuffer': 'jsfunction',
  'BrowserSourceBufferList.onremovesourcebuffer': 'jsfunction',
  'BrowserSpeechRecognition.abort': 'void',
  'BrowserSpeechRecognition.continuous': 'bool',
  'BrowserSpeechRecognition.grammars': 'wrap',
  'BrowserSpeechRecognition.interimResults': 'bool',
  'BrowserSpeechRecognition.lang': 'string',
  'BrowserSpeechRecognition.maxAlternatives': 'int',
  'BrowserSpeechRecognition.onaudioend': 'jsfunction',
  'BrowserSpeechRecognition.onaudiostart': 'jsfunction',
  'BrowserSpeechRecognition.onend': 'jsfunction',
  'BrowserSpeechRecognition.onerror': 'jsfunction',
  'BrowserSpeechRecognition.onnomatch': 'jsfunction',
  'BrowserSpeechRecognition.onresult': 'jsfunction',
  'BrowserSpeechRecognition.onsoundend': 'jsfunction',
  'BrowserSpeechRecognition.onsoundstart': 'jsfunction',
  'BrowserSpeechRecognition.onspeechend': 'jsfunction',
  'BrowserSpeechRecognition.onspeechstart': 'jsfunction',
  'BrowserSpeechRecognition.onstart': 'jsfunction',
  'BrowserSpeechRecognition.start': 'void',
  'BrowserSpeechRecognition.stop': 'void',
  'BrowserSpeechRecognitionAlternative.confidence': 'double',
  'BrowserSpeechRecognitionAlternative.transcript': 'string',
  'BrowserSpeechRecognitionErrorEvent.error': 'wrap',
  'BrowserSpeechRecognitionErrorEvent.message': 'string',
  'BrowserSpeechRecognitionEvent.resultIndex': 'int',
  'BrowserSpeechRecognitionEvent.results': 'wrap',
  'BrowserSpeechRecognitionResult.isFinal': 'bool',
  'BrowserSpeechRecognitionResult.item': 'wrap',
  'BrowserSpeechRecognitionResult.length': 'int',
  'BrowserSpeechRecognitionResultList.item': 'wrap',
  'BrowserSpeechRecognitionResultList.length': 'int',
  'BrowserSpeechSynthesis.cancel': 'void',
  'BrowserSpeechSynthesis.getVoices': 'wrap',
  'BrowserSpeechSynthesis.onvoiceschanged': 'jsfunction',
  'BrowserSpeechSynthesis.pause': 'void',
  'BrowserSpeechSynthesis.paused': 'bool',
  'BrowserSpeechSynthesis.pending': 'bool',
  'BrowserSpeechSynthesis.resume': 'void',
  'BrowserSpeechSynthesis.speak': 'void',
  'BrowserSpeechSynthesis.speaking': 'bool',
  'BrowserSpeechSynthesisErrorEvent.error': 'wrap',
  'BrowserSpeechSynthesisEvent.charIndex': 'int',
  'BrowserSpeechSynthesisEvent.charLength': 'int',
  'BrowserSpeechSynthesisEvent.elapsedTime': 'double',
  'BrowserSpeechSynthesisEvent.name': 'string',
  'BrowserSpeechSynthesisEvent.utterance': 'wrap',
  'BrowserSpeechSynthesisUtterance.lang': 'string',
  'BrowserSpeechSynthesisUtterance.onboundary': 'jsfunction',
  'BrowserSpeechSynthesisUtterance.onend': 'jsfunction',
  'BrowserSpeechSynthesisUtterance.onerror': 'jsfunction',
  'BrowserSpeechSynthesisUtterance.onmark': 'jsfunction',
  'BrowserSpeechSynthesisUtterance.onpause': 'jsfunction',
  'BrowserSpeechSynthesisUtterance.onresume': 'jsfunction',
  'BrowserSpeechSynthesisUtterance.onstart': 'jsfunction',
  'BrowserSpeechSynthesisUtterance.pitch': 'double',
  'BrowserSpeechSynthesisUtterance.rate': 'double',
  'BrowserSpeechSynthesisUtterance.text': 'string',
  'BrowserSpeechSynthesisUtterance.voice': 'wrap',
  'BrowserSpeechSynthesisUtterance.volume': 'double',
  'BrowserSpeechSynthesisVoice.default_': 'bool',
  'BrowserSpeechSynthesisVoice.lang': 'string',
  'BrowserSpeechSynthesisVoice.localService': 'bool',
  'BrowserSpeechSynthesisVoice.name': 'string',
  'BrowserSpeechSynthesisVoice.voiceURI': 'string',
  'BrowserStereoPannerNode.pan': 'wrap',
  'BrowserStorage.clear': 'void',
  'BrowserStorage.getItem': 'string',
  'BrowserStorage.key': 'string',
  'BrowserStorage.length': 'int',
  'BrowserStorage.removeItem': 'void',
  'BrowserStorage.setItem': 'void',
  'BrowserStorageEvent.initStorageEvent': 'void',
  'BrowserStorageEvent.key': 'string',
  'BrowserStorageEvent.newValue': 'string',
  'BrowserStorageEvent.oldValue': 'string',
  'BrowserStorageEvent.storageArea': 'wrap',
  'BrowserStorageEvent.url': 'string',
  'BrowserStorageManager.estimate': 'wrap',
  'BrowserStorageManager.getDirectory': 'wrap',
  'BrowserStorageManager.persist': 'wrap',
  'BrowserStorageManager.persisted': 'wrap',
  'BrowserStylePropertyMap.append': 'void',
  'BrowserStylePropertyMap.clear': 'void',
  'BrowserStylePropertyMap.delete': 'void',
  'BrowserStylePropertyMap.set_': 'void',
  'BrowserStylePropertyMapReadOnly.getAll': 'wrap',
  'BrowserStylePropertyMapReadOnly.get_': 'wrap',
  'BrowserStylePropertyMapReadOnly.has': 'bool',
  'BrowserStylePropertyMapReadOnly.size': 'int',
  'BrowserStyleSheetList.item': 'wrap',
  'BrowserStyleSheetList.length': 'int',
  'BrowserSubmitEvent.submitter': 'wrap',
  'BrowserSubtleCrypto.decrypt': 'wrap',
  'BrowserSubtleCrypto.deriveBits': 'wrap',
  'BrowserSubtleCrypto.deriveKey': 'wrap',
  'BrowserSubtleCrypto.digest': 'wrap',
  'BrowserSubtleCrypto.encrypt': 'wrap',
  'BrowserSubtleCrypto.exportKey': 'wrap',
  'BrowserSubtleCrypto.generateKey': 'wrap',
  'BrowserSubtleCrypto.importKey': 'wrap',
  'BrowserSubtleCrypto.sign': 'wrap',
  'BrowserSubtleCrypto.unwrapKey': 'wrap',
  'BrowserSubtleCrypto.verify': 'wrap',
  'BrowserSubtleCrypto.wrapKey': 'wrap',
  'BrowserSyncEvent.lastChance': 'bool',
  'BrowserSyncEvent.tag': 'string',
  'BrowserTaskController.setPriority': 'void',
  'BrowserTaskPriorityChangeEvent.previousPriority': 'wrap',
  'BrowserText.assignedSlot': 'wrap',
  'BrowserText.convertPointFromNode': 'wrap',
  'BrowserText.convertQuadFromNode': 'wrap',
  'BrowserText.convertRectFromNode': 'wrap',
  'BrowserText.getBoxQuads': 'wrap',
  'BrowserText.splitText': 'wrap',
  'BrowserText.wholeText': 'string',
  'BrowserTextDecoder.decode': 'string',
  'BrowserTextDecoder.encoding': 'string',
  'BrowserTextDecoder.fatal': 'bool',
  'BrowserTextDecoder.ignoreBOM': 'bool',
  'BrowserTextDecoderStream.encoding': 'string',
  'BrowserTextDecoderStream.fatal': 'bool',
  'BrowserTextDecoderStream.ignoreBOM': 'bool',
  'BrowserTextDecoderStream.readable': 'wrap',
  'BrowserTextDecoderStream.writable': 'wrap',
  'BrowserTextEncoder.encode': 'typedArray',
  'BrowserTextEncoder.encodeInto': 'wrap',
  'BrowserTextEncoder.encoding': 'string',
  'BrowserTextEncoderStream.encoding': 'string',
  'BrowserTextEncoderStream.readable': 'wrap',
  'BrowserTextEncoderStream.writable': 'wrap',
  'BrowserTextTrack.activeCues': 'wrap',
  'BrowserTextTrack.addCue': 'void',
  'BrowserTextTrack.cues': 'wrap',
  'BrowserTextTrack.id': 'string',
  'BrowserTextTrack.inBandMetadataTrackDispatchType': 'string',
  'BrowserTextTrack.kind': 'wrap',
  'BrowserTextTrack.label': 'string',
  'BrowserTextTrack.language': 'string',
  'BrowserTextTrack.mode': 'wrap',
  'BrowserTextTrack.oncuechange': 'jsfunction',
  'BrowserTextTrack.removeCue': 'void',
  'BrowserTextTrack.sourceBuffer': 'wrap',
  'BrowserTextTrackCue.endTime': 'double',
  'BrowserTextTrackCue.id': 'string',
  'BrowserTextTrackCue.onenter': 'jsfunction',
  'BrowserTextTrackCue.onexit': 'jsfunction',
  'BrowserTextTrackCue.pauseOnExit': 'bool',
  'BrowserTextTrackCue.startTime': 'double',
  'BrowserTextTrackCue.track': 'wrap',
  'BrowserTextTrackCueList.getCueById': 'wrap',
  'BrowserTextTrackCueList.length': 'int',
  'BrowserTextTrackList.getTrackById': 'wrap',
  'BrowserTextTrackList.length': 'int',
  'BrowserTextTrackList.onaddtrack': 'jsfunction',
  'BrowserTextTrackList.onchange': 'jsfunction',
  'BrowserTextTrackList.onremovetrack': 'jsfunction',
  'BrowserTimeRanges.end': 'double',
  'BrowserTimeRanges.length': 'int',
  'BrowserTimeRanges.start': 'double',
  'BrowserToggleEvent.newState': 'string',
  'BrowserToggleEvent.oldState': 'string',
  'BrowserTouch.altitudeAngle': 'double',
  'BrowserTouch.azimuthAngle': 'double',
  'BrowserTouch.clientX': 'double',
  'BrowserTouch.clientY': 'double',
  'BrowserTouch.force': 'double',
  'BrowserTouch.identifier': 'int',
  'BrowserTouch.pageX': 'double',
  'BrowserTouch.pageY': 'double',
  'BrowserTouch.radiusX': 'double',
  'BrowserTouch.radiusY': 'double',
  'BrowserTouch.rotationAngle': 'double',
  'BrowserTouch.screenX': 'double',
  'BrowserTouch.screenY': 'double',
  'BrowserTouch.target': 'wrap',
  'BrowserTouch.touchType': 'wrap',
  'BrowserTouchEvent.altKey': 'bool',
  'BrowserTouchEvent.changedTouches': 'wrap',
  'BrowserTouchEvent.ctrlKey': 'bool',
  'BrowserTouchEvent.metaKey': 'bool',
  'BrowserTouchEvent.shiftKey': 'bool',
  'BrowserTouchEvent.targetTouches': 'wrap',
  'BrowserTouchEvent.touches': 'wrap',
  'BrowserTouchList.item': 'wrap',
  'BrowserTouchList.length': 'int',
  'BrowserTrackEvent.track': 'wrap',
  'BrowserTransformStream.readable': 'wrap',
  'BrowserTransformStream.writable': 'wrap',
  'BrowserTransitionEvent.elapsedTime': 'double',
  'BrowserTransitionEvent.propertyName': 'wrap',
  'BrowserTransitionEvent.pseudoElement': 'wrap',
  'BrowserTreeWalker.currentNode': 'wrap',
  'BrowserTreeWalker.filter': 'wrap',
  'BrowserTreeWalker.firstChild': 'wrap',
  'BrowserTreeWalker.lastChild': 'wrap',
  'BrowserTreeWalker.nextNode': 'wrap',
  'BrowserTreeWalker.nextSibling': 'wrap',
  'BrowserTreeWalker.parentNode': 'wrap',
  'BrowserTreeWalker.previousNode': 'wrap',
  'BrowserTreeWalker.previousSibling': 'wrap',
  'BrowserTreeWalker.root': 'wrap',
  'BrowserTreeWalker.whatToShow': 'int',
  'BrowserTrustedHTML.toJSON': 'string',
  'BrowserTrustedScript.toJSON': 'string',
  'BrowserTrustedScriptURL.toJSON': 'string',
  'BrowserTrustedTypePolicy.createHTML': 'wrap',
  'BrowserTrustedTypePolicy.createScript': 'wrap',
  'BrowserTrustedTypePolicy.createScriptURL': 'wrap',
  'BrowserTrustedTypePolicy.name': 'string',
  'BrowserTrustedTypePolicyFactory.createPolicy': 'wrap',
  'BrowserTrustedTypePolicyFactory.defaultPolicy': 'wrap',
  'BrowserTrustedTypePolicyFactory.emptyHTML': 'wrap',
  'BrowserTrustedTypePolicyFactory.emptyScript': 'wrap',
  'BrowserTrustedTypePolicyFactory.getAttributeType': 'string',
  'BrowserTrustedTypePolicyFactory.getPropertyType': 'string',
  'BrowserTrustedTypePolicyFactory.isHTML': 'bool',
  'BrowserTrustedTypePolicyFactory.isScript': 'bool',
  'BrowserTrustedTypePolicyFactory.isScriptURL': 'bool',
  'BrowserUIEvent.detail': 'int',
  'BrowserUIEvent.initUIEvent': 'void',
  'BrowserUIEvent.view': 'wrap',
  'BrowserUIEvent.which': 'int',
  'BrowserURL.hash': 'string',
  'BrowserURL.host': 'string',
  'BrowserURL.hostname': 'string',
  'BrowserURL.href': 'string',
  'BrowserURL.origin': 'string',
  'BrowserURL.password': 'string',
  'BrowserURL.pathname': 'string',
  'BrowserURL.port': 'string',
  'BrowserURL.protocol': 'string',
  'BrowserURL.search': 'string',
  'BrowserURL.searchParams': 'wrap',
  'BrowserURL.toJSON': 'string',
  'BrowserURL.username': 'string',
  'BrowserURLSearchParams.append': 'void',
  'BrowserURLSearchParams.delete': 'void',
  'BrowserURLSearchParams.getAll': 'wrap',
  'BrowserURLSearchParams.get_': 'string',
  'BrowserURLSearchParams.has': 'bool',
  'BrowserURLSearchParams.set_': 'void',
  'BrowserURLSearchParams.size': 'int',
  'BrowserURLSearchParams.sort': 'void',
  'BrowserUserActivation.hasBeenActive': 'bool',
  'BrowserUserActivation.isActive': 'bool',
  'BrowserVTTCue.align': 'wrap',
  'BrowserVTTCue.getCueAsHTML': 'wrap',
  'BrowserVTTCue.line': 'wrap',
  'BrowserVTTCue.lineAlign': 'wrap',
  'BrowserVTTCue.position': 'wrap',
  'BrowserVTTCue.positionAlign': 'wrap',
  'BrowserVTTCue.region': 'wrap',
  'BrowserVTTCue.size': 'double',
  'BrowserVTTCue.snapToLines': 'bool',
  'BrowserVTTCue.text': 'string',
  'BrowserVTTCue.vertical': 'wrap',
  'BrowserVTTRegion.id': 'string',
  'BrowserVTTRegion.lines': 'int',
  'BrowserVTTRegion.regionAnchorX': 'double',
  'BrowserVTTRegion.regionAnchorY': 'double',
  'BrowserVTTRegion.scroll': 'wrap',
  'BrowserVTTRegion.viewportAnchorX': 'double',
  'BrowserVTTRegion.viewportAnchorY': 'double',
  'BrowserVTTRegion.width': 'double',
  'BrowserValidityState.badInput': 'bool',
  'BrowserValidityState.customError': 'bool',
  'BrowserValidityState.patternMismatch': 'bool',
  'BrowserValidityState.rangeOverflow': 'bool',
  'BrowserValidityState.rangeUnderflow': 'bool',
  'BrowserValidityState.stepMismatch': 'bool',
  'BrowserValidityState.tooLong': 'bool',
  'BrowserValidityState.tooShort': 'bool',
  'BrowserValidityState.typeMismatch': 'bool',
  'BrowserValidityState.valid': 'bool',
  'BrowserValidityState.valueMissing': 'bool',
  'BrowserVideoColorSpace.fullRange': 'bool',
  'BrowserVideoColorSpace.matrix': 'wrap',
  'BrowserVideoColorSpace.primaries': 'wrap',
  'BrowserVideoColorSpace.toJSON': 'wrap',
  'BrowserVideoColorSpace.transfer': 'wrap',
  'BrowserVideoDecoder.close': 'void',
  'BrowserVideoDecoder.configure': 'void',
  'BrowserVideoDecoder.decode': 'void',
  'BrowserVideoDecoder.decodeQueueSize': 'int',
  'BrowserVideoDecoder.flush': 'wrap',
  'BrowserVideoDecoder.ondequeue': 'jsfunction',
  'BrowserVideoDecoder.reset': 'void',
  'BrowserVideoDecoder.state': 'wrap',
  'BrowserVideoEncoder.close': 'void',
  'BrowserVideoEncoder.configure': 'void',
  'BrowserVideoEncoder.encode': 'void',
  'BrowserVideoEncoder.encodeQueueSize': 'int',
  'BrowserVideoEncoder.flush': 'wrap',
  'BrowserVideoEncoder.ondequeue': 'jsfunction',
  'BrowserVideoEncoder.reset': 'void',
  'BrowserVideoEncoder.state': 'wrap',
  'BrowserVideoFrame.allocationSize': 'int',
  'BrowserVideoFrame.clone': 'wrap',
  'BrowserVideoFrame.close': 'void',
  'BrowserVideoFrame.codedHeight': 'int',
  'BrowserVideoFrame.codedRect': 'wrap',
  'BrowserVideoFrame.codedWidth': 'int',
  'BrowserVideoFrame.colorSpace': 'wrap',
  'BrowserVideoFrame.copyTo': 'wrap',
  'BrowserVideoFrame.displayHeight': 'int',
  'BrowserVideoFrame.displayWidth': 'int',
  'BrowserVideoFrame.duration': 'int',
  'BrowserVideoFrame.format': 'wrap',
  'BrowserVideoFrame.timestamp': 'int',
  'BrowserVideoFrame.visibleRect': 'wrap',
  'BrowserVideoPlaybackQuality.corruptedVideoFrames': 'int',
  'BrowserVideoPlaybackQuality.creationTime': 'wrap',
  'BrowserVideoPlaybackQuality.droppedVideoFrames': 'int',
  'BrowserVideoPlaybackQuality.totalVideoFrames': 'int',
  'BrowserVideoTrack.id': 'string',
  'BrowserVideoTrack.kind': 'string',
  'BrowserVideoTrack.label': 'string',
  'BrowserVideoTrack.language': 'string',
  'BrowserVideoTrack.selected': 'bool',
  'BrowserVideoTrack.sourceBuffer': 'wrap',
  'BrowserVideoTrackList.getTrackById': 'wrap',
  'BrowserVideoTrackList.length': 'int',
  'BrowserVideoTrackList.onaddtrack': 'jsfunction',
  'BrowserVideoTrackList.onchange': 'jsfunction',
  'BrowserVideoTrackList.onremovetrack': 'jsfunction',
  'BrowserVideoTrackList.selectedIndex': 'int',
  'BrowserViewTransition.finished': 'wrap',
  'BrowserViewTransition.ready': 'wrap',
  'BrowserViewTransition.skipTransition': 'void',
  'BrowserViewTransition.updateCallbackDone': 'wrap',
  'BrowserVisualViewport.height': 'double',
  'BrowserVisualViewport.offsetLeft': 'double',
  'BrowserVisualViewport.offsetTop': 'double',
  'BrowserVisualViewport.onresize': 'jsfunction',
  'BrowserVisualViewport.onscroll': 'jsfunction',
  'BrowserVisualViewport.onscrollend': 'jsfunction',
  'BrowserVisualViewport.pageLeft': 'double',
  'BrowserVisualViewport.pageTop': 'double',
  'BrowserVisualViewport.scale': 'double',
  'BrowserVisualViewport.width': 'double',
  'BrowserWakeLock.request': 'wrap',
  'BrowserWaveShaperNode.curve': 'typedArray',
  'BrowserWaveShaperNode.oversample': 'wrap',
  'BrowserWebGLContextEvent.statusMessage': 'string',
  'BrowserWebSocket.binaryType': 'wrap',
  'BrowserWebSocket.bufferedAmount': 'int',
  'BrowserWebSocket.close': 'void',
  'BrowserWebSocket.extensions': 'string',
  'BrowserWebSocket.onclose': 'jsfunction',
  'BrowserWebSocket.onerror': 'jsfunction',
  'BrowserWebSocket.onmessage': 'jsfunction',
  'BrowserWebSocket.onopen': 'jsfunction',
  'BrowserWebSocket.protocol': 'string',
  'BrowserWebSocket.readyState': 'int',
  'BrowserWebSocket.send': 'void',
  'BrowserWebSocket.url': 'string',
  'BrowserWebTransport.close': 'void',
  'BrowserWebTransport.closed': 'wrap',
  'BrowserWebTransport.createBidirectionalStream': 'wrap',
  'BrowserWebTransport.createUnidirectionalStream': 'wrap',
  'BrowserWebTransport.datagrams': 'wrap',
  'BrowserWebTransport.incomingBidirectionalStreams': 'wrap',
  'BrowserWebTransport.incomingUnidirectionalStreams': 'wrap',
  'BrowserWebTransport.ready': 'wrap',
  'BrowserWebTransportDatagramDuplexStream.incomingHighWaterMark': 'double',
  'BrowserWebTransportDatagramDuplexStream.incomingMaxAge': 'double',
  'BrowserWebTransportDatagramDuplexStream.maxDatagramSize': 'int',
  'BrowserWebTransportDatagramDuplexStream.outgoingHighWaterMark': 'double',
  'BrowserWebTransportDatagramDuplexStream.outgoingMaxAge': 'double',
  'BrowserWebTransportDatagramDuplexStream.readable': 'wrap',
  'BrowserWebTransportDatagramDuplexStream.writable': 'wrap',
  'BrowserWebTransportError.source': 'wrap',
  'BrowserWebTransportError.streamErrorCode': 'int',
  'BrowserWheelEvent.deltaMode': 'int',
  'BrowserWheelEvent.deltaX': 'double',
  'BrowserWheelEvent.deltaY': 'double',
  'BrowserWheelEvent.deltaZ': 'double',
  'BrowserWindow.alert': 'void',
  'BrowserWindow.atob': 'string',
  'BrowserWindow.blur': 'void',
  'BrowserWindow.btoa': 'string',
  'BrowserWindow.caches': 'wrap',
  'BrowserWindow.cancelAnimationFrame': 'void',
  'BrowserWindow.cancelIdleCallback': 'void',
  'BrowserWindow.captureEvents': 'void',
  'BrowserWindow.clearInterval': 'void',
  'BrowserWindow.clearTimeout': 'void',
  'BrowserWindow.close': 'void',
  'BrowserWindow.closed': 'bool',
  'BrowserWindow.confirm': 'bool',
  'BrowserWindow.createImageBitmap': 'wrap',
  'BrowserWindow.crossOriginIsolated': 'bool',
  'BrowserWindow.crypto': 'wrap',
  'BrowserWindow.customElements': 'wrap',
  'BrowserWindow.devicePixelRatio': 'double',
  'BrowserWindow.document': 'wrap',
  'BrowserWindow.event': 'wrap',
  'BrowserWindow.external_': 'wrap',
  'BrowserWindow.fetch': 'wrap',
  'BrowserWindow.focus': 'void',
  'BrowserWindow.frameElement': 'wrap',
  'BrowserWindow.frames': 'wrap',
  'BrowserWindow.getComputedStyle': 'wrap',
  'BrowserWindow.getSelection': 'wrap',
  'BrowserWindow.history': 'wrap',
  'BrowserWindow.indexedDB': 'wrap',
  'BrowserWindow.innerHeight': 'int',
  'BrowserWindow.innerWidth': 'int',
  'BrowserWindow.isSecureContext': 'bool',
  'BrowserWindow.length': 'int',
  'BrowserWindow.localStorage': 'wrap',
  'BrowserWindow.location': 'wrap',
  'BrowserWindow.locationbar': 'wrap',
  'BrowserWindow.matchMedia': 'wrap',
  'BrowserWindow.menubar': 'wrap',
  'BrowserWindow.moveBy': 'void',
  'BrowserWindow.moveTo': 'void',
  'BrowserWindow.name': 'string',
  'BrowserWindow.navigator': 'wrap',
  'BrowserWindow.onabort': 'jsfunction',
  'BrowserWindow.onafterprint': 'jsfunction',
  'BrowserWindow.onanimationcancel': 'jsfunction',
  'BrowserWindow.onanimationend': 'jsfunction',
  'BrowserWindow.onanimationiteration': 'jsfunction',
  'BrowserWindow.onanimationstart': 'jsfunction',
  'BrowserWindow.onappinstalled': 'jsfunction',
  'BrowserWindow.onauxclick': 'jsfunction',
  'BrowserWindow.onbeforeinput': 'jsfunction',
  'BrowserWindow.onbeforeinstallprompt': 'jsfunction',
  'BrowserWindow.onbeforematch': 'jsfunction',
  'BrowserWindow.onbeforeprint': 'jsfunction',
  'BrowserWindow.onbeforetoggle': 'jsfunction',
  'BrowserWindow.onbeforeunload': 'jsfunction',
  'BrowserWindow.onbeforexrselect': 'jsfunction',
  'BrowserWindow.onblur': 'jsfunction',
  'BrowserWindow.oncancel': 'jsfunction',
  'BrowserWindow.oncanplay': 'jsfunction',
  'BrowserWindow.oncanplaythrough': 'jsfunction',
  'BrowserWindow.onchange': 'jsfunction',
  'BrowserWindow.onclick': 'jsfunction',
  'BrowserWindow.onclose': 'jsfunction',
  'BrowserWindow.oncontextlost': 'jsfunction',
  'BrowserWindow.oncontextmenu': 'jsfunction',
  'BrowserWindow.oncontextrestored': 'jsfunction',
  'BrowserWindow.oncopy': 'jsfunction',
  'BrowserWindow.oncuechange': 'jsfunction',
  'BrowserWindow.oncut': 'jsfunction',
  'BrowserWindow.ondblclick': 'jsfunction',
  'BrowserWindow.ondevicemotion': 'jsfunction',
  'BrowserWindow.ondeviceorientation': 'jsfunction',
  'BrowserWindow.ondeviceorientationabsolute': 'jsfunction',
  'BrowserWindow.ondrag': 'jsfunction',
  'BrowserWindow.ondragend': 'jsfunction',
  'BrowserWindow.ondragenter': 'jsfunction',
  'BrowserWindow.ondragleave': 'jsfunction',
  'BrowserWindow.ondragover': 'jsfunction',
  'BrowserWindow.ondragstart': 'jsfunction',
  'BrowserWindow.ondrop': 'jsfunction',
  'BrowserWindow.ondurationchange': 'jsfunction',
  'BrowserWindow.onemptied': 'jsfunction',
  'BrowserWindow.onended': 'jsfunction',
  'BrowserWindow.onerror': 'jsfunction',
  'BrowserWindow.onfocus': 'jsfunction',
  'BrowserWindow.onformdata': 'jsfunction',
  'BrowserWindow.ongamepadconnected': 'jsfunction',
  'BrowserWindow.ongamepaddisconnected': 'jsfunction',
  'BrowserWindow.ongotpointercapture': 'jsfunction',
  'BrowserWindow.onhashchange': 'jsfunction',
  'BrowserWindow.oninput': 'jsfunction',
  'BrowserWindow.oninvalid': 'jsfunction',
  'BrowserWindow.onkeydown': 'jsfunction',
  'BrowserWindow.onkeypress': 'jsfunction',
  'BrowserWindow.onkeyup': 'jsfunction',
  'BrowserWindow.onlanguagechange': 'jsfunction',
  'BrowserWindow.onload': 'jsfunction',
  'BrowserWindow.onloadeddata': 'jsfunction',
  'BrowserWindow.onloadedmetadata': 'jsfunction',
  'BrowserWindow.onloadstart': 'jsfunction',
  'BrowserWindow.onlostpointercapture': 'jsfunction',
  'BrowserWindow.onmessage': 'jsfunction',
  'BrowserWindow.onmessageerror': 'jsfunction',
  'BrowserWindow.onmousedown': 'jsfunction',
  'BrowserWindow.onmouseenter': 'jsfunction',
  'BrowserWindow.onmouseleave': 'jsfunction',
  'BrowserWindow.onmousemove': 'jsfunction',
  'BrowserWindow.onmouseout': 'jsfunction',
  'BrowserWindow.onmouseover': 'jsfunction',
  'BrowserWindow.onmouseup': 'jsfunction',
  'BrowserWindow.onoffline': 'jsfunction',
  'BrowserWindow.ononline': 'jsfunction',
  'BrowserWindow.onorientationchange': 'jsfunction',
  'BrowserWindow.onpagehide': 'jsfunction',
  'BrowserWindow.onpagereveal': 'jsfunction',
  'BrowserWindow.onpageshow': 'jsfunction',
  'BrowserWindow.onpageswap': 'jsfunction',
  'BrowserWindow.onpaste': 'jsfunction',
  'BrowserWindow.onpause': 'jsfunction',
  'BrowserWindow.onplay': 'jsfunction',
  'BrowserWindow.onplaying': 'jsfunction',
  'BrowserWindow.onpointercancel': 'jsfunction',
  'BrowserWindow.onpointerdown': 'jsfunction',
  'BrowserWindow.onpointerenter': 'jsfunction',
  'BrowserWindow.onpointerleave': 'jsfunction',
  'BrowserWindow.onpointermove': 'jsfunction',
  'BrowserWindow.onpointerout': 'jsfunction',
  'BrowserWindow.onpointerover': 'jsfunction',
  'BrowserWindow.onpointerrawupdate': 'jsfunction',
  'BrowserWindow.onpointerup': 'jsfunction',
  'BrowserWindow.onpopstate': 'jsfunction',
  'BrowserWindow.onportalactivate': 'jsfunction',
  'BrowserWindow.onprogress': 'jsfunction',
  'BrowserWindow.onratechange': 'jsfunction',
  'BrowserWindow.onrejectionhandled': 'jsfunction',
  'BrowserWindow.onreset': 'jsfunction',
  'BrowserWindow.onresize': 'jsfunction',
  'BrowserWindow.onscroll': 'jsfunction',
  'BrowserWindow.onscrollend': 'jsfunction',
  'BrowserWindow.onsecuritypolicyviolation': 'jsfunction',
  'BrowserWindow.onseeked': 'jsfunction',
  'BrowserWindow.onseeking': 'jsfunction',
  'BrowserWindow.onselect': 'jsfunction',
  'BrowserWindow.onselectionchange': 'jsfunction',
  'BrowserWindow.onselectstart': 'jsfunction',
  'BrowserWindow.onslotchange': 'jsfunction',
  'BrowserWindow.onsnapchanged': 'jsfunction',
  'BrowserWindow.onsnapchanging': 'jsfunction',
  'BrowserWindow.onstalled': 'jsfunction',
  'BrowserWindow.onstorage': 'jsfunction',
  'BrowserWindow.onsubmit': 'jsfunction',
  'BrowserWindow.onsuspend': 'jsfunction',
  'BrowserWindow.ontimeupdate': 'jsfunction',
  'BrowserWindow.ontoggle': 'jsfunction',
  'BrowserWindow.ontouchcancel': 'jsfunction',
  'BrowserWindow.ontouchend': 'jsfunction',
  'BrowserWindow.ontouchmove': 'jsfunction',
  'BrowserWindow.ontouchstart': 'jsfunction',
  'BrowserWindow.ontransitioncancel': 'jsfunction',
  'BrowserWindow.ontransitionend': 'jsfunction',
  'BrowserWindow.ontransitionrun': 'jsfunction',
  'BrowserWindow.ontransitionstart': 'jsfunction',
  'BrowserWindow.onunhandledrejection': 'jsfunction',
  'BrowserWindow.onunload': 'jsfunction',
  'BrowserWindow.onvolumechange': 'jsfunction',
  'BrowserWindow.onwaiting': 'jsfunction',
  'BrowserWindow.onwebkitanimationend': 'jsfunction',
  'BrowserWindow.onwebkitanimationiteration': 'jsfunction',
  'BrowserWindow.onwebkitanimationstart': 'jsfunction',
  'BrowserWindow.onwebkittransitionend': 'jsfunction',
  'BrowserWindow.onwheel': 'jsfunction',
  'BrowserWindow.open': 'wrap',
  'BrowserWindow.opener': 'wrap',
  'BrowserWindow.orientation': 'int',
  'BrowserWindow.origin': 'string',
  'BrowserWindow.outerHeight': 'int',
  'BrowserWindow.outerWidth': 'int',
  'BrowserWindow.parent': 'wrap',
  'BrowserWindow.performance': 'wrap',
  'BrowserWindow.personalbar': 'wrap',
  'BrowserWindow.postMessage': 'void',
  'BrowserWindow.print': 'void',
  'BrowserWindow.prompt': 'string',
  'BrowserWindow.queueMicrotask': 'void',
  'BrowserWindow.releaseEvents': 'void',
  'BrowserWindow.reportError': 'void',
  'BrowserWindow.requestAnimationFrame': 'int',
  'BrowserWindow.requestIdleCallback': 'int',
  'BrowserWindow.resizeBy': 'void',
  'BrowserWindow.resizeTo': 'void',
  'BrowserWindow.scheduler': 'wrap',
  'BrowserWindow.screen': 'wrap',
  'BrowserWindow.screenLeft': 'int',
  'BrowserWindow.screenTop': 'int',
  'BrowserWindow.screenX': 'int',
  'BrowserWindow.screenY': 'int',
  'BrowserWindow.scroll': 'void',
  'BrowserWindow.scrollBy': 'void',
  'BrowserWindow.scrollTo': 'void',
  'BrowserWindow.scrollX': 'double',
  'BrowserWindow.scrollY': 'double',
  'BrowserWindow.scrollbars': 'wrap',
  'BrowserWindow.self': 'wrap',
  'BrowserWindow.sessionStorage': 'wrap',
  'BrowserWindow.setInterval': 'int',
  'BrowserWindow.setTimeout': 'int',
  'BrowserWindow.speechSynthesis': 'wrap',
  'BrowserWindow.status': 'string',
  'BrowserWindow.statusbar': 'wrap',
  'BrowserWindow.stop': 'void',
  'BrowserWindow.structuredClone': 'wrap',
  'BrowserWindow.toolbar': 'wrap',
  'BrowserWindow.top': 'wrap',
  'BrowserWindow.trustedTypes': 'wrap',
  'BrowserWindow.visualViewport': 'wrap',
  'BrowserWindow.window': 'wrap',
  'BrowserWorker.onerror': 'jsfunction',
  'BrowserWorker.onmessage': 'jsfunction',
  'BrowserWorker.onmessageerror': 'jsfunction',
  'BrowserWorker.postMessage': 'void',
  'BrowserWorker.terminate': 'void',
  'BrowserWritableStream.abort': 'wrap',
  'BrowserWritableStream.close': 'wrap',
  'BrowserWritableStream.getWriter': 'wrap',
  'BrowserWritableStream.locked': 'bool',
  'BrowserWritableStreamDefaultWriter.abort': 'wrap',
  'BrowserWritableStreamDefaultWriter.close': 'wrap',
  'BrowserWritableStreamDefaultWriter.closed': 'wrap',
  'BrowserWritableStreamDefaultWriter.desiredSize': 'double',
  'BrowserWritableStreamDefaultWriter.ready': 'wrap',
  'BrowserWritableStreamDefaultWriter.releaseLock': 'void',
  'BrowserWritableStreamDefaultWriter.write': 'wrap',
  'BrowserXMLHttpRequest.abort': 'void',
  'BrowserXMLHttpRequest.getAllResponseHeaders': 'string',
  'BrowserXMLHttpRequest.getResponseHeader': 'string',
  'BrowserXMLHttpRequest.onreadystatechange': 'jsfunction',
  'BrowserXMLHttpRequest.open': 'void',
  'BrowserXMLHttpRequest.overrideMimeType': 'void',
  'BrowserXMLHttpRequest.readyState': 'int',
  'BrowserXMLHttpRequest.response': 'wrap',
  'BrowserXMLHttpRequest.responseText': 'string',
  'BrowserXMLHttpRequest.responseType': 'wrap',
  'BrowserXMLHttpRequest.responseURL': 'string',
  'BrowserXMLHttpRequest.responseXML': 'wrap',
  'BrowserXMLHttpRequest.send': 'void',
  'BrowserXMLHttpRequest.setRequestHeader': 'void',
  'BrowserXMLHttpRequest.status': 'int',
  'BrowserXMLHttpRequest.statusText': 'string',
  'BrowserXMLHttpRequest.timeout': 'int',
  'BrowserXMLHttpRequest.upload': 'wrap',
  'BrowserXMLHttpRequest.withCredentials': 'bool',
  'BrowserXMLSerializer.serializeToString': 'string',
  'BrowserXPathEvaluator.createExpression': 'wrap',
  'BrowserXPathEvaluator.createNSResolver': 'wrap',
  'BrowserXPathEvaluator.evaluate': 'wrap',
  'BrowserXPathExpression.evaluate': 'wrap',
  'BrowserXPathResult.booleanValue': 'bool',
  'BrowserXPathResult.invalidIteratorState': 'bool',
  'BrowserXPathResult.iterateNext': 'wrap',
  'BrowserXPathResult.numberValue': 'double',
  'BrowserXPathResult.resultType': 'int',
  'BrowserXPathResult.singleNodeValue': 'wrap',
  'BrowserXPathResult.snapshotItem': 'wrap',
  'BrowserXPathResult.snapshotLength': 'int',
  'BrowserXPathResult.stringValue': 'string',
  'BrowserXRInputSource.gamepad': 'wrap',
  'BrowserXRInputSource.gripSpace': 'wrap',
  'BrowserXRInputSource.hand': 'wrap',
  'BrowserXRInputSource.handedness': 'wrap',
  'BrowserXRInputSource.profiles': 'wrap',
  'BrowserXRInputSource.targetRayMode': 'wrap',
  'BrowserXRInputSource.targetRaySpace': 'wrap',
  'BrowserXRInputSourceEvent.frame': 'wrap',
  'BrowserXRInputSourceEvent.inputSource': 'wrap',
  'BrowserXRInputSourcesChangeEvent.added': 'wrap',
  'BrowserXRInputSourcesChangeEvent.removed': 'wrap',
  'BrowserXRInputSourcesChangeEvent.session': 'wrap',
  'BrowserXRReferenceSpace.getOffsetReferenceSpace': 'wrap',
  'BrowserXRReferenceSpace.onreset': 'jsfunction',
  'BrowserXRReferenceSpaceEvent.referenceSpace': 'wrap',
  'BrowserXRReferenceSpaceEvent.transform': 'wrap',
  'BrowserXRRigidTransform.inverse': 'wrap',
  'BrowserXRRigidTransform.matrix': 'typedArray',
  'BrowserXRRigidTransform.orientation': 'wrap',
  'BrowserXRRigidTransform.position': 'wrap',
  'BrowserXRSessionEvent.session': 'wrap',
  'BrowserXSLTProcessor.clearParameters': 'void',
  'BrowserXSLTProcessor.getParameter': 'wrap',
  'BrowserXSLTProcessor.importStylesheet': 'void',
  'BrowserXSLTProcessor.removeParameter': 'void',
  'BrowserXSLTProcessor.reset': 'void',
  'BrowserXSLTProcessor.setParameter': 'void',
  'BrowserXSLTProcessor.transformToDocument': 'wrap',
  'BrowserXSLTProcessor.transformToFragment': 'wrap',
};

/// JS property renames for IDL members whose escaped Dart name
/// differs from the actual JS name.
const Map<String, String> _jsNames = {
  'BrowserBiquadFilterNode.q': 'Q',
  'BrowserCredentialsContainer.get_': 'get',
  'BrowserCustomElementRegistry.get_': 'get',
  'BrowserDocument.url': 'URL',
  'BrowserElement.part_': 'part',
  'BrowserExternal.addSearchProvider': 'AddSearchProvider',
  'BrowserExternal.isSearchProviderInstalled': 'IsSearchProviderInstalled',
  'BrowserFormData.get_': 'get',
  'BrowserFormData.set_': 'set',
  'BrowserHTMLDialogElement.show_': 'show',
  'BrowserHTMLInputElement.required_': 'required',
  'BrowserHTMLLinkElement.as_': 'as',
  'BrowserHTMLScriptElement.async_': 'async',
  'BrowserHTMLSelectElement.required_': 'required',
  'BrowserHTMLTextAreaElement.required_': 'required',
  'BrowserHTMLTrackElement.default_': 'default',
  'BrowserHeaders.get_': 'get',
  'BrowserHeaders.set_': 'set',
  'BrowserMediaKeyStatusMap.get_': 'get',
  'BrowserPaymentRequest.show_': 'show',
  'BrowserSVGFECompositeElement.operator_': 'operator',
  'BrowserSVGFEMorphologyElement.operator_': 'operator',
  'BrowserSpeechSynthesisVoice.default_': 'default',
  'BrowserStylePropertyMap.set_': 'set',
  'BrowserStylePropertyMapReadOnly.get_': 'get',
  'BrowserURLSearchParams.get_': 'get',
  'BrowserURLSearchParams.set_': 'set',
  'BrowserWindow.external_': 'external',
};

final class BrowserAbortController extends BrowserObjectAdapter
    implements AbortController {
  BrowserAbortController(super.element);

  web.AbortController get inner => _element as web.AbortController;
}

final class BrowserAbortSignal extends BrowserObjectAdapter
    implements AbortSignal, EventTarget {
  BrowserAbortSignal(super.element);

  web.AbortSignal get inner => _element as web.AbortSignal;
}

final class BrowserAbsoluteOrientationSensor extends BrowserObjectAdapter
    implements AbsoluteOrientationSensor, OrientationSensor, Sensor, EventTarget {
  BrowserAbsoluteOrientationSensor(super.element);

  web.AbsoluteOrientationSensor get inner => _element as web.AbsoluteOrientationSensor;
}

final class BrowserAnalyserNode extends BrowserObjectAdapter
    implements AnalyserNode, AudioNode, EventTarget {
  BrowserAnalyserNode(super.element);

  web.AnalyserNode get inner => _element as web.AnalyserNode;
}

final class BrowserAnimation extends BrowserObjectAdapter
    implements Animation, EventTarget {
  BrowserAnimation(super.element);

  web.Animation get inner => _element as web.Animation;
}

final class BrowserAnimationEffect extends BrowserObjectAdapter
    implements AnimationEffect {
  BrowserAnimationEffect(super.element);

  web.AnimationEffect get inner => _element as web.AnimationEffect;
}

final class BrowserAnimationEvent extends BrowserObjectAdapter
    implements AnimationEvent, Event {
  BrowserAnimationEvent(super.element);

  web.AnimationEvent get inner => _element as web.AnimationEvent;
}

final class BrowserAnimationPlaybackEvent extends BrowserObjectAdapter
    implements AnimationPlaybackEvent, Event {
  BrowserAnimationPlaybackEvent(super.element);

  web.AnimationPlaybackEvent get inner => _element as web.AnimationPlaybackEvent;
}

final class BrowserAnimationTimeline extends BrowserObjectAdapter
    implements AnimationTimeline {
  BrowserAnimationTimeline(super.element);

  web.AnimationTimeline get inner => _element as web.AnimationTimeline;
}

final class BrowserAttr extends BrowserObjectAdapter
    implements Attr, Node, EventTarget {
  BrowserAttr(super.element);

  web.Attr get inner => _element as web.Attr;
}

final class BrowserAudioBuffer extends BrowserObjectAdapter
    implements AudioBuffer {
  BrowserAudioBuffer(super.element);

  web.AudioBuffer get inner => _element as web.AudioBuffer;
}

final class BrowserAudioBufferSourceNode extends BrowserObjectAdapter
    implements AudioBufferSourceNode, AudioNode, EventTarget {
  BrowserAudioBufferSourceNode(super.element);

  web.AudioBufferSourceNode get inner => _element as web.AudioBufferSourceNode;
}

final class BrowserAudioContext extends BrowserObjectAdapter
    implements AudioContext, BaseAudioContext, EventTarget {
  BrowserAudioContext(super.element);

  web.AudioContext get inner => _element as web.AudioContext;
}

final class BrowserAudioParam extends BrowserObjectAdapter
    implements AudioParam {
  BrowserAudioParam(super.element);

  web.AudioParam get inner => _element as web.AudioParam;
}

final class BrowserAudioParamMap extends BrowserObjectAdapter
    implements AudioParamMap {
  BrowserAudioParamMap(super.element);

  web.AudioParamMap get inner => _element as web.AudioParamMap;
}

final class BrowserAudioProcessingEvent extends BrowserObjectAdapter
    implements AudioProcessingEvent, Event {
  BrowserAudioProcessingEvent(super.element);

  web.AudioProcessingEvent get inner => _element as web.AudioProcessingEvent;
}

final class BrowserAudioTrack extends BrowserObjectAdapter
    implements AudioTrack {
  BrowserAudioTrack(super.element);

  web.AudioTrack get inner => _element as web.AudioTrack;
}

final class BrowserAudioTrackList extends BrowserObjectAdapter
    implements AudioTrackList, EventTarget {
  BrowserAudioTrackList(super.element);

  web.AudioTrackList get inner => _element as web.AudioTrackList;
}

final class BrowserAudioWorkletNode extends BrowserObjectAdapter
    implements AudioWorkletNode, AudioNode, EventTarget {
  BrowserAudioWorkletNode(super.element);

  web.AudioWorkletNode get inner => _element as web.AudioWorkletNode;
}

final class BrowserAudioWorkletProcessor extends BrowserObjectAdapter
    implements AudioWorkletProcessor {
  BrowserAudioWorkletProcessor(super.element);

  web.AudioWorkletProcessor get inner => _element as web.AudioWorkletProcessor;
}

final class BrowserBarProp extends BrowserObjectAdapter
    implements BarProp {
  BrowserBarProp(super.element);

  web.BarProp get inner => _element as web.BarProp;
}

final class BrowserBiquadFilterNode extends BrowserObjectAdapter
    implements BiquadFilterNode, AudioNode, EventTarget {
  BrowserBiquadFilterNode(super.element);

  web.BiquadFilterNode get inner => _element as web.BiquadFilterNode;
}

final class BrowserBlob extends BrowserObjectAdapter
    implements Blob {
  BrowserBlob(super.element);

  web.Blob get inner => _element as web.Blob;
}

final class BrowserBlobEvent extends BrowserObjectAdapter
    implements BlobEvent, Event {
  BrowserBlobEvent(super.element);

  web.BlobEvent get inner => _element as web.BlobEvent;
}

final class BrowserBroadcastChannel extends BrowserObjectAdapter
    implements BroadcastChannel, EventTarget {
  BrowserBroadcastChannel(super.element);

  web.BroadcastChannel get inner => _element as web.BroadcastChannel;
}

final class BrowserByteLengthQueuingStrategy extends BrowserObjectAdapter
    implements ByteLengthQueuingStrategy {
  BrowserByteLengthQueuingStrategy(super.element);

  web.ByteLengthQueuingStrategy get inner => _element as web.ByteLengthQueuingStrategy;
}

final class BrowserCDATASection extends BrowserObjectAdapter
    implements CDATASection, Text, CharacterData, Node, EventTarget {
  BrowserCDATASection(super.element);

  web.CDATASection get inner => _element as web.CDATASection;
}

final class BrowserCSSKeywordValue extends BrowserObjectAdapter
    implements CSSKeywordValue, CSSStyleValue {
  BrowserCSSKeywordValue(super.element);

  web.CSSKeywordValue get inner => _element as web.CSSKeywordValue;
}

final class BrowserCSSMathClamp extends BrowserObjectAdapter
    implements CSSMathClamp, CSSMathValue, CSSNumericValue, CSSStyleValue {
  BrowserCSSMathClamp(super.element);

  web.CSSMathClamp get inner => _element as web.CSSMathClamp;
}

final class BrowserCSSMathInvert extends BrowserObjectAdapter
    implements CSSMathInvert, CSSMathValue, CSSNumericValue, CSSStyleValue {
  BrowserCSSMathInvert(super.element);

  web.CSSMathInvert get inner => _element as web.CSSMathInvert;
}

final class BrowserCSSMathMax extends BrowserObjectAdapter
    implements CSSMathMax, CSSMathValue, CSSNumericValue, CSSStyleValue {
  BrowserCSSMathMax(super.element);

  web.CSSMathMax get inner => _element as web.CSSMathMax;
}

final class BrowserCSSMathMin extends BrowserObjectAdapter
    implements CSSMathMin, CSSMathValue, CSSNumericValue, CSSStyleValue {
  BrowserCSSMathMin(super.element);

  web.CSSMathMin get inner => _element as web.CSSMathMin;
}

final class BrowserCSSMathNegate extends BrowserObjectAdapter
    implements CSSMathNegate, CSSMathValue, CSSNumericValue, CSSStyleValue {
  BrowserCSSMathNegate(super.element);

  web.CSSMathNegate get inner => _element as web.CSSMathNegate;
}

final class BrowserCSSMathProduct extends BrowserObjectAdapter
    implements CSSMathProduct, CSSMathValue, CSSNumericValue, CSSStyleValue {
  BrowserCSSMathProduct(super.element);

  web.CSSMathProduct get inner => _element as web.CSSMathProduct;
}

final class BrowserCSSMathSum extends BrowserObjectAdapter
    implements CSSMathSum, CSSMathValue, CSSNumericValue, CSSStyleValue {
  BrowserCSSMathSum(super.element);

  web.CSSMathSum get inner => _element as web.CSSMathSum;
}

final class BrowserCSSMatrixComponent extends BrowserObjectAdapter
    implements CSSMatrixComponent, CSSTransformComponent {
  BrowserCSSMatrixComponent(super.element);

  web.CSSMatrixComponent get inner => _element as web.CSSMatrixComponent;
}

final class BrowserCSSNumericArray extends BrowserObjectAdapter
    implements CSSNumericArray {
  BrowserCSSNumericArray(super.element);

  web.CSSNumericArray get inner => _element as web.CSSNumericArray;
}

final class BrowserCSSNumericValue extends BrowserObjectAdapter
    implements CSSNumericValue, CSSStyleValue {
  BrowserCSSNumericValue(super.element);

  web.CSSNumericValue get inner => _element as web.CSSNumericValue;
}

final class BrowserCSSPerspective extends BrowserObjectAdapter
    implements CSSPerspective, CSSTransformComponent {
  BrowserCSSPerspective(super.element);

  web.CSSPerspective get inner => _element as web.CSSPerspective;
}

final class BrowserCSSRotate extends BrowserObjectAdapter
    implements CSSRotate, CSSTransformComponent {
  BrowserCSSRotate(super.element);

  web.CSSRotate get inner => _element as web.CSSRotate;
}

final class BrowserCSSRule extends BrowserObjectAdapter
    implements CSSRule {
  BrowserCSSRule(super.element);

  web.CSSRule get inner => _element as web.CSSRule;
}

final class BrowserCSSRuleList extends BrowserObjectAdapter
    implements CSSRuleList {
  BrowserCSSRuleList(super.element);

  web.CSSRuleList get inner => _element as web.CSSRuleList;
}

final class BrowserCSSScale extends BrowserObjectAdapter
    implements CSSScale, CSSTransformComponent {
  BrowserCSSScale(super.element);

  web.CSSScale get inner => _element as web.CSSScale;
}

final class BrowserCSSSkew extends BrowserObjectAdapter
    implements CSSSkew, CSSTransformComponent {
  BrowserCSSSkew(super.element);

  web.CSSSkew get inner => _element as web.CSSSkew;
}

final class BrowserCSSSkewX extends BrowserObjectAdapter
    implements CSSSkewX, CSSTransformComponent {
  BrowserCSSSkewX(super.element);

  web.CSSSkewX get inner => _element as web.CSSSkewX;
}

final class BrowserCSSSkewY extends BrowserObjectAdapter
    implements CSSSkewY, CSSTransformComponent {
  BrowserCSSSkewY(super.element);

  web.CSSSkewY get inner => _element as web.CSSSkewY;
}

final class BrowserCSSStyleDeclaration extends BrowserObjectAdapter
    implements CSSStyleDeclaration {
  BrowserCSSStyleDeclaration(super.element);

  web.CSSStyleDeclaration get inner => _element as web.CSSStyleDeclaration;
}

final class BrowserCSSStyleSheet extends BrowserObjectAdapter
    implements CSSStyleSheet, StyleSheet {
  BrowserCSSStyleSheet(super.element);

  web.CSSStyleSheet get inner => _element as web.CSSStyleSheet;
}

final class BrowserCSSStyleValue extends BrowserObjectAdapter
    implements CSSStyleValue {
  BrowserCSSStyleValue(super.element);

  web.CSSStyleValue get inner => _element as web.CSSStyleValue;
}

final class BrowserCSSTransformValue extends BrowserObjectAdapter
    implements CSSTransformValue, CSSStyleValue {
  BrowserCSSTransformValue(super.element);

  web.CSSTransformValue get inner => _element as web.CSSTransformValue;
}

final class BrowserCSSTranslate extends BrowserObjectAdapter
    implements CSSTranslate, CSSTransformComponent {
  BrowserCSSTranslate(super.element);

  web.CSSTranslate get inner => _element as web.CSSTranslate;
}

final class BrowserCSSUnitValue extends BrowserObjectAdapter
    implements CSSUnitValue, CSSNumericValue, CSSStyleValue {
  BrowserCSSUnitValue(super.element);

  web.CSSUnitValue get inner => _element as web.CSSUnitValue;
}

final class BrowserCSSUnparsedValue extends BrowserObjectAdapter
    implements CSSUnparsedValue, CSSStyleValue {
  BrowserCSSUnparsedValue(super.element);

  web.CSSUnparsedValue get inner => _element as web.CSSUnparsedValue;
}

final class BrowserCSSVariableReferenceValue extends BrowserObjectAdapter
    implements CSSVariableReferenceValue {
  BrowserCSSVariableReferenceValue(super.element);

  web.CSSVariableReferenceValue get inner => _element as web.CSSVariableReferenceValue;
}

final class BrowserCacheStorage extends BrowserObjectAdapter
    implements CacheStorage {
  BrowserCacheStorage(super.element);

  web.CacheStorage get inner => _element as web.CacheStorage;
}

final class BrowserChannelMergerNode extends BrowserObjectAdapter
    implements ChannelMergerNode, AudioNode, EventTarget {
  BrowserChannelMergerNode(super.element);

  web.ChannelMergerNode get inner => _element as web.ChannelMergerNode;
}

final class BrowserChannelSplitterNode extends BrowserObjectAdapter
    implements ChannelSplitterNode, AudioNode, EventTarget {
  BrowserChannelSplitterNode(super.element);

  web.ChannelSplitterNode get inner => _element as web.ChannelSplitterNode;
}

final class BrowserClient extends BrowserObjectAdapter
    implements Client {
  BrowserClient(super.element);

  web.Client get inner => _element as web.Client;
}

final class BrowserClipboard extends BrowserObjectAdapter
    implements Clipboard, EventTarget {
  BrowserClipboard(super.element);

  web.Clipboard get inner => _element as web.Clipboard;
}

final class BrowserClipboardEvent extends BrowserObjectAdapter
    implements ClipboardEvent, Event {
  BrowserClipboardEvent(super.element);

  web.ClipboardEvent get inner => _element as web.ClipboardEvent;
}

final class BrowserClipboardItem extends BrowserObjectAdapter
    implements ClipboardItem {
  BrowserClipboardItem(super.element);

  web.ClipboardItem get inner => _element as web.ClipboardItem;
}

final class BrowserCloseEvent extends BrowserObjectAdapter
    implements CloseEvent, Event {
  BrowserCloseEvent(super.element);

  web.CloseEvent get inner => _element as web.CloseEvent;
}

final class BrowserComment extends BrowserObjectAdapter
    implements Comment, CharacterData, Node, EventTarget {
  BrowserComment(super.element);

  web.Comment get inner => _element as web.Comment;
}

final class BrowserCompositionEvent extends BrowserObjectAdapter
    implements CompositionEvent, UIEvent, Event {
  BrowserCompositionEvent(super.element);

  web.CompositionEvent get inner => _element as web.CompositionEvent;
}

final class BrowserCompressionStream extends BrowserObjectAdapter
    implements CompressionStream {
  BrowserCompressionStream(super.element);

  web.CompressionStream get inner => _element as web.CompressionStream;
}

final class BrowserConstantSourceNode extends BrowserObjectAdapter
    implements ConstantSourceNode, AudioScheduledSourceNode, AudioNode, EventTarget {
  BrowserConstantSourceNode(super.element);

  web.ConstantSourceNode get inner => _element as web.ConstantSourceNode;
}

final class BrowserContentVisibilityAutoStateChangeEvent extends BrowserObjectAdapter
    implements ContentVisibilityAutoStateChangeEvent, Event {
  BrowserContentVisibilityAutoStateChangeEvent(super.element);

  web.ContentVisibilityAutoStateChangeEvent get inner => _element as web.ContentVisibilityAutoStateChangeEvent;
}

final class BrowserConvolverNode extends BrowserObjectAdapter
    implements ConvolverNode, AudioNode, EventTarget {
  BrowserConvolverNode(super.element);

  web.ConvolverNode get inner => _element as web.ConvolverNode;
}

final class BrowserCookieChangeEvent extends BrowserObjectAdapter
    implements CookieChangeEvent, Event {
  BrowserCookieChangeEvent(super.element);

  web.CookieChangeEvent get inner => _element as web.CookieChangeEvent;
}

final class BrowserCountQueuingStrategy extends BrowserObjectAdapter
    implements CountQueuingStrategy {
  BrowserCountQueuingStrategy(super.element);

  web.CountQueuingStrategy get inner => _element as web.CountQueuingStrategy;
}

final class BrowserCredential extends BrowserObjectAdapter
    implements Credential {
  BrowserCredential(super.element);

  web.Credential get inner => _element as web.Credential;
}

final class BrowserCredentialsContainer extends BrowserObjectAdapter
    implements CredentialsContainer {
  BrowserCredentialsContainer(super.element);

  web.CredentialsContainer get inner => _element as web.CredentialsContainer;
}

final class BrowserCrypto extends BrowserObjectAdapter
    implements Crypto {
  BrowserCrypto(super.element);

  web.Crypto get inner => _element as web.Crypto;
}

final class BrowserCryptoKey extends BrowserObjectAdapter
    implements CryptoKey {
  BrowserCryptoKey(super.element);

  web.CryptoKey get inner => _element as web.CryptoKey;
}

final class BrowserCustomElementRegistry extends BrowserObjectAdapter
    implements CustomElementRegistry {
  BrowserCustomElementRegistry(super.element);

  web.CustomElementRegistry get inner => _element as web.CustomElementRegistry;
}

final class BrowserCustomEvent extends BrowserObjectAdapter
    implements CustomEvent, Event {
  BrowserCustomEvent(super.element);

  web.CustomEvent get inner => _element as web.CustomEvent;
}

final class BrowserCustomStateSet extends BrowserObjectAdapter
    implements CustomStateSet {
  BrowserCustomStateSet(super.element);

  web.CustomStateSet get inner => _element as web.CustomStateSet;
}

final class BrowserDOMException extends BrowserObjectAdapter
    implements DOMException {
  BrowserDOMException(super.element);

  web.DOMException get inner => _element as web.DOMException;
}

final class BrowserDOMImplementation extends BrowserObjectAdapter
    implements DOMImplementation {
  BrowserDOMImplementation(super.element);

  web.DOMImplementation get inner => _element as web.DOMImplementation;
}

final class BrowserDOMMatrix extends BrowserObjectAdapter
    implements DOMMatrix {
  BrowserDOMMatrix(super.element);

  web.DOMMatrix get inner => _element as web.DOMMatrix;
}

final class BrowserDOMMatrixReadOnly extends BrowserObjectAdapter
    implements DOMMatrixReadOnly {
  BrowserDOMMatrixReadOnly(super.element);

  web.DOMMatrixReadOnly get inner => _element as web.DOMMatrixReadOnly;
}

final class BrowserDOMParser extends BrowserObjectAdapter
    implements DOMParser {
  BrowserDOMParser(super.element);

  web.DOMParser get inner => _element as web.DOMParser;
}

final class BrowserDOMPoint extends BrowserObjectAdapter
    implements DOMPoint {
  BrowserDOMPoint(super.element);

  web.DOMPoint get inner => _element as web.DOMPoint;
}

final class BrowserDOMPointReadOnly extends BrowserObjectAdapter
    implements DOMPointReadOnly {
  BrowserDOMPointReadOnly(super.element);

  web.DOMPointReadOnly get inner => _element as web.DOMPointReadOnly;
}

final class BrowserDOMQuad extends BrowserObjectAdapter
    implements DOMQuad {
  BrowserDOMQuad(super.element);

  web.DOMQuad get inner => _element as web.DOMQuad;
}

final class BrowserDOMRect extends BrowserObjectAdapter
    implements DOMRect {
  BrowserDOMRect(super.element);

  web.DOMRect get inner => _element as web.DOMRect;
}

final class BrowserDOMRectList extends BrowserObjectAdapter
    implements DOMRectList {
  BrowserDOMRectList(super.element);

  web.DOMRectList get inner => _element as web.DOMRectList;
}

final class BrowserDOMRectReadOnly extends BrowserObjectAdapter
    implements DOMRectReadOnly {
  BrowserDOMRectReadOnly(super.element);

  web.DOMRectReadOnly get inner => _element as web.DOMRectReadOnly;
}

final class BrowserDOMStringList extends BrowserObjectAdapter
    implements DOMStringList {
  BrowserDOMStringList(super.element);

  web.DOMStringList get inner => _element as web.DOMStringList;
}

final class BrowserDOMStringMap extends BrowserObjectAdapter
    implements DOMStringMap {
  BrowserDOMStringMap(super.element);

  web.DOMStringMap get inner => _element as web.DOMStringMap;
}

final class BrowserDOMTokenList extends BrowserObjectAdapter
    implements DOMTokenList {
  BrowserDOMTokenList(super.element);

  web.DOMTokenList get inner => _element as web.DOMTokenList;
}

final class BrowserDataTransfer extends BrowserObjectAdapter
    implements DataTransfer {
  BrowserDataTransfer(super.element);

  web.DataTransfer get inner => _element as web.DataTransfer;
}

final class BrowserDataTransferItem extends BrowserObjectAdapter
    implements DataTransferItem {
  BrowserDataTransferItem(super.element);

  web.DataTransferItem get inner => _element as web.DataTransferItem;
}

final class BrowserDataTransferItemList extends BrowserObjectAdapter
    implements DataTransferItemList {
  BrowserDataTransferItemList(super.element);

  web.DataTransferItemList get inner => _element as web.DataTransferItemList;
}

final class BrowserDecompressionStream extends BrowserObjectAdapter
    implements DecompressionStream {
  BrowserDecompressionStream(super.element);

  web.DecompressionStream get inner => _element as web.DecompressionStream;
}

final class BrowserDelayNode extends BrowserObjectAdapter
    implements DelayNode, AudioNode, EventTarget {
  BrowserDelayNode(super.element);

  web.DelayNode get inner => _element as web.DelayNode;
}

final class BrowserDeviceMotionEvent extends BrowserObjectAdapter
    implements DeviceMotionEvent, Event {
  BrowserDeviceMotionEvent(super.element);

  web.DeviceMotionEvent get inner => _element as web.DeviceMotionEvent;
}

final class BrowserDeviceMotionEventAcceleration extends BrowserObjectAdapter
    implements DeviceMotionEventAcceleration {
  BrowserDeviceMotionEventAcceleration(super.element);

  web.DeviceMotionEventAcceleration get inner => _element as web.DeviceMotionEventAcceleration;
}

final class BrowserDeviceMotionEventRotationRate extends BrowserObjectAdapter
    implements DeviceMotionEventRotationRate {
  BrowserDeviceMotionEventRotationRate(super.element);

  web.DeviceMotionEventRotationRate get inner => _element as web.DeviceMotionEventRotationRate;
}

final class BrowserDeviceOrientationEvent extends BrowserObjectAdapter
    implements DeviceOrientationEvent, Event {
  BrowserDeviceOrientationEvent(super.element);

  web.DeviceOrientationEvent get inner => _element as web.DeviceOrientationEvent;
}

final class BrowserDocument extends BrowserObjectAdapter
    implements Document, Node, EventTarget {
  BrowserDocument(super.element);

  web.Document get inner => _element as web.Document;
}

final class BrowserDocumentFragment extends BrowserObjectAdapter
    implements DocumentFragment, Node, EventTarget {
  BrowserDocumentFragment(super.element);

  web.DocumentFragment get inner => _element as web.DocumentFragment;
}

final class BrowserDocumentTimeline extends BrowserObjectAdapter
    implements DocumentTimeline, AnimationTimeline {
  BrowserDocumentTimeline(super.element);

  web.DocumentTimeline get inner => _element as web.DocumentTimeline;
}

final class BrowserDocumentType extends BrowserObjectAdapter
    implements DocumentType, Node, EventTarget {
  BrowserDocumentType(super.element);

  web.DocumentType get inner => _element as web.DocumentType;
}

final class BrowserDragEvent extends BrowserObjectAdapter
    implements DragEvent, MouseEvent, UIEvent, Event {
  BrowserDragEvent(super.element);

  web.DragEvent get inner => _element as web.DragEvent;
}

final class BrowserDynamicsCompressorNode extends BrowserObjectAdapter
    implements DynamicsCompressorNode, AudioNode, EventTarget {
  BrowserDynamicsCompressorNode(super.element);

  web.DynamicsCompressorNode get inner => _element as web.DynamicsCompressorNode;
}

final class BrowserElement extends BrowserObjectAdapter
    implements Element, Node, EventTarget {
  BrowserElement(super.element);

  web.Element get inner => _element as web.Element;
}

final class BrowserElementInternals extends BrowserObjectAdapter
    implements ElementInternals {
  BrowserElementInternals(super.element);

  web.ElementInternals get inner => _element as web.ElementInternals;
}

final class BrowserEncodedVideoChunk extends BrowserObjectAdapter
    implements EncodedVideoChunk {
  BrowserEncodedVideoChunk(super.element);

  web.EncodedVideoChunk get inner => _element as web.EncodedVideoChunk;
}

final class BrowserErrorEvent extends BrowserObjectAdapter
    implements ErrorEvent, Event {
  BrowserErrorEvent(super.element);

  web.ErrorEvent get inner => _element as web.ErrorEvent;
}

final class BrowserEvent extends BrowserObjectAdapter
    implements Event {
  BrowserEvent(super.element);

  web.Event get inner => _element as web.Event;
}

final class BrowserEventCounts extends BrowserObjectAdapter
    implements EventCounts {
  BrowserEventCounts(super.element);

  web.EventCounts get inner => _element as web.EventCounts;
}

final class BrowserEventSource extends BrowserObjectAdapter
    implements EventSource, EventTarget {
  BrowserEventSource(super.element);

  web.EventSource get inner => _element as web.EventSource;
}

final class BrowserEventTarget extends BrowserObjectAdapter
    implements EventTarget {
  BrowserEventTarget(super.element);

  web.EventTarget get inner => _element as web.EventTarget;
}

final class BrowserExtendableCookieChangeEvent extends BrowserObjectAdapter
    implements ExtendableCookieChangeEvent, ExtendableEvent, Event {
  BrowserExtendableCookieChangeEvent(super.element);

  web.ExtendableCookieChangeEvent get inner => _element as web.ExtendableCookieChangeEvent;
}

final class BrowserExtendableEvent extends BrowserObjectAdapter
    implements ExtendableEvent, Event {
  BrowserExtendableEvent(super.element);

  web.ExtendableEvent get inner => _element as web.ExtendableEvent;
}

final class BrowserExtendableMessageEvent extends BrowserObjectAdapter
    implements ExtendableMessageEvent, ExtendableEvent, Event {
  BrowserExtendableMessageEvent(super.element);

  web.ExtendableMessageEvent get inner => _element as web.ExtendableMessageEvent;
}

final class BrowserExternal extends BrowserObjectAdapter
    implements External {
  BrowserExternal(super.element);

  web.External get inner => _element as web.External;
}

final class BrowserFetchEvent extends BrowserObjectAdapter
    implements FetchEvent, ExtendableEvent, Event {
  BrowserFetchEvent(super.element);

  web.FetchEvent get inner => _element as web.FetchEvent;
}

final class BrowserFile extends BrowserObjectAdapter
    implements File, Blob {
  BrowserFile(super.element);

  web.File get inner => _element as web.File;
}

final class BrowserFileList extends BrowserObjectAdapter
    implements FileList {
  BrowserFileList(super.element);

  web.FileList get inner => _element as web.FileList;
}

final class BrowserFileReader extends BrowserObjectAdapter
    implements FileReader, EventTarget {
  BrowserFileReader(super.element);

  web.FileReader get inner => _element as web.FileReader;
}

final class BrowserFileReaderSync extends BrowserObjectAdapter
    implements FileReaderSync {
  BrowserFileReaderSync(super.element);

  web.FileReaderSync get inner => _element as web.FileReaderSync;
}

final class BrowserFileSystem extends BrowserObjectAdapter
    implements FileSystem {
  BrowserFileSystem(super.element);

  web.FileSystem get inner => _element as web.FileSystem;
}

final class BrowserFileSystemDirectoryEntry extends BrowserObjectAdapter
    implements FileSystemDirectoryEntry, FileSystemEntry {
  BrowserFileSystemDirectoryEntry(super.element);

  web.FileSystemDirectoryEntry get inner => _element as web.FileSystemDirectoryEntry;
}

final class BrowserFileSystemDirectoryReader extends BrowserObjectAdapter
    implements FileSystemDirectoryReader {
  BrowserFileSystemDirectoryReader(super.element);

  web.FileSystemDirectoryReader get inner => _element as web.FileSystemDirectoryReader;
}

final class BrowserFileSystemEntry extends BrowserObjectAdapter
    implements FileSystemEntry {
  BrowserFileSystemEntry(super.element);

  web.FileSystemEntry get inner => _element as web.FileSystemEntry;
}

final class BrowserFocusEvent extends BrowserObjectAdapter
    implements FocusEvent, UIEvent, Event {
  BrowserFocusEvent(super.element);

  web.FocusEvent get inner => _element as web.FocusEvent;
}

final class BrowserFontFace extends BrowserObjectAdapter
    implements FontFace {
  BrowserFontFace(super.element);

  web.FontFace get inner => _element as web.FontFace;
}

final class BrowserFontFaceSet extends BrowserObjectAdapter
    implements FontFaceSet, EventTarget {
  BrowserFontFaceSet(super.element);

  web.FontFaceSet get inner => _element as web.FontFaceSet;
}

final class BrowserFontFaceSetLoadEvent extends BrowserObjectAdapter
    implements FontFaceSetLoadEvent, Event {
  BrowserFontFaceSetLoadEvent(super.element);

  web.FontFaceSetLoadEvent get inner => _element as web.FontFaceSetLoadEvent;
}

final class BrowserFormData extends BrowserObjectAdapter
    implements FormData {
  BrowserFormData(super.element);

  web.FormData get inner => _element as web.FormData;
}

final class BrowserFormDataEvent extends BrowserObjectAdapter
    implements FormDataEvent, Event {
  BrowserFormDataEvent(super.element);

  web.FormDataEvent get inner => _element as web.FormDataEvent;
}

final class BrowserGainNode extends BrowserObjectAdapter
    implements GainNode, AudioNode, EventTarget {
  BrowserGainNode(super.element);

  web.GainNode get inner => _element as web.GainNode;
}

final class BrowserGamepad extends BrowserObjectAdapter
    implements Gamepad {
  BrowserGamepad(super.element);

  web.Gamepad get inner => _element as web.Gamepad;
}

final class BrowserGamepadEvent extends BrowserObjectAdapter
    implements GamepadEvent, Event {
  BrowserGamepadEvent(super.element);

  web.GamepadEvent get inner => _element as web.GamepadEvent;
}

final class BrowserGeolocation extends BrowserObjectAdapter
    implements Geolocation {
  BrowserGeolocation(super.element);

  web.Geolocation get inner => _element as web.Geolocation;
}

final class BrowserGravitySensor extends BrowserObjectAdapter
    implements GravitySensor {
  BrowserGravitySensor(super.element);

  web.GravitySensor get inner => _element as web.GravitySensor;
}

final class BrowserGyroscope extends BrowserObjectAdapter
    implements Gyroscope, Sensor, EventTarget {
  BrowserGyroscope(super.element);

  web.Gyroscope get inner => _element as web.Gyroscope;
}

final class BrowserHTMLAllCollection extends BrowserObjectAdapter
    implements HTMLAllCollection {
  BrowserHTMLAllCollection(super.element);

  web.HTMLAllCollection get inner => _element as web.HTMLAllCollection;
}

final class BrowserHTMLAnchorElement extends BrowserObjectAdapter
    implements HTMLAnchorElement, HTMLElement, Element, Node, EventTarget {
  BrowserHTMLAnchorElement(super.element);

  web.HTMLAnchorElement get inner => _element as web.HTMLAnchorElement;
}

final class BrowserHTMLAreaElement extends BrowserObjectAdapter
    implements HTMLAreaElement, HTMLElement, Element, Node, EventTarget {
  BrowserHTMLAreaElement(super.element);

  web.HTMLAreaElement get inner => _element as web.HTMLAreaElement;
}

final class BrowserHTMLAudioElement extends BrowserObjectAdapter
    implements HTMLAudioElement, HTMLMediaElement, HTMLElement, Element, Node, EventTarget {
  BrowserHTMLAudioElement(super.element);

  web.HTMLAudioElement get inner => _element as web.HTMLAudioElement;
}

final class BrowserHTMLBRElement extends BrowserObjectAdapter
    implements HTMLBRElement, HTMLElement, Element, Node, EventTarget {
  BrowserHTMLBRElement(super.element);

  web.HTMLBRElement get inner => _element as web.HTMLBRElement;
}

final class BrowserHTMLBaseElement extends BrowserObjectAdapter
    implements HTMLBaseElement, HTMLElement, Element, Node, EventTarget {
  BrowserHTMLBaseElement(super.element);

  web.HTMLBaseElement get inner => _element as web.HTMLBaseElement;
}

final class BrowserHTMLBodyElement extends BrowserObjectAdapter
    implements HTMLBodyElement, HTMLElement, Element, Node, EventTarget {
  BrowserHTMLBodyElement(super.element);

  web.HTMLBodyElement get inner => _element as web.HTMLBodyElement;
}

final class BrowserHTMLButtonElement extends BrowserObjectAdapter
    implements HTMLButtonElement, HTMLElement, Element, Node, EventTarget {
  BrowserHTMLButtonElement(super.element);

  web.HTMLButtonElement get inner => _element as web.HTMLButtonElement;
}

final class BrowserHTMLCanvasElement extends BrowserObjectAdapter
    implements HTMLCanvasElement, HTMLElement, Element, Node, EventTarget {
  BrowserHTMLCanvasElement(super.element);

  web.HTMLCanvasElement get inner => _element as web.HTMLCanvasElement;
}

final class BrowserHTMLCollection extends BrowserObjectAdapter
    implements HTMLCollection {
  BrowserHTMLCollection(super.element);

  web.HTMLCollection get inner => _element as web.HTMLCollection;
}

final class BrowserHTMLDListElement extends BrowserObjectAdapter
    implements HTMLDListElement, HTMLElement, Element, Node, EventTarget {
  BrowserHTMLDListElement(super.element);

  web.HTMLDListElement get inner => _element as web.HTMLDListElement;
}

final class BrowserHTMLDataElement extends BrowserObjectAdapter
    implements HTMLDataElement, HTMLElement, Element, Node, EventTarget {
  BrowserHTMLDataElement(super.element);

  web.HTMLDataElement get inner => _element as web.HTMLDataElement;
}

final class BrowserHTMLDataListElement extends BrowserObjectAdapter
    implements HTMLDataListElement, HTMLElement, Element, Node, EventTarget {
  BrowserHTMLDataListElement(super.element);

  web.HTMLDataListElement get inner => _element as web.HTMLDataListElement;
}

final class BrowserHTMLDetailsElement extends BrowserObjectAdapter
    implements HTMLDetailsElement, HTMLElement, Element, Node, EventTarget {
  BrowserHTMLDetailsElement(super.element);

  web.HTMLDetailsElement get inner => _element as web.HTMLDetailsElement;
}

final class BrowserHTMLDialogElement extends BrowserObjectAdapter
    implements HTMLDialogElement, HTMLElement, Element, Node, EventTarget {
  BrowserHTMLDialogElement(super.element);

  web.HTMLDialogElement get inner => _element as web.HTMLDialogElement;
}

final class BrowserHTMLDirectoryElement extends BrowserObjectAdapter
    implements HTMLDirectoryElement, HTMLElement, Element, Node, EventTarget {
  BrowserHTMLDirectoryElement(super.element);

  web.HTMLDirectoryElement get inner => _element as web.HTMLDirectoryElement;
}

final class BrowserHTMLDivElement extends BrowserObjectAdapter
    implements HTMLDivElement, HTMLElement, Element, Node, EventTarget {
  BrowserHTMLDivElement(super.element);

  web.HTMLDivElement get inner => _element as web.HTMLDivElement;
}

final class BrowserHTMLElement extends BrowserObjectAdapter
    implements HTMLElement, Element, Node, EventTarget {
  BrowserHTMLElement(super.element);

  web.HTMLElement get inner => _element as web.HTMLElement;
}

final class BrowserHTMLEmbedElement extends BrowserObjectAdapter
    implements HTMLEmbedElement, HTMLElement, Element, Node, EventTarget {
  BrowserHTMLEmbedElement(super.element);

  web.HTMLEmbedElement get inner => _element as web.HTMLEmbedElement;
}

final class BrowserHTMLFieldSetElement extends BrowserObjectAdapter
    implements HTMLFieldSetElement, HTMLElement, Element, Node, EventTarget {
  BrowserHTMLFieldSetElement(super.element);

  web.HTMLFieldSetElement get inner => _element as web.HTMLFieldSetElement;
}

final class BrowserHTMLFontElement extends BrowserObjectAdapter
    implements HTMLFontElement, HTMLElement, Element, Node, EventTarget {
  BrowserHTMLFontElement(super.element);

  web.HTMLFontElement get inner => _element as web.HTMLFontElement;
}

final class BrowserHTMLFormControlsCollection extends BrowserObjectAdapter
    implements HTMLFormControlsCollection {
  BrowserHTMLFormControlsCollection(super.element);

  web.HTMLFormControlsCollection get inner => _element as web.HTMLFormControlsCollection;
}

final class BrowserHTMLFormElement extends BrowserObjectAdapter
    implements HTMLFormElement, HTMLElement, Element, Node, EventTarget {
  BrowserHTMLFormElement(super.element);

  web.HTMLFormElement get inner => _element as web.HTMLFormElement;
}

final class BrowserHTMLFrameElement extends BrowserObjectAdapter
    implements HTMLFrameElement, HTMLElement, Element, Node, EventTarget {
  BrowserHTMLFrameElement(super.element);

  web.HTMLFrameElement get inner => _element as web.HTMLFrameElement;
}

final class BrowserHTMLFrameSetElement extends BrowserObjectAdapter
    implements HTMLFrameSetElement, HTMLElement, Element, Node, EventTarget {
  BrowserHTMLFrameSetElement(super.element);

  web.HTMLFrameSetElement get inner => _element as web.HTMLFrameSetElement;
}

final class BrowserHTMLHRElement extends BrowserObjectAdapter
    implements HTMLHRElement, HTMLElement, Element, Node, EventTarget {
  BrowserHTMLHRElement(super.element);

  web.HTMLHRElement get inner => _element as web.HTMLHRElement;
}

final class BrowserHTMLHeadElement extends BrowserObjectAdapter
    implements HTMLHeadElement, HTMLElement, Element, Node, EventTarget {
  BrowserHTMLHeadElement(super.element);

  web.HTMLHeadElement get inner => _element as web.HTMLHeadElement;
}

final class BrowserHTMLHeadingElement extends BrowserObjectAdapter
    implements HTMLHeadingElement, HTMLElement, Element, Node, EventTarget {
  BrowserHTMLHeadingElement(super.element);

  web.HTMLHeadingElement get inner => _element as web.HTMLHeadingElement;
}

final class BrowserHTMLHtmlElement extends BrowserObjectAdapter
    implements HTMLHtmlElement, HTMLElement, Element, Node, EventTarget {
  BrowserHTMLHtmlElement(super.element);

  web.HTMLHtmlElement get inner => _element as web.HTMLHtmlElement;
}

final class BrowserHTMLIFrameElement extends BrowserObjectAdapter
    implements HTMLIFrameElement, HTMLElement, Element, Node, EventTarget {
  BrowserHTMLIFrameElement(super.element);

  web.HTMLIFrameElement get inner => _element as web.HTMLIFrameElement;
}

final class BrowserHTMLImageElement extends BrowserObjectAdapter
    implements HTMLImageElement, HTMLElement, Element, Node, EventTarget {
  BrowserHTMLImageElement(super.element);

  web.HTMLImageElement get inner => _element as web.HTMLImageElement;
}

final class BrowserHTMLInputElement extends BrowserObjectAdapter
    implements HTMLInputElement, HTMLElement, Element, Node, EventTarget {
  BrowserHTMLInputElement(super.element);

  web.HTMLInputElement get inner => _element as web.HTMLInputElement;
}

final class BrowserHTMLLIElement extends BrowserObjectAdapter
    implements HTMLLIElement, HTMLElement, Element, Node, EventTarget {
  BrowserHTMLLIElement(super.element);

  web.HTMLLIElement get inner => _element as web.HTMLLIElement;
}

final class BrowserHTMLLabelElement extends BrowserObjectAdapter
    implements HTMLLabelElement, HTMLElement, Element, Node, EventTarget {
  BrowserHTMLLabelElement(super.element);

  web.HTMLLabelElement get inner => _element as web.HTMLLabelElement;
}

final class BrowserHTMLLegendElement extends BrowserObjectAdapter
    implements HTMLLegendElement, HTMLElement, Element, Node, EventTarget {
  BrowserHTMLLegendElement(super.element);

  web.HTMLLegendElement get inner => _element as web.HTMLLegendElement;
}

final class BrowserHTMLLinkElement extends BrowserObjectAdapter
    implements HTMLLinkElement, HTMLElement, Element, Node, EventTarget {
  BrowserHTMLLinkElement(super.element);

  web.HTMLLinkElement get inner => _element as web.HTMLLinkElement;
}

final class BrowserHTMLMapElement extends BrowserObjectAdapter
    implements HTMLMapElement, HTMLElement, Element, Node, EventTarget {
  BrowserHTMLMapElement(super.element);

  web.HTMLMapElement get inner => _element as web.HTMLMapElement;
}

final class BrowserHTMLMarqueeElement extends BrowserObjectAdapter
    implements HTMLMarqueeElement, HTMLElement, Element, Node, EventTarget {
  BrowserHTMLMarqueeElement(super.element);

  web.HTMLMarqueeElement get inner => _element as web.HTMLMarqueeElement;
}

final class BrowserHTMLMediaElement extends BrowserObjectAdapter
    implements HTMLMediaElement, HTMLElement, Element, Node, EventTarget {
  BrowserHTMLMediaElement(super.element);

  web.HTMLMediaElement get inner => _element as web.HTMLMediaElement;
}

final class BrowserHTMLMenuElement extends BrowserObjectAdapter
    implements HTMLMenuElement, HTMLElement, Element, Node, EventTarget {
  BrowserHTMLMenuElement(super.element);

  web.HTMLMenuElement get inner => _element as web.HTMLMenuElement;
}

final class BrowserHTMLMetaElement extends BrowserObjectAdapter
    implements HTMLMetaElement, HTMLElement, Element, Node, EventTarget {
  BrowserHTMLMetaElement(super.element);

  web.HTMLMetaElement get inner => _element as web.HTMLMetaElement;
}

final class BrowserHTMLMeterElement extends BrowserObjectAdapter
    implements HTMLMeterElement, HTMLElement, Element, Node, EventTarget {
  BrowserHTMLMeterElement(super.element);

  web.HTMLMeterElement get inner => _element as web.HTMLMeterElement;
}

final class BrowserHTMLModElement extends BrowserObjectAdapter
    implements HTMLModElement, HTMLElement, Element, Node, EventTarget {
  BrowserHTMLModElement(super.element);

  web.HTMLModElement get inner => _element as web.HTMLModElement;
}

final class BrowserHTMLOListElement extends BrowserObjectAdapter
    implements HTMLOListElement, HTMLElement, Element, Node, EventTarget {
  BrowserHTMLOListElement(super.element);

  web.HTMLOListElement get inner => _element as web.HTMLOListElement;
}

final class BrowserHTMLObjectElement extends BrowserObjectAdapter
    implements HTMLObjectElement, HTMLElement, Element, Node, EventTarget {
  BrowserHTMLObjectElement(super.element);

  web.HTMLObjectElement get inner => _element as web.HTMLObjectElement;
}

final class BrowserHTMLOptGroupElement extends BrowserObjectAdapter
    implements HTMLOptGroupElement, HTMLElement, Element, Node, EventTarget {
  BrowserHTMLOptGroupElement(super.element);

  web.HTMLOptGroupElement get inner => _element as web.HTMLOptGroupElement;
}

final class BrowserHTMLOptionElement extends BrowserObjectAdapter
    implements HTMLOptionElement, HTMLElement, Element, Node, EventTarget {
  BrowserHTMLOptionElement(super.element);

  web.HTMLOptionElement get inner => _element as web.HTMLOptionElement;
}

final class BrowserHTMLOptionsCollection extends BrowserObjectAdapter
    implements HTMLOptionsCollection {
  BrowserHTMLOptionsCollection(super.element);

  web.HTMLOptionsCollection get inner => _element as web.HTMLOptionsCollection;
}

final class BrowserHTMLOutputElement extends BrowserObjectAdapter
    implements HTMLOutputElement, HTMLElement, Element, Node, EventTarget {
  BrowserHTMLOutputElement(super.element);

  web.HTMLOutputElement get inner => _element as web.HTMLOutputElement;
}

final class BrowserHTMLParagraphElement extends BrowserObjectAdapter
    implements HTMLParagraphElement, HTMLElement, Element, Node, EventTarget {
  BrowserHTMLParagraphElement(super.element);

  web.HTMLParagraphElement get inner => _element as web.HTMLParagraphElement;
}

final class BrowserHTMLParamElement extends BrowserObjectAdapter
    implements HTMLParamElement, HTMLElement, Element, Node, EventTarget {
  BrowserHTMLParamElement(super.element);

  web.HTMLParamElement get inner => _element as web.HTMLParamElement;
}

final class BrowserHTMLPictureElement extends BrowserObjectAdapter
    implements HTMLPictureElement, HTMLElement, Element, Node, EventTarget {
  BrowserHTMLPictureElement(super.element);

  web.HTMLPictureElement get inner => _element as web.HTMLPictureElement;
}

final class BrowserHTMLPreElement extends BrowserObjectAdapter
    implements HTMLPreElement, HTMLElement, Element, Node, EventTarget {
  BrowserHTMLPreElement(super.element);

  web.HTMLPreElement get inner => _element as web.HTMLPreElement;
}

final class BrowserHTMLProgressElement extends BrowserObjectAdapter
    implements HTMLProgressElement, HTMLElement, Element, Node, EventTarget {
  BrowserHTMLProgressElement(super.element);

  web.HTMLProgressElement get inner => _element as web.HTMLProgressElement;
}

final class BrowserHTMLQuoteElement extends BrowserObjectAdapter
    implements HTMLQuoteElement, HTMLElement, Element, Node, EventTarget {
  BrowserHTMLQuoteElement(super.element);

  web.HTMLQuoteElement get inner => _element as web.HTMLQuoteElement;
}

final class BrowserHTMLScriptElement extends BrowserObjectAdapter
    implements HTMLScriptElement, HTMLElement, Element, Node, EventTarget {
  BrowserHTMLScriptElement(super.element);

  web.HTMLScriptElement get inner => _element as web.HTMLScriptElement;
}

final class BrowserHTMLSelectElement extends BrowserObjectAdapter
    implements HTMLSelectElement, HTMLElement, Node, EventTarget {
  BrowserHTMLSelectElement(super.element);

  web.HTMLSelectElement get inner => _element as web.HTMLSelectElement;
}

final class BrowserHTMLSlotElement extends BrowserObjectAdapter
    implements HTMLSlotElement, HTMLElement, Element, Node, EventTarget {
  BrowserHTMLSlotElement(super.element);

  web.HTMLSlotElement get inner => _element as web.HTMLSlotElement;
}

final class BrowserHTMLSourceElement extends BrowserObjectAdapter
    implements HTMLSourceElement, HTMLElement, Element, Node, EventTarget {
  BrowserHTMLSourceElement(super.element);

  web.HTMLSourceElement get inner => _element as web.HTMLSourceElement;
}

final class BrowserHTMLSpanElement extends BrowserObjectAdapter
    implements HTMLSpanElement, HTMLElement, Element, Node, EventTarget {
  BrowserHTMLSpanElement(super.element);

  web.HTMLSpanElement get inner => _element as web.HTMLSpanElement;
}

final class BrowserHTMLStyleElement extends BrowserObjectAdapter
    implements HTMLStyleElement, HTMLElement, Element, Node, EventTarget {
  BrowserHTMLStyleElement(super.element);

  web.HTMLStyleElement get inner => _element as web.HTMLStyleElement;
}

final class BrowserHTMLTableCaptionElement extends BrowserObjectAdapter
    implements HTMLTableCaptionElement, HTMLElement, Element, Node, EventTarget {
  BrowserHTMLTableCaptionElement(super.element);

  web.HTMLTableCaptionElement get inner => _element as web.HTMLTableCaptionElement;
}

final class BrowserHTMLTableCellElement extends BrowserObjectAdapter
    implements HTMLTableCellElement, HTMLElement, Element, Node, EventTarget {
  BrowserHTMLTableCellElement(super.element);

  web.HTMLTableCellElement get inner => _element as web.HTMLTableCellElement;
}

final class BrowserHTMLTableColElement extends BrowserObjectAdapter
    implements HTMLTableColElement, HTMLElement, Element, Node, EventTarget {
  BrowserHTMLTableColElement(super.element);

  web.HTMLTableColElement get inner => _element as web.HTMLTableColElement;
}

final class BrowserHTMLTableElement extends BrowserObjectAdapter
    implements HTMLTableElement, HTMLElement, Element, Node, EventTarget {
  BrowserHTMLTableElement(super.element);

  web.HTMLTableElement get inner => _element as web.HTMLTableElement;
}

final class BrowserHTMLTableRowElement extends BrowserObjectAdapter
    implements HTMLTableRowElement, HTMLElement, Element, Node, EventTarget {
  BrowserHTMLTableRowElement(super.element);

  web.HTMLTableRowElement get inner => _element as web.HTMLTableRowElement;
}

final class BrowserHTMLTableSectionElement extends BrowserObjectAdapter
    implements HTMLTableSectionElement, HTMLElement, Element, Node, EventTarget {
  BrowserHTMLTableSectionElement(super.element);

  web.HTMLTableSectionElement get inner => _element as web.HTMLTableSectionElement;
}

final class BrowserHTMLTemplateElement extends BrowserObjectAdapter
    implements HTMLTemplateElement, HTMLElement, Element, Node, EventTarget {
  BrowserHTMLTemplateElement(super.element);

  web.HTMLTemplateElement get inner => _element as web.HTMLTemplateElement;
}

final class BrowserHTMLTextAreaElement extends BrowserObjectAdapter
    implements HTMLTextAreaElement, HTMLElement, Element, Node, EventTarget {
  BrowserHTMLTextAreaElement(super.element);

  web.HTMLTextAreaElement get inner => _element as web.HTMLTextAreaElement;
}

final class BrowserHTMLTimeElement extends BrowserObjectAdapter
    implements HTMLTimeElement, HTMLElement, Element, Node, EventTarget {
  BrowserHTMLTimeElement(super.element);

  web.HTMLTimeElement get inner => _element as web.HTMLTimeElement;
}

final class BrowserHTMLTitleElement extends BrowserObjectAdapter
    implements HTMLTitleElement, HTMLElement, Element, Node, EventTarget {
  BrowserHTMLTitleElement(super.element);

  web.HTMLTitleElement get inner => _element as web.HTMLTitleElement;
}

final class BrowserHTMLTrackElement extends BrowserObjectAdapter
    implements HTMLTrackElement, HTMLElement, Element, Node, EventTarget {
  BrowserHTMLTrackElement(super.element);

  web.HTMLTrackElement get inner => _element as web.HTMLTrackElement;
}

final class BrowserHTMLUListElement extends BrowserObjectAdapter
    implements HTMLUListElement, HTMLElement, Element, Node, EventTarget {
  BrowserHTMLUListElement(super.element);

  web.HTMLUListElement get inner => _element as web.HTMLUListElement;
}

final class BrowserHTMLUnknownElement extends BrowserObjectAdapter
    implements HTMLUnknownElement, HTMLElement, Element, Node, EventTarget {
  BrowserHTMLUnknownElement(super.element);

  web.HTMLUnknownElement get inner => _element as web.HTMLUnknownElement;
}

final class BrowserHTMLVideoElement extends BrowserObjectAdapter
    implements HTMLVideoElement, HTMLMediaElement, HTMLElement, Element, Node, EventTarget {
  BrowserHTMLVideoElement(super.element);

  web.HTMLVideoElement get inner => _element as web.HTMLVideoElement;
}

final class BrowserHashChangeEvent extends BrowserObjectAdapter
    implements HashChangeEvent, Event {
  BrowserHashChangeEvent(super.element);

  web.HashChangeEvent get inner => _element as web.HashChangeEvent;
}

final class BrowserHeaders extends BrowserObjectAdapter
    implements Headers {
  BrowserHeaders(super.element);

  web.Headers get inner => _element as web.Headers;
}

final class BrowserHighlight extends BrowserObjectAdapter
    implements Highlight {
  BrowserHighlight(super.element);

  web.Highlight get inner => _element as web.Highlight;
}

final class BrowserHistory extends BrowserObjectAdapter
    implements History {
  BrowserHistory(super.element);

  web.History get inner => _element as web.History;
}

final class BrowserIDBFactory extends BrowserObjectAdapter
    implements IDBFactory {
  BrowserIDBFactory(super.element);

  web.IDBFactory get inner => _element as web.IDBFactory;
}

final class BrowserIDBOpenDBRequest extends BrowserObjectAdapter
    implements IDBOpenDBRequest, IDBRequest, EventTarget {
  BrowserIDBOpenDBRequest(super.element);

  web.IDBOpenDBRequest get inner => _element as web.IDBOpenDBRequest;
}

final class BrowserIDBVersionChangeEvent extends BrowserObjectAdapter
    implements IDBVersionChangeEvent, Event {
  BrowserIDBVersionChangeEvent(super.element);

  web.IDBVersionChangeEvent get inner => _element as web.IDBVersionChangeEvent;
}

final class BrowserIIRFilterNode extends BrowserObjectAdapter
    implements IIRFilterNode, AudioNode, EventTarget {
  BrowserIIRFilterNode(super.element);

  web.IIRFilterNode get inner => _element as web.IIRFilterNode;
}

final class BrowserImageBitmap extends BrowserObjectAdapter
    implements ImageBitmap {
  BrowserImageBitmap(super.element);

  web.ImageBitmap get inner => _element as web.ImageBitmap;
}

final class BrowserImageData extends BrowserObjectAdapter
    implements ImageData {
  BrowserImageData(super.element);

  web.ImageData get inner => _element as web.ImageData;
}

final class BrowserInputEvent extends BrowserObjectAdapter
    implements InputEvent, UIEvent, Event {
  BrowserInputEvent(super.element);

  web.InputEvent get inner => _element as web.InputEvent;
}

final class BrowserIntersectionObserver extends BrowserObjectAdapter
    implements IntersectionObserver {
  BrowserIntersectionObserver(super.element);

  web.IntersectionObserver get inner => _element as web.IntersectionObserver;
}

final class BrowserIntersectionObserverEntry extends BrowserObjectAdapter
    implements IntersectionObserverEntry {
  BrowserIntersectionObserverEntry(super.element);

  web.IntersectionObserverEntry get inner => _element as web.IntersectionObserverEntry;
}

final class BrowserKeyboardEvent extends BrowserObjectAdapter
    implements KeyboardEvent, UIEvent, Event {
  BrowserKeyboardEvent(super.element);

  web.KeyboardEvent get inner => _element as web.KeyboardEvent;
}

final class BrowserKeyframeEffect extends BrowserObjectAdapter
    implements KeyframeEffect, AnimationEffect {
  BrowserKeyframeEffect(super.element);

  web.KeyframeEffect get inner => _element as web.KeyframeEffect;
}

final class BrowserLinearAccelerationSensor extends BrowserObjectAdapter
    implements LinearAccelerationSensor {
  BrowserLinearAccelerationSensor(super.element);

  web.LinearAccelerationSensor get inner => _element as web.LinearAccelerationSensor;
}

final class BrowserLocation extends BrowserObjectAdapter
    implements Location {
  BrowserLocation(super.element);

  web.Location get inner => _element as web.Location;
}

final class BrowserLockManager extends BrowserObjectAdapter
    implements LockManager {
  BrowserLockManager(super.element);

  web.LockManager get inner => _element as web.LockManager;
}

final class BrowserMIDIConnectionEvent extends BrowserObjectAdapter
    implements MIDIConnectionEvent, Event {
  BrowserMIDIConnectionEvent(super.element);

  web.MIDIConnectionEvent get inner => _element as web.MIDIConnectionEvent;
}

final class BrowserMIDIMessageEvent extends BrowserObjectAdapter
    implements MIDIMessageEvent, Event {
  BrowserMIDIMessageEvent(super.element);

  web.MIDIMessageEvent get inner => _element as web.MIDIMessageEvent;
}

final class BrowserMIDIPort extends BrowserObjectAdapter
    implements MIDIPort, EventTarget {
  BrowserMIDIPort(super.element);

  web.MIDIPort get inner => _element as web.MIDIPort;
}

final class BrowserMathMLElement extends BrowserObjectAdapter
    implements MathMLElement, Element, Node, EventTarget {
  BrowserMathMLElement(super.element);

  web.MathMLElement get inner => _element as web.MathMLElement;
}

final class BrowserMediaCapabilities extends BrowserObjectAdapter
    implements MediaCapabilities {
  BrowserMediaCapabilities(super.element);

  web.MediaCapabilities get inner => _element as web.MediaCapabilities;
}

final class BrowserMediaDevices extends BrowserObjectAdapter
    implements MediaDevices, EventTarget {
  BrowserMediaDevices(super.element);

  web.MediaDevices get inner => _element as web.MediaDevices;
}

final class BrowserMediaElementAudioSourceNode extends BrowserObjectAdapter
    implements MediaElementAudioSourceNode, AudioNode, EventTarget {
  BrowserMediaElementAudioSourceNode(super.element);

  web.MediaElementAudioSourceNode get inner => _element as web.MediaElementAudioSourceNode;
}

final class BrowserMediaEncryptedEvent extends BrowserObjectAdapter
    implements MediaEncryptedEvent, Event {
  BrowserMediaEncryptedEvent(super.element);

  web.MediaEncryptedEvent get inner => _element as web.MediaEncryptedEvent;
}

final class BrowserMediaError extends BrowserObjectAdapter
    implements MediaError {
  BrowserMediaError(super.element);

  web.MediaError get inner => _element as web.MediaError;
}

final class BrowserMediaKeyMessageEvent extends BrowserObjectAdapter
    implements MediaKeyMessageEvent, Event {
  BrowserMediaKeyMessageEvent(super.element);

  web.MediaKeyMessageEvent get inner => _element as web.MediaKeyMessageEvent;
}

final class BrowserMediaKeySession extends BrowserObjectAdapter
    implements MediaKeySession, EventTarget {
  BrowserMediaKeySession(super.element);

  web.MediaKeySession get inner => _element as web.MediaKeySession;
}

final class BrowserMediaKeyStatusMap extends BrowserObjectAdapter
    implements MediaKeyStatusMap {
  BrowserMediaKeyStatusMap(super.element);

  web.MediaKeyStatusMap get inner => _element as web.MediaKeyStatusMap;
}

final class BrowserMediaKeys extends BrowserObjectAdapter
    implements MediaKeys {
  BrowserMediaKeys(super.element);

  web.MediaKeys get inner => _element as web.MediaKeys;
}

final class BrowserMediaMetadata extends BrowserObjectAdapter
    implements MediaMetadata {
  BrowserMediaMetadata(super.element);

  web.MediaMetadata get inner => _element as web.MediaMetadata;
}

final class BrowserMediaQueryList extends BrowserObjectAdapter
    implements MediaQueryList, EventTarget {
  BrowserMediaQueryList(super.element);

  web.MediaQueryList get inner => _element as web.MediaQueryList;
}

final class BrowserMediaQueryListEvent extends BrowserObjectAdapter
    implements MediaQueryListEvent, Event {
  BrowserMediaQueryListEvent(super.element);

  web.MediaQueryListEvent get inner => _element as web.MediaQueryListEvent;
}

final class BrowserMediaRecorder extends BrowserObjectAdapter
    implements MediaRecorder, EventTarget {
  BrowserMediaRecorder(super.element);

  web.MediaRecorder get inner => _element as web.MediaRecorder;
}

final class BrowserMediaSession extends BrowserObjectAdapter
    implements MediaSession {
  BrowserMediaSession(super.element);

  web.MediaSession get inner => _element as web.MediaSession;
}

final class BrowserMediaSource extends BrowserObjectAdapter
    implements MediaSource, EventTarget {
  BrowserMediaSource(super.element);

  web.MediaSource get inner => _element as web.MediaSource;
}

final class BrowserMediaSourceHandle extends BrowserObjectAdapter
    implements MediaSourceHandle {
  BrowserMediaSourceHandle(super.element);

  web.MediaSourceHandle get inner => _element as web.MediaSourceHandle;
}

final class BrowserMediaStream extends BrowserObjectAdapter
    implements MediaStream, EventTarget {
  BrowserMediaStream(super.element);

  web.MediaStream get inner => _element as web.MediaStream;
}

final class BrowserMediaStreamAudioDestinationNode extends BrowserObjectAdapter
    implements MediaStreamAudioDestinationNode, AudioNode, EventTarget {
  BrowserMediaStreamAudioDestinationNode(super.element);

  web.MediaStreamAudioDestinationNode get inner => _element as web.MediaStreamAudioDestinationNode;
}

final class BrowserMediaStreamAudioSourceNode extends BrowserObjectAdapter
    implements MediaStreamAudioSourceNode, AudioNode, EventTarget {
  BrowserMediaStreamAudioSourceNode(super.element);

  web.MediaStreamAudioSourceNode get inner => _element as web.MediaStreamAudioSourceNode;
}

final class BrowserMediaStreamTrack extends BrowserObjectAdapter
    implements MediaStreamTrack, EventTarget {
  BrowserMediaStreamTrack(super.element);

  web.MediaStreamTrack get inner => _element as web.MediaStreamTrack;
}

final class BrowserMediaStreamTrackAudioSourceNode extends BrowserObjectAdapter
    implements MediaStreamTrackAudioSourceNode, AudioNode, EventTarget {
  BrowserMediaStreamTrackAudioSourceNode(super.element);

  web.MediaStreamTrackAudioSourceNode get inner => _element as web.MediaStreamTrackAudioSourceNode;
}

final class BrowserMediaStreamTrackEvent extends BrowserObjectAdapter
    implements MediaStreamTrackEvent, Event {
  BrowserMediaStreamTrackEvent(super.element);

  web.MediaStreamTrackEvent get inner => _element as web.MediaStreamTrackEvent;
}

final class BrowserMediaStreamTrackProcessor extends BrowserObjectAdapter
    implements MediaStreamTrackProcessor {
  BrowserMediaStreamTrackProcessor(super.element);

  web.MediaStreamTrackProcessor get inner => _element as web.MediaStreamTrackProcessor;
}

final class BrowserMessageChannel extends BrowserObjectAdapter
    implements MessageChannel {
  BrowserMessageChannel(super.element);

  web.MessageChannel get inner => _element as web.MessageChannel;
}

final class BrowserMessageEvent extends BrowserObjectAdapter
    implements MessageEvent, Event {
  BrowserMessageEvent(super.element);

  web.MessageEvent get inner => _element as web.MessageEvent;
}

final class BrowserMessagePort extends BrowserObjectAdapter
    implements MessagePort, EventTarget {
  BrowserMessagePort(super.element);

  web.MessagePort get inner => _element as web.MessagePort;
}

final class BrowserMimeType extends BrowserObjectAdapter
    implements MimeType {
  BrowserMimeType(super.element);

  web.MimeType get inner => _element as web.MimeType;
}

final class BrowserMimeTypeArray extends BrowserObjectAdapter
    implements MimeTypeArray {
  BrowserMimeTypeArray(super.element);

  web.MimeTypeArray get inner => _element as web.MimeTypeArray;
}

final class BrowserMouseEvent extends BrowserObjectAdapter
    implements MouseEvent, UIEvent, Event {
  BrowserMouseEvent(super.element);

  web.MouseEvent get inner => _element as web.MouseEvent;
}

final class BrowserMutationObserver extends BrowserObjectAdapter
    implements MutationObserver {
  BrowserMutationObserver(super.element);

  web.MutationObserver get inner => _element as web.MutationObserver;
}

final class BrowserNamedNodeMap extends BrowserObjectAdapter
    implements NamedNodeMap {
  BrowserNamedNodeMap(super.element);

  web.NamedNodeMap get inner => _element as web.NamedNodeMap;
}

final class BrowserNavigator extends BrowserObjectAdapter
    implements Navigator {
  BrowserNavigator(super.element);

  web.Navigator get inner => _element as web.Navigator;
}

final class BrowserNetworkInformation extends BrowserObjectAdapter
    implements NetworkInformation, EventTarget {
  BrowserNetworkInformation(super.element);

  web.NetworkInformation get inner => _element as web.NetworkInformation;
}

final class BrowserNode extends BrowserObjectAdapter
    implements Node, EventTarget {
  BrowserNode(super.element);

  web.Node get inner => _element as web.Node;
}

final class BrowserNodeIterator extends BrowserObjectAdapter
    implements NodeIterator {
  BrowserNodeIterator(super.element);

  web.NodeIterator get inner => _element as web.NodeIterator;
}

final class BrowserNodeList extends BrowserObjectAdapter
    implements NodeList {
  BrowserNodeList(super.element);

  web.NodeList get inner => _element as web.NodeList;
}

final class BrowserNotification extends BrowserObjectAdapter
    implements Notification, EventTarget {
  BrowserNotification(super.element);

  web.Notification get inner => _element as web.Notification;
}

final class BrowserNotificationEvent extends BrowserObjectAdapter
    implements NotificationEvent, ExtendableEvent, Event {
  BrowserNotificationEvent(super.element);

  web.NotificationEvent get inner => _element as web.NotificationEvent;
}

final class BrowserOfflineAudioCompletionEvent extends BrowserObjectAdapter
    implements OfflineAudioCompletionEvent, Event {
  BrowserOfflineAudioCompletionEvent(super.element);

  web.OfflineAudioCompletionEvent get inner => _element as web.OfflineAudioCompletionEvent;
}

final class BrowserOfflineAudioContext extends BrowserObjectAdapter
    implements OfflineAudioContext, BaseAudioContext, EventTarget {
  BrowserOfflineAudioContext(super.element);

  web.OfflineAudioContext get inner => _element as web.OfflineAudioContext;
}

final class BrowserOffscreenCanvas extends BrowserObjectAdapter
    implements OffscreenCanvas, EventTarget {
  BrowserOffscreenCanvas(super.element);

  web.OffscreenCanvas get inner => _element as web.OffscreenCanvas;
}

final class BrowserOscillatorNode extends BrowserObjectAdapter
    implements OscillatorNode, AudioScheduledSourceNode, AudioNode, EventTarget {
  BrowserOscillatorNode(super.element);

  web.OscillatorNode get inner => _element as web.OscillatorNode;
}

final class BrowserOverconstrainedError extends BrowserObjectAdapter
    implements OverconstrainedError, DOMException {
  BrowserOverconstrainedError(super.element);

  web.OverconstrainedError get inner => _element as web.OverconstrainedError;
}

final class BrowserPageTransitionEvent extends BrowserObjectAdapter
    implements PageTransitionEvent, Event {
  BrowserPageTransitionEvent(super.element);

  web.PageTransitionEvent get inner => _element as web.PageTransitionEvent;
}

final class BrowserPannerNode extends BrowserObjectAdapter
    implements PannerNode, AudioNode, EventTarget {
  BrowserPannerNode(super.element);

  web.PannerNode get inner => _element as web.PannerNode;
}

final class BrowserPath2D extends BrowserObjectAdapter
    implements Path2D {
  BrowserPath2D(super.element);

  web.Path2D get inner => _element as web.Path2D;
}

final class BrowserPaymentMethodChangeEvent extends BrowserObjectAdapter
    implements PaymentMethodChangeEvent, PaymentRequestUpdateEvent, Event {
  BrowserPaymentMethodChangeEvent(super.element);

  web.PaymentMethodChangeEvent get inner => _element as web.PaymentMethodChangeEvent;
}

final class BrowserPaymentRequest extends BrowserObjectAdapter
    implements PaymentRequest, EventTarget {
  BrowserPaymentRequest(super.element);

  web.PaymentRequest get inner => _element as web.PaymentRequest;
}

final class BrowserPaymentRequestUpdateEvent extends BrowserObjectAdapter
    implements PaymentRequestUpdateEvent, Event {
  BrowserPaymentRequestUpdateEvent(super.element);

  web.PaymentRequestUpdateEvent get inner => _element as web.PaymentRequestUpdateEvent;
}

final class BrowserPerformance extends BrowserObjectAdapter
    implements Performance, EventTarget {
  BrowserPerformance(super.element);

  web.Performance get inner => _element as web.Performance;
}

final class BrowserPerformanceMark extends BrowserObjectAdapter
    implements PerformanceMark, PerformanceEntry {
  BrowserPerformanceMark(super.element);

  web.PerformanceMark get inner => _element as web.PerformanceMark;
}

final class BrowserPerformanceMeasure extends BrowserObjectAdapter
    implements PerformanceMeasure, PerformanceEntry {
  BrowserPerformanceMeasure(super.element);

  web.PerformanceMeasure get inner => _element as web.PerformanceMeasure;
}

final class BrowserPerformanceNavigation extends BrowserObjectAdapter
    implements PerformanceNavigation {
  BrowserPerformanceNavigation(super.element);

  web.PerformanceNavigation get inner => _element as web.PerformanceNavigation;
}

final class BrowserPerformanceObserver extends BrowserObjectAdapter
    implements PerformanceObserver {
  BrowserPerformanceObserver(super.element);

  web.PerformanceObserver get inner => _element as web.PerformanceObserver;
}

final class BrowserPerformanceTiming extends BrowserObjectAdapter
    implements PerformanceTiming {
  BrowserPerformanceTiming(super.element);

  web.PerformanceTiming get inner => _element as web.PerformanceTiming;
}

final class BrowserPeriodicWave extends BrowserObjectAdapter
    implements PeriodicWave {
  BrowserPeriodicWave(super.element);

  web.PeriodicWave get inner => _element as web.PeriodicWave;
}

final class BrowserPermissions extends BrowserObjectAdapter
    implements Permissions {
  BrowserPermissions(super.element);

  web.Permissions get inner => _element as web.Permissions;
}

final class BrowserPictureInPictureEvent extends BrowserObjectAdapter
    implements PictureInPictureEvent, Event {
  BrowserPictureInPictureEvent(super.element);

  web.PictureInPictureEvent get inner => _element as web.PictureInPictureEvent;
}

final class BrowserPictureInPictureWindow extends BrowserObjectAdapter
    implements PictureInPictureWindow, EventTarget {
  BrowserPictureInPictureWindow(super.element);

  web.PictureInPictureWindow get inner => _element as web.PictureInPictureWindow;
}

final class BrowserPlugin extends BrowserObjectAdapter
    implements Plugin {
  BrowserPlugin(super.element);

  web.Plugin get inner => _element as web.Plugin;
}

final class BrowserPluginArray extends BrowserObjectAdapter
    implements PluginArray {
  BrowserPluginArray(super.element);

  web.PluginArray get inner => _element as web.PluginArray;
}

final class BrowserPointerEvent extends BrowserObjectAdapter
    implements PointerEvent, MouseEvent, UIEvent, Event {
  BrowserPointerEvent(super.element);

  web.PointerEvent get inner => _element as web.PointerEvent;
}

final class BrowserPopStateEvent extends BrowserObjectAdapter
    implements PopStateEvent, Event {
  BrowserPopStateEvent(super.element);

  web.PopStateEvent get inner => _element as web.PopStateEvent;
}

final class BrowserProcessingInstruction extends BrowserObjectAdapter
    implements ProcessingInstruction, CharacterData, Node, EventTarget {
  BrowserProcessingInstruction(super.element);

  web.ProcessingInstruction get inner => _element as web.ProcessingInstruction;
}

final class BrowserProgressEvent extends BrowserObjectAdapter
    implements ProgressEvent, Event {
  BrowserProgressEvent(super.element);

  web.ProgressEvent get inner => _element as web.ProgressEvent;
}

final class BrowserPromiseRejectionEvent extends BrowserObjectAdapter
    implements PromiseRejectionEvent, Event {
  BrowserPromiseRejectionEvent(super.element);

  web.PromiseRejectionEvent get inner => _element as web.PromiseRejectionEvent;
}

final class BrowserPushEvent extends BrowserObjectAdapter
    implements PushEvent, ExtendableEvent, Event {
  BrowserPushEvent(super.element);

  web.PushEvent get inner => _element as web.PushEvent;
}

final class BrowserPushMessageData extends BrowserObjectAdapter
    implements PushMessageData {
  BrowserPushMessageData(super.element);

  web.PushMessageData get inner => _element as web.PushMessageData;
}

final class BrowserPushSubscription extends BrowserObjectAdapter
    implements PushSubscription {
  BrowserPushSubscription(super.element);

  web.PushSubscription get inner => _element as web.PushSubscription;
}

final class BrowserPushSubscriptionChangeEvent extends BrowserObjectAdapter
    implements PushSubscriptionChangeEvent, ExtendableEvent, Event {
  BrowserPushSubscriptionChangeEvent(super.element);

  web.PushSubscriptionChangeEvent get inner => _element as web.PushSubscriptionChangeEvent;
}

final class BrowserPushSubscriptionOptions extends BrowserObjectAdapter
    implements PushSubscriptionOptions {
  BrowserPushSubscriptionOptions(super.element);

  web.PushSubscriptionOptions get inner => _element as web.PushSubscriptionOptions;
}

final class BrowserRTCDTMFSender extends BrowserObjectAdapter
    implements RTCDTMFSender, EventTarget {
  BrowserRTCDTMFSender(super.element);

  web.RTCDTMFSender get inner => _element as web.RTCDTMFSender;
}

final class BrowserRTCDTMFToneChangeEvent extends BrowserObjectAdapter
    implements RTCDTMFToneChangeEvent, Event {
  BrowserRTCDTMFToneChangeEvent(super.element);

  web.RTCDTMFToneChangeEvent get inner => _element as web.RTCDTMFToneChangeEvent;
}

final class BrowserRTCDataChannel extends BrowserObjectAdapter
    implements RTCDataChannel, EventTarget {
  BrowserRTCDataChannel(super.element);

  web.RTCDataChannel get inner => _element as web.RTCDataChannel;
}

final class BrowserRTCDataChannelEvent extends BrowserObjectAdapter
    implements RTCDataChannelEvent, Event {
  BrowserRTCDataChannelEvent(super.element);

  web.RTCDataChannelEvent get inner => _element as web.RTCDataChannelEvent;
}

final class BrowserRTCDtlsTransport extends BrowserObjectAdapter
    implements RTCDtlsTransport, EventTarget {
  BrowserRTCDtlsTransport(super.element);

  web.RTCDtlsTransport get inner => _element as web.RTCDtlsTransport;
}

final class BrowserRTCEncodedAudioFrame extends BrowserObjectAdapter
    implements RTCEncodedAudioFrame {
  BrowserRTCEncodedAudioFrame(super.element);

  web.RTCEncodedAudioFrame get inner => _element as web.RTCEncodedAudioFrame;
}

final class BrowserRTCEncodedVideoFrame extends BrowserObjectAdapter
    implements RTCEncodedVideoFrame {
  BrowserRTCEncodedVideoFrame(super.element);

  web.RTCEncodedVideoFrame get inner => _element as web.RTCEncodedVideoFrame;
}

final class BrowserRTCError extends BrowserObjectAdapter
    implements RTCError, DOMException {
  BrowserRTCError(super.element);

  web.RTCError get inner => _element as web.RTCError;
}

final class BrowserRTCErrorEvent extends BrowserObjectAdapter
    implements RTCErrorEvent, Event {
  BrowserRTCErrorEvent(super.element);

  web.RTCErrorEvent get inner => _element as web.RTCErrorEvent;
}

final class BrowserRTCIceCandidate extends BrowserObjectAdapter
    implements RTCIceCandidate {
  BrowserRTCIceCandidate(super.element);

  web.RTCIceCandidate get inner => _element as web.RTCIceCandidate;
}

final class BrowserRTCIceTransport extends BrowserObjectAdapter
    implements RTCIceTransport, EventTarget {
  BrowserRTCIceTransport(super.element);

  web.RTCIceTransport get inner => _element as web.RTCIceTransport;
}

final class BrowserRTCPeerConnection extends BrowserObjectAdapter
    implements RTCPeerConnection, EventTarget {
  BrowserRTCPeerConnection(super.element);

  web.RTCPeerConnection get inner => _element as web.RTCPeerConnection;
}

final class BrowserRTCPeerConnectionIceErrorEvent extends BrowserObjectAdapter
    implements RTCPeerConnectionIceErrorEvent, Event {
  BrowserRTCPeerConnectionIceErrorEvent(super.element);

  web.RTCPeerConnectionIceErrorEvent get inner => _element as web.RTCPeerConnectionIceErrorEvent;
}

final class BrowserRTCPeerConnectionIceEvent extends BrowserObjectAdapter
    implements RTCPeerConnectionIceEvent, Event {
  BrowserRTCPeerConnectionIceEvent(super.element);

  web.RTCPeerConnectionIceEvent get inner => _element as web.RTCPeerConnectionIceEvent;
}

final class BrowserRTCRtpReceiver extends BrowserObjectAdapter
    implements RTCRtpReceiver {
  BrowserRTCRtpReceiver(super.element);

  web.RTCRtpReceiver get inner => _element as web.RTCRtpReceiver;
}

final class BrowserRTCRtpScriptTransform extends BrowserObjectAdapter
    implements RTCRtpScriptTransform {
  BrowserRTCRtpScriptTransform(super.element);

  web.RTCRtpScriptTransform get inner => _element as web.RTCRtpScriptTransform;
}

final class BrowserRTCRtpSender extends BrowserObjectAdapter
    implements RTCRtpSender {
  BrowserRTCRtpSender(super.element);

  web.RTCRtpSender get inner => _element as web.RTCRtpSender;
}

final class BrowserRTCRtpTransceiver extends BrowserObjectAdapter
    implements RTCRtpTransceiver {
  BrowserRTCRtpTransceiver(super.element);

  web.RTCRtpTransceiver get inner => _element as web.RTCRtpTransceiver;
}

final class BrowserRTCSctpTransport extends BrowserObjectAdapter
    implements RTCSctpTransport, EventTarget {
  BrowserRTCSctpTransport(super.element);

  web.RTCSctpTransport get inner => _element as web.RTCSctpTransport;
}

final class BrowserRTCSessionDescription extends BrowserObjectAdapter
    implements RTCSessionDescription {
  BrowserRTCSessionDescription(super.element);

  web.RTCSessionDescription get inner => _element as web.RTCSessionDescription;
}

final class BrowserRTCTrackEvent extends BrowserObjectAdapter
    implements RTCTrackEvent, Event {
  BrowserRTCTrackEvent(super.element);

  web.RTCTrackEvent get inner => _element as web.RTCTrackEvent;
}

final class BrowserRadioNodeList extends BrowserObjectAdapter
    implements RadioNodeList, NodeList {
  BrowserRadioNodeList(super.element);

  web.RadioNodeList get inner => _element as web.RadioNodeList;
}

final class BrowserRange extends BrowserObjectAdapter
    implements Range, AbstractRange {
  BrowserRange(super.element);

  web.Range get inner => _element as web.Range;
}

final class BrowserReadableStream extends BrowserObjectAdapter
    implements ReadableStream {
  BrowserReadableStream(super.element);

  web.ReadableStream get inner => _element as web.ReadableStream;
}

final class BrowserReadableStreamBYOBReader extends BrowserObjectAdapter
    implements ReadableStreamBYOBReader {
  BrowserReadableStreamBYOBReader(super.element);

  web.ReadableStreamBYOBReader get inner => _element as web.ReadableStreamBYOBReader;
}

final class BrowserReadableStreamDefaultReader extends BrowserObjectAdapter
    implements ReadableStreamDefaultReader {
  BrowserReadableStreamDefaultReader(super.element);

  web.ReadableStreamDefaultReader get inner => _element as web.ReadableStreamDefaultReader;
}

final class BrowserRelativeOrientationSensor extends BrowserObjectAdapter
    implements RelativeOrientationSensor, OrientationSensor, Sensor, EventTarget {
  BrowserRelativeOrientationSensor(super.element);

  web.RelativeOrientationSensor get inner => _element as web.RelativeOrientationSensor;
}

final class BrowserRemotePlayback extends BrowserObjectAdapter
    implements RemotePlayback, EventTarget {
  BrowserRemotePlayback(super.element);

  web.RemotePlayback get inner => _element as web.RemotePlayback;
}

final class BrowserReportingObserver extends BrowserObjectAdapter
    implements ReportingObserver {
  BrowserReportingObserver(super.element);

  web.ReportingObserver get inner => _element as web.ReportingObserver;
}

final class BrowserRequest extends BrowserObjectAdapter
    implements Request {
  BrowserRequest(super.element);

  web.Request get inner => _element as web.Request;
}

final class BrowserResizeObserver extends BrowserObjectAdapter
    implements ResizeObserver {
  BrowserResizeObserver(super.element);

  web.ResizeObserver get inner => _element as web.ResizeObserver;
}

final class BrowserResponse extends BrowserObjectAdapter
    implements Response {
  BrowserResponse(super.element);

  web.Response get inner => _element as web.Response;
}

final class BrowserSVGAElement extends BrowserObjectAdapter
    implements SVGAElement, SVGGraphicsElement, SVGElement, Node, EventTarget {
  BrowserSVGAElement(super.element);

  web.SVGAElement get inner => _element as web.SVGAElement;
}

final class BrowserSVGAngle extends BrowserObjectAdapter
    implements SVGAngle {
  BrowserSVGAngle(super.element);

  web.SVGAngle get inner => _element as web.SVGAngle;
}

final class BrowserSVGAnimateElement extends BrowserObjectAdapter
    implements SVGAnimateElement, SVGAnimationElement, SVGElement, Node, EventTarget {
  BrowserSVGAnimateElement(super.element);

  web.SVGAnimateElement get inner => _element as web.SVGAnimateElement;
}

final class BrowserSVGAnimateMotionElement extends BrowserObjectAdapter
    implements SVGAnimateMotionElement, SVGAnimationElement, SVGElement, Node, EventTarget {
  BrowserSVGAnimateMotionElement(super.element);

  web.SVGAnimateMotionElement get inner => _element as web.SVGAnimateMotionElement;
}

final class BrowserSVGAnimateTransformElement extends BrowserObjectAdapter
    implements SVGAnimateTransformElement, SVGAnimationElement, SVGElement, Node, EventTarget {
  BrowserSVGAnimateTransformElement(super.element);

  web.SVGAnimateTransformElement get inner => _element as web.SVGAnimateTransformElement;
}

final class BrowserSVGAnimatedAngle extends BrowserObjectAdapter
    implements SVGAnimatedAngle {
  BrowserSVGAnimatedAngle(super.element);

  web.SVGAnimatedAngle get inner => _element as web.SVGAnimatedAngle;
}

final class BrowserSVGAnimatedBoolean extends BrowserObjectAdapter
    implements SVGAnimatedBoolean {
  BrowserSVGAnimatedBoolean(super.element);

  web.SVGAnimatedBoolean get inner => _element as web.SVGAnimatedBoolean;
}

final class BrowserSVGAnimatedEnumeration extends BrowserObjectAdapter
    implements SVGAnimatedEnumeration {
  BrowserSVGAnimatedEnumeration(super.element);

  web.SVGAnimatedEnumeration get inner => _element as web.SVGAnimatedEnumeration;
}

final class BrowserSVGAnimatedInteger extends BrowserObjectAdapter
    implements SVGAnimatedInteger {
  BrowserSVGAnimatedInteger(super.element);

  web.SVGAnimatedInteger get inner => _element as web.SVGAnimatedInteger;
}

final class BrowserSVGAnimatedLength extends BrowserObjectAdapter
    implements SVGAnimatedLength {
  BrowserSVGAnimatedLength(super.element);

  web.SVGAnimatedLength get inner => _element as web.SVGAnimatedLength;
}

final class BrowserSVGAnimatedLengthList extends BrowserObjectAdapter
    implements SVGAnimatedLengthList {
  BrowserSVGAnimatedLengthList(super.element);

  web.SVGAnimatedLengthList get inner => _element as web.SVGAnimatedLengthList;
}

final class BrowserSVGAnimatedNumber extends BrowserObjectAdapter
    implements SVGAnimatedNumber {
  BrowserSVGAnimatedNumber(super.element);

  web.SVGAnimatedNumber get inner => _element as web.SVGAnimatedNumber;
}

final class BrowserSVGAnimatedNumberList extends BrowserObjectAdapter
    implements SVGAnimatedNumberList {
  BrowserSVGAnimatedNumberList(super.element);

  web.SVGAnimatedNumberList get inner => _element as web.SVGAnimatedNumberList;
}

final class BrowserSVGAnimatedPreserveAspectRatio extends BrowserObjectAdapter
    implements SVGAnimatedPreserveAspectRatio {
  BrowserSVGAnimatedPreserveAspectRatio(super.element);

  web.SVGAnimatedPreserveAspectRatio get inner => _element as web.SVGAnimatedPreserveAspectRatio;
}

final class BrowserSVGAnimatedRect extends BrowserObjectAdapter
    implements SVGAnimatedRect {
  BrowserSVGAnimatedRect(super.element);

  web.SVGAnimatedRect get inner => _element as web.SVGAnimatedRect;
}

final class BrowserSVGAnimatedString extends BrowserObjectAdapter
    implements SVGAnimatedString {
  BrowserSVGAnimatedString(super.element);

  web.SVGAnimatedString get inner => _element as web.SVGAnimatedString;
}

final class BrowserSVGAnimatedTransformList extends BrowserObjectAdapter
    implements SVGAnimatedTransformList {
  BrowserSVGAnimatedTransformList(super.element);

  web.SVGAnimatedTransformList get inner => _element as web.SVGAnimatedTransformList;
}

final class BrowserSVGAnimationElement extends BrowserObjectAdapter
    implements SVGAnimationElement, SVGElement, Node, EventTarget {
  BrowserSVGAnimationElement(super.element);

  web.SVGAnimationElement get inner => _element as web.SVGAnimationElement;
}

final class BrowserSVGCircleElement extends BrowserObjectAdapter
    implements SVGCircleElement, SVGGeometryElement, SVGGraphicsElement, SVGElement, Node, EventTarget {
  BrowserSVGCircleElement(super.element);

  web.SVGCircleElement get inner => _element as web.SVGCircleElement;
}

final class BrowserSVGClipPathElement extends BrowserObjectAdapter
    implements SVGClipPathElement, SVGElement, Node, EventTarget {
  BrowserSVGClipPathElement(super.element);

  web.SVGClipPathElement get inner => _element as web.SVGClipPathElement;
}

final class BrowserSVGComponentTransferFunctionElement extends BrowserObjectAdapter
    implements SVGComponentTransferFunctionElement, SVGElement, Node, EventTarget {
  BrowserSVGComponentTransferFunctionElement(super.element);

  web.SVGComponentTransferFunctionElement get inner => _element as web.SVGComponentTransferFunctionElement;
}

final class BrowserSVGDefsElement extends BrowserObjectAdapter
    implements SVGDefsElement, SVGGraphicsElement, SVGElement, Node, EventTarget {
  BrowserSVGDefsElement(super.element);

  web.SVGDefsElement get inner => _element as web.SVGDefsElement;
}

final class BrowserSVGDescElement extends BrowserObjectAdapter
    implements SVGDescElement, SVGElement, Node, EventTarget {
  BrowserSVGDescElement(super.element);

  web.SVGDescElement get inner => _element as web.SVGDescElement;
}

final class BrowserSVGElement extends BrowserObjectAdapter
    implements SVGElement, Node, EventTarget {
  BrowserSVGElement(super.element);

  web.SVGElement get inner => _element as web.SVGElement;
}

final class BrowserSVGEllipseElement extends BrowserObjectAdapter
    implements SVGEllipseElement, SVGGeometryElement, SVGGraphicsElement, SVGElement, Node, EventTarget {
  BrowserSVGEllipseElement(super.element);

  web.SVGEllipseElement get inner => _element as web.SVGEllipseElement;
}

final class BrowserSVGFEBlendElement extends BrowserObjectAdapter
    implements SVGFEBlendElement, SVGElement, Node, EventTarget {
  BrowserSVGFEBlendElement(super.element);

  web.SVGFEBlendElement get inner => _element as web.SVGFEBlendElement;
}

final class BrowserSVGFEColorMatrixElement extends BrowserObjectAdapter
    implements SVGFEColorMatrixElement, SVGElement, Node, EventTarget {
  BrowserSVGFEColorMatrixElement(super.element);

  web.SVGFEColorMatrixElement get inner => _element as web.SVGFEColorMatrixElement;
}

final class BrowserSVGFEComponentTransferElement extends BrowserObjectAdapter
    implements SVGFEComponentTransferElement, SVGElement, Node, EventTarget {
  BrowserSVGFEComponentTransferElement(super.element);

  web.SVGFEComponentTransferElement get inner => _element as web.SVGFEComponentTransferElement;
}

final class BrowserSVGFECompositeElement extends BrowserObjectAdapter
    implements SVGFECompositeElement, SVGElement, Node, EventTarget {
  BrowserSVGFECompositeElement(super.element);

  web.SVGFECompositeElement get inner => _element as web.SVGFECompositeElement;
}

final class BrowserSVGFEConvolveMatrixElement extends BrowserObjectAdapter
    implements SVGFEConvolveMatrixElement, SVGElement, Node, EventTarget {
  BrowserSVGFEConvolveMatrixElement(super.element);

  web.SVGFEConvolveMatrixElement get inner => _element as web.SVGFEConvolveMatrixElement;
}

final class BrowserSVGFEDiffuseLightingElement extends BrowserObjectAdapter
    implements SVGFEDiffuseLightingElement, SVGElement, Node, EventTarget {
  BrowserSVGFEDiffuseLightingElement(super.element);

  web.SVGFEDiffuseLightingElement get inner => _element as web.SVGFEDiffuseLightingElement;
}

final class BrowserSVGFEDisplacementMapElement extends BrowserObjectAdapter
    implements SVGFEDisplacementMapElement, SVGElement, Node, EventTarget {
  BrowserSVGFEDisplacementMapElement(super.element);

  web.SVGFEDisplacementMapElement get inner => _element as web.SVGFEDisplacementMapElement;
}

final class BrowserSVGFEDistantLightElement extends BrowserObjectAdapter
    implements SVGFEDistantLightElement, SVGElement, Node, EventTarget {
  BrowserSVGFEDistantLightElement(super.element);

  web.SVGFEDistantLightElement get inner => _element as web.SVGFEDistantLightElement;
}

final class BrowserSVGFEDropShadowElement extends BrowserObjectAdapter
    implements SVGFEDropShadowElement, SVGElement, Node, EventTarget {
  BrowserSVGFEDropShadowElement(super.element);

  web.SVGFEDropShadowElement get inner => _element as web.SVGFEDropShadowElement;
}

final class BrowserSVGFEFloodElement extends BrowserObjectAdapter
    implements SVGFEFloodElement, SVGElement, Node, EventTarget {
  BrowserSVGFEFloodElement(super.element);

  web.SVGFEFloodElement get inner => _element as web.SVGFEFloodElement;
}

final class BrowserSVGFEFuncAElement extends BrowserObjectAdapter
    implements SVGFEFuncAElement, SVGComponentTransferFunctionElement, SVGElement, Node, EventTarget {
  BrowserSVGFEFuncAElement(super.element);

  web.SVGFEFuncAElement get inner => _element as web.SVGFEFuncAElement;
}

final class BrowserSVGFEFuncBElement extends BrowserObjectAdapter
    implements SVGFEFuncBElement, SVGComponentTransferFunctionElement, SVGElement, Node, EventTarget {
  BrowserSVGFEFuncBElement(super.element);

  web.SVGFEFuncBElement get inner => _element as web.SVGFEFuncBElement;
}

final class BrowserSVGFEFuncGElement extends BrowserObjectAdapter
    implements SVGFEFuncGElement, SVGComponentTransferFunctionElement, SVGElement, Node, EventTarget {
  BrowserSVGFEFuncGElement(super.element);

  web.SVGFEFuncGElement get inner => _element as web.SVGFEFuncGElement;
}

final class BrowserSVGFEFuncRElement extends BrowserObjectAdapter
    implements SVGFEFuncRElement, SVGComponentTransferFunctionElement, SVGElement, Node, EventTarget {
  BrowserSVGFEFuncRElement(super.element);

  web.SVGFEFuncRElement get inner => _element as web.SVGFEFuncRElement;
}

final class BrowserSVGFEGaussianBlurElement extends BrowserObjectAdapter
    implements SVGFEGaussianBlurElement, SVGElement, Node, EventTarget {
  BrowserSVGFEGaussianBlurElement(super.element);

  web.SVGFEGaussianBlurElement get inner => _element as web.SVGFEGaussianBlurElement;
}

final class BrowserSVGFEImageElement extends BrowserObjectAdapter
    implements SVGFEImageElement, SVGElement, Node, EventTarget {
  BrowserSVGFEImageElement(super.element);

  web.SVGFEImageElement get inner => _element as web.SVGFEImageElement;
}

final class BrowserSVGFEMergeElement extends BrowserObjectAdapter
    implements SVGFEMergeElement, SVGElement, Node, EventTarget {
  BrowserSVGFEMergeElement(super.element);

  web.SVGFEMergeElement get inner => _element as web.SVGFEMergeElement;
}

final class BrowserSVGFEMergeNodeElement extends BrowserObjectAdapter
    implements SVGFEMergeNodeElement, SVGElement, Node, EventTarget {
  BrowserSVGFEMergeNodeElement(super.element);

  web.SVGFEMergeNodeElement get inner => _element as web.SVGFEMergeNodeElement;
}

final class BrowserSVGFEMorphologyElement extends BrowserObjectAdapter
    implements SVGFEMorphologyElement, SVGElement, Node, EventTarget {
  BrowserSVGFEMorphologyElement(super.element);

  web.SVGFEMorphologyElement get inner => _element as web.SVGFEMorphologyElement;
}

final class BrowserSVGFEOffsetElement extends BrowserObjectAdapter
    implements SVGFEOffsetElement, SVGElement, Node, EventTarget {
  BrowserSVGFEOffsetElement(super.element);

  web.SVGFEOffsetElement get inner => _element as web.SVGFEOffsetElement;
}

final class BrowserSVGFEPointLightElement extends BrowserObjectAdapter
    implements SVGFEPointLightElement, SVGElement, Node, EventTarget {
  BrowserSVGFEPointLightElement(super.element);

  web.SVGFEPointLightElement get inner => _element as web.SVGFEPointLightElement;
}

final class BrowserSVGFESpecularLightingElement extends BrowserObjectAdapter
    implements SVGFESpecularLightingElement, SVGElement, Node, EventTarget {
  BrowserSVGFESpecularLightingElement(super.element);

  web.SVGFESpecularLightingElement get inner => _element as web.SVGFESpecularLightingElement;
}

final class BrowserSVGFESpotLightElement extends BrowserObjectAdapter
    implements SVGFESpotLightElement, SVGElement, Node, EventTarget {
  BrowserSVGFESpotLightElement(super.element);

  web.SVGFESpotLightElement get inner => _element as web.SVGFESpotLightElement;
}

final class BrowserSVGFETileElement extends BrowserObjectAdapter
    implements SVGFETileElement, SVGElement, Node, EventTarget {
  BrowserSVGFETileElement(super.element);

  web.SVGFETileElement get inner => _element as web.SVGFETileElement;
}

final class BrowserSVGFETurbulenceElement extends BrowserObjectAdapter
    implements SVGFETurbulenceElement, SVGElement, Node, EventTarget {
  BrowserSVGFETurbulenceElement(super.element);

  web.SVGFETurbulenceElement get inner => _element as web.SVGFETurbulenceElement;
}

final class BrowserSVGFilterElement extends BrowserObjectAdapter
    implements SVGFilterElement, SVGElement, Node, EventTarget {
  BrowserSVGFilterElement(super.element);

  web.SVGFilterElement get inner => _element as web.SVGFilterElement;
}

final class BrowserSVGForeignObjectElement extends BrowserObjectAdapter
    implements SVGForeignObjectElement, SVGGraphicsElement, SVGElement, Node, EventTarget {
  BrowserSVGForeignObjectElement(super.element);

  web.SVGForeignObjectElement get inner => _element as web.SVGForeignObjectElement;
}

final class BrowserSVGGElement extends BrowserObjectAdapter
    implements SVGGElement, SVGGraphicsElement, SVGElement, Node, EventTarget {
  BrowserSVGGElement(super.element);

  web.SVGGElement get inner => _element as web.SVGGElement;
}

final class BrowserSVGGeometryElement extends BrowserObjectAdapter
    implements SVGGeometryElement, SVGGraphicsElement, SVGElement, Node, EventTarget {
  BrowserSVGGeometryElement(super.element);

  web.SVGGeometryElement get inner => _element as web.SVGGeometryElement;
}

final class BrowserSVGGradientElement extends BrowserObjectAdapter
    implements SVGGradientElement, SVGElement, Node, EventTarget {
  BrowserSVGGradientElement(super.element);

  web.SVGGradientElement get inner => _element as web.SVGGradientElement;
}

final class BrowserSVGGraphicsElement extends BrowserObjectAdapter
    implements SVGGraphicsElement, SVGElement, Node, EventTarget {
  BrowserSVGGraphicsElement(super.element);

  web.SVGGraphicsElement get inner => _element as web.SVGGraphicsElement;
}

final class BrowserSVGImageElement extends BrowserObjectAdapter
    implements SVGImageElement, SVGGraphicsElement, SVGElement, Node, EventTarget {
  BrowserSVGImageElement(super.element);

  web.SVGImageElement get inner => _element as web.SVGImageElement;
}

final class BrowserSVGLength extends BrowserObjectAdapter
    implements SVGLength {
  BrowserSVGLength(super.element);

  web.SVGLength get inner => _element as web.SVGLength;
}

final class BrowserSVGLengthList extends BrowserObjectAdapter
    implements SVGLengthList {
  BrowserSVGLengthList(super.element);

  web.SVGLengthList get inner => _element as web.SVGLengthList;
}

final class BrowserSVGLineElement extends BrowserObjectAdapter
    implements SVGLineElement, SVGGeometryElement, SVGGraphicsElement, SVGElement, Node, EventTarget {
  BrowserSVGLineElement(super.element);

  web.SVGLineElement get inner => _element as web.SVGLineElement;
}

final class BrowserSVGLinearGradientElement extends BrowserObjectAdapter
    implements SVGLinearGradientElement, SVGGradientElement, SVGElement, Node, EventTarget {
  BrowserSVGLinearGradientElement(super.element);

  web.SVGLinearGradientElement get inner => _element as web.SVGLinearGradientElement;
}

final class BrowserSVGMPathElement extends BrowserObjectAdapter
    implements SVGMPathElement, SVGElement, Node, EventTarget {
  BrowserSVGMPathElement(super.element);

  web.SVGMPathElement get inner => _element as web.SVGMPathElement;
}

final class BrowserSVGMarkerElement extends BrowserObjectAdapter
    implements SVGMarkerElement, SVGElement, Node, EventTarget {
  BrowserSVGMarkerElement(super.element);

  web.SVGMarkerElement get inner => _element as web.SVGMarkerElement;
}

final class BrowserSVGMaskElement extends BrowserObjectAdapter
    implements SVGMaskElement, SVGElement, Node, EventTarget {
  BrowserSVGMaskElement(super.element);

  web.SVGMaskElement get inner => _element as web.SVGMaskElement;
}

final class BrowserSVGMetadataElement extends BrowserObjectAdapter
    implements SVGMetadataElement, SVGElement, Node, EventTarget {
  BrowserSVGMetadataElement(super.element);

  web.SVGMetadataElement get inner => _element as web.SVGMetadataElement;
}

final class BrowserSVGNumber extends BrowserObjectAdapter
    implements SVGNumber {
  BrowserSVGNumber(super.element);

  web.SVGNumber get inner => _element as web.SVGNumber;
}

final class BrowserSVGNumberList extends BrowserObjectAdapter
    implements SVGNumberList {
  BrowserSVGNumberList(super.element);

  web.SVGNumberList get inner => _element as web.SVGNumberList;
}

final class BrowserSVGPathElement extends BrowserObjectAdapter
    implements SVGPathElement, SVGGeometryElement, SVGGraphicsElement, SVGElement, Node, EventTarget {
  BrowserSVGPathElement(super.element);

  web.SVGPathElement get inner => _element as web.SVGPathElement;
}

final class BrowserSVGPatternElement extends BrowserObjectAdapter
    implements SVGPatternElement, SVGElement, Node, EventTarget {
  BrowserSVGPatternElement(super.element);

  web.SVGPatternElement get inner => _element as web.SVGPatternElement;
}

final class BrowserSVGPointList extends BrowserObjectAdapter
    implements SVGPointList {
  BrowserSVGPointList(super.element);

  web.SVGPointList get inner => _element as web.SVGPointList;
}

final class BrowserSVGPolygonElement extends BrowserObjectAdapter
    implements SVGPolygonElement, SVGGeometryElement, SVGGraphicsElement, SVGElement, Node, EventTarget {
  BrowserSVGPolygonElement(super.element);

  web.SVGPolygonElement get inner => _element as web.SVGPolygonElement;
}

final class BrowserSVGPolylineElement extends BrowserObjectAdapter
    implements SVGPolylineElement, SVGGeometryElement, SVGGraphicsElement, SVGElement, Node, EventTarget {
  BrowserSVGPolylineElement(super.element);

  web.SVGPolylineElement get inner => _element as web.SVGPolylineElement;
}

final class BrowserSVGPreserveAspectRatio extends BrowserObjectAdapter
    implements SVGPreserveAspectRatio {
  BrowserSVGPreserveAspectRatio(super.element);

  web.SVGPreserveAspectRatio get inner => _element as web.SVGPreserveAspectRatio;
}

final class BrowserSVGRadialGradientElement extends BrowserObjectAdapter
    implements SVGRadialGradientElement, SVGGradientElement, SVGElement, Node, EventTarget {
  BrowserSVGRadialGradientElement(super.element);

  web.SVGRadialGradientElement get inner => _element as web.SVGRadialGradientElement;
}

final class BrowserSVGRectElement extends BrowserObjectAdapter
    implements SVGRectElement, SVGGeometryElement, SVGGraphicsElement, SVGElement, Node, EventTarget {
  BrowserSVGRectElement(super.element);

  web.SVGRectElement get inner => _element as web.SVGRectElement;
}

final class BrowserSVGSVGElement extends BrowserObjectAdapter
    implements SVGSVGElement, SVGGraphicsElement, SVGElement, Node, EventTarget {
  BrowserSVGSVGElement(super.element);

  web.SVGSVGElement get inner => _element as web.SVGSVGElement;
}

final class BrowserSVGScriptElement extends BrowserObjectAdapter
    implements SVGScriptElement, SVGElement, Node, EventTarget {
  BrowserSVGScriptElement(super.element);

  web.SVGScriptElement get inner => _element as web.SVGScriptElement;
}

final class BrowserSVGSetElement extends BrowserObjectAdapter
    implements SVGSetElement, SVGAnimationElement, SVGElement, Node, EventTarget {
  BrowserSVGSetElement(super.element);

  web.SVGSetElement get inner => _element as web.SVGSetElement;
}

final class BrowserSVGStopElement extends BrowserObjectAdapter
    implements SVGStopElement, SVGElement, Node, EventTarget {
  BrowserSVGStopElement(super.element);

  web.SVGStopElement get inner => _element as web.SVGStopElement;
}

final class BrowserSVGStringList extends BrowserObjectAdapter
    implements SVGStringList {
  BrowserSVGStringList(super.element);

  web.SVGStringList get inner => _element as web.SVGStringList;
}

final class BrowserSVGStyleElement extends BrowserObjectAdapter
    implements SVGStyleElement, SVGElement, Node, EventTarget {
  BrowserSVGStyleElement(super.element);

  web.SVGStyleElement get inner => _element as web.SVGStyleElement;
}

final class BrowserSVGSwitchElement extends BrowserObjectAdapter
    implements SVGSwitchElement, SVGGraphicsElement, SVGElement, Node, EventTarget {
  BrowserSVGSwitchElement(super.element);

  web.SVGSwitchElement get inner => _element as web.SVGSwitchElement;
}

final class BrowserSVGSymbolElement extends BrowserObjectAdapter
    implements SVGSymbolElement, SVGGraphicsElement, SVGElement, Node, EventTarget {
  BrowserSVGSymbolElement(super.element);

  web.SVGSymbolElement get inner => _element as web.SVGSymbolElement;
}

final class BrowserSVGTSpanElement extends BrowserObjectAdapter
    implements SVGTSpanElement, SVGTextPositioningElement, SVGTextContentElement, SVGGraphicsElement, SVGElement, Node, EventTarget {
  BrowserSVGTSpanElement(super.element);

  web.SVGTSpanElement get inner => _element as web.SVGTSpanElement;
}

final class BrowserSVGTextContentElement extends BrowserObjectAdapter
    implements SVGTextContentElement, SVGGraphicsElement, SVGElement, Node, EventTarget {
  BrowserSVGTextContentElement(super.element);

  web.SVGTextContentElement get inner => _element as web.SVGTextContentElement;
}

final class BrowserSVGTextElement extends BrowserObjectAdapter
    implements SVGTextElement, SVGTextPositioningElement, SVGTextContentElement, SVGGraphicsElement, SVGElement, Node, EventTarget {
  BrowserSVGTextElement(super.element);

  web.SVGTextElement get inner => _element as web.SVGTextElement;
}

final class BrowserSVGTextPathElement extends BrowserObjectAdapter
    implements SVGTextPathElement, SVGTextContentElement, SVGGraphicsElement, SVGElement, Node, EventTarget {
  BrowserSVGTextPathElement(super.element);

  web.SVGTextPathElement get inner => _element as web.SVGTextPathElement;
}

final class BrowserSVGTextPositioningElement extends BrowserObjectAdapter
    implements SVGTextPositioningElement, SVGTextContentElement, SVGGraphicsElement, SVGElement, Node, EventTarget {
  BrowserSVGTextPositioningElement(super.element);

  web.SVGTextPositioningElement get inner => _element as web.SVGTextPositioningElement;
}

final class BrowserSVGTitleElement extends BrowserObjectAdapter
    implements SVGTitleElement, SVGElement, Node, EventTarget {
  BrowserSVGTitleElement(super.element);

  web.SVGTitleElement get inner => _element as web.SVGTitleElement;
}

final class BrowserSVGTransform extends BrowserObjectAdapter
    implements SVGTransform {
  BrowserSVGTransform(super.element);

  web.SVGTransform get inner => _element as web.SVGTransform;
}

final class BrowserSVGTransformList extends BrowserObjectAdapter
    implements SVGTransformList {
  BrowserSVGTransformList(super.element);

  web.SVGTransformList get inner => _element as web.SVGTransformList;
}

final class BrowserSVGUnitTypes extends BrowserObjectAdapter
    implements SVGUnitTypes {
  BrowserSVGUnitTypes(super.element);

  web.SVGUnitTypes get inner => _element as web.SVGUnitTypes;
}

final class BrowserSVGUseElement extends BrowserObjectAdapter
    implements SVGUseElement, SVGGraphicsElement, SVGElement, Node, EventTarget {
  BrowserSVGUseElement(super.element);

  web.SVGUseElement get inner => _element as web.SVGUseElement;
}

final class BrowserSVGViewElement extends BrowserObjectAdapter
    implements SVGViewElement, SVGElement, Node, EventTarget {
  BrowserSVGViewElement(super.element);

  web.SVGViewElement get inner => _element as web.SVGViewElement;
}

final class BrowserSanitizer extends BrowserObjectAdapter
    implements Sanitizer {
  BrowserSanitizer(super.element);

  web.Sanitizer get inner => _element as web.Sanitizer;
}

final class BrowserScheduler extends BrowserObjectAdapter
    implements Scheduler {
  BrowserScheduler(super.element);

  web.Scheduler get inner => _element as web.Scheduler;
}

final class BrowserScreen extends BrowserObjectAdapter
    implements Screen {
  BrowserScreen(super.element);

  web.Screen get inner => _element as web.Screen;
}

final class BrowserScreenOrientation extends BrowserObjectAdapter
    implements ScreenOrientation, EventTarget {
  BrowserScreenOrientation(super.element);

  web.ScreenOrientation get inner => _element as web.ScreenOrientation;
}

final class BrowserSecurityPolicyViolationEvent extends BrowserObjectAdapter
    implements SecurityPolicyViolationEvent, Event {
  BrowserSecurityPolicyViolationEvent(super.element);

  web.SecurityPolicyViolationEvent get inner => _element as web.SecurityPolicyViolationEvent;
}

final class BrowserSelection extends BrowserObjectAdapter
    implements Selection {
  BrowserSelection(super.element);

  web.Selection get inner => _element as web.Selection;
}

final class BrowserSensorErrorEvent extends BrowserObjectAdapter
    implements SensorErrorEvent, Event {
  BrowserSensorErrorEvent(super.element);

  web.SensorErrorEvent get inner => _element as web.SensorErrorEvent;
}

final class BrowserServiceWorker extends BrowserObjectAdapter
    implements ServiceWorker, EventTarget {
  BrowserServiceWorker(super.element);

  web.ServiceWorker get inner => _element as web.ServiceWorker;
}

final class BrowserServiceWorkerContainer extends BrowserObjectAdapter
    implements ServiceWorkerContainer, EventTarget {
  BrowserServiceWorkerContainer(super.element);

  web.ServiceWorkerContainer get inner => _element as web.ServiceWorkerContainer;
}

final class BrowserShadowRoot extends BrowserObjectAdapter
    implements ShadowRoot, DocumentFragment, Node, EventTarget {
  BrowserShadowRoot(super.element);

  web.ShadowRoot get inner => _element as web.ShadowRoot;
}

final class BrowserSharedWorker extends BrowserObjectAdapter
    implements SharedWorker, EventTarget {
  BrowserSharedWorker(super.element);

  web.SharedWorker get inner => _element as web.SharedWorker;
}

final class BrowserSourceBuffer extends BrowserObjectAdapter
    implements SourceBuffer, EventTarget {
  BrowserSourceBuffer(super.element);

  web.SourceBuffer get inner => _element as web.SourceBuffer;
}

final class BrowserSourceBufferList extends BrowserObjectAdapter
    implements SourceBufferList, EventTarget {
  BrowserSourceBufferList(super.element);

  web.SourceBufferList get inner => _element as web.SourceBufferList;
}

final class BrowserSpeechRecognition extends BrowserObjectAdapter
    implements SpeechRecognition, EventTarget {
  BrowserSpeechRecognition(super.element);

  web.SpeechRecognition get inner => _element as web.SpeechRecognition;
}

final class BrowserSpeechRecognitionAlternative extends BrowserObjectAdapter
    implements SpeechRecognitionAlternative {
  BrowserSpeechRecognitionAlternative(super.element);

  web.SpeechRecognitionAlternative get inner => _element as web.SpeechRecognitionAlternative;
}

final class BrowserSpeechRecognitionErrorEvent extends BrowserObjectAdapter
    implements SpeechRecognitionErrorEvent, Event {
  BrowserSpeechRecognitionErrorEvent(super.element);

  web.SpeechRecognitionErrorEvent get inner => _element as web.SpeechRecognitionErrorEvent;
}

final class BrowserSpeechRecognitionEvent extends BrowserObjectAdapter
    implements SpeechRecognitionEvent, Event {
  BrowserSpeechRecognitionEvent(super.element);

  web.SpeechRecognitionEvent get inner => _element as web.SpeechRecognitionEvent;
}

final class BrowserSpeechRecognitionResult extends BrowserObjectAdapter
    implements SpeechRecognitionResult {
  BrowserSpeechRecognitionResult(super.element);

  web.SpeechRecognitionResult get inner => _element as web.SpeechRecognitionResult;
}

final class BrowserSpeechRecognitionResultList extends BrowserObjectAdapter
    implements SpeechRecognitionResultList {
  BrowserSpeechRecognitionResultList(super.element);

  web.SpeechRecognitionResultList get inner => _element as web.SpeechRecognitionResultList;
}

final class BrowserSpeechSynthesis extends BrowserObjectAdapter
    implements SpeechSynthesis, EventTarget {
  BrowserSpeechSynthesis(super.element);

  web.SpeechSynthesis get inner => _element as web.SpeechSynthesis;
}

final class BrowserSpeechSynthesisErrorEvent extends BrowserObjectAdapter
    implements SpeechSynthesisErrorEvent, SpeechSynthesisEvent, Event {
  BrowserSpeechSynthesisErrorEvent(super.element);

  web.SpeechSynthesisErrorEvent get inner => _element as web.SpeechSynthesisErrorEvent;
}

final class BrowserSpeechSynthesisEvent extends BrowserObjectAdapter
    implements SpeechSynthesisEvent, Event {
  BrowserSpeechSynthesisEvent(super.element);

  web.SpeechSynthesisEvent get inner => _element as web.SpeechSynthesisEvent;
}

final class BrowserSpeechSynthesisUtterance extends BrowserObjectAdapter
    implements SpeechSynthesisUtterance, EventTarget {
  BrowserSpeechSynthesisUtterance(super.element);

  web.SpeechSynthesisUtterance get inner => _element as web.SpeechSynthesisUtterance;
}

final class BrowserSpeechSynthesisVoice extends BrowserObjectAdapter
    implements SpeechSynthesisVoice {
  BrowserSpeechSynthesisVoice(super.element);

  web.SpeechSynthesisVoice get inner => _element as web.SpeechSynthesisVoice;
}

final class BrowserStaticRange extends BrowserObjectAdapter
    implements StaticRange, AbstractRange {
  BrowserStaticRange(super.element);

  web.StaticRange get inner => _element as web.StaticRange;
}

final class BrowserStereoPannerNode extends BrowserObjectAdapter
    implements StereoPannerNode, AudioNode, EventTarget {
  BrowserStereoPannerNode(super.element);

  web.StereoPannerNode get inner => _element as web.StereoPannerNode;
}

final class BrowserStorage extends BrowserObjectAdapter
    implements Storage {
  BrowserStorage(super.element);

  web.Storage get inner => _element as web.Storage;
}

final class BrowserStorageEvent extends BrowserObjectAdapter
    implements StorageEvent, Event {
  BrowserStorageEvent(super.element);

  web.StorageEvent get inner => _element as web.StorageEvent;
}

final class BrowserStorageManager extends BrowserObjectAdapter
    implements StorageManager {
  BrowserStorageManager(super.element);

  web.StorageManager get inner => _element as web.StorageManager;
}

final class BrowserStylePropertyMap extends BrowserObjectAdapter
    implements StylePropertyMap, StylePropertyMapReadOnly {
  BrowserStylePropertyMap(super.element);

  web.StylePropertyMap get inner => _element as web.StylePropertyMap;
}

final class BrowserStylePropertyMapReadOnly extends BrowserObjectAdapter
    implements StylePropertyMapReadOnly {
  BrowserStylePropertyMapReadOnly(super.element);

  web.StylePropertyMapReadOnly get inner => _element as web.StylePropertyMapReadOnly;
}

final class BrowserStyleSheetList extends BrowserObjectAdapter
    implements StyleSheetList {
  BrowserStyleSheetList(super.element);

  web.StyleSheetList get inner => _element as web.StyleSheetList;
}

final class BrowserSubmitEvent extends BrowserObjectAdapter
    implements SubmitEvent, Event {
  BrowserSubmitEvent(super.element);

  web.SubmitEvent get inner => _element as web.SubmitEvent;
}

final class BrowserSubtleCrypto extends BrowserObjectAdapter
    implements SubtleCrypto {
  BrowserSubtleCrypto(super.element);

  web.SubtleCrypto get inner => _element as web.SubtleCrypto;
}

final class BrowserSyncEvent extends BrowserObjectAdapter
    implements SyncEvent, ExtendableEvent, Event {
  BrowserSyncEvent(super.element);

  web.SyncEvent get inner => _element as web.SyncEvent;
}

final class BrowserTaskController extends BrowserObjectAdapter
    implements TaskController, AbortController {
  BrowserTaskController(super.element);

  web.TaskController get inner => _element as web.TaskController;
}

final class BrowserTaskPriorityChangeEvent extends BrowserObjectAdapter
    implements TaskPriorityChangeEvent, Event {
  BrowserTaskPriorityChangeEvent(super.element);

  web.TaskPriorityChangeEvent get inner => _element as web.TaskPriorityChangeEvent;
}

final class BrowserText extends BrowserObjectAdapter
    implements Text, CharacterData, Node, EventTarget {
  BrowserText(super.element);

  web.Text get inner => _element as web.Text;
}

final class BrowserTextDecoder extends BrowserObjectAdapter
    implements TextDecoder {
  BrowserTextDecoder(super.element);

  web.TextDecoder get inner => _element as web.TextDecoder;
}

final class BrowserTextDecoderStream extends BrowserObjectAdapter
    implements TextDecoderStream {
  BrowserTextDecoderStream(super.element);

  web.TextDecoderStream get inner => _element as web.TextDecoderStream;
}

final class BrowserTextEncoder extends BrowserObjectAdapter
    implements TextEncoder {
  BrowserTextEncoder(super.element);

  web.TextEncoder get inner => _element as web.TextEncoder;
}

final class BrowserTextEncoderStream extends BrowserObjectAdapter
    implements TextEncoderStream {
  BrowserTextEncoderStream(super.element);

  web.TextEncoderStream get inner => _element as web.TextEncoderStream;
}

final class BrowserTextTrack extends BrowserObjectAdapter
    implements TextTrack, EventTarget {
  BrowserTextTrack(super.element);

  web.TextTrack get inner => _element as web.TextTrack;
}

final class BrowserTextTrackCue extends BrowserObjectAdapter
    implements TextTrackCue, EventTarget {
  BrowserTextTrackCue(super.element);

  web.TextTrackCue get inner => _element as web.TextTrackCue;
}

final class BrowserTextTrackCueList extends BrowserObjectAdapter
    implements TextTrackCueList {
  BrowserTextTrackCueList(super.element);

  web.TextTrackCueList get inner => _element as web.TextTrackCueList;
}

final class BrowserTextTrackList extends BrowserObjectAdapter
    implements TextTrackList, EventTarget {
  BrowserTextTrackList(super.element);

  web.TextTrackList get inner => _element as web.TextTrackList;
}

final class BrowserTimeRanges extends BrowserObjectAdapter
    implements TimeRanges {
  BrowserTimeRanges(super.element);

  web.TimeRanges get inner => _element as web.TimeRanges;
}

final class BrowserToggleEvent extends BrowserObjectAdapter
    implements ToggleEvent, Event {
  BrowserToggleEvent(super.element);

  web.ToggleEvent get inner => _element as web.ToggleEvent;
}

final class BrowserTouch extends BrowserObjectAdapter
    implements Touch {
  BrowserTouch(super.element);

  web.Touch get inner => _element as web.Touch;
}

final class BrowserTouchEvent extends BrowserObjectAdapter
    implements TouchEvent, UIEvent, Event {
  BrowserTouchEvent(super.element);

  web.TouchEvent get inner => _element as web.TouchEvent;
}

final class BrowserTouchList extends BrowserObjectAdapter
    implements TouchList {
  BrowserTouchList(super.element);

  web.TouchList get inner => _element as web.TouchList;
}

final class BrowserTrackEvent extends BrowserObjectAdapter
    implements TrackEvent, Event {
  BrowserTrackEvent(super.element);

  web.TrackEvent get inner => _element as web.TrackEvent;
}

final class BrowserTransformStream extends BrowserObjectAdapter
    implements TransformStream {
  BrowserTransformStream(super.element);

  web.TransformStream get inner => _element as web.TransformStream;
}

final class BrowserTransitionEvent extends BrowserObjectAdapter
    implements TransitionEvent, Event {
  BrowserTransitionEvent(super.element);

  web.TransitionEvent get inner => _element as web.TransitionEvent;
}

final class BrowserTreeWalker extends BrowserObjectAdapter
    implements TreeWalker {
  BrowserTreeWalker(super.element);

  web.TreeWalker get inner => _element as web.TreeWalker;
}

final class BrowserTrustedHTML extends BrowserObjectAdapter
    implements TrustedHTML {
  BrowserTrustedHTML(super.element);

  web.TrustedHTML get inner => _element as web.TrustedHTML;
}

final class BrowserTrustedScript extends BrowserObjectAdapter
    implements TrustedScript {
  BrowserTrustedScript(super.element);

  web.TrustedScript get inner => _element as web.TrustedScript;
}

final class BrowserTrustedScriptURL extends BrowserObjectAdapter
    implements TrustedScriptURL {
  BrowserTrustedScriptURL(super.element);

  web.TrustedScriptURL get inner => _element as web.TrustedScriptURL;
}

final class BrowserTrustedTypePolicy extends BrowserObjectAdapter
    implements TrustedTypePolicy {
  BrowserTrustedTypePolicy(super.element);

  web.TrustedTypePolicy get inner => _element as web.TrustedTypePolicy;
}

final class BrowserTrustedTypePolicyFactory extends BrowserObjectAdapter
    implements TrustedTypePolicyFactory {
  BrowserTrustedTypePolicyFactory(super.element);

  web.TrustedTypePolicyFactory get inner => _element as web.TrustedTypePolicyFactory;
}

final class BrowserUIEvent extends BrowserObjectAdapter
    implements UIEvent, Event {
  BrowserUIEvent(super.element);

  web.UIEvent get inner => _element as web.UIEvent;
}

final class BrowserURL extends BrowserObjectAdapter
    implements URL {
  BrowserURL(super.element);

  web.URL get inner => _element as web.URL;
}

final class BrowserURLSearchParams extends BrowserObjectAdapter
    implements URLSearchParams {
  BrowserURLSearchParams(super.element);

  web.URLSearchParams get inner => _element as web.URLSearchParams;
}

final class BrowserUserActivation extends BrowserObjectAdapter
    implements UserActivation {
  BrowserUserActivation(super.element);

  web.UserActivation get inner => _element as web.UserActivation;
}

final class BrowserVTTCue extends BrowserObjectAdapter
    implements VTTCue, TextTrackCue, EventTarget {
  BrowserVTTCue(super.element);

  web.VTTCue get inner => _element as web.VTTCue;
}

final class BrowserVTTRegion extends BrowserObjectAdapter
    implements VTTRegion {
  BrowserVTTRegion(super.element);

  web.VTTRegion get inner => _element as web.VTTRegion;
}

final class BrowserValidityState extends BrowserObjectAdapter
    implements ValidityState {
  BrowserValidityState(super.element);

  web.ValidityState get inner => _element as web.ValidityState;
}

final class BrowserVideoColorSpace extends BrowserObjectAdapter
    implements VideoColorSpace {
  BrowserVideoColorSpace(super.element);

  web.VideoColorSpace get inner => _element as web.VideoColorSpace;
}

final class BrowserVideoDecoder extends BrowserObjectAdapter
    implements VideoDecoder, EventTarget {
  BrowserVideoDecoder(super.element);

  web.VideoDecoder get inner => _element as web.VideoDecoder;
}

final class BrowserVideoEncoder extends BrowserObjectAdapter
    implements VideoEncoder, EventTarget {
  BrowserVideoEncoder(super.element);

  web.VideoEncoder get inner => _element as web.VideoEncoder;
}

final class BrowserVideoFrame extends BrowserObjectAdapter
    implements VideoFrame {
  BrowserVideoFrame(super.element);

  web.VideoFrame get inner => _element as web.VideoFrame;
}

final class BrowserVideoPlaybackQuality extends BrowserObjectAdapter
    implements VideoPlaybackQuality {
  BrowserVideoPlaybackQuality(super.element);

  web.VideoPlaybackQuality get inner => _element as web.VideoPlaybackQuality;
}

final class BrowserVideoTrack extends BrowserObjectAdapter
    implements VideoTrack {
  BrowserVideoTrack(super.element);

  web.VideoTrack get inner => _element as web.VideoTrack;
}

final class BrowserVideoTrackList extends BrowserObjectAdapter
    implements VideoTrackList, EventTarget {
  BrowserVideoTrackList(super.element);

  web.VideoTrackList get inner => _element as web.VideoTrackList;
}

final class BrowserViewTransition extends BrowserObjectAdapter
    implements ViewTransition {
  BrowserViewTransition(super.element);

  web.ViewTransition get inner => _element as web.ViewTransition;
}

final class BrowserVisualViewport extends BrowserObjectAdapter
    implements VisualViewport, EventTarget {
  BrowserVisualViewport(super.element);

  web.VisualViewport get inner => _element as web.VisualViewport;
}

final class BrowserWakeLock extends BrowserObjectAdapter
    implements WakeLock {
  BrowserWakeLock(super.element);

  web.WakeLock get inner => _element as web.WakeLock;
}

final class BrowserWaveShaperNode extends BrowserObjectAdapter
    implements WaveShaperNode, AudioNode, EventTarget {
  BrowserWaveShaperNode(super.element);

  web.WaveShaperNode get inner => _element as web.WaveShaperNode;
}

final class BrowserWebGLContextEvent extends BrowserObjectAdapter
    implements WebGLContextEvent, Event {
  BrowserWebGLContextEvent(super.element);

  web.WebGLContextEvent get inner => _element as web.WebGLContextEvent;
}

final class BrowserWebSocket extends BrowserObjectAdapter
    implements WebSocket, EventTarget {
  BrowserWebSocket(super.element);

  web.WebSocket get inner => _element as web.WebSocket;
}

final class BrowserWebTransport extends BrowserObjectAdapter
    implements WebTransport {
  BrowserWebTransport(super.element);

  web.WebTransport get inner => _element as web.WebTransport;
}

final class BrowserWebTransportDatagramDuplexStream extends BrowserObjectAdapter
    implements WebTransportDatagramDuplexStream {
  BrowserWebTransportDatagramDuplexStream(super.element);

  web.WebTransportDatagramDuplexStream get inner => _element as web.WebTransportDatagramDuplexStream;
}

final class BrowserWebTransportError extends BrowserObjectAdapter
    implements WebTransportError, DOMException {
  BrowserWebTransportError(super.element);

  web.WebTransportError get inner => _element as web.WebTransportError;
}

final class BrowserWheelEvent extends BrowserObjectAdapter
    implements WheelEvent, MouseEvent, UIEvent, Event {
  BrowserWheelEvent(super.element);

  web.WheelEvent get inner => _element as web.WheelEvent;
}

final class BrowserWindow extends BrowserObjectAdapter
    implements Window, EventTarget {
  BrowserWindow(super.element);

  web.Window get inner => _element as web.Window;
}

final class BrowserWorker extends BrowserObjectAdapter
    implements Worker, EventTarget {
  BrowserWorker(super.element);

  web.Worker get inner => _element as web.Worker;
}

final class BrowserWritableStream extends BrowserObjectAdapter
    implements WritableStream {
  BrowserWritableStream(super.element);

  web.WritableStream get inner => _element as web.WritableStream;
}

final class BrowserWritableStreamDefaultWriter extends BrowserObjectAdapter
    implements WritableStreamDefaultWriter {
  BrowserWritableStreamDefaultWriter(super.element);

  web.WritableStreamDefaultWriter get inner => _element as web.WritableStreamDefaultWriter;
}

final class BrowserXMLDocument extends BrowserObjectAdapter
    implements XMLDocument, Document, Node, EventTarget {
  BrowserXMLDocument(super.element);

  web.XMLDocument get inner => _element as web.XMLDocument;
}

final class BrowserXMLHttpRequest extends BrowserObjectAdapter
    implements XMLHttpRequest, XMLHttpRequestEventTarget, EventTarget {
  BrowserXMLHttpRequest(super.element);

  web.XMLHttpRequest get inner => _element as web.XMLHttpRequest;
}

final class BrowserXMLHttpRequestUpload extends BrowserObjectAdapter
    implements XMLHttpRequestUpload, XMLHttpRequestEventTarget, EventTarget {
  BrowserXMLHttpRequestUpload(super.element);

  web.XMLHttpRequestUpload get inner => _element as web.XMLHttpRequestUpload;
}

final class BrowserXMLSerializer extends BrowserObjectAdapter
    implements XMLSerializer {
  BrowserXMLSerializer(super.element);

  web.XMLSerializer get inner => _element as web.XMLSerializer;
}

final class BrowserXPathEvaluator extends BrowserObjectAdapter
    implements XPathEvaluator {
  BrowserXPathEvaluator(super.element);

  web.XPathEvaluator get inner => _element as web.XPathEvaluator;
}

final class BrowserXPathExpression extends BrowserObjectAdapter
    implements XPathExpression {
  BrowserXPathExpression(super.element);

  web.XPathExpression get inner => _element as web.XPathExpression;
}

final class BrowserXPathResult extends BrowserObjectAdapter
    implements XPathResult {
  BrowserXPathResult(super.element);

  web.XPathResult get inner => _element as web.XPathResult;
}

final class BrowserXRHand extends BrowserObjectAdapter
    implements XRHand {
  BrowserXRHand(super.element);

  web.XRHand get inner => _element as web.XRHand;
}

final class BrowserXRInputSource extends BrowserObjectAdapter
    implements XRInputSource {
  BrowserXRInputSource(super.element);

  web.XRInputSource get inner => _element as web.XRInputSource;
}

final class BrowserXRInputSourceEvent extends BrowserObjectAdapter
    implements XRInputSourceEvent, Event {
  BrowserXRInputSourceEvent(super.element);

  web.XRInputSourceEvent get inner => _element as web.XRInputSourceEvent;
}

final class BrowserXRInputSourcesChangeEvent extends BrowserObjectAdapter
    implements XRInputSourcesChangeEvent, Event {
  BrowserXRInputSourcesChangeEvent(super.element);

  web.XRInputSourcesChangeEvent get inner => _element as web.XRInputSourcesChangeEvent;
}

final class BrowserXRReferenceSpace extends BrowserObjectAdapter
    implements XRReferenceSpace, XRSpace, EventTarget {
  BrowserXRReferenceSpace(super.element);

  web.XRReferenceSpace get inner => _element as web.XRReferenceSpace;
}

final class BrowserXRReferenceSpaceEvent extends BrowserObjectAdapter
    implements XRReferenceSpaceEvent, Event {
  BrowserXRReferenceSpaceEvent(super.element);

  web.XRReferenceSpaceEvent get inner => _element as web.XRReferenceSpaceEvent;
}

final class BrowserXRRigidTransform extends BrowserObjectAdapter
    implements XRRigidTransform {
  BrowserXRRigidTransform(super.element);

  web.XRRigidTransform get inner => _element as web.XRRigidTransform;
}

final class BrowserXRSessionEvent extends BrowserObjectAdapter
    implements XRSessionEvent, Event {
  BrowserXRSessionEvent(super.element);

  web.XRSessionEvent get inner => _element as web.XRSessionEvent;
}

final class BrowserXRSpace extends BrowserObjectAdapter
    implements XRSpace, EventTarget {
  BrowserXRSpace(super.element);

  web.XRSpace get inner => _element as web.XRSpace;
}

final class BrowserXSLTProcessor extends BrowserObjectAdapter
    implements XSLTProcessor {
  BrowserXSLTProcessor(super.element);

  web.XSLTProcessor get inner => _element as web.XSLTProcessor;
}

final Map<String, BrowserObjectAdapter Function(JSObject)>
    _wrapFactories = {
  'AbortController': (o) => BrowserAbortController(o),
  'AbortSignal': (o) => BrowserAbortSignal(o),
  'AbsoluteOrientationSensor': (o) => BrowserAbsoluteOrientationSensor(o),
  'AnalyserNode': (o) => BrowserAnalyserNode(o),
  'Animation': (o) => BrowserAnimation(o),
  'AnimationEffect': (o) => BrowserAnimationEffect(o),
  'AnimationEvent': (o) => BrowserAnimationEvent(o),
  'AnimationPlaybackEvent': (o) => BrowserAnimationPlaybackEvent(o),
  'AnimationTimeline': (o) => BrowserAnimationTimeline(o),
  'Attr': (o) => BrowserAttr(o),
  'AudioBuffer': (o) => BrowserAudioBuffer(o),
  'AudioBufferSourceNode': (o) => BrowserAudioBufferSourceNode(o),
  'AudioContext': (o) => BrowserAudioContext(o),
  'AudioParam': (o) => BrowserAudioParam(o),
  'AudioParamMap': (o) => BrowserAudioParamMap(o),
  'AudioProcessingEvent': (o) => BrowserAudioProcessingEvent(o),
  'AudioTrack': (o) => BrowserAudioTrack(o),
  'AudioTrackList': (o) => BrowserAudioTrackList(o),
  'AudioWorkletNode': (o) => BrowserAudioWorkletNode(o),
  'AudioWorkletProcessor': (o) => BrowserAudioWorkletProcessor(o),
  'BarProp': (o) => BrowserBarProp(o),
  'BiquadFilterNode': (o) => BrowserBiquadFilterNode(o),
  'Blob': (o) => BrowserBlob(o),
  'BlobEvent': (o) => BrowserBlobEvent(o),
  'BroadcastChannel': (o) => BrowserBroadcastChannel(o),
  'ByteLengthQueuingStrategy': (o) => BrowserByteLengthQueuingStrategy(o),
  'CDATASection': (o) => BrowserCDATASection(o),
  'CSSKeywordValue': (o) => BrowserCSSKeywordValue(o),
  'CSSMathClamp': (o) => BrowserCSSMathClamp(o),
  'CSSMathInvert': (o) => BrowserCSSMathInvert(o),
  'CSSMathMax': (o) => BrowserCSSMathMax(o),
  'CSSMathMin': (o) => BrowserCSSMathMin(o),
  'CSSMathNegate': (o) => BrowserCSSMathNegate(o),
  'CSSMathProduct': (o) => BrowserCSSMathProduct(o),
  'CSSMathSum': (o) => BrowserCSSMathSum(o),
  'CSSMatrixComponent': (o) => BrowserCSSMatrixComponent(o),
  'CSSNumericArray': (o) => BrowserCSSNumericArray(o),
  'CSSNumericValue': (o) => BrowserCSSNumericValue(o),
  'CSSPerspective': (o) => BrowserCSSPerspective(o),
  'CSSRotate': (o) => BrowserCSSRotate(o),
  'CSSRule': (o) => BrowserCSSRule(o),
  'CSSRuleList': (o) => BrowserCSSRuleList(o),
  'CSSScale': (o) => BrowserCSSScale(o),
  'CSSSkew': (o) => BrowserCSSSkew(o),
  'CSSSkewX': (o) => BrowserCSSSkewX(o),
  'CSSSkewY': (o) => BrowserCSSSkewY(o),
  'CSSStyleDeclaration': (o) => BrowserCSSStyleDeclaration(o),
  'CSSStyleSheet': (o) => BrowserCSSStyleSheet(o),
  'CSSStyleValue': (o) => BrowserCSSStyleValue(o),
  'CSSTransformValue': (o) => BrowserCSSTransformValue(o),
  'CSSTranslate': (o) => BrowserCSSTranslate(o),
  'CSSUnitValue': (o) => BrowserCSSUnitValue(o),
  'CSSUnparsedValue': (o) => BrowserCSSUnparsedValue(o),
  'CSSVariableReferenceValue': (o) => BrowserCSSVariableReferenceValue(o),
  'CacheStorage': (o) => BrowserCacheStorage(o),
  'ChannelMergerNode': (o) => BrowserChannelMergerNode(o),
  'ChannelSplitterNode': (o) => BrowserChannelSplitterNode(o),
  'Client': (o) => BrowserClient(o),
  'Clipboard': (o) => BrowserClipboard(o),
  'ClipboardEvent': (o) => BrowserClipboardEvent(o),
  'ClipboardItem': (o) => BrowserClipboardItem(o),
  'CloseEvent': (o) => BrowserCloseEvent(o),
  'Comment': (o) => BrowserComment(o),
  'CompositionEvent': (o) => BrowserCompositionEvent(o),
  'CompressionStream': (o) => BrowserCompressionStream(o),
  'ConstantSourceNode': (o) => BrowserConstantSourceNode(o),
  'ContentVisibilityAutoStateChangeEvent': (o) => BrowserContentVisibilityAutoStateChangeEvent(o),
  'ConvolverNode': (o) => BrowserConvolverNode(o),
  'CookieChangeEvent': (o) => BrowserCookieChangeEvent(o),
  'CountQueuingStrategy': (o) => BrowserCountQueuingStrategy(o),
  'Credential': (o) => BrowserCredential(o),
  'CredentialsContainer': (o) => BrowserCredentialsContainer(o),
  'Crypto': (o) => BrowserCrypto(o),
  'CryptoKey': (o) => BrowserCryptoKey(o),
  'CustomElementRegistry': (o) => BrowserCustomElementRegistry(o),
  'CustomEvent': (o) => BrowserCustomEvent(o),
  'CustomStateSet': (o) => BrowserCustomStateSet(o),
  'DOMException': (o) => BrowserDOMException(o),
  'DOMImplementation': (o) => BrowserDOMImplementation(o),
  'DOMMatrix': (o) => BrowserDOMMatrix(o),
  'DOMMatrixReadOnly': (o) => BrowserDOMMatrixReadOnly(o),
  'DOMParser': (o) => BrowserDOMParser(o),
  'DOMPoint': (o) => BrowserDOMPoint(o),
  'DOMPointReadOnly': (o) => BrowserDOMPointReadOnly(o),
  'DOMQuad': (o) => BrowserDOMQuad(o),
  'DOMRect': (o) => BrowserDOMRect(o),
  'DOMRectList': (o) => BrowserDOMRectList(o),
  'DOMRectReadOnly': (o) => BrowserDOMRectReadOnly(o),
  'DOMStringList': (o) => BrowserDOMStringList(o),
  'DOMStringMap': (o) => BrowserDOMStringMap(o),
  'DOMTokenList': (o) => BrowserDOMTokenList(o),
  'DataTransfer': (o) => BrowserDataTransfer(o),
  'DataTransferItem': (o) => BrowserDataTransferItem(o),
  'DataTransferItemList': (o) => BrowserDataTransferItemList(o),
  'DecompressionStream': (o) => BrowserDecompressionStream(o),
  'DelayNode': (o) => BrowserDelayNode(o),
  'DeviceMotionEvent': (o) => BrowserDeviceMotionEvent(o),
  'DeviceMotionEventAcceleration': (o) => BrowserDeviceMotionEventAcceleration(o),
  'DeviceMotionEventRotationRate': (o) => BrowserDeviceMotionEventRotationRate(o),
  'DeviceOrientationEvent': (o) => BrowserDeviceOrientationEvent(o),
  'Document': (o) => BrowserDocument(o),
  'DocumentFragment': (o) => BrowserDocumentFragment(o),
  'DocumentTimeline': (o) => BrowserDocumentTimeline(o),
  'DocumentType': (o) => BrowserDocumentType(o),
  'DragEvent': (o) => BrowserDragEvent(o),
  'DynamicsCompressorNode': (o) => BrowserDynamicsCompressorNode(o),
  'Element': (o) => BrowserElement(o),
  'ElementInternals': (o) => BrowserElementInternals(o),
  'EncodedVideoChunk': (o) => BrowserEncodedVideoChunk(o),
  'ErrorEvent': (o) => BrowserErrorEvent(o),
  'Event': (o) => BrowserEvent(o),
  'EventCounts': (o) => BrowserEventCounts(o),
  'EventSource': (o) => BrowserEventSource(o),
  'EventTarget': (o) => BrowserEventTarget(o),
  'ExtendableCookieChangeEvent': (o) => BrowserExtendableCookieChangeEvent(o),
  'ExtendableEvent': (o) => BrowserExtendableEvent(o),
  'ExtendableMessageEvent': (o) => BrowserExtendableMessageEvent(o),
  'External': (o) => BrowserExternal(o),
  'FetchEvent': (o) => BrowserFetchEvent(o),
  'File': (o) => BrowserFile(o),
  'FileList': (o) => BrowserFileList(o),
  'FileReader': (o) => BrowserFileReader(o),
  'FileReaderSync': (o) => BrowserFileReaderSync(o),
  'FileSystem': (o) => BrowserFileSystem(o),
  'FileSystemDirectoryEntry': (o) => BrowserFileSystemDirectoryEntry(o),
  'FileSystemDirectoryReader': (o) => BrowserFileSystemDirectoryReader(o),
  'FileSystemEntry': (o) => BrowserFileSystemEntry(o),
  'FocusEvent': (o) => BrowserFocusEvent(o),
  'FontFace': (o) => BrowserFontFace(o),
  'FontFaceSet': (o) => BrowserFontFaceSet(o),
  'FontFaceSetLoadEvent': (o) => BrowserFontFaceSetLoadEvent(o),
  'FormData': (o) => BrowserFormData(o),
  'FormDataEvent': (o) => BrowserFormDataEvent(o),
  'GainNode': (o) => BrowserGainNode(o),
  'Gamepad': (o) => BrowserGamepad(o),
  'GamepadEvent': (o) => BrowserGamepadEvent(o),
  'Geolocation': (o) => BrowserGeolocation(o),
  'GravitySensor': (o) => BrowserGravitySensor(o),
  'Gyroscope': (o) => BrowserGyroscope(o),
  'HTMLAllCollection': (o) => BrowserHTMLAllCollection(o),
  'HTMLAnchorElement': (o) => BrowserHTMLAnchorElement(o),
  'HTMLAreaElement': (o) => BrowserHTMLAreaElement(o),
  'HTMLAudioElement': (o) => BrowserHTMLAudioElement(o),
  'HTMLBRElement': (o) => BrowserHTMLBRElement(o),
  'HTMLBaseElement': (o) => BrowserHTMLBaseElement(o),
  'HTMLBodyElement': (o) => BrowserHTMLBodyElement(o),
  'HTMLButtonElement': (o) => BrowserHTMLButtonElement(o),
  'HTMLCanvasElement': (o) => BrowserHTMLCanvasElement(o),
  'HTMLCollection': (o) => BrowserHTMLCollection(o),
  'HTMLDListElement': (o) => BrowserHTMLDListElement(o),
  'HTMLDataElement': (o) => BrowserHTMLDataElement(o),
  'HTMLDataListElement': (o) => BrowserHTMLDataListElement(o),
  'HTMLDetailsElement': (o) => BrowserHTMLDetailsElement(o),
  'HTMLDialogElement': (o) => BrowserHTMLDialogElement(o),
  'HTMLDirectoryElement': (o) => BrowserHTMLDirectoryElement(o),
  'HTMLDivElement': (o) => BrowserHTMLDivElement(o),
  'HTMLElement': (o) => BrowserHTMLElement(o),
  'HTMLEmbedElement': (o) => BrowserHTMLEmbedElement(o),
  'HTMLFieldSetElement': (o) => BrowserHTMLFieldSetElement(o),
  'HTMLFontElement': (o) => BrowserHTMLFontElement(o),
  'HTMLFormControlsCollection': (o) => BrowserHTMLFormControlsCollection(o),
  'HTMLFormElement': (o) => BrowserHTMLFormElement(o),
  'HTMLFrameElement': (o) => BrowserHTMLFrameElement(o),
  'HTMLFrameSetElement': (o) => BrowserHTMLFrameSetElement(o),
  'HTMLHRElement': (o) => BrowserHTMLHRElement(o),
  'HTMLHeadElement': (o) => BrowserHTMLHeadElement(o),
  'HTMLHeadingElement': (o) => BrowserHTMLHeadingElement(o),
  'HTMLHtmlElement': (o) => BrowserHTMLHtmlElement(o),
  'HTMLIFrameElement': (o) => BrowserHTMLIFrameElement(o),
  'HTMLImageElement': (o) => BrowserHTMLImageElement(o),
  'HTMLInputElement': (o) => BrowserHTMLInputElement(o),
  'HTMLLIElement': (o) => BrowserHTMLLIElement(o),
  'HTMLLabelElement': (o) => BrowserHTMLLabelElement(o),
  'HTMLLegendElement': (o) => BrowserHTMLLegendElement(o),
  'HTMLLinkElement': (o) => BrowserHTMLLinkElement(o),
  'HTMLMapElement': (o) => BrowserHTMLMapElement(o),
  'HTMLMarqueeElement': (o) => BrowserHTMLMarqueeElement(o),
  'HTMLMediaElement': (o) => BrowserHTMLMediaElement(o),
  'HTMLMenuElement': (o) => BrowserHTMLMenuElement(o),
  'HTMLMetaElement': (o) => BrowserHTMLMetaElement(o),
  'HTMLMeterElement': (o) => BrowserHTMLMeterElement(o),
  'HTMLModElement': (o) => BrowserHTMLModElement(o),
  'HTMLOListElement': (o) => BrowserHTMLOListElement(o),
  'HTMLObjectElement': (o) => BrowserHTMLObjectElement(o),
  'HTMLOptGroupElement': (o) => BrowserHTMLOptGroupElement(o),
  'HTMLOptionElement': (o) => BrowserHTMLOptionElement(o),
  'HTMLOptionsCollection': (o) => BrowserHTMLOptionsCollection(o),
  'HTMLOutputElement': (o) => BrowserHTMLOutputElement(o),
  'HTMLParagraphElement': (o) => BrowserHTMLParagraphElement(o),
  'HTMLParamElement': (o) => BrowserHTMLParamElement(o),
  'HTMLPictureElement': (o) => BrowserHTMLPictureElement(o),
  'HTMLPreElement': (o) => BrowserHTMLPreElement(o),
  'HTMLProgressElement': (o) => BrowserHTMLProgressElement(o),
  'HTMLQuoteElement': (o) => BrowserHTMLQuoteElement(o),
  'HTMLScriptElement': (o) => BrowserHTMLScriptElement(o),
  'HTMLSelectElement': (o) => BrowserHTMLSelectElement(o),
  'HTMLSlotElement': (o) => BrowserHTMLSlotElement(o),
  'HTMLSourceElement': (o) => BrowserHTMLSourceElement(o),
  'HTMLSpanElement': (o) => BrowserHTMLSpanElement(o),
  'HTMLStyleElement': (o) => BrowserHTMLStyleElement(o),
  'HTMLTableCaptionElement': (o) => BrowserHTMLTableCaptionElement(o),
  'HTMLTableCellElement': (o) => BrowserHTMLTableCellElement(o),
  'HTMLTableColElement': (o) => BrowserHTMLTableColElement(o),
  'HTMLTableElement': (o) => BrowserHTMLTableElement(o),
  'HTMLTableRowElement': (o) => BrowserHTMLTableRowElement(o),
  'HTMLTableSectionElement': (o) => BrowserHTMLTableSectionElement(o),
  'HTMLTemplateElement': (o) => BrowserHTMLTemplateElement(o),
  'HTMLTextAreaElement': (o) => BrowserHTMLTextAreaElement(o),
  'HTMLTimeElement': (o) => BrowserHTMLTimeElement(o),
  'HTMLTitleElement': (o) => BrowserHTMLTitleElement(o),
  'HTMLTrackElement': (o) => BrowserHTMLTrackElement(o),
  'HTMLUListElement': (o) => BrowserHTMLUListElement(o),
  'HTMLUnknownElement': (o) => BrowserHTMLUnknownElement(o),
  'HTMLVideoElement': (o) => BrowserHTMLVideoElement(o),
  'HashChangeEvent': (o) => BrowserHashChangeEvent(o),
  'Headers': (o) => BrowserHeaders(o),
  'Highlight': (o) => BrowserHighlight(o),
  'History': (o) => BrowserHistory(o),
  'IDBFactory': (o) => BrowserIDBFactory(o),
  'IDBOpenDBRequest': (o) => BrowserIDBOpenDBRequest(o),
  'IDBVersionChangeEvent': (o) => BrowserIDBVersionChangeEvent(o),
  'IIRFilterNode': (o) => BrowserIIRFilterNode(o),
  'ImageBitmap': (o) => BrowserImageBitmap(o),
  'ImageData': (o) => BrowserImageData(o),
  'InputEvent': (o) => BrowserInputEvent(o),
  'IntersectionObserver': (o) => BrowserIntersectionObserver(o),
  'IntersectionObserverEntry': (o) => BrowserIntersectionObserverEntry(o),
  'KeyboardEvent': (o) => BrowserKeyboardEvent(o),
  'KeyframeEffect': (o) => BrowserKeyframeEffect(o),
  'LinearAccelerationSensor': (o) => BrowserLinearAccelerationSensor(o),
  'Location': (o) => BrowserLocation(o),
  'LockManager': (o) => BrowserLockManager(o),
  'MIDIConnectionEvent': (o) => BrowserMIDIConnectionEvent(o),
  'MIDIMessageEvent': (o) => BrowserMIDIMessageEvent(o),
  'MIDIPort': (o) => BrowserMIDIPort(o),
  'MathMLElement': (o) => BrowserMathMLElement(o),
  'MediaCapabilities': (o) => BrowserMediaCapabilities(o),
  'MediaDevices': (o) => BrowserMediaDevices(o),
  'MediaElementAudioSourceNode': (o) => BrowserMediaElementAudioSourceNode(o),
  'MediaEncryptedEvent': (o) => BrowserMediaEncryptedEvent(o),
  'MediaError': (o) => BrowserMediaError(o),
  'MediaKeyMessageEvent': (o) => BrowserMediaKeyMessageEvent(o),
  'MediaKeySession': (o) => BrowserMediaKeySession(o),
  'MediaKeyStatusMap': (o) => BrowserMediaKeyStatusMap(o),
  'MediaKeys': (o) => BrowserMediaKeys(o),
  'MediaMetadata': (o) => BrowserMediaMetadata(o),
  'MediaQueryList': (o) => BrowserMediaQueryList(o),
  'MediaQueryListEvent': (o) => BrowserMediaQueryListEvent(o),
  'MediaRecorder': (o) => BrowserMediaRecorder(o),
  'MediaSession': (o) => BrowserMediaSession(o),
  'MediaSource': (o) => BrowserMediaSource(o),
  'MediaSourceHandle': (o) => BrowserMediaSourceHandle(o),
  'MediaStream': (o) => BrowserMediaStream(o),
  'MediaStreamAudioDestinationNode': (o) => BrowserMediaStreamAudioDestinationNode(o),
  'MediaStreamAudioSourceNode': (o) => BrowserMediaStreamAudioSourceNode(o),
  'MediaStreamTrack': (o) => BrowserMediaStreamTrack(o),
  'MediaStreamTrackAudioSourceNode': (o) => BrowserMediaStreamTrackAudioSourceNode(o),
  'MediaStreamTrackEvent': (o) => BrowserMediaStreamTrackEvent(o),
  'MediaStreamTrackProcessor': (o) => BrowserMediaStreamTrackProcessor(o),
  'MessageChannel': (o) => BrowserMessageChannel(o),
  'MessageEvent': (o) => BrowserMessageEvent(o),
  'MessagePort': (o) => BrowserMessagePort(o),
  'MimeType': (o) => BrowserMimeType(o),
  'MimeTypeArray': (o) => BrowserMimeTypeArray(o),
  'MouseEvent': (o) => BrowserMouseEvent(o),
  'MutationObserver': (o) => BrowserMutationObserver(o),
  'NamedNodeMap': (o) => BrowserNamedNodeMap(o),
  'Navigator': (o) => BrowserNavigator(o),
  'NetworkInformation': (o) => BrowserNetworkInformation(o),
  'Node': (o) => BrowserNode(o),
  'NodeIterator': (o) => BrowserNodeIterator(o),
  'NodeList': (o) => BrowserNodeList(o),
  'Notification': (o) => BrowserNotification(o),
  'NotificationEvent': (o) => BrowserNotificationEvent(o),
  'OfflineAudioCompletionEvent': (o) => BrowserOfflineAudioCompletionEvent(o),
  'OfflineAudioContext': (o) => BrowserOfflineAudioContext(o),
  'OffscreenCanvas': (o) => BrowserOffscreenCanvas(o),
  'OscillatorNode': (o) => BrowserOscillatorNode(o),
  'OverconstrainedError': (o) => BrowserOverconstrainedError(o),
  'PageTransitionEvent': (o) => BrowserPageTransitionEvent(o),
  'PannerNode': (o) => BrowserPannerNode(o),
  'Path2D': (o) => BrowserPath2D(o),
  'PaymentMethodChangeEvent': (o) => BrowserPaymentMethodChangeEvent(o),
  'PaymentRequest': (o) => BrowserPaymentRequest(o),
  'PaymentRequestUpdateEvent': (o) => BrowserPaymentRequestUpdateEvent(o),
  'Performance': (o) => BrowserPerformance(o),
  'PerformanceMark': (o) => BrowserPerformanceMark(o),
  'PerformanceMeasure': (o) => BrowserPerformanceMeasure(o),
  'PerformanceNavigation': (o) => BrowserPerformanceNavigation(o),
  'PerformanceObserver': (o) => BrowserPerformanceObserver(o),
  'PerformanceTiming': (o) => BrowserPerformanceTiming(o),
  'PeriodicWave': (o) => BrowserPeriodicWave(o),
  'Permissions': (o) => BrowserPermissions(o),
  'PictureInPictureEvent': (o) => BrowserPictureInPictureEvent(o),
  'PictureInPictureWindow': (o) => BrowserPictureInPictureWindow(o),
  'Plugin': (o) => BrowserPlugin(o),
  'PluginArray': (o) => BrowserPluginArray(o),
  'PointerEvent': (o) => BrowserPointerEvent(o),
  'PopStateEvent': (o) => BrowserPopStateEvent(o),
  'ProcessingInstruction': (o) => BrowserProcessingInstruction(o),
  'ProgressEvent': (o) => BrowserProgressEvent(o),
  'PromiseRejectionEvent': (o) => BrowserPromiseRejectionEvent(o),
  'PushEvent': (o) => BrowserPushEvent(o),
  'PushMessageData': (o) => BrowserPushMessageData(o),
  'PushSubscription': (o) => BrowserPushSubscription(o),
  'PushSubscriptionChangeEvent': (o) => BrowserPushSubscriptionChangeEvent(o),
  'PushSubscriptionOptions': (o) => BrowserPushSubscriptionOptions(o),
  'RTCDTMFSender': (o) => BrowserRTCDTMFSender(o),
  'RTCDTMFToneChangeEvent': (o) => BrowserRTCDTMFToneChangeEvent(o),
  'RTCDataChannel': (o) => BrowserRTCDataChannel(o),
  'RTCDataChannelEvent': (o) => BrowserRTCDataChannelEvent(o),
  'RTCDtlsTransport': (o) => BrowserRTCDtlsTransport(o),
  'RTCEncodedAudioFrame': (o) => BrowserRTCEncodedAudioFrame(o),
  'RTCEncodedVideoFrame': (o) => BrowserRTCEncodedVideoFrame(o),
  'RTCError': (o) => BrowserRTCError(o),
  'RTCErrorEvent': (o) => BrowserRTCErrorEvent(o),
  'RTCIceCandidate': (o) => BrowserRTCIceCandidate(o),
  'RTCIceTransport': (o) => BrowserRTCIceTransport(o),
  'RTCPeerConnection': (o) => BrowserRTCPeerConnection(o),
  'RTCPeerConnectionIceErrorEvent': (o) => BrowserRTCPeerConnectionIceErrorEvent(o),
  'RTCPeerConnectionIceEvent': (o) => BrowserRTCPeerConnectionIceEvent(o),
  'RTCRtpReceiver': (o) => BrowserRTCRtpReceiver(o),
  'RTCRtpScriptTransform': (o) => BrowserRTCRtpScriptTransform(o),
  'RTCRtpSender': (o) => BrowserRTCRtpSender(o),
  'RTCRtpTransceiver': (o) => BrowserRTCRtpTransceiver(o),
  'RTCSctpTransport': (o) => BrowserRTCSctpTransport(o),
  'RTCSessionDescription': (o) => BrowserRTCSessionDescription(o),
  'RTCTrackEvent': (o) => BrowserRTCTrackEvent(o),
  'RadioNodeList': (o) => BrowserRadioNodeList(o),
  'Range': (o) => BrowserRange(o),
  'ReadableStream': (o) => BrowserReadableStream(o),
  'ReadableStreamBYOBReader': (o) => BrowserReadableStreamBYOBReader(o),
  'ReadableStreamDefaultReader': (o) => BrowserReadableStreamDefaultReader(o),
  'RelativeOrientationSensor': (o) => BrowserRelativeOrientationSensor(o),
  'RemotePlayback': (o) => BrowserRemotePlayback(o),
  'ReportingObserver': (o) => BrowserReportingObserver(o),
  'Request': (o) => BrowserRequest(o),
  'ResizeObserver': (o) => BrowserResizeObserver(o),
  'Response': (o) => BrowserResponse(o),
  'SVGAElement': (o) => BrowserSVGAElement(o),
  'SVGAngle': (o) => BrowserSVGAngle(o),
  'SVGAnimateElement': (o) => BrowserSVGAnimateElement(o),
  'SVGAnimateMotionElement': (o) => BrowserSVGAnimateMotionElement(o),
  'SVGAnimateTransformElement': (o) => BrowserSVGAnimateTransformElement(o),
  'SVGAnimatedAngle': (o) => BrowserSVGAnimatedAngle(o),
  'SVGAnimatedBoolean': (o) => BrowserSVGAnimatedBoolean(o),
  'SVGAnimatedEnumeration': (o) => BrowserSVGAnimatedEnumeration(o),
  'SVGAnimatedInteger': (o) => BrowserSVGAnimatedInteger(o),
  'SVGAnimatedLength': (o) => BrowserSVGAnimatedLength(o),
  'SVGAnimatedLengthList': (o) => BrowserSVGAnimatedLengthList(o),
  'SVGAnimatedNumber': (o) => BrowserSVGAnimatedNumber(o),
  'SVGAnimatedNumberList': (o) => BrowserSVGAnimatedNumberList(o),
  'SVGAnimatedPreserveAspectRatio': (o) => BrowserSVGAnimatedPreserveAspectRatio(o),
  'SVGAnimatedRect': (o) => BrowserSVGAnimatedRect(o),
  'SVGAnimatedString': (o) => BrowserSVGAnimatedString(o),
  'SVGAnimatedTransformList': (o) => BrowserSVGAnimatedTransformList(o),
  'SVGAnimationElement': (o) => BrowserSVGAnimationElement(o),
  'SVGCircleElement': (o) => BrowserSVGCircleElement(o),
  'SVGClipPathElement': (o) => BrowserSVGClipPathElement(o),
  'SVGComponentTransferFunctionElement': (o) => BrowserSVGComponentTransferFunctionElement(o),
  'SVGDefsElement': (o) => BrowserSVGDefsElement(o),
  'SVGDescElement': (o) => BrowserSVGDescElement(o),
  'SVGElement': (o) => BrowserSVGElement(o),
  'SVGEllipseElement': (o) => BrowserSVGEllipseElement(o),
  'SVGFEBlendElement': (o) => BrowserSVGFEBlendElement(o),
  'SVGFEColorMatrixElement': (o) => BrowserSVGFEColorMatrixElement(o),
  'SVGFEComponentTransferElement': (o) => BrowserSVGFEComponentTransferElement(o),
  'SVGFECompositeElement': (o) => BrowserSVGFECompositeElement(o),
  'SVGFEConvolveMatrixElement': (o) => BrowserSVGFEConvolveMatrixElement(o),
  'SVGFEDiffuseLightingElement': (o) => BrowserSVGFEDiffuseLightingElement(o),
  'SVGFEDisplacementMapElement': (o) => BrowserSVGFEDisplacementMapElement(o),
  'SVGFEDistantLightElement': (o) => BrowserSVGFEDistantLightElement(o),
  'SVGFEDropShadowElement': (o) => BrowserSVGFEDropShadowElement(o),
  'SVGFEFloodElement': (o) => BrowserSVGFEFloodElement(o),
  'SVGFEFuncAElement': (o) => BrowserSVGFEFuncAElement(o),
  'SVGFEFuncBElement': (o) => BrowserSVGFEFuncBElement(o),
  'SVGFEFuncGElement': (o) => BrowserSVGFEFuncGElement(o),
  'SVGFEFuncRElement': (o) => BrowserSVGFEFuncRElement(o),
  'SVGFEGaussianBlurElement': (o) => BrowserSVGFEGaussianBlurElement(o),
  'SVGFEImageElement': (o) => BrowserSVGFEImageElement(o),
  'SVGFEMergeElement': (o) => BrowserSVGFEMergeElement(o),
  'SVGFEMergeNodeElement': (o) => BrowserSVGFEMergeNodeElement(o),
  'SVGFEMorphologyElement': (o) => BrowserSVGFEMorphologyElement(o),
  'SVGFEOffsetElement': (o) => BrowserSVGFEOffsetElement(o),
  'SVGFEPointLightElement': (o) => BrowserSVGFEPointLightElement(o),
  'SVGFESpecularLightingElement': (o) => BrowserSVGFESpecularLightingElement(o),
  'SVGFESpotLightElement': (o) => BrowserSVGFESpotLightElement(o),
  'SVGFETileElement': (o) => BrowserSVGFETileElement(o),
  'SVGFETurbulenceElement': (o) => BrowserSVGFETurbulenceElement(o),
  'SVGFilterElement': (o) => BrowserSVGFilterElement(o),
  'SVGForeignObjectElement': (o) => BrowserSVGForeignObjectElement(o),
  'SVGGElement': (o) => BrowserSVGGElement(o),
  'SVGGeometryElement': (o) => BrowserSVGGeometryElement(o),
  'SVGGradientElement': (o) => BrowserSVGGradientElement(o),
  'SVGGraphicsElement': (o) => BrowserSVGGraphicsElement(o),
  'SVGImageElement': (o) => BrowserSVGImageElement(o),
  'SVGLength': (o) => BrowserSVGLength(o),
  'SVGLengthList': (o) => BrowserSVGLengthList(o),
  'SVGLineElement': (o) => BrowserSVGLineElement(o),
  'SVGLinearGradientElement': (o) => BrowserSVGLinearGradientElement(o),
  'SVGMPathElement': (o) => BrowserSVGMPathElement(o),
  'SVGMarkerElement': (o) => BrowserSVGMarkerElement(o),
  'SVGMaskElement': (o) => BrowserSVGMaskElement(o),
  'SVGMetadataElement': (o) => BrowserSVGMetadataElement(o),
  'SVGNumber': (o) => BrowserSVGNumber(o),
  'SVGNumberList': (o) => BrowserSVGNumberList(o),
  'SVGPathElement': (o) => BrowserSVGPathElement(o),
  'SVGPatternElement': (o) => BrowserSVGPatternElement(o),
  'SVGPointList': (o) => BrowserSVGPointList(o),
  'SVGPolygonElement': (o) => BrowserSVGPolygonElement(o),
  'SVGPolylineElement': (o) => BrowserSVGPolylineElement(o),
  'SVGPreserveAspectRatio': (o) => BrowserSVGPreserveAspectRatio(o),
  'SVGRadialGradientElement': (o) => BrowserSVGRadialGradientElement(o),
  'SVGRectElement': (o) => BrowserSVGRectElement(o),
  'SVGSVGElement': (o) => BrowserSVGSVGElement(o),
  'SVGScriptElement': (o) => BrowserSVGScriptElement(o),
  'SVGSetElement': (o) => BrowserSVGSetElement(o),
  'SVGStopElement': (o) => BrowserSVGStopElement(o),
  'SVGStringList': (o) => BrowserSVGStringList(o),
  'SVGStyleElement': (o) => BrowserSVGStyleElement(o),
  'SVGSwitchElement': (o) => BrowserSVGSwitchElement(o),
  'SVGSymbolElement': (o) => BrowserSVGSymbolElement(o),
  'SVGTSpanElement': (o) => BrowserSVGTSpanElement(o),
  'SVGTextContentElement': (o) => BrowserSVGTextContentElement(o),
  'SVGTextElement': (o) => BrowserSVGTextElement(o),
  'SVGTextPathElement': (o) => BrowserSVGTextPathElement(o),
  'SVGTextPositioningElement': (o) => BrowserSVGTextPositioningElement(o),
  'SVGTitleElement': (o) => BrowserSVGTitleElement(o),
  'SVGTransform': (o) => BrowserSVGTransform(o),
  'SVGTransformList': (o) => BrowserSVGTransformList(o),
  'SVGUnitTypes': (o) => BrowserSVGUnitTypes(o),
  'SVGUseElement': (o) => BrowserSVGUseElement(o),
  'SVGViewElement': (o) => BrowserSVGViewElement(o),
  'Sanitizer': (o) => BrowserSanitizer(o),
  'Scheduler': (o) => BrowserScheduler(o),
  'Screen': (o) => BrowserScreen(o),
  'ScreenOrientation': (o) => BrowserScreenOrientation(o),
  'SecurityPolicyViolationEvent': (o) => BrowserSecurityPolicyViolationEvent(o),
  'Selection': (o) => BrowserSelection(o),
  'SensorErrorEvent': (o) => BrowserSensorErrorEvent(o),
  'ServiceWorker': (o) => BrowserServiceWorker(o),
  'ServiceWorkerContainer': (o) => BrowserServiceWorkerContainer(o),
  'ShadowRoot': (o) => BrowserShadowRoot(o),
  'SharedWorker': (o) => BrowserSharedWorker(o),
  'SourceBuffer': (o) => BrowserSourceBuffer(o),
  'SourceBufferList': (o) => BrowserSourceBufferList(o),
  'SpeechRecognition': (o) => BrowserSpeechRecognition(o),
  'SpeechRecognitionAlternative': (o) => BrowserSpeechRecognitionAlternative(o),
  'SpeechRecognitionErrorEvent': (o) => BrowserSpeechRecognitionErrorEvent(o),
  'SpeechRecognitionEvent': (o) => BrowserSpeechRecognitionEvent(o),
  'SpeechRecognitionResult': (o) => BrowserSpeechRecognitionResult(o),
  'SpeechRecognitionResultList': (o) => BrowserSpeechRecognitionResultList(o),
  'SpeechSynthesis': (o) => BrowserSpeechSynthesis(o),
  'SpeechSynthesisErrorEvent': (o) => BrowserSpeechSynthesisErrorEvent(o),
  'SpeechSynthesisEvent': (o) => BrowserSpeechSynthesisEvent(o),
  'SpeechSynthesisUtterance': (o) => BrowserSpeechSynthesisUtterance(o),
  'SpeechSynthesisVoice': (o) => BrowserSpeechSynthesisVoice(o),
  'StaticRange': (o) => BrowserStaticRange(o),
  'StereoPannerNode': (o) => BrowserStereoPannerNode(o),
  'Storage': (o) => BrowserStorage(o),
  'StorageEvent': (o) => BrowserStorageEvent(o),
  'StorageManager': (o) => BrowserStorageManager(o),
  'StylePropertyMap': (o) => BrowserStylePropertyMap(o),
  'StylePropertyMapReadOnly': (o) => BrowserStylePropertyMapReadOnly(o),
  'StyleSheetList': (o) => BrowserStyleSheetList(o),
  'SubmitEvent': (o) => BrowserSubmitEvent(o),
  'SubtleCrypto': (o) => BrowserSubtleCrypto(o),
  'SyncEvent': (o) => BrowserSyncEvent(o),
  'TaskController': (o) => BrowserTaskController(o),
  'TaskPriorityChangeEvent': (o) => BrowserTaskPriorityChangeEvent(o),
  'Text': (o) => BrowserText(o),
  'TextDecoder': (o) => BrowserTextDecoder(o),
  'TextDecoderStream': (o) => BrowserTextDecoderStream(o),
  'TextEncoder': (o) => BrowserTextEncoder(o),
  'TextEncoderStream': (o) => BrowserTextEncoderStream(o),
  'TextTrack': (o) => BrowserTextTrack(o),
  'TextTrackCue': (o) => BrowserTextTrackCue(o),
  'TextTrackCueList': (o) => BrowserTextTrackCueList(o),
  'TextTrackList': (o) => BrowserTextTrackList(o),
  'TimeRanges': (o) => BrowserTimeRanges(o),
  'ToggleEvent': (o) => BrowserToggleEvent(o),
  'Touch': (o) => BrowserTouch(o),
  'TouchEvent': (o) => BrowserTouchEvent(o),
  'TouchList': (o) => BrowserTouchList(o),
  'TrackEvent': (o) => BrowserTrackEvent(o),
  'TransformStream': (o) => BrowserTransformStream(o),
  'TransitionEvent': (o) => BrowserTransitionEvent(o),
  'TreeWalker': (o) => BrowserTreeWalker(o),
  'TrustedHTML': (o) => BrowserTrustedHTML(o),
  'TrustedScript': (o) => BrowserTrustedScript(o),
  'TrustedScriptURL': (o) => BrowserTrustedScriptURL(o),
  'TrustedTypePolicy': (o) => BrowserTrustedTypePolicy(o),
  'TrustedTypePolicyFactory': (o) => BrowserTrustedTypePolicyFactory(o),
  'UIEvent': (o) => BrowserUIEvent(o),
  'URL': (o) => BrowserURL(o),
  'URLSearchParams': (o) => BrowserURLSearchParams(o),
  'UserActivation': (o) => BrowserUserActivation(o),
  'VTTCue': (o) => BrowserVTTCue(o),
  'VTTRegion': (o) => BrowserVTTRegion(o),
  'ValidityState': (o) => BrowserValidityState(o),
  'VideoColorSpace': (o) => BrowserVideoColorSpace(o),
  'VideoDecoder': (o) => BrowserVideoDecoder(o),
  'VideoEncoder': (o) => BrowserVideoEncoder(o),
  'VideoFrame': (o) => BrowserVideoFrame(o),
  'VideoPlaybackQuality': (o) => BrowserVideoPlaybackQuality(o),
  'VideoTrack': (o) => BrowserVideoTrack(o),
  'VideoTrackList': (o) => BrowserVideoTrackList(o),
  'ViewTransition': (o) => BrowserViewTransition(o),
  'VisualViewport': (o) => BrowserVisualViewport(o),
  'WakeLock': (o) => BrowserWakeLock(o),
  'WaveShaperNode': (o) => BrowserWaveShaperNode(o),
  'WebGLContextEvent': (o) => BrowserWebGLContextEvent(o),
  'WebSocket': (o) => BrowserWebSocket(o),
  'WebTransport': (o) => BrowserWebTransport(o),
  'WebTransportDatagramDuplexStream': (o) => BrowserWebTransportDatagramDuplexStream(o),
  'WebTransportError': (o) => BrowserWebTransportError(o),
  'WheelEvent': (o) => BrowserWheelEvent(o),
  'Window': (o) => BrowserWindow(o),
  'Worker': (o) => BrowserWorker(o),
  'WritableStream': (o) => BrowserWritableStream(o),
  'WritableStreamDefaultWriter': (o) => BrowserWritableStreamDefaultWriter(o),
  'XMLDocument': (o) => BrowserXMLDocument(o),
  'XMLHttpRequest': (o) => BrowserXMLHttpRequest(o),
  'XMLHttpRequestUpload': (o) => BrowserXMLHttpRequestUpload(o),
  'XMLSerializer': (o) => BrowserXMLSerializer(o),
  'XPathEvaluator': (o) => BrowserXPathEvaluator(o),
  'XPathExpression': (o) => BrowserXPathExpression(o),
  'XPathResult': (o) => BrowserXPathResult(o),
  'XRHand': (o) => BrowserXRHand(o),
  'XRInputSource': (o) => BrowserXRInputSource(o),
  'XRInputSourceEvent': (o) => BrowserXRInputSourceEvent(o),
  'XRInputSourcesChangeEvent': (o) => BrowserXRInputSourcesChangeEvent(o),
  'XRReferenceSpace': (o) => BrowserXRReferenceSpace(o),
  'XRReferenceSpaceEvent': (o) => BrowserXRReferenceSpaceEvent(o),
  'XRRigidTransform': (o) => BrowserXRRigidTransform(o),
  'XRSessionEvent': (o) => BrowserXRSessionEvent(o),
  'XRSpace': (o) => BrowserXRSpace(o),
  'XSLTProcessor': (o) => BrowserXSLTProcessor(o),
};

/// JS constructors for neutral constructible interfaces, keyed
/// by interface name. Each entry invokes the global JS
/// constructor with the IDL arguments converted to JS and
/// returns the wrapped `Browser*` proxy.
final Map<String, BrowserObjectAdapter Function(List<Object?>)>
    _webConstructors = {
  'AbortController': (arguments) => BrowserAbortController((globalContext
      .getProperty('AbortController'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
      ])),
  'AbsoluteOrientationSensor': (arguments) => BrowserAbsoluteOrientationSensor((globalContext
      .getProperty('AbsoluteOrientationSensor'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
        _toJs(arguments[0]),
      ])),
  'AnalyserNode': (arguments) => BrowserAnalyserNode((globalContext
      .getProperty('AnalyserNode'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
        _toJs(arguments[0]),
        _toJs(arguments[1]),
      ])),
  'Animation': (arguments) => BrowserAnimation((globalContext
      .getProperty('Animation'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
        _toJs(arguments[0]),
        _toJs(arguments[1]),
      ])),
  'AnimationEvent': (arguments) => BrowserAnimationEvent((globalContext
      .getProperty('AnimationEvent'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
        _toJs(arguments[0]),
        _toJs(arguments[1]),
      ])),
  'AnimationPlaybackEvent': (arguments) => BrowserAnimationPlaybackEvent((globalContext
      .getProperty('AnimationPlaybackEvent'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
        _toJs(arguments[0]),
        _toJs(arguments[1]),
      ])),
  'AudioBuffer': (arguments) => BrowserAudioBuffer((globalContext
      .getProperty('AudioBuffer'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
        _toJs(arguments[0]),
      ])),
  'AudioBufferSourceNode': (arguments) => BrowserAudioBufferSourceNode((globalContext
      .getProperty('AudioBufferSourceNode'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
        _toJs(arguments[0]),
        _toJs(arguments[1]),
      ])),
  'AudioContext': (arguments) => BrowserAudioContext((globalContext
      .getProperty('AudioContext'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
        _toJs(arguments[0]),
      ])),
  'AudioProcessingEvent': (arguments) => BrowserAudioProcessingEvent((globalContext
      .getProperty('AudioProcessingEvent'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
        _toJs(arguments[0]),
        _toJs(arguments[1]),
      ])),
  'AudioWorkletNode': (arguments) => BrowserAudioWorkletNode((globalContext
      .getProperty('AudioWorkletNode'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
        _toJs(arguments[0]),
        _toJs(arguments[1]),
        _toJs(arguments[2]),
      ])),
  'AudioWorkletProcessor': (arguments) => BrowserAudioWorkletProcessor((globalContext
      .getProperty('AudioWorkletProcessor'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
      ])),
  'BiquadFilterNode': (arguments) => BrowserBiquadFilterNode((globalContext
      .getProperty('BiquadFilterNode'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
        _toJs(arguments[0]),
        _toJs(arguments[1]),
      ])),
  'Blob': (arguments) => BrowserBlob((globalContext
      .getProperty('Blob'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
        _toJs(arguments[0]),
        _toJs(arguments[1]),
      ])),
  'BlobEvent': (arguments) => BrowserBlobEvent((globalContext
      .getProperty('BlobEvent'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
        _toJs(arguments[0]),
        _toJs(arguments[1]),
      ])),
  'BroadcastChannel': (arguments) => BrowserBroadcastChannel((globalContext
      .getProperty('BroadcastChannel'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
        _toJs(arguments[0]),
      ])),
  'ByteLengthQueuingStrategy': (arguments) => BrowserByteLengthQueuingStrategy((globalContext
      .getProperty('ByteLengthQueuingStrategy'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
        _toJs(arguments[0]),
      ])),
  'CSSKeywordValue': (arguments) => BrowserCSSKeywordValue((globalContext
      .getProperty('CSSKeywordValue'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
        _toJs(arguments[0]),
      ])),
  'CSSMathClamp': (arguments) => BrowserCSSMathClamp((globalContext
      .getProperty('CSSMathClamp'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
        _toJs(arguments[0]),
        _toJs(arguments[1]),
        _toJs(arguments[2]),
      ])),
  'CSSMathInvert': (arguments) => BrowserCSSMathInvert((globalContext
      .getProperty('CSSMathInvert'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
        _toJs(arguments[0]),
      ])),
  'CSSMathMax': (arguments) => BrowserCSSMathMax((globalContext
      .getProperty('CSSMathMax'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
        _toJs(arguments[0]),
      ])),
  'CSSMathMin': (arguments) => BrowserCSSMathMin((globalContext
      .getProperty('CSSMathMin'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
        _toJs(arguments[0]),
      ])),
  'CSSMathNegate': (arguments) => BrowserCSSMathNegate((globalContext
      .getProperty('CSSMathNegate'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
        _toJs(arguments[0]),
      ])),
  'CSSMathProduct': (arguments) => BrowserCSSMathProduct((globalContext
      .getProperty('CSSMathProduct'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
        _toJs(arguments[0]),
      ])),
  'CSSMathSum': (arguments) => BrowserCSSMathSum((globalContext
      .getProperty('CSSMathSum'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
        _toJs(arguments[0]),
      ])),
  'CSSMatrixComponent': (arguments) => BrowserCSSMatrixComponent((globalContext
      .getProperty('CSSMatrixComponent'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
        _toJs(arguments[0]),
        _toJs(arguments[1]),
      ])),
  'CSSPerspective': (arguments) => BrowserCSSPerspective((globalContext
      .getProperty('CSSPerspective'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
        _toJs(arguments[0]),
      ])),
  'CSSRotate': (arguments) => BrowserCSSRotate((globalContext
      .getProperty('CSSRotate'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
        _toJs(arguments[0]),
      ])),
  'CSSScale': (arguments) => BrowserCSSScale((globalContext
      .getProperty('CSSScale'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
        _toJs(arguments[0]),
        _toJs(arguments[1]),
        _toJs(arguments[2]),
      ])),
  'CSSSkew': (arguments) => BrowserCSSSkew((globalContext
      .getProperty('CSSSkew'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
        _toJs(arguments[0]),
        _toJs(arguments[1]),
      ])),
  'CSSSkewX': (arguments) => BrowserCSSSkewX((globalContext
      .getProperty('CSSSkewX'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
        _toJs(arguments[0]),
      ])),
  'CSSSkewY': (arguments) => BrowserCSSSkewY((globalContext
      .getProperty('CSSSkewY'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
        _toJs(arguments[0]),
      ])),
  'CSSStyleSheet': (arguments) => BrowserCSSStyleSheet((globalContext
      .getProperty('CSSStyleSheet'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
        _toJs(arguments[0]),
      ])),
  'CSSTransformValue': (arguments) => BrowserCSSTransformValue((globalContext
      .getProperty('CSSTransformValue'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
        _toJs(arguments[0]),
      ])),
  'CSSTranslate': (arguments) => BrowserCSSTranslate((globalContext
      .getProperty('CSSTranslate'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
        _toJs(arguments[0]),
        _toJs(arguments[1]),
        _toJs(arguments[2]),
      ])),
  'CSSUnitValue': (arguments) => BrowserCSSUnitValue((globalContext
      .getProperty('CSSUnitValue'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
        _toJs(arguments[0]),
        _toJs(arguments[1]),
      ])),
  'CSSUnparsedValue': (arguments) => BrowserCSSUnparsedValue((globalContext
      .getProperty('CSSUnparsedValue'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
        _toJs(arguments[0]),
      ])),
  'CSSVariableReferenceValue': (arguments) => BrowserCSSVariableReferenceValue((globalContext
      .getProperty('CSSVariableReferenceValue'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
        _toJs(arguments[0]),
        _toJs(arguments[1]),
      ])),
  'ChannelMergerNode': (arguments) => BrowserChannelMergerNode((globalContext
      .getProperty('ChannelMergerNode'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
        _toJs(arguments[0]),
        _toJs(arguments[1]),
      ])),
  'ChannelSplitterNode': (arguments) => BrowserChannelSplitterNode((globalContext
      .getProperty('ChannelSplitterNode'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
        _toJs(arguments[0]),
        _toJs(arguments[1]),
      ])),
  'ClipboardEvent': (arguments) => BrowserClipboardEvent((globalContext
      .getProperty('ClipboardEvent'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
        _toJs(arguments[0]),
        _toJs(arguments[1]),
      ])),
  'ClipboardItem': (arguments) => BrowserClipboardItem((globalContext
      .getProperty('ClipboardItem'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
        _toJs(arguments[0]),
        _toJs(arguments[1]),
      ])),
  'CloseEvent': (arguments) => BrowserCloseEvent((globalContext
      .getProperty('CloseEvent'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
        _toJs(arguments[0]),
        _toJs(arguments[1]),
      ])),
  'Comment': (arguments) => BrowserComment((globalContext
      .getProperty('Comment'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
        _toJs(arguments[0]),
      ])),
  'CompositionEvent': (arguments) => BrowserCompositionEvent((globalContext
      .getProperty('CompositionEvent'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
        _toJs(arguments[0]),
        _toJs(arguments[1]),
      ])),
  'CompressionStream': (arguments) => BrowserCompressionStream((globalContext
      .getProperty('CompressionStream'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
        _toJs(arguments[0]),
      ])),
  'ConstantSourceNode': (arguments) => BrowserConstantSourceNode((globalContext
      .getProperty('ConstantSourceNode'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
        _toJs(arguments[0]),
        _toJs(arguments[1]),
      ])),
  'ContentVisibilityAutoStateChangeEvent': (arguments) => BrowserContentVisibilityAutoStateChangeEvent((globalContext
      .getProperty('ContentVisibilityAutoStateChangeEvent'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
        _toJs(arguments[0]),
        _toJs(arguments[1]),
      ])),
  'ConvolverNode': (arguments) => BrowserConvolverNode((globalContext
      .getProperty('ConvolverNode'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
        _toJs(arguments[0]),
        _toJs(arguments[1]),
      ])),
  'CookieChangeEvent': (arguments) => BrowserCookieChangeEvent((globalContext
      .getProperty('CookieChangeEvent'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
        _toJs(arguments[0]),
        _toJs(arguments[1]),
      ])),
  'CountQueuingStrategy': (arguments) => BrowserCountQueuingStrategy((globalContext
      .getProperty('CountQueuingStrategy'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
        _toJs(arguments[0]),
      ])),
  'CustomEvent': (arguments) => BrowserCustomEvent((globalContext
      .getProperty('CustomEvent'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
        _toJs(arguments[0]),
        _toJs(arguments[1]),
      ])),
  'DOMException': (arguments) => BrowserDOMException((globalContext
      .getProperty('DOMException'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
        _toJs(arguments[0]),
        _toJs(arguments[1]),
      ])),
  'DOMMatrix': (arguments) => BrowserDOMMatrix((globalContext
      .getProperty('DOMMatrix'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
        _toJs(arguments[0]),
      ])),
  'DOMMatrixReadOnly': (arguments) => BrowserDOMMatrixReadOnly((globalContext
      .getProperty('DOMMatrixReadOnly'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
        _toJs(arguments[0]),
      ])),
  'DOMParser': (arguments) => BrowserDOMParser((globalContext
      .getProperty('DOMParser'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
      ])),
  'DOMPoint': (arguments) => BrowserDOMPoint((globalContext
      .getProperty('DOMPoint'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
        _toJs(arguments[0]),
        _toJs(arguments[1]),
        _toJs(arguments[2]),
        _toJs(arguments[3]),
      ])),
  'DOMPointReadOnly': (arguments) => BrowserDOMPointReadOnly((globalContext
      .getProperty('DOMPointReadOnly'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
        _toJs(arguments[0]),
        _toJs(arguments[1]),
        _toJs(arguments[2]),
        _toJs(arguments[3]),
      ])),
  'DOMQuad': (arguments) => BrowserDOMQuad((globalContext
      .getProperty('DOMQuad'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
        _toJs(arguments[0]),
        _toJs(arguments[1]),
        _toJs(arguments[2]),
        _toJs(arguments[3]),
      ])),
  'DOMRect': (arguments) => BrowserDOMRect((globalContext
      .getProperty('DOMRect'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
        _toJs(arguments[0]),
        _toJs(arguments[1]),
        _toJs(arguments[2]),
        _toJs(arguments[3]),
      ])),
  'DOMRectReadOnly': (arguments) => BrowserDOMRectReadOnly((globalContext
      .getProperty('DOMRectReadOnly'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
        _toJs(arguments[0]),
        _toJs(arguments[1]),
        _toJs(arguments[2]),
        _toJs(arguments[3]),
      ])),
  'DataTransfer': (arguments) => BrowserDataTransfer((globalContext
      .getProperty('DataTransfer'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
      ])),
  'DecompressionStream': (arguments) => BrowserDecompressionStream((globalContext
      .getProperty('DecompressionStream'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
        _toJs(arguments[0]),
      ])),
  'DelayNode': (arguments) => BrowserDelayNode((globalContext
      .getProperty('DelayNode'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
        _toJs(arguments[0]),
        _toJs(arguments[1]),
      ])),
  'DeviceMotionEvent': (arguments) => BrowserDeviceMotionEvent((globalContext
      .getProperty('DeviceMotionEvent'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
        _toJs(arguments[0]),
        _toJs(arguments[1]),
      ])),
  'DeviceOrientationEvent': (arguments) => BrowserDeviceOrientationEvent((globalContext
      .getProperty('DeviceOrientationEvent'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
        _toJs(arguments[0]),
        _toJs(arguments[1]),
      ])),
  'Document': (arguments) => BrowserDocument((globalContext
      .getProperty('Document'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
      ])),
  'DocumentFragment': (arguments) => BrowserDocumentFragment((globalContext
      .getProperty('DocumentFragment'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
      ])),
  'DocumentTimeline': (arguments) => BrowserDocumentTimeline((globalContext
      .getProperty('DocumentTimeline'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
        _toJs(arguments[0]),
      ])),
  'DragEvent': (arguments) => BrowserDragEvent((globalContext
      .getProperty('DragEvent'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
        _toJs(arguments[0]),
        _toJs(arguments[1]),
      ])),
  'DynamicsCompressorNode': (arguments) => BrowserDynamicsCompressorNode((globalContext
      .getProperty('DynamicsCompressorNode'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
        _toJs(arguments[0]),
        _toJs(arguments[1]),
      ])),
  'EncodedVideoChunk': (arguments) => BrowserEncodedVideoChunk((globalContext
      .getProperty('EncodedVideoChunk'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
        _toJs(arguments[0]),
      ])),
  'ErrorEvent': (arguments) => BrowserErrorEvent((globalContext
      .getProperty('ErrorEvent'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
        _toJs(arguments[0]),
        _toJs(arguments[1]),
      ])),
  'Event': (arguments) => BrowserEvent((globalContext
      .getProperty('Event'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
        _toJs(arguments[0]),
        _toJs(arguments[1]),
      ])),
  'EventSource': (arguments) => BrowserEventSource((globalContext
      .getProperty('EventSource'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
        _toJs(arguments[0]),
        _toJs(arguments[1]),
      ])),
  'EventTarget': (arguments) => BrowserEventTarget((globalContext
      .getProperty('EventTarget'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
      ])),
  'ExtendableCookieChangeEvent': (arguments) => BrowserExtendableCookieChangeEvent((globalContext
      .getProperty('ExtendableCookieChangeEvent'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
        _toJs(arguments[0]),
        _toJs(arguments[1]),
      ])),
  'ExtendableEvent': (arguments) => BrowserExtendableEvent((globalContext
      .getProperty('ExtendableEvent'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
        _toJs(arguments[0]),
        _toJs(arguments[1]),
      ])),
  'ExtendableMessageEvent': (arguments) => BrowserExtendableMessageEvent((globalContext
      .getProperty('ExtendableMessageEvent'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
        _toJs(arguments[0]),
        _toJs(arguments[1]),
      ])),
  'FetchEvent': (arguments) => BrowserFetchEvent((globalContext
      .getProperty('FetchEvent'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
        _toJs(arguments[0]),
        _toJs(arguments[1]),
      ])),
  'File': (arguments) => BrowserFile((globalContext
      .getProperty('File'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
        _toJs(arguments[0]),
        _toJs(arguments[1]),
        _toJs(arguments[2]),
      ])),
  'FileReader': (arguments) => BrowserFileReader((globalContext
      .getProperty('FileReader'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
      ])),
  'FileReaderSync': (arguments) => BrowserFileReaderSync((globalContext
      .getProperty('FileReaderSync'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
      ])),
  'FocusEvent': (arguments) => BrowserFocusEvent((globalContext
      .getProperty('FocusEvent'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
        _toJs(arguments[0]),
        _toJs(arguments[1]),
      ])),
  'FontFace': (arguments) => BrowserFontFace((globalContext
      .getProperty('FontFace'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
        _toJs(arguments[0]),
        _toJs(arguments[1]),
        _toJs(arguments[2]),
      ])),
  'FontFaceSet': (arguments) => BrowserFontFaceSet((globalContext
      .getProperty('FontFaceSet'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
        _toJs(arguments[0]),
      ])),
  'FontFaceSetLoadEvent': (arguments) => BrowserFontFaceSetLoadEvent((globalContext
      .getProperty('FontFaceSetLoadEvent'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
        _toJs(arguments[0]),
        _toJs(arguments[1]),
      ])),
  'FormData': (arguments) => BrowserFormData((globalContext
      .getProperty('FormData'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
        _toJs(arguments[0]),
        _toJs(arguments[1]),
      ])),
  'FormDataEvent': (arguments) => BrowserFormDataEvent((globalContext
      .getProperty('FormDataEvent'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
        _toJs(arguments[0]),
        _toJs(arguments[1]),
      ])),
  'GainNode': (arguments) => BrowserGainNode((globalContext
      .getProperty('GainNode'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
        _toJs(arguments[0]),
        _toJs(arguments[1]),
      ])),
  'GamepadEvent': (arguments) => BrowserGamepadEvent((globalContext
      .getProperty('GamepadEvent'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
        _toJs(arguments[0]),
        _toJs(arguments[1]),
      ])),
  'GravitySensor': (arguments) => BrowserGravitySensor((globalContext
      .getProperty('GravitySensor'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
        _toJs(arguments[0]),
      ])),
  'Gyroscope': (arguments) => BrowserGyroscope((globalContext
      .getProperty('Gyroscope'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
        _toJs(arguments[0]),
      ])),
  'HTMLAnchorElement': (arguments) => BrowserHTMLAnchorElement((globalContext
      .getProperty('HTMLAnchorElement'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
      ])),
  'HTMLAreaElement': (arguments) => BrowserHTMLAreaElement((globalContext
      .getProperty('HTMLAreaElement'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
      ])),
  'HTMLAudioElement': (arguments) => BrowserHTMLAudioElement((globalContext
      .getProperty('HTMLAudioElement'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
      ])),
  'HTMLBRElement': (arguments) => BrowserHTMLBRElement((globalContext
      .getProperty('HTMLBRElement'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
      ])),
  'HTMLBaseElement': (arguments) => BrowserHTMLBaseElement((globalContext
      .getProperty('HTMLBaseElement'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
      ])),
  'HTMLBodyElement': (arguments) => BrowserHTMLBodyElement((globalContext
      .getProperty('HTMLBodyElement'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
      ])),
  'HTMLButtonElement': (arguments) => BrowserHTMLButtonElement((globalContext
      .getProperty('HTMLButtonElement'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
      ])),
  'HTMLCanvasElement': (arguments) => BrowserHTMLCanvasElement((globalContext
      .getProperty('HTMLCanvasElement'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
      ])),
  'HTMLDListElement': (arguments) => BrowserHTMLDListElement((globalContext
      .getProperty('HTMLDListElement'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
      ])),
  'HTMLDataElement': (arguments) => BrowserHTMLDataElement((globalContext
      .getProperty('HTMLDataElement'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
      ])),
  'HTMLDataListElement': (arguments) => BrowserHTMLDataListElement((globalContext
      .getProperty('HTMLDataListElement'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
      ])),
  'HTMLDetailsElement': (arguments) => BrowserHTMLDetailsElement((globalContext
      .getProperty('HTMLDetailsElement'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
      ])),
  'HTMLDialogElement': (arguments) => BrowserHTMLDialogElement((globalContext
      .getProperty('HTMLDialogElement'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
      ])),
  'HTMLDirectoryElement': (arguments) => BrowserHTMLDirectoryElement((globalContext
      .getProperty('HTMLDirectoryElement'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
      ])),
  'HTMLDivElement': (arguments) => BrowserHTMLDivElement((globalContext
      .getProperty('HTMLDivElement'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
      ])),
  'HTMLElement': (arguments) => BrowserHTMLElement((globalContext
      .getProperty('HTMLElement'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
      ])),
  'HTMLEmbedElement': (arguments) => BrowserHTMLEmbedElement((globalContext
      .getProperty('HTMLEmbedElement'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
      ])),
  'HTMLFieldSetElement': (arguments) => BrowserHTMLFieldSetElement((globalContext
      .getProperty('HTMLFieldSetElement'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
      ])),
  'HTMLFontElement': (arguments) => BrowserHTMLFontElement((globalContext
      .getProperty('HTMLFontElement'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
      ])),
  'HTMLFormElement': (arguments) => BrowserHTMLFormElement((globalContext
      .getProperty('HTMLFormElement'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
      ])),
  'HTMLFrameElement': (arguments) => BrowserHTMLFrameElement((globalContext
      .getProperty('HTMLFrameElement'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
      ])),
  'HTMLFrameSetElement': (arguments) => BrowserHTMLFrameSetElement((globalContext
      .getProperty('HTMLFrameSetElement'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
      ])),
  'HTMLHRElement': (arguments) => BrowserHTMLHRElement((globalContext
      .getProperty('HTMLHRElement'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
      ])),
  'HTMLHeadElement': (arguments) => BrowserHTMLHeadElement((globalContext
      .getProperty('HTMLHeadElement'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
      ])),
  'HTMLHeadingElement': (arguments) => BrowserHTMLHeadingElement((globalContext
      .getProperty('HTMLHeadingElement'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
      ])),
  'HTMLHtmlElement': (arguments) => BrowserHTMLHtmlElement((globalContext
      .getProperty('HTMLHtmlElement'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
      ])),
  'HTMLIFrameElement': (arguments) => BrowserHTMLIFrameElement((globalContext
      .getProperty('HTMLIFrameElement'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
      ])),
  'HTMLImageElement': (arguments) => BrowserHTMLImageElement((globalContext
      .getProperty('HTMLImageElement'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
      ])),
  'HTMLInputElement': (arguments) => BrowserHTMLInputElement((globalContext
      .getProperty('HTMLInputElement'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
      ])),
  'HTMLLIElement': (arguments) => BrowserHTMLLIElement((globalContext
      .getProperty('HTMLLIElement'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
      ])),
  'HTMLLabelElement': (arguments) => BrowserHTMLLabelElement((globalContext
      .getProperty('HTMLLabelElement'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
      ])),
  'HTMLLegendElement': (arguments) => BrowserHTMLLegendElement((globalContext
      .getProperty('HTMLLegendElement'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
      ])),
  'HTMLLinkElement': (arguments) => BrowserHTMLLinkElement((globalContext
      .getProperty('HTMLLinkElement'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
      ])),
  'HTMLMapElement': (arguments) => BrowserHTMLMapElement((globalContext
      .getProperty('HTMLMapElement'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
      ])),
  'HTMLMarqueeElement': (arguments) => BrowserHTMLMarqueeElement((globalContext
      .getProperty('HTMLMarqueeElement'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
      ])),
  'HTMLMenuElement': (arguments) => BrowserHTMLMenuElement((globalContext
      .getProperty('HTMLMenuElement'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
      ])),
  'HTMLMetaElement': (arguments) => BrowserHTMLMetaElement((globalContext
      .getProperty('HTMLMetaElement'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
      ])),
  'HTMLMeterElement': (arguments) => BrowserHTMLMeterElement((globalContext
      .getProperty('HTMLMeterElement'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
      ])),
  'HTMLModElement': (arguments) => BrowserHTMLModElement((globalContext
      .getProperty('HTMLModElement'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
      ])),
  'HTMLOListElement': (arguments) => BrowserHTMLOListElement((globalContext
      .getProperty('HTMLOListElement'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
      ])),
  'HTMLObjectElement': (arguments) => BrowserHTMLObjectElement((globalContext
      .getProperty('HTMLObjectElement'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
      ])),
  'HTMLOptGroupElement': (arguments) => BrowserHTMLOptGroupElement((globalContext
      .getProperty('HTMLOptGroupElement'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
      ])),
  'HTMLOptionElement': (arguments) => BrowserHTMLOptionElement((globalContext
      .getProperty('HTMLOptionElement'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
      ])),
  'HTMLOutputElement': (arguments) => BrowserHTMLOutputElement((globalContext
      .getProperty('HTMLOutputElement'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
      ])),
  'HTMLParagraphElement': (arguments) => BrowserHTMLParagraphElement((globalContext
      .getProperty('HTMLParagraphElement'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
      ])),
  'HTMLParamElement': (arguments) => BrowserHTMLParamElement((globalContext
      .getProperty('HTMLParamElement'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
      ])),
  'HTMLPictureElement': (arguments) => BrowserHTMLPictureElement((globalContext
      .getProperty('HTMLPictureElement'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
      ])),
  'HTMLPreElement': (arguments) => BrowserHTMLPreElement((globalContext
      .getProperty('HTMLPreElement'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
      ])),
  'HTMLProgressElement': (arguments) => BrowserHTMLProgressElement((globalContext
      .getProperty('HTMLProgressElement'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
      ])),
  'HTMLQuoteElement': (arguments) => BrowserHTMLQuoteElement((globalContext
      .getProperty('HTMLQuoteElement'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
      ])),
  'HTMLScriptElement': (arguments) => BrowserHTMLScriptElement((globalContext
      .getProperty('HTMLScriptElement'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
      ])),
  'HTMLSelectElement': (arguments) => BrowserHTMLSelectElement((globalContext
      .getProperty('HTMLSelectElement'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
      ])),
  'HTMLSlotElement': (arguments) => BrowserHTMLSlotElement((globalContext
      .getProperty('HTMLSlotElement'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
      ])),
  'HTMLSourceElement': (arguments) => BrowserHTMLSourceElement((globalContext
      .getProperty('HTMLSourceElement'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
      ])),
  'HTMLSpanElement': (arguments) => BrowserHTMLSpanElement((globalContext
      .getProperty('HTMLSpanElement'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
      ])),
  'HTMLStyleElement': (arguments) => BrowserHTMLStyleElement((globalContext
      .getProperty('HTMLStyleElement'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
      ])),
  'HTMLTableCaptionElement': (arguments) => BrowserHTMLTableCaptionElement((globalContext
      .getProperty('HTMLTableCaptionElement'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
      ])),
  'HTMLTableCellElement': (arguments) => BrowserHTMLTableCellElement((globalContext
      .getProperty('HTMLTableCellElement'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
      ])),
  'HTMLTableColElement': (arguments) => BrowserHTMLTableColElement((globalContext
      .getProperty('HTMLTableColElement'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
      ])),
  'HTMLTableElement': (arguments) => BrowserHTMLTableElement((globalContext
      .getProperty('HTMLTableElement'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
      ])),
  'HTMLTableRowElement': (arguments) => BrowserHTMLTableRowElement((globalContext
      .getProperty('HTMLTableRowElement'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
      ])),
  'HTMLTableSectionElement': (arguments) => BrowserHTMLTableSectionElement((globalContext
      .getProperty('HTMLTableSectionElement'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
      ])),
  'HTMLTemplateElement': (arguments) => BrowserHTMLTemplateElement((globalContext
      .getProperty('HTMLTemplateElement'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
      ])),
  'HTMLTextAreaElement': (arguments) => BrowserHTMLTextAreaElement((globalContext
      .getProperty('HTMLTextAreaElement'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
      ])),
  'HTMLTimeElement': (arguments) => BrowserHTMLTimeElement((globalContext
      .getProperty('HTMLTimeElement'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
      ])),
  'HTMLTitleElement': (arguments) => BrowserHTMLTitleElement((globalContext
      .getProperty('HTMLTitleElement'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
      ])),
  'HTMLTrackElement': (arguments) => BrowserHTMLTrackElement((globalContext
      .getProperty('HTMLTrackElement'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
      ])),
  'HTMLUListElement': (arguments) => BrowserHTMLUListElement((globalContext
      .getProperty('HTMLUListElement'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
      ])),
  'HTMLVideoElement': (arguments) => BrowserHTMLVideoElement((globalContext
      .getProperty('HTMLVideoElement'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
      ])),
  'HashChangeEvent': (arguments) => BrowserHashChangeEvent((globalContext
      .getProperty('HashChangeEvent'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
        _toJs(arguments[0]),
        _toJs(arguments[1]),
      ])),
  'Headers': (arguments) => BrowserHeaders((globalContext
      .getProperty('Headers'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
        _toJs(arguments[0]),
      ])),
  'Highlight': (arguments) => BrowserHighlight((globalContext
      .getProperty('Highlight'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
        _toJs(arguments[0]),
      ])),
  'IDBVersionChangeEvent': (arguments) => BrowserIDBVersionChangeEvent((globalContext
      .getProperty('IDBVersionChangeEvent'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
        _toJs(arguments[0]),
        _toJs(arguments[1]),
      ])),
  'IIRFilterNode': (arguments) => BrowserIIRFilterNode((globalContext
      .getProperty('IIRFilterNode'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
        _toJs(arguments[0]),
        _toJs(arguments[1]),
      ])),
  'ImageData': (arguments) => BrowserImageData((globalContext
      .getProperty('ImageData'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
        _toJs(arguments[0]),
        _toJs(arguments[1]),
        _toJs(arguments[2]),
      ])),
  'InputEvent': (arguments) => BrowserInputEvent((globalContext
      .getProperty('InputEvent'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
        _toJs(arguments[0]),
        _toJs(arguments[1]),
      ])),
  'IntersectionObserver': (arguments) => BrowserIntersectionObserver((globalContext
      .getProperty('IntersectionObserver'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
        _toJs(arguments[0]),
        _toJs(arguments[1]),
      ])),
  'IntersectionObserverEntry': (arguments) => BrowserIntersectionObserverEntry((globalContext
      .getProperty('IntersectionObserverEntry'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
        _toJs(arguments[0]),
      ])),
  'KeyboardEvent': (arguments) => BrowserKeyboardEvent((globalContext
      .getProperty('KeyboardEvent'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
        _toJs(arguments[0]),
        _toJs(arguments[1]),
      ])),
  'KeyframeEffect': (arguments) => BrowserKeyframeEffect((globalContext
      .getProperty('KeyframeEffect'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
        _toJs(arguments[0]),
        _toJs(arguments[1]),
        _toJs(arguments[2]),
      ])),
  'LinearAccelerationSensor': (arguments) => BrowserLinearAccelerationSensor((globalContext
      .getProperty('LinearAccelerationSensor'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
        _toJs(arguments[0]),
      ])),
  'MIDIConnectionEvent': (arguments) => BrowserMIDIConnectionEvent((globalContext
      .getProperty('MIDIConnectionEvent'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
        _toJs(arguments[0]),
        _toJs(arguments[1]),
      ])),
  'MIDIMessageEvent': (arguments) => BrowserMIDIMessageEvent((globalContext
      .getProperty('MIDIMessageEvent'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
        _toJs(arguments[0]),
        _toJs(arguments[1]),
      ])),
  'MediaElementAudioSourceNode': (arguments) => BrowserMediaElementAudioSourceNode((globalContext
      .getProperty('MediaElementAudioSourceNode'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
        _toJs(arguments[0]),
        _toJs(arguments[1]),
      ])),
  'MediaEncryptedEvent': (arguments) => BrowserMediaEncryptedEvent((globalContext
      .getProperty('MediaEncryptedEvent'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
        _toJs(arguments[0]),
        _toJs(arguments[1]),
      ])),
  'MediaKeyMessageEvent': (arguments) => BrowserMediaKeyMessageEvent((globalContext
      .getProperty('MediaKeyMessageEvent'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
        _toJs(arguments[0]),
        _toJs(arguments[1]),
      ])),
  'MediaMetadata': (arguments) => BrowserMediaMetadata((globalContext
      .getProperty('MediaMetadata'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
        _toJs(arguments[0]),
      ])),
  'MediaQueryListEvent': (arguments) => BrowserMediaQueryListEvent((globalContext
      .getProperty('MediaQueryListEvent'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
        _toJs(arguments[0]),
        _toJs(arguments[1]),
      ])),
  'MediaRecorder': (arguments) => BrowserMediaRecorder((globalContext
      .getProperty('MediaRecorder'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
        _toJs(arguments[0]),
        _toJs(arguments[1]),
      ])),
  'MediaSource': (arguments) => BrowserMediaSource((globalContext
      .getProperty('MediaSource'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
      ])),
  'MediaStream': (arguments) => BrowserMediaStream((globalContext
      .getProperty('MediaStream'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
      ])),
  'MediaStreamAudioDestinationNode': (arguments) => BrowserMediaStreamAudioDestinationNode((globalContext
      .getProperty('MediaStreamAudioDestinationNode'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
        _toJs(arguments[0]),
        _toJs(arguments[1]),
      ])),
  'MediaStreamAudioSourceNode': (arguments) => BrowserMediaStreamAudioSourceNode((globalContext
      .getProperty('MediaStreamAudioSourceNode'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
        _toJs(arguments[0]),
        _toJs(arguments[1]),
      ])),
  'MediaStreamTrackAudioSourceNode': (arguments) => BrowserMediaStreamTrackAudioSourceNode((globalContext
      .getProperty('MediaStreamTrackAudioSourceNode'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
        _toJs(arguments[0]),
        _toJs(arguments[1]),
      ])),
  'MediaStreamTrackEvent': (arguments) => BrowserMediaStreamTrackEvent((globalContext
      .getProperty('MediaStreamTrackEvent'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
        _toJs(arguments[0]),
        _toJs(arguments[1]),
      ])),
  'MediaStreamTrackProcessor': (arguments) => BrowserMediaStreamTrackProcessor((globalContext
      .getProperty('MediaStreamTrackProcessor'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
        _toJs(arguments[0]),
      ])),
  'MessageChannel': (arguments) => BrowserMessageChannel((globalContext
      .getProperty('MessageChannel'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
      ])),
  'MessageEvent': (arguments) => BrowserMessageEvent((globalContext
      .getProperty('MessageEvent'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
        _toJs(arguments[0]),
        _toJs(arguments[1]),
      ])),
  'MouseEvent': (arguments) => BrowserMouseEvent((globalContext
      .getProperty('MouseEvent'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
        _toJs(arguments[0]),
        _toJs(arguments[1]),
      ])),
  'MutationObserver': (arguments) => BrowserMutationObserver((globalContext
      .getProperty('MutationObserver'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
        _toJs(arguments[0]),
      ])),
  'Notification': (arguments) => BrowserNotification((globalContext
      .getProperty('Notification'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
        _toJs(arguments[0]),
        _toJs(arguments[1]),
      ])),
  'NotificationEvent': (arguments) => BrowserNotificationEvent((globalContext
      .getProperty('NotificationEvent'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
        _toJs(arguments[0]),
        _toJs(arguments[1]),
      ])),
  'OfflineAudioCompletionEvent': (arguments) => BrowserOfflineAudioCompletionEvent((globalContext
      .getProperty('OfflineAudioCompletionEvent'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
        _toJs(arguments[0]),
        _toJs(arguments[1]),
      ])),
  'OfflineAudioContext': (arguments) => BrowserOfflineAudioContext((globalContext
      .getProperty('OfflineAudioContext'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
        _toJs(arguments[0]),
      ])),
  'OffscreenCanvas': (arguments) => BrowserOffscreenCanvas((globalContext
      .getProperty('OffscreenCanvas'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
        _toJs(arguments[0]),
        _toJs(arguments[1]),
      ])),
  'OscillatorNode': (arguments) => BrowserOscillatorNode((globalContext
      .getProperty('OscillatorNode'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
        _toJs(arguments[0]),
        _toJs(arguments[1]),
      ])),
  'OverconstrainedError': (arguments) => BrowserOverconstrainedError((globalContext
      .getProperty('OverconstrainedError'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
        _toJs(arguments[0]),
        _toJs(arguments[1]),
      ])),
  'PageTransitionEvent': (arguments) => BrowserPageTransitionEvent((globalContext
      .getProperty('PageTransitionEvent'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
        _toJs(arguments[0]),
        _toJs(arguments[1]),
      ])),
  'PannerNode': (arguments) => BrowserPannerNode((globalContext
      .getProperty('PannerNode'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
        _toJs(arguments[0]),
        _toJs(arguments[1]),
      ])),
  'Path2D': (arguments) => BrowserPath2D((globalContext
      .getProperty('Path2D'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
        _toJs(arguments[0]),
      ])),
  'PaymentMethodChangeEvent': (arguments) => BrowserPaymentMethodChangeEvent((globalContext
      .getProperty('PaymentMethodChangeEvent'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
        _toJs(arguments[0]),
        _toJs(arguments[1]),
      ])),
  'PaymentRequest': (arguments) => BrowserPaymentRequest((globalContext
      .getProperty('PaymentRequest'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
        _toJs(arguments[0]),
        _toJs(arguments[1]),
      ])),
  'PaymentRequestUpdateEvent': (arguments) => BrowserPaymentRequestUpdateEvent((globalContext
      .getProperty('PaymentRequestUpdateEvent'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
        _toJs(arguments[0]),
        _toJs(arguments[1]),
      ])),
  'PerformanceMark': (arguments) => BrowserPerformanceMark((globalContext
      .getProperty('PerformanceMark'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
        _toJs(arguments[0]),
        _toJs(arguments[1]),
      ])),
  'PerformanceObserver': (arguments) => BrowserPerformanceObserver((globalContext
      .getProperty('PerformanceObserver'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
        _toJs(arguments[0]),
      ])),
  'PeriodicWave': (arguments) => BrowserPeriodicWave((globalContext
      .getProperty('PeriodicWave'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
        _toJs(arguments[0]),
        _toJs(arguments[1]),
      ])),
  'PictureInPictureEvent': (arguments) => BrowserPictureInPictureEvent((globalContext
      .getProperty('PictureInPictureEvent'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
        _toJs(arguments[0]),
        _toJs(arguments[1]),
      ])),
  'PointerEvent': (arguments) => BrowserPointerEvent((globalContext
      .getProperty('PointerEvent'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
        _toJs(arguments[0]),
        _toJs(arguments[1]),
      ])),
  'PopStateEvent': (arguments) => BrowserPopStateEvent((globalContext
      .getProperty('PopStateEvent'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
        _toJs(arguments[0]),
        _toJs(arguments[1]),
      ])),
  'ProgressEvent': (arguments) => BrowserProgressEvent((globalContext
      .getProperty('ProgressEvent'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
        _toJs(arguments[0]),
        _toJs(arguments[1]),
      ])),
  'PromiseRejectionEvent': (arguments) => BrowserPromiseRejectionEvent((globalContext
      .getProperty('PromiseRejectionEvent'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
        _toJs(arguments[0]),
        _toJs(arguments[1]),
      ])),
  'PushEvent': (arguments) => BrowserPushEvent((globalContext
      .getProperty('PushEvent'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
        _toJs(arguments[0]),
        _toJs(arguments[1]),
      ])),
  'PushSubscriptionChangeEvent': (arguments) => BrowserPushSubscriptionChangeEvent((globalContext
      .getProperty('PushSubscriptionChangeEvent'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
        _toJs(arguments[0]),
        _toJs(arguments[1]),
      ])),
  'RTCDTMFToneChangeEvent': (arguments) => BrowserRTCDTMFToneChangeEvent((globalContext
      .getProperty('RTCDTMFToneChangeEvent'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
        _toJs(arguments[0]),
        _toJs(arguments[1]),
      ])),
  'RTCDataChannelEvent': (arguments) => BrowserRTCDataChannelEvent((globalContext
      .getProperty('RTCDataChannelEvent'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
        _toJs(arguments[0]),
        _toJs(arguments[1]),
      ])),
  'RTCEncodedAudioFrame': (arguments) => BrowserRTCEncodedAudioFrame((globalContext
      .getProperty('RTCEncodedAudioFrame'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
        _toJs(arguments[0]),
        _toJs(arguments[1]),
      ])),
  'RTCEncodedVideoFrame': (arguments) => BrowserRTCEncodedVideoFrame((globalContext
      .getProperty('RTCEncodedVideoFrame'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
        _toJs(arguments[0]),
        _toJs(arguments[1]),
      ])),
  'RTCError': (arguments) => BrowserRTCError((globalContext
      .getProperty('RTCError'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
        _toJs(arguments[0]),
        _toJs(arguments[1]),
      ])),
  'RTCErrorEvent': (arguments) => BrowserRTCErrorEvent((globalContext
      .getProperty('RTCErrorEvent'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
        _toJs(arguments[0]),
        _toJs(arguments[1]),
      ])),
  'RTCIceCandidate': (arguments) => BrowserRTCIceCandidate((globalContext
      .getProperty('RTCIceCandidate'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
        _toJs(arguments[0]),
      ])),
  'RTCIceTransport': (arguments) => BrowserRTCIceTransport((globalContext
      .getProperty('RTCIceTransport'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
      ])),
  'RTCPeerConnection': (arguments) => BrowserRTCPeerConnection((globalContext
      .getProperty('RTCPeerConnection'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
        _toJs(arguments[0]),
      ])),
  'RTCPeerConnectionIceErrorEvent': (arguments) => BrowserRTCPeerConnectionIceErrorEvent((globalContext
      .getProperty('RTCPeerConnectionIceErrorEvent'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
        _toJs(arguments[0]),
        _toJs(arguments[1]),
      ])),
  'RTCPeerConnectionIceEvent': (arguments) => BrowserRTCPeerConnectionIceEvent((globalContext
      .getProperty('RTCPeerConnectionIceEvent'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
        _toJs(arguments[0]),
        _toJs(arguments[1]),
      ])),
  'RTCRtpScriptTransform': (arguments) => BrowserRTCRtpScriptTransform((globalContext
      .getProperty('RTCRtpScriptTransform'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
        _toJs(arguments[0]),
        _toJs(arguments[1]),
        _toJs(arguments[2]),
      ])),
  'RTCSessionDescription': (arguments) => BrowserRTCSessionDescription((globalContext
      .getProperty('RTCSessionDescription'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
        _toJs(arguments[0]),
      ])),
  'RTCTrackEvent': (arguments) => BrowserRTCTrackEvent((globalContext
      .getProperty('RTCTrackEvent'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
        _toJs(arguments[0]),
        _toJs(arguments[1]),
      ])),
  'Range': (arguments) => BrowserRange((globalContext
      .getProperty('Range'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
      ])),
  'ReadableStream': (arguments) => BrowserReadableStream((globalContext
      .getProperty('ReadableStream'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
        _toJs(arguments[0]),
        _toJs(arguments[1]),
      ])),
  'ReadableStreamBYOBReader': (arguments) => BrowserReadableStreamBYOBReader((globalContext
      .getProperty('ReadableStreamBYOBReader'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
        _toJs(arguments[0]),
      ])),
  'ReadableStreamDefaultReader': (arguments) => BrowserReadableStreamDefaultReader((globalContext
      .getProperty('ReadableStreamDefaultReader'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
        _toJs(arguments[0]),
      ])),
  'RelativeOrientationSensor': (arguments) => BrowserRelativeOrientationSensor((globalContext
      .getProperty('RelativeOrientationSensor'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
        _toJs(arguments[0]),
      ])),
  'ReportingObserver': (arguments) => BrowserReportingObserver((globalContext
      .getProperty('ReportingObserver'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
        _toJs(arguments[0]),
        _toJs(arguments[1]),
      ])),
  'Request': (arguments) => BrowserRequest((globalContext
      .getProperty('Request'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
        _toJs(arguments[0]),
        _toJs(arguments[1]),
      ])),
  'ResizeObserver': (arguments) => BrowserResizeObserver((globalContext
      .getProperty('ResizeObserver'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
        _toJs(arguments[0]),
      ])),
  'Response': (arguments) => BrowserResponse((globalContext
      .getProperty('Response'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
        _toJs(arguments[0]),
        _toJs(arguments[1]),
      ])),
  'Sanitizer': (arguments) => BrowserSanitizer((globalContext
      .getProperty('Sanitizer'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
        _toJs(arguments[0]),
      ])),
  'SecurityPolicyViolationEvent': (arguments) => BrowserSecurityPolicyViolationEvent((globalContext
      .getProperty('SecurityPolicyViolationEvent'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
        _toJs(arguments[0]),
        _toJs(arguments[1]),
      ])),
  'SensorErrorEvent': (arguments) => BrowserSensorErrorEvent((globalContext
      .getProperty('SensorErrorEvent'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
        _toJs(arguments[0]),
        _toJs(arguments[1]),
      ])),
  'SharedWorker': (arguments) => BrowserSharedWorker((globalContext
      .getProperty('SharedWorker'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
        _toJs(arguments[0]),
        _toJs(arguments[1]),
      ])),
  'SpeechRecognition': (arguments) => BrowserSpeechRecognition((globalContext
      .getProperty('SpeechRecognition'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
      ])),
  'SpeechRecognitionErrorEvent': (arguments) => BrowserSpeechRecognitionErrorEvent((globalContext
      .getProperty('SpeechRecognitionErrorEvent'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
        _toJs(arguments[0]),
        _toJs(arguments[1]),
      ])),
  'SpeechRecognitionEvent': (arguments) => BrowserSpeechRecognitionEvent((globalContext
      .getProperty('SpeechRecognitionEvent'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
        _toJs(arguments[0]),
        _toJs(arguments[1]),
      ])),
  'SpeechSynthesisErrorEvent': (arguments) => BrowserSpeechSynthesisErrorEvent((globalContext
      .getProperty('SpeechSynthesisErrorEvent'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
        _toJs(arguments[0]),
        _toJs(arguments[1]),
      ])),
  'SpeechSynthesisEvent': (arguments) => BrowserSpeechSynthesisEvent((globalContext
      .getProperty('SpeechSynthesisEvent'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
        _toJs(arguments[0]),
        _toJs(arguments[1]),
      ])),
  'SpeechSynthesisUtterance': (arguments) => BrowserSpeechSynthesisUtterance((globalContext
      .getProperty('SpeechSynthesisUtterance'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
        _toJs(arguments[0]),
      ])),
  'StaticRange': (arguments) => BrowserStaticRange((globalContext
      .getProperty('StaticRange'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
        _toJs(arguments[0]),
      ])),
  'StereoPannerNode': (arguments) => BrowserStereoPannerNode((globalContext
      .getProperty('StereoPannerNode'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
        _toJs(arguments[0]),
        _toJs(arguments[1]),
      ])),
  'StorageEvent': (arguments) => BrowserStorageEvent((globalContext
      .getProperty('StorageEvent'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
        _toJs(arguments[0]),
        _toJs(arguments[1]),
      ])),
  'SubmitEvent': (arguments) => BrowserSubmitEvent((globalContext
      .getProperty('SubmitEvent'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
        _toJs(arguments[0]),
        _toJs(arguments[1]),
      ])),
  'SyncEvent': (arguments) => BrowserSyncEvent((globalContext
      .getProperty('SyncEvent'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
        _toJs(arguments[0]),
        _toJs(arguments[1]),
      ])),
  'TaskController': (arguments) => BrowserTaskController((globalContext
      .getProperty('TaskController'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
        _toJs(arguments[0]),
      ])),
  'TaskPriorityChangeEvent': (arguments) => BrowserTaskPriorityChangeEvent((globalContext
      .getProperty('TaskPriorityChangeEvent'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
        _toJs(arguments[0]),
        _toJs(arguments[1]),
      ])),
  'Text': (arguments) => BrowserText((globalContext
      .getProperty('Text'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
        _toJs(arguments[0]),
      ])),
  'TextDecoder': (arguments) => BrowserTextDecoder((globalContext
      .getProperty('TextDecoder'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
        _toJs(arguments[0]),
        _toJs(arguments[1]),
      ])),
  'TextDecoderStream': (arguments) => BrowserTextDecoderStream((globalContext
      .getProperty('TextDecoderStream'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
        _toJs(arguments[0]),
        _toJs(arguments[1]),
      ])),
  'TextEncoder': (arguments) => BrowserTextEncoder((globalContext
      .getProperty('TextEncoder'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
      ])),
  'TextEncoderStream': (arguments) => BrowserTextEncoderStream((globalContext
      .getProperty('TextEncoderStream'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
      ])),
  'ToggleEvent': (arguments) => BrowserToggleEvent((globalContext
      .getProperty('ToggleEvent'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
        _toJs(arguments[0]),
        _toJs(arguments[1]),
      ])),
  'Touch': (arguments) => BrowserTouch((globalContext
      .getProperty('Touch'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
        _toJs(arguments[0]),
      ])),
  'TouchEvent': (arguments) => BrowserTouchEvent((globalContext
      .getProperty('TouchEvent'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
        _toJs(arguments[0]),
        _toJs(arguments[1]),
      ])),
  'TrackEvent': (arguments) => BrowserTrackEvent((globalContext
      .getProperty('TrackEvent'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
        _toJs(arguments[0]),
        _toJs(arguments[1]),
      ])),
  'TransformStream': (arguments) => BrowserTransformStream((globalContext
      .getProperty('TransformStream'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
        _toJs(arguments[0]),
        _toJs(arguments[1]),
        _toJs(arguments[2]),
      ])),
  'TransitionEvent': (arguments) => BrowserTransitionEvent((globalContext
      .getProperty('TransitionEvent'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
        _toJs(arguments[0]),
        _toJs(arguments[1]),
      ])),
  'UIEvent': (arguments) => BrowserUIEvent((globalContext
      .getProperty('UIEvent'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
        _toJs(arguments[0]),
        _toJs(arguments[1]),
      ])),
  'URL': (arguments) => BrowserURL((globalContext
      .getProperty('URL'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
        _toJs(arguments[0]),
        _toJs(arguments[1]),
      ])),
  'URLSearchParams': (arguments) => BrowserURLSearchParams((globalContext
      .getProperty('URLSearchParams'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
        _toJs(arguments[0]),
      ])),
  'VTTCue': (arguments) => BrowserVTTCue((globalContext
      .getProperty('VTTCue'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
        _toJs(arguments[0]),
        _toJs(arguments[1]),
        _toJs(arguments[2]),
      ])),
  'VTTRegion': (arguments) => BrowserVTTRegion((globalContext
      .getProperty('VTTRegion'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
      ])),
  'VideoColorSpace': (arguments) => BrowserVideoColorSpace((globalContext
      .getProperty('VideoColorSpace'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
        _toJs(arguments[0]),
      ])),
  'VideoDecoder': (arguments) => BrowserVideoDecoder((globalContext
      .getProperty('VideoDecoder'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
        _toJs(arguments[0]),
      ])),
  'VideoEncoder': (arguments) => BrowserVideoEncoder((globalContext
      .getProperty('VideoEncoder'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
        _toJs(arguments[0]),
      ])),
  'VideoFrame': (arguments) => BrowserVideoFrame((globalContext
      .getProperty('VideoFrame'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
        _toJs(arguments[0]),
        _toJs(arguments[1]),
      ])),
  'WaveShaperNode': (arguments) => BrowserWaveShaperNode((globalContext
      .getProperty('WaveShaperNode'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
        _toJs(arguments[0]),
        _toJs(arguments[1]),
      ])),
  'WebGLContextEvent': (arguments) => BrowserWebGLContextEvent((globalContext
      .getProperty('WebGLContextEvent'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
        _toJs(arguments[0]),
        _toJs(arguments[1]),
      ])),
  'WebSocket': (arguments) => BrowserWebSocket((globalContext
      .getProperty('WebSocket'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
        _toJs(arguments[0]),
        _toJs(arguments[1]),
      ])),
  'WebTransport': (arguments) => BrowserWebTransport((globalContext
      .getProperty('WebTransport'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
        _toJs(arguments[0]),
        _toJs(arguments[1]),
      ])),
  'WebTransportError': (arguments) => BrowserWebTransportError((globalContext
      .getProperty('WebTransportError'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
        _toJs(arguments[0]),
        _toJs(arguments[1]),
      ])),
  'WheelEvent': (arguments) => BrowserWheelEvent((globalContext
      .getProperty('WheelEvent'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
        _toJs(arguments[0]),
        _toJs(arguments[1]),
      ])),
  'Worker': (arguments) => BrowserWorker((globalContext
      .getProperty('Worker'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
        _toJs(arguments[0]),
        _toJs(arguments[1]),
      ])),
  'WritableStream': (arguments) => BrowserWritableStream((globalContext
      .getProperty('WritableStream'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
        _toJs(arguments[0]),
        _toJs(arguments[1]),
      ])),
  'WritableStreamDefaultWriter': (arguments) => BrowserWritableStreamDefaultWriter((globalContext
      .getProperty('WritableStreamDefaultWriter'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
        _toJs(arguments[0]),
      ])),
  'XMLHttpRequest': (arguments) => BrowserXMLHttpRequest((globalContext
      .getProperty('XMLHttpRequest'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
      ])),
  'XMLSerializer': (arguments) => BrowserXMLSerializer((globalContext
      .getProperty('XMLSerializer'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
      ])),
  'XPathEvaluator': (arguments) => BrowserXPathEvaluator((globalContext
      .getProperty('XPathEvaluator'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
      ])),
  'XRInputSourceEvent': (arguments) => BrowserXRInputSourceEvent((globalContext
      .getProperty('XRInputSourceEvent'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
        _toJs(arguments[0]),
        _toJs(arguments[1]),
      ])),
  'XRInputSourcesChangeEvent': (arguments) => BrowserXRInputSourcesChangeEvent((globalContext
      .getProperty('XRInputSourcesChangeEvent'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
        _toJs(arguments[0]),
        _toJs(arguments[1]),
      ])),
  'XRReferenceSpaceEvent': (arguments) => BrowserXRReferenceSpaceEvent((globalContext
      .getProperty('XRReferenceSpaceEvent'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
        _toJs(arguments[0]),
        _toJs(arguments[1]),
      ])),
  'XRRigidTransform': (arguments) => BrowserXRRigidTransform((globalContext
      .getProperty('XRRigidTransform'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
        _toJs(arguments[0]),
        _toJs(arguments[1]),
      ])),
  'XRSessionEvent': (arguments) => BrowserXRSessionEvent((globalContext
      .getProperty('XRSessionEvent'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
        _toJs(arguments[0]),
        _toJs(arguments[1]),
      ])),
  'XSLTProcessor': (arguments) => BrowserXSLTProcessor((globalContext
      .getProperty('XSLTProcessor'.toJS) as JSFunction)
      .callAsConstructorVarArgs<JSObject>([
      ])),
};

final class BrowserReactSyntheticEvent<T extends EventTarget>
    extends BrowserObjectAdapter
    implements ReactSyntheticEvent<T> {
  BrowserReactSyntheticEvent(super.element);

  JSObject get inner => _element;
}

final class BrowserReactCompositionEvent<T extends EventTarget>
    extends BrowserObjectAdapter
    implements ReactCompositionEvent<T> {
  BrowserReactCompositionEvent(super.element);

  JSObject get inner => _element;
}

final class BrowserReactTouchEvent<T extends EventTarget>
    extends BrowserObjectAdapter
    implements ReactTouchEvent<T> {
  BrowserReactTouchEvent(super.element);

  JSObject get inner => _element;
}

final class BrowserReactPointerEvent<T extends EventTarget>
    extends BrowserObjectAdapter
    implements ReactPointerEvent<T> {
  BrowserReactPointerEvent(super.element);

  JSObject get inner => _element;
}

final class BrowserReactWheelEvent<T extends EventTarget>
    extends BrowserObjectAdapter
    implements ReactWheelEvent<T> {
  BrowserReactWheelEvent(super.element);

  JSObject get inner => _element;
}

final class BrowserReactDragEvent<T extends EventTarget>
    extends BrowserObjectAdapter
    implements ReactDragEvent<T> {
  BrowserReactDragEvent(super.element);

  JSObject get inner => _element;
}

final class BrowserReactFocusEvent<T extends EventTarget>
    extends BrowserObjectAdapter
    implements ReactFocusEvent<T> {
  BrowserReactFocusEvent(super.element);

  JSObject get inner => _element;
}

final class BrowserReactKeyboardEvent<T extends EventTarget>
    extends BrowserObjectAdapter
    implements ReactKeyboardEvent<T> {
  BrowserReactKeyboardEvent(super.element);

  JSObject get inner => _element;
}

final class BrowserReactFormEvent<T extends EventTarget>
    extends BrowserObjectAdapter
    implements ReactFormEvent<T> {
  BrowserReactFormEvent(super.element);

  JSObject get inner => _element;
}

final class BrowserReactChangeEvent<T extends EventTarget>
    extends BrowserObjectAdapter
    implements ReactChangeEvent<T> {
  BrowserReactChangeEvent(super.element);

  JSObject get inner => _element;
}

final class BrowserReactInputEvent<T extends EventTarget>
    extends BrowserObjectAdapter
    implements ReactInputEvent<T> {
  BrowserReactInputEvent(super.element);

  JSObject get inner => _element;
}

final class BrowserReactMouseEvent<T extends EventTarget>
    extends BrowserObjectAdapter
    implements ReactMouseEvent<T> {
  BrowserReactMouseEvent(super.element);

  JSObject get inner => _element;
}

/// Browser [WebRuntime] backend backed by the `package:web`
/// global objects (`window`, `document`, `navigator`).
final class BrowserWebRuntime implements WebRuntime {
  @override
  Window get window => BrowserWindow(web.window);
  @override
  Document get document => BrowserDocument(web.document);
  @override
  Navigator get navigator =>
      BrowserNavigator(web.window.navigator);
  @override
  T createWebObject<T extends Object>(String name, List<Object?> arguments) {
    final ctor = _webConstructors[name];
    if (ctor == null) {
      throw UnsupportedWebApiError('$name constructor');
    }
    return ctor(arguments) as T;
  }
  @override
  dynamic invokeNamespace(String namespace, String member, List<Object?> arguments) {
    final ns = globalContext.getProperty(namespace.toJS);
    if (ns == null || ns.isNull || ns.isUndefined) throw UnsupportedWebApiError("$namespace.$member");
    final jsArgs = [for (final a in arguments) _toJs(a)];
    final result = (ns as JSObject).callMethodVarArgs(member.toJS, jsArgs);
    return _convert(result, "wrap");
  }
  @override
  dynamic getNamespaceProperty(String namespace, String property) {
    final ns = globalContext.getProperty(namespace.toJS);
    if (ns == null || ns.isNull || ns.isUndefined) throw UnsupportedWebApiError("$namespace.$property");
    final value = (ns as JSObject).getProperty(property.toJS);
    return _convert(value, "wrap");
  }
  @override
  void setNamespaceProperty(String namespace, String property, Object? value) {
    final ns = globalContext.getProperty(namespace.toJS);
    if (ns == null || ns.isNull || ns.isUndefined) throw UnsupportedWebApiError("$namespace.$property");
    (ns as JSObject).setProperty(property.toJS, _toJs(value));
  }
}

/// Installs the browser [WebRuntime]. Safe to call repeatedly.
void installBrowserWebRuntime() =>
    WebRuntime.install(BrowserWebRuntime());

/// Registers browser host-value codecs for elements and React
/// synthetic events. Safe to call repeatedly.
void registerBrowserAdapters() {
  ReactCodecRegistry.registerHostValue(
    'web', 'Document',
    decoder: (value) => BrowserDocument(value as JSObject),
    encoder: (value) => (value as BrowserDocument)._element as JSAny?,
  );
  ReactCodecRegistry.registerHostValue(
    'web', 'Element',
    decoder: (value) => BrowserElement(value as JSObject),
    encoder: (value) => (value as BrowserElement)._element as JSAny?,
  );
  ReactCodecRegistry.registerHostValue(
    'web', 'EventTarget',
    decoder: (value) => BrowserEventTarget(value as JSObject),
    encoder: (value) => (value as BrowserEventTarget)._element as JSAny?,
  );
  ReactCodecRegistry.registerHostValue(
    'web', 'HTMLAllCollection',
    decoder: (value) => BrowserHTMLAllCollection(value as JSObject),
    encoder: (value) => (value as BrowserHTMLAllCollection)._element as JSAny?,
  );
  ReactCodecRegistry.registerHostValue(
    'web', 'HTMLAnchorElement',
    decoder: (value) => BrowserHTMLAnchorElement(value as JSObject),
    encoder: (value) => (value as BrowserHTMLAnchorElement)._element as JSAny?,
  );
  ReactCodecRegistry.registerHostValue(
    'web', 'HTMLAreaElement',
    decoder: (value) => BrowserHTMLAreaElement(value as JSObject),
    encoder: (value) => (value as BrowserHTMLAreaElement)._element as JSAny?,
  );
  ReactCodecRegistry.registerHostValue(
    'web', 'HTMLAudioElement',
    decoder: (value) => BrowserHTMLAudioElement(value as JSObject),
    encoder: (value) => (value as BrowserHTMLAudioElement)._element as JSAny?,
  );
  ReactCodecRegistry.registerHostValue(
    'web', 'HTMLBRElement',
    decoder: (value) => BrowserHTMLBRElement(value as JSObject),
    encoder: (value) => (value as BrowserHTMLBRElement)._element as JSAny?,
  );
  ReactCodecRegistry.registerHostValue(
    'web', 'HTMLBaseElement',
    decoder: (value) => BrowserHTMLBaseElement(value as JSObject),
    encoder: (value) => (value as BrowserHTMLBaseElement)._element as JSAny?,
  );
  ReactCodecRegistry.registerHostValue(
    'web', 'HTMLBodyElement',
    decoder: (value) => BrowserHTMLBodyElement(value as JSObject),
    encoder: (value) => (value as BrowserHTMLBodyElement)._element as JSAny?,
  );
  ReactCodecRegistry.registerHostValue(
    'web', 'HTMLButtonElement',
    decoder: (value) => BrowserHTMLButtonElement(value as JSObject),
    encoder: (value) => (value as BrowserHTMLButtonElement)._element as JSAny?,
  );
  ReactCodecRegistry.registerHostValue(
    'web', 'HTMLCanvasElement',
    decoder: (value) => BrowserHTMLCanvasElement(value as JSObject),
    encoder: (value) => (value as BrowserHTMLCanvasElement)._element as JSAny?,
  );
  ReactCodecRegistry.registerHostValue(
    'web', 'HTMLCollection',
    decoder: (value) => BrowserHTMLCollection(value as JSObject),
    encoder: (value) => (value as BrowserHTMLCollection)._element as JSAny?,
  );
  ReactCodecRegistry.registerHostValue(
    'web', 'HTMLDListElement',
    decoder: (value) => BrowserHTMLDListElement(value as JSObject),
    encoder: (value) => (value as BrowserHTMLDListElement)._element as JSAny?,
  );
  ReactCodecRegistry.registerHostValue(
    'web', 'HTMLDataElement',
    decoder: (value) => BrowserHTMLDataElement(value as JSObject),
    encoder: (value) => (value as BrowserHTMLDataElement)._element as JSAny?,
  );
  ReactCodecRegistry.registerHostValue(
    'web', 'HTMLDataListElement',
    decoder: (value) => BrowserHTMLDataListElement(value as JSObject),
    encoder: (value) => (value as BrowserHTMLDataListElement)._element as JSAny?,
  );
  ReactCodecRegistry.registerHostValue(
    'web', 'HTMLDetailsElement',
    decoder: (value) => BrowserHTMLDetailsElement(value as JSObject),
    encoder: (value) => (value as BrowserHTMLDetailsElement)._element as JSAny?,
  );
  ReactCodecRegistry.registerHostValue(
    'web', 'HTMLDialogElement',
    decoder: (value) => BrowserHTMLDialogElement(value as JSObject),
    encoder: (value) => (value as BrowserHTMLDialogElement)._element as JSAny?,
  );
  ReactCodecRegistry.registerHostValue(
    'web', 'HTMLDirectoryElement',
    decoder: (value) => BrowserHTMLDirectoryElement(value as JSObject),
    encoder: (value) => (value as BrowserHTMLDirectoryElement)._element as JSAny?,
  );
  ReactCodecRegistry.registerHostValue(
    'web', 'HTMLDivElement',
    decoder: (value) => BrowserHTMLDivElement(value as JSObject),
    encoder: (value) => (value as BrowserHTMLDivElement)._element as JSAny?,
  );
  ReactCodecRegistry.registerHostValue(
    'web', 'HTMLElement',
    decoder: (value) => BrowserHTMLElement(value as JSObject),
    encoder: (value) => (value as BrowserHTMLElement)._element as JSAny?,
  );
  ReactCodecRegistry.registerHostValue(
    'web', 'HTMLEmbedElement',
    decoder: (value) => BrowserHTMLEmbedElement(value as JSObject),
    encoder: (value) => (value as BrowserHTMLEmbedElement)._element as JSAny?,
  );
  ReactCodecRegistry.registerHostValue(
    'web', 'HTMLFieldSetElement',
    decoder: (value) => BrowserHTMLFieldSetElement(value as JSObject),
    encoder: (value) => (value as BrowserHTMLFieldSetElement)._element as JSAny?,
  );
  ReactCodecRegistry.registerHostValue(
    'web', 'HTMLFontElement',
    decoder: (value) => BrowserHTMLFontElement(value as JSObject),
    encoder: (value) => (value as BrowserHTMLFontElement)._element as JSAny?,
  );
  ReactCodecRegistry.registerHostValue(
    'web', 'HTMLFormControlsCollection',
    decoder: (value) => BrowserHTMLFormControlsCollection(value as JSObject),
    encoder: (value) => (value as BrowserHTMLFormControlsCollection)._element as JSAny?,
  );
  ReactCodecRegistry.registerHostValue(
    'web', 'HTMLFormElement',
    decoder: (value) => BrowserHTMLFormElement(value as JSObject),
    encoder: (value) => (value as BrowserHTMLFormElement)._element as JSAny?,
  );
  ReactCodecRegistry.registerHostValue(
    'web', 'HTMLFrameElement',
    decoder: (value) => BrowserHTMLFrameElement(value as JSObject),
    encoder: (value) => (value as BrowserHTMLFrameElement)._element as JSAny?,
  );
  ReactCodecRegistry.registerHostValue(
    'web', 'HTMLFrameSetElement',
    decoder: (value) => BrowserHTMLFrameSetElement(value as JSObject),
    encoder: (value) => (value as BrowserHTMLFrameSetElement)._element as JSAny?,
  );
  ReactCodecRegistry.registerHostValue(
    'web', 'HTMLHRElement',
    decoder: (value) => BrowserHTMLHRElement(value as JSObject),
    encoder: (value) => (value as BrowserHTMLHRElement)._element as JSAny?,
  );
  ReactCodecRegistry.registerHostValue(
    'web', 'HTMLHeadElement',
    decoder: (value) => BrowserHTMLHeadElement(value as JSObject),
    encoder: (value) => (value as BrowserHTMLHeadElement)._element as JSAny?,
  );
  ReactCodecRegistry.registerHostValue(
    'web', 'HTMLHeadingElement',
    decoder: (value) => BrowserHTMLHeadingElement(value as JSObject),
    encoder: (value) => (value as BrowserHTMLHeadingElement)._element as JSAny?,
  );
  ReactCodecRegistry.registerHostValue(
    'web', 'HTMLHtmlElement',
    decoder: (value) => BrowserHTMLHtmlElement(value as JSObject),
    encoder: (value) => (value as BrowserHTMLHtmlElement)._element as JSAny?,
  );
  ReactCodecRegistry.registerHostValue(
    'web', 'HTMLIFrameElement',
    decoder: (value) => BrowserHTMLIFrameElement(value as JSObject),
    encoder: (value) => (value as BrowserHTMLIFrameElement)._element as JSAny?,
  );
  ReactCodecRegistry.registerHostValue(
    'web', 'HTMLImageElement',
    decoder: (value) => BrowserHTMLImageElement(value as JSObject),
    encoder: (value) => (value as BrowserHTMLImageElement)._element as JSAny?,
  );
  ReactCodecRegistry.registerHostValue(
    'web', 'HTMLInputElement',
    decoder: (value) => BrowserHTMLInputElement(value as JSObject),
    encoder: (value) => (value as BrowserHTMLInputElement)._element as JSAny?,
  );
  ReactCodecRegistry.registerHostValue(
    'web', 'HTMLLIElement',
    decoder: (value) => BrowserHTMLLIElement(value as JSObject),
    encoder: (value) => (value as BrowserHTMLLIElement)._element as JSAny?,
  );
  ReactCodecRegistry.registerHostValue(
    'web', 'HTMLLabelElement',
    decoder: (value) => BrowserHTMLLabelElement(value as JSObject),
    encoder: (value) => (value as BrowserHTMLLabelElement)._element as JSAny?,
  );
  ReactCodecRegistry.registerHostValue(
    'web', 'HTMLLegendElement',
    decoder: (value) => BrowserHTMLLegendElement(value as JSObject),
    encoder: (value) => (value as BrowserHTMLLegendElement)._element as JSAny?,
  );
  ReactCodecRegistry.registerHostValue(
    'web', 'HTMLLinkElement',
    decoder: (value) => BrowserHTMLLinkElement(value as JSObject),
    encoder: (value) => (value as BrowserHTMLLinkElement)._element as JSAny?,
  );
  ReactCodecRegistry.registerHostValue(
    'web', 'HTMLMapElement',
    decoder: (value) => BrowserHTMLMapElement(value as JSObject),
    encoder: (value) => (value as BrowserHTMLMapElement)._element as JSAny?,
  );
  ReactCodecRegistry.registerHostValue(
    'web', 'HTMLMarqueeElement',
    decoder: (value) => BrowserHTMLMarqueeElement(value as JSObject),
    encoder: (value) => (value as BrowserHTMLMarqueeElement)._element as JSAny?,
  );
  ReactCodecRegistry.registerHostValue(
    'web', 'HTMLMediaElement',
    decoder: (value) => BrowserHTMLMediaElement(value as JSObject),
    encoder: (value) => (value as BrowserHTMLMediaElement)._element as JSAny?,
  );
  ReactCodecRegistry.registerHostValue(
    'web', 'HTMLMenuElement',
    decoder: (value) => BrowserHTMLMenuElement(value as JSObject),
    encoder: (value) => (value as BrowserHTMLMenuElement)._element as JSAny?,
  );
  ReactCodecRegistry.registerHostValue(
    'web', 'HTMLMetaElement',
    decoder: (value) => BrowserHTMLMetaElement(value as JSObject),
    encoder: (value) => (value as BrowserHTMLMetaElement)._element as JSAny?,
  );
  ReactCodecRegistry.registerHostValue(
    'web', 'HTMLMeterElement',
    decoder: (value) => BrowserHTMLMeterElement(value as JSObject),
    encoder: (value) => (value as BrowserHTMLMeterElement)._element as JSAny?,
  );
  ReactCodecRegistry.registerHostValue(
    'web', 'HTMLModElement',
    decoder: (value) => BrowserHTMLModElement(value as JSObject),
    encoder: (value) => (value as BrowserHTMLModElement)._element as JSAny?,
  );
  ReactCodecRegistry.registerHostValue(
    'web', 'HTMLOListElement',
    decoder: (value) => BrowserHTMLOListElement(value as JSObject),
    encoder: (value) => (value as BrowserHTMLOListElement)._element as JSAny?,
  );
  ReactCodecRegistry.registerHostValue(
    'web', 'HTMLObjectElement',
    decoder: (value) => BrowserHTMLObjectElement(value as JSObject),
    encoder: (value) => (value as BrowserHTMLObjectElement)._element as JSAny?,
  );
  ReactCodecRegistry.registerHostValue(
    'web', 'HTMLOptGroupElement',
    decoder: (value) => BrowserHTMLOptGroupElement(value as JSObject),
    encoder: (value) => (value as BrowserHTMLOptGroupElement)._element as JSAny?,
  );
  ReactCodecRegistry.registerHostValue(
    'web', 'HTMLOptionElement',
    decoder: (value) => BrowserHTMLOptionElement(value as JSObject),
    encoder: (value) => (value as BrowserHTMLOptionElement)._element as JSAny?,
  );
  ReactCodecRegistry.registerHostValue(
    'web', 'HTMLOptionsCollection',
    decoder: (value) => BrowserHTMLOptionsCollection(value as JSObject),
    encoder: (value) => (value as BrowserHTMLOptionsCollection)._element as JSAny?,
  );
  ReactCodecRegistry.registerHostValue(
    'web', 'HTMLOutputElement',
    decoder: (value) => BrowserHTMLOutputElement(value as JSObject),
    encoder: (value) => (value as BrowserHTMLOutputElement)._element as JSAny?,
  );
  ReactCodecRegistry.registerHostValue(
    'web', 'HTMLParagraphElement',
    decoder: (value) => BrowserHTMLParagraphElement(value as JSObject),
    encoder: (value) => (value as BrowserHTMLParagraphElement)._element as JSAny?,
  );
  ReactCodecRegistry.registerHostValue(
    'web', 'HTMLParamElement',
    decoder: (value) => BrowserHTMLParamElement(value as JSObject),
    encoder: (value) => (value as BrowserHTMLParamElement)._element as JSAny?,
  );
  ReactCodecRegistry.registerHostValue(
    'web', 'HTMLPictureElement',
    decoder: (value) => BrowserHTMLPictureElement(value as JSObject),
    encoder: (value) => (value as BrowserHTMLPictureElement)._element as JSAny?,
  );
  ReactCodecRegistry.registerHostValue(
    'web', 'HTMLPreElement',
    decoder: (value) => BrowserHTMLPreElement(value as JSObject),
    encoder: (value) => (value as BrowserHTMLPreElement)._element as JSAny?,
  );
  ReactCodecRegistry.registerHostValue(
    'web', 'HTMLProgressElement',
    decoder: (value) => BrowserHTMLProgressElement(value as JSObject),
    encoder: (value) => (value as BrowserHTMLProgressElement)._element as JSAny?,
  );
  ReactCodecRegistry.registerHostValue(
    'web', 'HTMLQuoteElement',
    decoder: (value) => BrowserHTMLQuoteElement(value as JSObject),
    encoder: (value) => (value as BrowserHTMLQuoteElement)._element as JSAny?,
  );
  ReactCodecRegistry.registerHostValue(
    'web', 'HTMLScriptElement',
    decoder: (value) => BrowserHTMLScriptElement(value as JSObject),
    encoder: (value) => (value as BrowserHTMLScriptElement)._element as JSAny?,
  );
  ReactCodecRegistry.registerHostValue(
    'web', 'HTMLSelectElement',
    decoder: (value) => BrowserHTMLSelectElement(value as JSObject),
    encoder: (value) => (value as BrowserHTMLSelectElement)._element as JSAny?,
  );
  ReactCodecRegistry.registerHostValue(
    'web', 'HTMLSlotElement',
    decoder: (value) => BrowserHTMLSlotElement(value as JSObject),
    encoder: (value) => (value as BrowserHTMLSlotElement)._element as JSAny?,
  );
  ReactCodecRegistry.registerHostValue(
    'web', 'HTMLSourceElement',
    decoder: (value) => BrowserHTMLSourceElement(value as JSObject),
    encoder: (value) => (value as BrowserHTMLSourceElement)._element as JSAny?,
  );
  ReactCodecRegistry.registerHostValue(
    'web', 'HTMLSpanElement',
    decoder: (value) => BrowserHTMLSpanElement(value as JSObject),
    encoder: (value) => (value as BrowserHTMLSpanElement)._element as JSAny?,
  );
  ReactCodecRegistry.registerHostValue(
    'web', 'HTMLStyleElement',
    decoder: (value) => BrowserHTMLStyleElement(value as JSObject),
    encoder: (value) => (value as BrowserHTMLStyleElement)._element as JSAny?,
  );
  ReactCodecRegistry.registerHostValue(
    'web', 'HTMLTableCaptionElement',
    decoder: (value) => BrowserHTMLTableCaptionElement(value as JSObject),
    encoder: (value) => (value as BrowserHTMLTableCaptionElement)._element as JSAny?,
  );
  ReactCodecRegistry.registerHostValue(
    'web', 'HTMLTableCellElement',
    decoder: (value) => BrowserHTMLTableCellElement(value as JSObject),
    encoder: (value) => (value as BrowserHTMLTableCellElement)._element as JSAny?,
  );
  ReactCodecRegistry.registerHostValue(
    'web', 'HTMLTableColElement',
    decoder: (value) => BrowserHTMLTableColElement(value as JSObject),
    encoder: (value) => (value as BrowserHTMLTableColElement)._element as JSAny?,
  );
  ReactCodecRegistry.registerHostValue(
    'web', 'HTMLTableElement',
    decoder: (value) => BrowserHTMLTableElement(value as JSObject),
    encoder: (value) => (value as BrowserHTMLTableElement)._element as JSAny?,
  );
  ReactCodecRegistry.registerHostValue(
    'web', 'HTMLTableRowElement',
    decoder: (value) => BrowserHTMLTableRowElement(value as JSObject),
    encoder: (value) => (value as BrowserHTMLTableRowElement)._element as JSAny?,
  );
  ReactCodecRegistry.registerHostValue(
    'web', 'HTMLTableSectionElement',
    decoder: (value) => BrowserHTMLTableSectionElement(value as JSObject),
    encoder: (value) => (value as BrowserHTMLTableSectionElement)._element as JSAny?,
  );
  ReactCodecRegistry.registerHostValue(
    'web', 'HTMLTemplateElement',
    decoder: (value) => BrowserHTMLTemplateElement(value as JSObject),
    encoder: (value) => (value as BrowserHTMLTemplateElement)._element as JSAny?,
  );
  ReactCodecRegistry.registerHostValue(
    'web', 'HTMLTextAreaElement',
    decoder: (value) => BrowserHTMLTextAreaElement(value as JSObject),
    encoder: (value) => (value as BrowserHTMLTextAreaElement)._element as JSAny?,
  );
  ReactCodecRegistry.registerHostValue(
    'web', 'HTMLTimeElement',
    decoder: (value) => BrowserHTMLTimeElement(value as JSObject),
    encoder: (value) => (value as BrowserHTMLTimeElement)._element as JSAny?,
  );
  ReactCodecRegistry.registerHostValue(
    'web', 'HTMLTitleElement',
    decoder: (value) => BrowserHTMLTitleElement(value as JSObject),
    encoder: (value) => (value as BrowserHTMLTitleElement)._element as JSAny?,
  );
  ReactCodecRegistry.registerHostValue(
    'web', 'HTMLTrackElement',
    decoder: (value) => BrowserHTMLTrackElement(value as JSObject),
    encoder: (value) => (value as BrowserHTMLTrackElement)._element as JSAny?,
  );
  ReactCodecRegistry.registerHostValue(
    'web', 'HTMLUListElement',
    decoder: (value) => BrowserHTMLUListElement(value as JSObject),
    encoder: (value) => (value as BrowserHTMLUListElement)._element as JSAny?,
  );
  ReactCodecRegistry.registerHostValue(
    'web', 'HTMLUnknownElement',
    decoder: (value) => BrowserHTMLUnknownElement(value as JSObject),
    encoder: (value) => (value as BrowserHTMLUnknownElement)._element as JSAny?,
  );
  ReactCodecRegistry.registerHostValue(
    'web', 'HTMLVideoElement',
    decoder: (value) => BrowserHTMLVideoElement(value as JSObject),
    encoder: (value) => (value as BrowserHTMLVideoElement)._element as JSAny?,
  );
  ReactCodecRegistry.registerHostValue(
    'web', 'MathMLElement',
    decoder: (value) => BrowserMathMLElement(value as JSObject),
    encoder: (value) => (value as BrowserMathMLElement)._element as JSAny?,
  );
  ReactCodecRegistry.registerHostValue(
    'web', 'Navigator',
    decoder: (value) => BrowserNavigator(value as JSObject),
    encoder: (value) => (value as BrowserNavigator)._element as JSAny?,
  );
  ReactCodecRegistry.registerHostValue(
    'web', 'Node',
    decoder: (value) => BrowserNode(value as JSObject),
    encoder: (value) => (value as BrowserNode)._element as JSAny?,
  );
  ReactCodecRegistry.registerHostValue(
    'web', 'SVGAElement',
    decoder: (value) => BrowserSVGAElement(value as JSObject),
    encoder: (value) => (value as BrowserSVGAElement)._element as JSAny?,
  );
  ReactCodecRegistry.registerHostValue(
    'web', 'SVGAngle',
    decoder: (value) => BrowserSVGAngle(value as JSObject),
    encoder: (value) => (value as BrowserSVGAngle)._element as JSAny?,
  );
  ReactCodecRegistry.registerHostValue(
    'web', 'SVGAnimateElement',
    decoder: (value) => BrowserSVGAnimateElement(value as JSObject),
    encoder: (value) => (value as BrowserSVGAnimateElement)._element as JSAny?,
  );
  ReactCodecRegistry.registerHostValue(
    'web', 'SVGAnimateMotionElement',
    decoder: (value) => BrowserSVGAnimateMotionElement(value as JSObject),
    encoder: (value) => (value as BrowserSVGAnimateMotionElement)._element as JSAny?,
  );
  ReactCodecRegistry.registerHostValue(
    'web', 'SVGAnimateTransformElement',
    decoder: (value) => BrowserSVGAnimateTransformElement(value as JSObject),
    encoder: (value) => (value as BrowserSVGAnimateTransformElement)._element as JSAny?,
  );
  ReactCodecRegistry.registerHostValue(
    'web', 'SVGAnimatedAngle',
    decoder: (value) => BrowserSVGAnimatedAngle(value as JSObject),
    encoder: (value) => (value as BrowserSVGAnimatedAngle)._element as JSAny?,
  );
  ReactCodecRegistry.registerHostValue(
    'web', 'SVGAnimatedBoolean',
    decoder: (value) => BrowserSVGAnimatedBoolean(value as JSObject),
    encoder: (value) => (value as BrowserSVGAnimatedBoolean)._element as JSAny?,
  );
  ReactCodecRegistry.registerHostValue(
    'web', 'SVGAnimatedEnumeration',
    decoder: (value) => BrowserSVGAnimatedEnumeration(value as JSObject),
    encoder: (value) => (value as BrowserSVGAnimatedEnumeration)._element as JSAny?,
  );
  ReactCodecRegistry.registerHostValue(
    'web', 'SVGAnimatedInteger',
    decoder: (value) => BrowserSVGAnimatedInteger(value as JSObject),
    encoder: (value) => (value as BrowserSVGAnimatedInteger)._element as JSAny?,
  );
  ReactCodecRegistry.registerHostValue(
    'web', 'SVGAnimatedLength',
    decoder: (value) => BrowserSVGAnimatedLength(value as JSObject),
    encoder: (value) => (value as BrowserSVGAnimatedLength)._element as JSAny?,
  );
  ReactCodecRegistry.registerHostValue(
    'web', 'SVGAnimatedLengthList',
    decoder: (value) => BrowserSVGAnimatedLengthList(value as JSObject),
    encoder: (value) => (value as BrowserSVGAnimatedLengthList)._element as JSAny?,
  );
  ReactCodecRegistry.registerHostValue(
    'web', 'SVGAnimatedNumber',
    decoder: (value) => BrowserSVGAnimatedNumber(value as JSObject),
    encoder: (value) => (value as BrowserSVGAnimatedNumber)._element as JSAny?,
  );
  ReactCodecRegistry.registerHostValue(
    'web', 'SVGAnimatedNumberList',
    decoder: (value) => BrowserSVGAnimatedNumberList(value as JSObject),
    encoder: (value) => (value as BrowserSVGAnimatedNumberList)._element as JSAny?,
  );
  ReactCodecRegistry.registerHostValue(
    'web', 'SVGAnimatedPreserveAspectRatio',
    decoder: (value) => BrowserSVGAnimatedPreserveAspectRatio(value as JSObject),
    encoder: (value) => (value as BrowserSVGAnimatedPreserveAspectRatio)._element as JSAny?,
  );
  ReactCodecRegistry.registerHostValue(
    'web', 'SVGAnimatedRect',
    decoder: (value) => BrowserSVGAnimatedRect(value as JSObject),
    encoder: (value) => (value as BrowserSVGAnimatedRect)._element as JSAny?,
  );
  ReactCodecRegistry.registerHostValue(
    'web', 'SVGAnimatedString',
    decoder: (value) => BrowserSVGAnimatedString(value as JSObject),
    encoder: (value) => (value as BrowserSVGAnimatedString)._element as JSAny?,
  );
  ReactCodecRegistry.registerHostValue(
    'web', 'SVGAnimatedTransformList',
    decoder: (value) => BrowserSVGAnimatedTransformList(value as JSObject),
    encoder: (value) => (value as BrowserSVGAnimatedTransformList)._element as JSAny?,
  );
  ReactCodecRegistry.registerHostValue(
    'web', 'SVGAnimationElement',
    decoder: (value) => BrowserSVGAnimationElement(value as JSObject),
    encoder: (value) => (value as BrowserSVGAnimationElement)._element as JSAny?,
  );
  ReactCodecRegistry.registerHostValue(
    'web', 'SVGCircleElement',
    decoder: (value) => BrowserSVGCircleElement(value as JSObject),
    encoder: (value) => (value as BrowserSVGCircleElement)._element as JSAny?,
  );
  ReactCodecRegistry.registerHostValue(
    'web', 'SVGClipPathElement',
    decoder: (value) => BrowserSVGClipPathElement(value as JSObject),
    encoder: (value) => (value as BrowserSVGClipPathElement)._element as JSAny?,
  );
  ReactCodecRegistry.registerHostValue(
    'web', 'SVGComponentTransferFunctionElement',
    decoder: (value) => BrowserSVGComponentTransferFunctionElement(value as JSObject),
    encoder: (value) => (value as BrowserSVGComponentTransferFunctionElement)._element as JSAny?,
  );
  ReactCodecRegistry.registerHostValue(
    'web', 'SVGDefsElement',
    decoder: (value) => BrowserSVGDefsElement(value as JSObject),
    encoder: (value) => (value as BrowserSVGDefsElement)._element as JSAny?,
  );
  ReactCodecRegistry.registerHostValue(
    'web', 'SVGDescElement',
    decoder: (value) => BrowserSVGDescElement(value as JSObject),
    encoder: (value) => (value as BrowserSVGDescElement)._element as JSAny?,
  );
  ReactCodecRegistry.registerHostValue(
    'web', 'SVGElement',
    decoder: (value) => BrowserSVGElement(value as JSObject),
    encoder: (value) => (value as BrowserSVGElement)._element as JSAny?,
  );
  ReactCodecRegistry.registerHostValue(
    'web', 'SVGEllipseElement',
    decoder: (value) => BrowserSVGEllipseElement(value as JSObject),
    encoder: (value) => (value as BrowserSVGEllipseElement)._element as JSAny?,
  );
  ReactCodecRegistry.registerHostValue(
    'web', 'SVGFEBlendElement',
    decoder: (value) => BrowserSVGFEBlendElement(value as JSObject),
    encoder: (value) => (value as BrowserSVGFEBlendElement)._element as JSAny?,
  );
  ReactCodecRegistry.registerHostValue(
    'web', 'SVGFEColorMatrixElement',
    decoder: (value) => BrowserSVGFEColorMatrixElement(value as JSObject),
    encoder: (value) => (value as BrowserSVGFEColorMatrixElement)._element as JSAny?,
  );
  ReactCodecRegistry.registerHostValue(
    'web', 'SVGFEComponentTransferElement',
    decoder: (value) => BrowserSVGFEComponentTransferElement(value as JSObject),
    encoder: (value) => (value as BrowserSVGFEComponentTransferElement)._element as JSAny?,
  );
  ReactCodecRegistry.registerHostValue(
    'web', 'SVGFECompositeElement',
    decoder: (value) => BrowserSVGFECompositeElement(value as JSObject),
    encoder: (value) => (value as BrowserSVGFECompositeElement)._element as JSAny?,
  );
  ReactCodecRegistry.registerHostValue(
    'web', 'SVGFEConvolveMatrixElement',
    decoder: (value) => BrowserSVGFEConvolveMatrixElement(value as JSObject),
    encoder: (value) => (value as BrowserSVGFEConvolveMatrixElement)._element as JSAny?,
  );
  ReactCodecRegistry.registerHostValue(
    'web', 'SVGFEDiffuseLightingElement',
    decoder: (value) => BrowserSVGFEDiffuseLightingElement(value as JSObject),
    encoder: (value) => (value as BrowserSVGFEDiffuseLightingElement)._element as JSAny?,
  );
  ReactCodecRegistry.registerHostValue(
    'web', 'SVGFEDisplacementMapElement',
    decoder: (value) => BrowserSVGFEDisplacementMapElement(value as JSObject),
    encoder: (value) => (value as BrowserSVGFEDisplacementMapElement)._element as JSAny?,
  );
  ReactCodecRegistry.registerHostValue(
    'web', 'SVGFEDistantLightElement',
    decoder: (value) => BrowserSVGFEDistantLightElement(value as JSObject),
    encoder: (value) => (value as BrowserSVGFEDistantLightElement)._element as JSAny?,
  );
  ReactCodecRegistry.registerHostValue(
    'web', 'SVGFEDropShadowElement',
    decoder: (value) => BrowserSVGFEDropShadowElement(value as JSObject),
    encoder: (value) => (value as BrowserSVGFEDropShadowElement)._element as JSAny?,
  );
  ReactCodecRegistry.registerHostValue(
    'web', 'SVGFEFloodElement',
    decoder: (value) => BrowserSVGFEFloodElement(value as JSObject),
    encoder: (value) => (value as BrowserSVGFEFloodElement)._element as JSAny?,
  );
  ReactCodecRegistry.registerHostValue(
    'web', 'SVGFEFuncAElement',
    decoder: (value) => BrowserSVGFEFuncAElement(value as JSObject),
    encoder: (value) => (value as BrowserSVGFEFuncAElement)._element as JSAny?,
  );
  ReactCodecRegistry.registerHostValue(
    'web', 'SVGFEFuncBElement',
    decoder: (value) => BrowserSVGFEFuncBElement(value as JSObject),
    encoder: (value) => (value as BrowserSVGFEFuncBElement)._element as JSAny?,
  );
  ReactCodecRegistry.registerHostValue(
    'web', 'SVGFEFuncGElement',
    decoder: (value) => BrowserSVGFEFuncGElement(value as JSObject),
    encoder: (value) => (value as BrowserSVGFEFuncGElement)._element as JSAny?,
  );
  ReactCodecRegistry.registerHostValue(
    'web', 'SVGFEFuncRElement',
    decoder: (value) => BrowserSVGFEFuncRElement(value as JSObject),
    encoder: (value) => (value as BrowserSVGFEFuncRElement)._element as JSAny?,
  );
  ReactCodecRegistry.registerHostValue(
    'web', 'SVGFEGaussianBlurElement',
    decoder: (value) => BrowserSVGFEGaussianBlurElement(value as JSObject),
    encoder: (value) => (value as BrowserSVGFEGaussianBlurElement)._element as JSAny?,
  );
  ReactCodecRegistry.registerHostValue(
    'web', 'SVGFEImageElement',
    decoder: (value) => BrowserSVGFEImageElement(value as JSObject),
    encoder: (value) => (value as BrowserSVGFEImageElement)._element as JSAny?,
  );
  ReactCodecRegistry.registerHostValue(
    'web', 'SVGFEMergeElement',
    decoder: (value) => BrowserSVGFEMergeElement(value as JSObject),
    encoder: (value) => (value as BrowserSVGFEMergeElement)._element as JSAny?,
  );
  ReactCodecRegistry.registerHostValue(
    'web', 'SVGFEMergeNodeElement',
    decoder: (value) => BrowserSVGFEMergeNodeElement(value as JSObject),
    encoder: (value) => (value as BrowserSVGFEMergeNodeElement)._element as JSAny?,
  );
  ReactCodecRegistry.registerHostValue(
    'web', 'SVGFEMorphologyElement',
    decoder: (value) => BrowserSVGFEMorphologyElement(value as JSObject),
    encoder: (value) => (value as BrowserSVGFEMorphologyElement)._element as JSAny?,
  );
  ReactCodecRegistry.registerHostValue(
    'web', 'SVGFEOffsetElement',
    decoder: (value) => BrowserSVGFEOffsetElement(value as JSObject),
    encoder: (value) => (value as BrowserSVGFEOffsetElement)._element as JSAny?,
  );
  ReactCodecRegistry.registerHostValue(
    'web', 'SVGFEPointLightElement',
    decoder: (value) => BrowserSVGFEPointLightElement(value as JSObject),
    encoder: (value) => (value as BrowserSVGFEPointLightElement)._element as JSAny?,
  );
  ReactCodecRegistry.registerHostValue(
    'web', 'SVGFESpecularLightingElement',
    decoder: (value) => BrowserSVGFESpecularLightingElement(value as JSObject),
    encoder: (value) => (value as BrowserSVGFESpecularLightingElement)._element as JSAny?,
  );
  ReactCodecRegistry.registerHostValue(
    'web', 'SVGFESpotLightElement',
    decoder: (value) => BrowserSVGFESpotLightElement(value as JSObject),
    encoder: (value) => (value as BrowserSVGFESpotLightElement)._element as JSAny?,
  );
  ReactCodecRegistry.registerHostValue(
    'web', 'SVGFETileElement',
    decoder: (value) => BrowserSVGFETileElement(value as JSObject),
    encoder: (value) => (value as BrowserSVGFETileElement)._element as JSAny?,
  );
  ReactCodecRegistry.registerHostValue(
    'web', 'SVGFETurbulenceElement',
    decoder: (value) => BrowserSVGFETurbulenceElement(value as JSObject),
    encoder: (value) => (value as BrowserSVGFETurbulenceElement)._element as JSAny?,
  );
  ReactCodecRegistry.registerHostValue(
    'web', 'SVGFilterElement',
    decoder: (value) => BrowserSVGFilterElement(value as JSObject),
    encoder: (value) => (value as BrowserSVGFilterElement)._element as JSAny?,
  );
  ReactCodecRegistry.registerHostValue(
    'web', 'SVGForeignObjectElement',
    decoder: (value) => BrowserSVGForeignObjectElement(value as JSObject),
    encoder: (value) => (value as BrowserSVGForeignObjectElement)._element as JSAny?,
  );
  ReactCodecRegistry.registerHostValue(
    'web', 'SVGGElement',
    decoder: (value) => BrowserSVGGElement(value as JSObject),
    encoder: (value) => (value as BrowserSVGGElement)._element as JSAny?,
  );
  ReactCodecRegistry.registerHostValue(
    'web', 'SVGGeometryElement',
    decoder: (value) => BrowserSVGGeometryElement(value as JSObject),
    encoder: (value) => (value as BrowserSVGGeometryElement)._element as JSAny?,
  );
  ReactCodecRegistry.registerHostValue(
    'web', 'SVGGradientElement',
    decoder: (value) => BrowserSVGGradientElement(value as JSObject),
    encoder: (value) => (value as BrowserSVGGradientElement)._element as JSAny?,
  );
  ReactCodecRegistry.registerHostValue(
    'web', 'SVGGraphicsElement',
    decoder: (value) => BrowserSVGGraphicsElement(value as JSObject),
    encoder: (value) => (value as BrowserSVGGraphicsElement)._element as JSAny?,
  );
  ReactCodecRegistry.registerHostValue(
    'web', 'SVGImageElement',
    decoder: (value) => BrowserSVGImageElement(value as JSObject),
    encoder: (value) => (value as BrowserSVGImageElement)._element as JSAny?,
  );
  ReactCodecRegistry.registerHostValue(
    'web', 'SVGLength',
    decoder: (value) => BrowserSVGLength(value as JSObject),
    encoder: (value) => (value as BrowserSVGLength)._element as JSAny?,
  );
  ReactCodecRegistry.registerHostValue(
    'web', 'SVGLengthList',
    decoder: (value) => BrowserSVGLengthList(value as JSObject),
    encoder: (value) => (value as BrowserSVGLengthList)._element as JSAny?,
  );
  ReactCodecRegistry.registerHostValue(
    'web', 'SVGLineElement',
    decoder: (value) => BrowserSVGLineElement(value as JSObject),
    encoder: (value) => (value as BrowserSVGLineElement)._element as JSAny?,
  );
  ReactCodecRegistry.registerHostValue(
    'web', 'SVGLinearGradientElement',
    decoder: (value) => BrowserSVGLinearGradientElement(value as JSObject),
    encoder: (value) => (value as BrowserSVGLinearGradientElement)._element as JSAny?,
  );
  ReactCodecRegistry.registerHostValue(
    'web', 'SVGMPathElement',
    decoder: (value) => BrowserSVGMPathElement(value as JSObject),
    encoder: (value) => (value as BrowserSVGMPathElement)._element as JSAny?,
  );
  ReactCodecRegistry.registerHostValue(
    'web', 'SVGMarkerElement',
    decoder: (value) => BrowserSVGMarkerElement(value as JSObject),
    encoder: (value) => (value as BrowserSVGMarkerElement)._element as JSAny?,
  );
  ReactCodecRegistry.registerHostValue(
    'web', 'SVGMaskElement',
    decoder: (value) => BrowserSVGMaskElement(value as JSObject),
    encoder: (value) => (value as BrowserSVGMaskElement)._element as JSAny?,
  );
  ReactCodecRegistry.registerHostValue(
    'web', 'SVGMetadataElement',
    decoder: (value) => BrowserSVGMetadataElement(value as JSObject),
    encoder: (value) => (value as BrowserSVGMetadataElement)._element as JSAny?,
  );
  ReactCodecRegistry.registerHostValue(
    'web', 'SVGNumber',
    decoder: (value) => BrowserSVGNumber(value as JSObject),
    encoder: (value) => (value as BrowserSVGNumber)._element as JSAny?,
  );
  ReactCodecRegistry.registerHostValue(
    'web', 'SVGNumberList',
    decoder: (value) => BrowserSVGNumberList(value as JSObject),
    encoder: (value) => (value as BrowserSVGNumberList)._element as JSAny?,
  );
  ReactCodecRegistry.registerHostValue(
    'web', 'SVGPathElement',
    decoder: (value) => BrowserSVGPathElement(value as JSObject),
    encoder: (value) => (value as BrowserSVGPathElement)._element as JSAny?,
  );
  ReactCodecRegistry.registerHostValue(
    'web', 'SVGPatternElement',
    decoder: (value) => BrowserSVGPatternElement(value as JSObject),
    encoder: (value) => (value as BrowserSVGPatternElement)._element as JSAny?,
  );
  ReactCodecRegistry.registerHostValue(
    'web', 'SVGPointList',
    decoder: (value) => BrowserSVGPointList(value as JSObject),
    encoder: (value) => (value as BrowserSVGPointList)._element as JSAny?,
  );
  ReactCodecRegistry.registerHostValue(
    'web', 'SVGPolygonElement',
    decoder: (value) => BrowserSVGPolygonElement(value as JSObject),
    encoder: (value) => (value as BrowserSVGPolygonElement)._element as JSAny?,
  );
  ReactCodecRegistry.registerHostValue(
    'web', 'SVGPolylineElement',
    decoder: (value) => BrowserSVGPolylineElement(value as JSObject),
    encoder: (value) => (value as BrowserSVGPolylineElement)._element as JSAny?,
  );
  ReactCodecRegistry.registerHostValue(
    'web', 'SVGPreserveAspectRatio',
    decoder: (value) => BrowserSVGPreserveAspectRatio(value as JSObject),
    encoder: (value) => (value as BrowserSVGPreserveAspectRatio)._element as JSAny?,
  );
  ReactCodecRegistry.registerHostValue(
    'web', 'SVGRadialGradientElement',
    decoder: (value) => BrowserSVGRadialGradientElement(value as JSObject),
    encoder: (value) => (value as BrowserSVGRadialGradientElement)._element as JSAny?,
  );
  ReactCodecRegistry.registerHostValue(
    'web', 'SVGRectElement',
    decoder: (value) => BrowserSVGRectElement(value as JSObject),
    encoder: (value) => (value as BrowserSVGRectElement)._element as JSAny?,
  );
  ReactCodecRegistry.registerHostValue(
    'web', 'SVGSVGElement',
    decoder: (value) => BrowserSVGSVGElement(value as JSObject),
    encoder: (value) => (value as BrowserSVGSVGElement)._element as JSAny?,
  );
  ReactCodecRegistry.registerHostValue(
    'web', 'SVGScriptElement',
    decoder: (value) => BrowserSVGScriptElement(value as JSObject),
    encoder: (value) => (value as BrowserSVGScriptElement)._element as JSAny?,
  );
  ReactCodecRegistry.registerHostValue(
    'web', 'SVGSetElement',
    decoder: (value) => BrowserSVGSetElement(value as JSObject),
    encoder: (value) => (value as BrowserSVGSetElement)._element as JSAny?,
  );
  ReactCodecRegistry.registerHostValue(
    'web', 'SVGStopElement',
    decoder: (value) => BrowserSVGStopElement(value as JSObject),
    encoder: (value) => (value as BrowserSVGStopElement)._element as JSAny?,
  );
  ReactCodecRegistry.registerHostValue(
    'web', 'SVGStringList',
    decoder: (value) => BrowserSVGStringList(value as JSObject),
    encoder: (value) => (value as BrowserSVGStringList)._element as JSAny?,
  );
  ReactCodecRegistry.registerHostValue(
    'web', 'SVGStyleElement',
    decoder: (value) => BrowserSVGStyleElement(value as JSObject),
    encoder: (value) => (value as BrowserSVGStyleElement)._element as JSAny?,
  );
  ReactCodecRegistry.registerHostValue(
    'web', 'SVGSwitchElement',
    decoder: (value) => BrowserSVGSwitchElement(value as JSObject),
    encoder: (value) => (value as BrowserSVGSwitchElement)._element as JSAny?,
  );
  ReactCodecRegistry.registerHostValue(
    'web', 'SVGSymbolElement',
    decoder: (value) => BrowserSVGSymbolElement(value as JSObject),
    encoder: (value) => (value as BrowserSVGSymbolElement)._element as JSAny?,
  );
  ReactCodecRegistry.registerHostValue(
    'web', 'SVGTSpanElement',
    decoder: (value) => BrowserSVGTSpanElement(value as JSObject),
    encoder: (value) => (value as BrowserSVGTSpanElement)._element as JSAny?,
  );
  ReactCodecRegistry.registerHostValue(
    'web', 'SVGTextContentElement',
    decoder: (value) => BrowserSVGTextContentElement(value as JSObject),
    encoder: (value) => (value as BrowserSVGTextContentElement)._element as JSAny?,
  );
  ReactCodecRegistry.registerHostValue(
    'web', 'SVGTextElement',
    decoder: (value) => BrowserSVGTextElement(value as JSObject),
    encoder: (value) => (value as BrowserSVGTextElement)._element as JSAny?,
  );
  ReactCodecRegistry.registerHostValue(
    'web', 'SVGTextPathElement',
    decoder: (value) => BrowserSVGTextPathElement(value as JSObject),
    encoder: (value) => (value as BrowserSVGTextPathElement)._element as JSAny?,
  );
  ReactCodecRegistry.registerHostValue(
    'web', 'SVGTextPositioningElement',
    decoder: (value) => BrowserSVGTextPositioningElement(value as JSObject),
    encoder: (value) => (value as BrowserSVGTextPositioningElement)._element as JSAny?,
  );
  ReactCodecRegistry.registerHostValue(
    'web', 'SVGTitleElement',
    decoder: (value) => BrowserSVGTitleElement(value as JSObject),
    encoder: (value) => (value as BrowserSVGTitleElement)._element as JSAny?,
  );
  ReactCodecRegistry.registerHostValue(
    'web', 'SVGTransform',
    decoder: (value) => BrowserSVGTransform(value as JSObject),
    encoder: (value) => (value as BrowserSVGTransform)._element as JSAny?,
  );
  ReactCodecRegistry.registerHostValue(
    'web', 'SVGTransformList',
    decoder: (value) => BrowserSVGTransformList(value as JSObject),
    encoder: (value) => (value as BrowserSVGTransformList)._element as JSAny?,
  );
  ReactCodecRegistry.registerHostValue(
    'web', 'SVGUnitTypes',
    decoder: (value) => BrowserSVGUnitTypes(value as JSObject),
    encoder: (value) => (value as BrowserSVGUnitTypes)._element as JSAny?,
  );
  ReactCodecRegistry.registerHostValue(
    'web', 'SVGUseElement',
    decoder: (value) => BrowserSVGUseElement(value as JSObject),
    encoder: (value) => (value as BrowserSVGUseElement)._element as JSAny?,
  );
  ReactCodecRegistry.registerHostValue(
    'web', 'SVGViewElement',
    decoder: (value) => BrowserSVGViewElement(value as JSObject),
    encoder: (value) => (value as BrowserSVGViewElement)._element as JSAny?,
  );
  ReactCodecRegistry.registerHostValue(
    'web', 'Window',
    decoder: (value) => BrowserWindow(value as JSObject),
    encoder: (value) => (value as BrowserWindow)._element as JSAny?,
  );
  ReactCodecRegistry.registerHostValue(
    'web', 'ReactSyntheticEvent',
    decoder: (value) => BrowserReactSyntheticEvent(value as JSObject),
  );
  ReactCodecRegistry.registerHostValue(
    'web', 'ReactCompositionEvent',
    decoder: (value) => BrowserReactCompositionEvent(value as JSObject),
  );
  ReactCodecRegistry.registerHostValue(
    'web', 'ReactTouchEvent',
    decoder: (value) => BrowserReactTouchEvent(value as JSObject),
  );
  ReactCodecRegistry.registerHostValue(
    'web', 'ReactPointerEvent',
    decoder: (value) => BrowserReactPointerEvent(value as JSObject),
  );
  ReactCodecRegistry.registerHostValue(
    'web', 'ReactWheelEvent',
    decoder: (value) => BrowserReactWheelEvent(value as JSObject),
  );
  ReactCodecRegistry.registerHostValue(
    'web', 'ReactDragEvent',
    decoder: (value) => BrowserReactDragEvent(value as JSObject),
  );
  ReactCodecRegistry.registerHostValue(
    'web', 'ReactFocusEvent',
    decoder: (value) => BrowserReactFocusEvent(value as JSObject),
  );
  ReactCodecRegistry.registerHostValue(
    'web', 'ReactKeyboardEvent',
    decoder: (value) => BrowserReactKeyboardEvent(value as JSObject),
  );
  ReactCodecRegistry.registerHostValue(
    'web', 'ReactFormEvent',
    decoder: (value) => BrowserReactFormEvent(value as JSObject),
  );
  ReactCodecRegistry.registerHostValue(
    'web', 'ReactChangeEvent',
    decoder: (value) => BrowserReactChangeEvent(value as JSObject),
  );
  ReactCodecRegistry.registerHostValue(
    'web', 'ReactInputEvent',
    decoder: (value) => BrowserReactInputEvent(value as JSObject),
  );
  ReactCodecRegistry.registerHostValue(
    'web', 'ReactMouseEvent',
    decoder: (value) => BrowserReactMouseEvent(value as JSObject),
  );
}

