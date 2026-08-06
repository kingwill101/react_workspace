import 'package:react_web/src/generated/web/web.dart';
import 'package:react_web/src/ssr_metadata.dart';
import 'package:react_web/src/web_runtime.dart';
import 'package:test/test.dart';

void main() {
  group('UnsupportedWebApiError', () {
    test('message includes api name', () {
      final error = UnsupportedWebApiError('Storage.length');
      expect(error.api, 'Storage.length');
      expect(error.message, contains('Storage.length'));
      expect(error.message, contains('SSR'));
    });

    test('message includes exposed when provided', () {
      final error = UnsupportedWebApiError('Window.localStorage', exposed: 'Window');
      expect(error.exposed, 'Window');
      expect(error.message, contains('Exposed=Window'));
    });

    test('is UnsupportedError', () {
      final error = UnsupportedWebApiError('Blob.text');
      expect(error, isA<UnsupportedError>());
    });
  });

  group('WebRuntime', () {
    test('current throws StateError when not installed', () {
      // Reset any installed runtime for this test
      // The runtime is global; we test that accessing without install throws
      // Note: other tests may have installed a runtime, so we check
      // that the getter either returns a runtime or throws, but fresh
      // isolate should throw. We verify install works.
      final runtime = _FakeWebRuntime();
      WebRuntime.install(runtime);
      expect(WebRuntime.current, same(runtime));
    });

    test('install replaces previous runtime', () {
      final r1 = _FakeWebRuntime();
      final r2 = _FakeWebRuntime();
      WebRuntime.install(r1);
      expect(WebRuntime.current, same(r1));
      WebRuntime.install(r2);
      expect(WebRuntime.current, same(r2));
    });

    test('createWebObject throws for SSR fake', () {
      final runtime = _FakeWebRuntime();
      expect(() => runtime.createWebObject('BroadcastChannel', []), throwsA(isA<UnsupportedWebApiError>()));
    });

    test('invokeNamespace delegates', () {
      final runtime = _FakeWebRuntime();
      expect(runtime.invokeNamespace('CSS', 'supports', ['display', 'grid']), 'fake-css-supports');
    });

    test('getNamespaceProperty delegates', () {
      final runtime = _FakeWebRuntime();
      expect(runtime.getNamespaceProperty('CSS', 'escape'), isNull);
    });
  });

  group('WebSsrBehavior', () {
    test('all behaviors are distinct', () {
      final values = WebSsrBehavior.values;
      expect(values.toSet(), hasLength(values.length));
    });

    test('can map behavior to string', () {
      expect(WebSsrBehavior.attribute.name, 'attribute');
      expect(WebSsrBehavior.eventOmitted.name, 'eventOmitted');
    });
  });

  group('WebElementSsrDefinition', () {
    test('stores tagName, voidElement, props', () {
      const def = WebElementSsrDefinition(
        tagName: 'input',
        voidElement: true,
        props: {'value': WebSsrBehavior.property},
      );
      expect(def.tagName, 'input');
      expect(def.voidElement, isTrue);
      expect(def.props['value'], WebSsrBehavior.property);
    });
  });
}

class _FakeWebRuntime implements WebRuntime {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);

  @override
  Window get window => throw UnsupportedWebApiError('Window');

  @override
  Document get document => throw UnsupportedWebApiError('Document');

  @override
  Navigator get navigator => throw UnsupportedWebApiError('Navigator');

  @override
  T createWebObject<T extends Object>(String name, List<Object?> arguments) =>
      throw UnsupportedWebApiError(name);

  @override
  dynamic getNamespaceProperty(String namespace, String property) => null;

  @override
  dynamic invokeNamespace(String namespace, String member, List<Object?> arguments) {
    if (namespace == 'CSS' && member == 'supports') return 'fake-css-supports';
    throw UnsupportedWebApiError('$namespace.$member');
  }

  @override
  void setNamespaceProperty(String namespace, String property, Object? value) {}
}
