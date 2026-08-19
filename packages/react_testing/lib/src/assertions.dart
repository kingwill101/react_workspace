import 'package:react/react.dart';

/// Assertion helpers for React Dart tests.
///
/// Provides expressive matchers and failure messages tailored to
/// React node trees, server-function envelopes, and HTML output.
extension ReactNodeAssertions on ReactNode {
  /// Asserts this node is a [HostNode] with the given [typeName].
  void shouldBeHost(String typeName) {
    if (this is! HostNode) {
      throw StateError('Expected HostNode<$typeName> but got $runtimeType');
    }
    final host = this as HostNode;
    if (host.type.name != typeName) {
      throw StateError(
        'Expected HostNode<$typeName> but got ${host.type.name}',
      );
    }
  }

  /// Asserts this node is a [Text] node with [value].
  void shouldBeText(String value) {
    if (this is! Text) {
      throw StateError('Expected Text but got $runtimeType');
    }
    if ((this as Text).value != value) {
      throw StateError(
        'Expected Text("$value") but got "${(this as Text).value}"',
      );
    }
  }

  /// Asserts this node is a [Fragment].
  void shouldBeFragment() {
    if (this is! Fragment) {
      throw StateError('Expected Fragment but got $runtimeType');
    }
  }

  /// Asserts this node is a [Component] with the given [id].
  void shouldBeComponent(String id) {
    if (this is! Component) {
      throw StateError('Expected Component but got $runtimeType');
    }
    if ((this as Component).id.value != id) {
      throw StateError(
        'Expected Component($id) but got ${(this as Component).id.value}',
      );
    }
  }
}

/// Assertion helpers for HTML strings.
extension HtmlAssertions on String {
  /// Asserts this HTML contains [substring].
  void shouldContainHtml(String substring) {
    if (!contains(substring)) {
      throw StateError('Expected HTML to contain "$substring" but was:\n$this');
    }
  }

  /// Asserts this HTML does not contain [substring].
  void shouldNotContainHtml(String substring) {
    if (contains(substring)) {
      throw StateError('Expected HTML NOT to contain "$substring"');
    }
  }

  /// Asserts this HTML contains an element with [tag].
  void shouldContainTag(String tag) {
    if (!contains('<$tag')) {
      throw StateError('Expected HTML to contain <$tag> tag');
    }
  }
}

/// Assertion helpers for callback testing.
extension ReactCallbackAssertions on ReactCallback {
  /// Asserts the signature has [positionalCount] parameters.
  void shouldHaveArity(int positionalCount) {
    if (signature.positional.length != positionalCount) {
      throw StateError(
        'Expected arity $positionalCount but got ${signature.positional.length}',
      );
    }
  }

  /// Invokes with [args] and expects [expectedResult].
  void shouldInvoke(List<Object?> args, Object? expectedResult) {
    final result = invoke(args);
    if (result != expectedResult) {
      throw StateError('Expected $expectedResult but got $result');
    }
  }
}

/// Creates a minimal test component node.
Component<String> testComponent(
  String id, {
  String props = '',
  List<ReactNode> children = const [],
}) => Component(ComponentId(id), props, children: children);

/// Creates a test host node.
HostNode<Map<String, Object?>> testHostNode(
  String name, {
  Map<String, Object?> props = const {},
  List<ReactNode> children = const [],
}) => HostNode(HostType('web', name), props, children: children);
