import 'web_dart_type.dart';

enum WebNamespace { html, svg, mathMl }

enum WebSsrBehavior {
  attribute,
  booleanAttribute,
  property,
  textContent,
  eventOmitted,
  refOmitted,
  special,
  unsupported,
}

final class WebHostPropIR {
  final String idlName;
  final String dartName;
  final String reactName;
  final WebDartType dartType;
  final bool required;
  final bool clientOnly;
  final WebSsrBehavior ssrBehavior;

  const WebHostPropIR({
    required this.idlName,
    required this.dartName,
    required this.reactName,
    required this.dartType,
    required this.required,
    required this.clientOnly,
    required this.ssrBehavior,
  });
}

final class WebEventPropIR {
  final String domEventName;
  final String reactName;
  final String captureName;
  final WebDartType reactEventType;
  final WebDartType nativeEventType;

  const WebEventPropIR({
    required this.domEventName,
    required this.reactName,
    required this.captureName,
    required this.reactEventType,
    required this.nativeEventType,
  });
}

final class WebHostElementIR {
  final String tagName;
  final String factoryName;
  final WebNamespace namespace;
  final WebDartType elementType;
  final bool voidElement;
  final List<WebHostPropIR> props;
  final List<WebEventPropIR> events;

  const WebHostElementIR({
    required this.tagName,
    required this.factoryName,
    required this.namespace,
    required this.elementType,
    required this.voidElement,
    required this.props,
    required this.events,
  });
}
