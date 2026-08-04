// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: css-animation-worklet
// ignore_for_file: constant_identifier_names, unnecessary_late, non_constant_identifier_names, unused_local_variable, camel_case_types, unused_import

import 'html.dart';
import 'css_highlight_api.dart';
import 'css_parser_api.dart';
import 'css_properties_values_api.dart';
import 'css_typed_om.dart';
import 'web_animations_2.dart';

abstract interface class AnimationWorkletGlobalScope {
  void registerAnimator(String name, AnimatorInstanceConstructor animatorCtor);
}

typedef AnimatorInstanceConstructor = Object Function(Object options, Object state,);

abstract final class CSS {
  CSS._();
  static Worklet get animationWorklet =>
      throw UnsupportedError('animationWorklet not supported in neutral surface');
  static bool supports(Object property, Object value) => throw UnsupportedError(
      'supports is not supported in the neutral surface');
  static HighlightRegistry get highlights =>
      throw UnsupportedError('highlights not supported in neutral surface');
  static Object get elementSources =>
      throw UnsupportedError('elementSources not supported in neutral surface');
  static Worklet get layoutWorklet =>
      throw UnsupportedError('layoutWorklet not supported in neutral surface');
  static Worklet get paintWorklet =>
      throw UnsupportedError('paintWorklet not supported in neutral surface');
  static Future<List<CSSParserRule>> parseStylesheet(CSSStringSource css, [CSSParserOptions? options]) => throw UnsupportedError(
      'parseStylesheet is not supported in the neutral surface');
  static Future<List<CSSParserRule>> parseRuleList(CSSStringSource css, [CSSParserOptions? options]) => throw UnsupportedError(
      'parseRuleList is not supported in the neutral surface');
  static Future<CSSParserRule> parseRule(CSSStringSource css, [CSSParserOptions? options]) => throw UnsupportedError(
      'parseRule is not supported in the neutral surface');
  static Future<List<CSSParserRule>> parseDeclarationList(CSSStringSource css, [CSSParserOptions? options]) => throw UnsupportedError(
      'parseDeclarationList is not supported in the neutral surface');
  static CSSParserDeclaration parseDeclaration(String css, [CSSParserOptions? options]) => throw UnsupportedError(
      'parseDeclaration is not supported in the neutral surface');
  static CSSToken parseValue(String css) => throw UnsupportedError(
      'parseValue is not supported in the neutral surface');
  static List<CSSToken> parseValueList(String css) => throw UnsupportedError(
      'parseValueList is not supported in the neutral surface');
  static List<List<CSSToken>> parseCommaValueList(String css) => throw UnsupportedError(
      'parseCommaValueList is not supported in the neutral surface');
  static void registerProperty(PropertyDefinition definition) => throw UnsupportedError(
      'registerProperty is not supported in the neutral surface');
  static CSSUnitValue number(double value) => throw UnsupportedError(
      'number is not supported in the neutral surface');
  static CSSUnitValue percent(double value) => throw UnsupportedError(
      'percent is not supported in the neutral surface');
  static CSSUnitValue cap(double value) => throw UnsupportedError(
      'cap is not supported in the neutral surface');
  static CSSUnitValue ch(double value) => throw UnsupportedError(
      'ch is not supported in the neutral surface');
  static CSSUnitValue em(double value) => throw UnsupportedError(
      'em is not supported in the neutral surface');
  static CSSUnitValue ex(double value) => throw UnsupportedError(
      'ex is not supported in the neutral surface');
  static CSSUnitValue ic(double value) => throw UnsupportedError(
      'ic is not supported in the neutral surface');
  static CSSUnitValue lh(double value) => throw UnsupportedError(
      'lh is not supported in the neutral surface');
  static CSSUnitValue rcap(double value) => throw UnsupportedError(
      'rcap is not supported in the neutral surface');
  static CSSUnitValue rch(double value) => throw UnsupportedError(
      'rch is not supported in the neutral surface');
  static CSSUnitValue rem(double value) => throw UnsupportedError(
      'rem is not supported in the neutral surface');
  static CSSUnitValue rex(double value) => throw UnsupportedError(
      'rex is not supported in the neutral surface');
  static CSSUnitValue ric(double value) => throw UnsupportedError(
      'ric is not supported in the neutral surface');
  static CSSUnitValue rlh(double value) => throw UnsupportedError(
      'rlh is not supported in the neutral surface');
  static CSSUnitValue vw(double value) => throw UnsupportedError(
      'vw is not supported in the neutral surface');
  static CSSUnitValue vh(double value) => throw UnsupportedError(
      'vh is not supported in the neutral surface');
  static CSSUnitValue vi(double value) => throw UnsupportedError(
      'vi is not supported in the neutral surface');
  static CSSUnitValue vb(double value) => throw UnsupportedError(
      'vb is not supported in the neutral surface');
  static CSSUnitValue vmin(double value) => throw UnsupportedError(
      'vmin is not supported in the neutral surface');
  static CSSUnitValue vmax(double value) => throw UnsupportedError(
      'vmax is not supported in the neutral surface');
  static CSSUnitValue svw(double value) => throw UnsupportedError(
      'svw is not supported in the neutral surface');
  static CSSUnitValue svh(double value) => throw UnsupportedError(
      'svh is not supported in the neutral surface');
  static CSSUnitValue svi(double value) => throw UnsupportedError(
      'svi is not supported in the neutral surface');
  static CSSUnitValue svb(double value) => throw UnsupportedError(
      'svb is not supported in the neutral surface');
  static CSSUnitValue svmin(double value) => throw UnsupportedError(
      'svmin is not supported in the neutral surface');
  static CSSUnitValue svmax(double value) => throw UnsupportedError(
      'svmax is not supported in the neutral surface');
  static CSSUnitValue lvw(double value) => throw UnsupportedError(
      'lvw is not supported in the neutral surface');
  static CSSUnitValue lvh(double value) => throw UnsupportedError(
      'lvh is not supported in the neutral surface');
  static CSSUnitValue lvi(double value) => throw UnsupportedError(
      'lvi is not supported in the neutral surface');
  static CSSUnitValue lvb(double value) => throw UnsupportedError(
      'lvb is not supported in the neutral surface');
  static CSSUnitValue lvmin(double value) => throw UnsupportedError(
      'lvmin is not supported in the neutral surface');
  static CSSUnitValue lvmax(double value) => throw UnsupportedError(
      'lvmax is not supported in the neutral surface');
  static CSSUnitValue dvw(double value) => throw UnsupportedError(
      'dvw is not supported in the neutral surface');
  static CSSUnitValue dvh(double value) => throw UnsupportedError(
      'dvh is not supported in the neutral surface');
  static CSSUnitValue dvi(double value) => throw UnsupportedError(
      'dvi is not supported in the neutral surface');
  static CSSUnitValue dvb(double value) => throw UnsupportedError(
      'dvb is not supported in the neutral surface');
  static CSSUnitValue dvmin(double value) => throw UnsupportedError(
      'dvmin is not supported in the neutral surface');
  static CSSUnitValue dvmax(double value) => throw UnsupportedError(
      'dvmax is not supported in the neutral surface');
  static CSSUnitValue cqw(double value) => throw UnsupportedError(
      'cqw is not supported in the neutral surface');
  static CSSUnitValue cqh(double value) => throw UnsupportedError(
      'cqh is not supported in the neutral surface');
  static CSSUnitValue cqi(double value) => throw UnsupportedError(
      'cqi is not supported in the neutral surface');
  static CSSUnitValue cqb(double value) => throw UnsupportedError(
      'cqb is not supported in the neutral surface');
  static CSSUnitValue cqmin(double value) => throw UnsupportedError(
      'cqmin is not supported in the neutral surface');
  static CSSUnitValue cqmax(double value) => throw UnsupportedError(
      'cqmax is not supported in the neutral surface');
  static CSSUnitValue cm(double value) => throw UnsupportedError(
      'cm is not supported in the neutral surface');
  static CSSUnitValue mm(double value) => throw UnsupportedError(
      'mm is not supported in the neutral surface');
  static CSSUnitValue Q(double value) => throw UnsupportedError(
      'Q is not supported in the neutral surface');
  static CSSUnitValue in_(double value) => throw UnsupportedError(
      'in is not supported in the neutral surface');
  static CSSUnitValue pt(double value) => throw UnsupportedError(
      'pt is not supported in the neutral surface');
  static CSSUnitValue pc(double value) => throw UnsupportedError(
      'pc is not supported in the neutral surface');
  static CSSUnitValue px(double value) => throw UnsupportedError(
      'px is not supported in the neutral surface');
  static CSSUnitValue deg(double value) => throw UnsupportedError(
      'deg is not supported in the neutral surface');
  static CSSUnitValue grad(double value) => throw UnsupportedError(
      'grad is not supported in the neutral surface');
  static CSSUnitValue rad(double value) => throw UnsupportedError(
      'rad is not supported in the neutral surface');
  static CSSUnitValue turn(double value) => throw UnsupportedError(
      'turn is not supported in the neutral surface');
  static CSSUnitValue s(double value) => throw UnsupportedError(
      's is not supported in the neutral surface');
  static CSSUnitValue ms(double value) => throw UnsupportedError(
      'ms is not supported in the neutral surface');
  static CSSUnitValue Hz(double value) => throw UnsupportedError(
      'Hz is not supported in the neutral surface');
  static CSSUnitValue kHz(double value) => throw UnsupportedError(
      'kHz is not supported in the neutral surface');
  static CSSUnitValue dpi(double value) => throw UnsupportedError(
      'dpi is not supported in the neutral surface');
  static CSSUnitValue dpcm(double value) => throw UnsupportedError(
      'dpcm is not supported in the neutral surface');
  static CSSUnitValue dppx(double value) => throw UnsupportedError(
      'dppx is not supported in the neutral surface');
  static CSSUnitValue fr(double value) => throw UnsupportedError(
      'fr is not supported in the neutral surface');
  static Object escape(Object ident) => throw UnsupportedError(
      'escape is not supported in the neutral surface');
}

abstract interface class WorkletAnimation {
  String get animatorName;
}

abstract interface class WorkletAnimationEffect {
  EffectTiming getTiming();
  ComputedEffectTiming getComputedTiming();
  double? get localTime;
   set localTime(double? value);
}

abstract interface class WorkletGroupEffect {
  List<WorkletAnimationEffect> getChildren();
}

