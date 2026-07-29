import 'type_ref.dart';

final class EventDecl {
  final String name;
  final TypeRef eventType;

  const EventDecl({required this.name, required this.eventType});

  Map<String, Object?> toJson() => {
    'name': name,
    'eventType': eventType.toJson(),
  };
}

final class PropDecl {
  final String name;
  final TypeRef type;
  final bool required;

  const PropDecl({
    required this.name,
    required this.type,
    this.required = false,
  });

  Map<String, Object?> toJson() => {
    'name': name,
    'type': type.toJson(),
    'required': required,
  };
}

final class ElementDecl {
  final String tagName;
  final String namespace;
  final TypeRef elementType;
  final bool voidElement;
  final List<PropDecl> props;
  final List<EventDecl> events;

  const ElementDecl({
    required this.tagName,
    this.namespace = 'html',
    required this.elementType,
    this.voidElement = false,
    this.props = const [],
    this.events = const [],
  });

  Map<String, Object?> toJson() => {
    'tagName': tagName,
    'namespace': namespace,
    'elementType': elementType.toJson(),
    'voidElement': voidElement,
    'props': props.map((p) => p.toJson()).toList(),
    'events': events.map((e) => e.toJson()).toList(),
  };
}
