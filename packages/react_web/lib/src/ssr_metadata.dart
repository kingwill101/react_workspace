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

final class WebElementSsrDefinition {
  final String tagName;
  final bool voidElement;
  final Map<String, WebSsrBehavior> props;

  const WebElementSsrDefinition({
    required this.tagName,
    required this.voidElement,
    required this.props,
  });
}
