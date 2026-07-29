/// Opaque identifier for a registered server function.
///
/// Produced by the generator. Must be stable across rebuilds and shared
/// between the client proxy and the server registry so both sides agree
/// on which function to invoke.
final class ServerFunctionId {
  final String value;

  const ServerFunctionId(this.value);

  @override
  bool operator ==(Object other) =>
      other is ServerFunctionId && other.value == value;

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => 'ServerFunctionId($value)';
}
