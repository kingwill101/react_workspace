// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: performance-measure-memory
// ignore_for_file: type=lint

abstract interface class MemoryAttribution {
  String? get url;
  set url(String? value);
  MemoryAttributionContainer? get container;
  set container(MemoryAttributionContainer? value);
  String? get scope;
  set scope(String? value);
}

final class MemoryAttributionValue implements MemoryAttribution {
  @override
  String? url;
  @override
  MemoryAttributionContainer? container;
  @override
  String? scope;

  MemoryAttributionValue({this.url, this.container, this.scope});
}

abstract interface class MemoryAttributionContainer {
  String? get id;
  set id(String? value);
  String? get src;
  set src(String? value);
}

final class MemoryAttributionContainerValue
    implements MemoryAttributionContainer {
  @override
  String? id;
  @override
  String? src;

  MemoryAttributionContainerValue({this.id, this.src});
}

abstract interface class MemoryBreakdownEntry {
  int? get bytes;
  set bytes(int? value);
  List<MemoryAttribution>? get attribution;
  set attribution(List<MemoryAttribution>? value);
  List<String>? get types;
  set types(List<String>? value);
}

final class MemoryBreakdownEntryValue implements MemoryBreakdownEntry {
  @override
  int? bytes;
  @override
  List<MemoryAttribution>? attribution;
  @override
  List<String>? types;

  MemoryBreakdownEntryValue({this.bytes, this.attribution, this.types});
}

abstract interface class MemoryMeasurement {
  int? get bytes;
  set bytes(int? value);
  List<MemoryBreakdownEntry>? get breakdown;
  set breakdown(List<MemoryBreakdownEntry>? value);
}

final class MemoryMeasurementValue implements MemoryMeasurement {
  @override
  int? bytes;
  @override
  List<MemoryBreakdownEntry>? breakdown;

  MemoryMeasurementValue({this.bytes, this.breakdown});
}
