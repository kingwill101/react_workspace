final class WebDartType {
  final String symbol;
  final Uri import;
  final bool nullable;
  final List<WebDartType> typeArguments;

  const WebDartType({
    required this.symbol,
    required this.import,
    required this.nullable,
    this.typeArguments = const [],
  });
}
