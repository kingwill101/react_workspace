import 'package:react/react.dart';
import 'package:react/src/dom.dart' as dom;
import 'package:test/test.dart';

void main() {
  group('ReactNode hierarchy', () {
    test('normalizes text, numbers, nested iterables, and empty values', () {
      final children = normalizeChildren([
        'hello',
        42,
        [const Text('nested'), null, false],
        true,
      ]);

      expect(children, hasLength(3));
      expect((children[0] as Text).value, 'hello');
      expect((children[1] as Text).value, '42');
      expect((children[2] as Text).value, 'nested');
    });

    test('rejects unsupported child values', () {
      expect(() => normalizeChildren([Object()]), throwsArgumentError);
    });

    test('text and fragment helpers create portable nodes', () {
      expect(text(42).value, '42');
      final node = fragment(['hello', 7], key: 'group') as Fragment;
      expect(node.key, 'group');
      expect(node.children, hasLength(2));
    });

    test('HostNode stores type, props, children, key', () {
      const type = HostType<Map<String, Object?>>('web', 'div');
      const node = HostNode(
        type,
        {'id': 'a'},
        children: [Text('hi')],
        key: 'k',
      );
      expect(node.type, type);
      expect(node.props['id'], 'a');
      expect(node.children, hasLength(1));
      expect(node.key, 'k');
    });

    test('HostType toString is namespace:name', () {
      const type = HostType<String>('web', 'button');
      expect(type.toString(), 'web:button');
    });

    test('ForeignComponent stores name, props, children', () {
      const node = ForeignComponent('MyWidget', props: {'value': 42});
      expect(node.name, 'MyWidget');
      expect(node.props['value'], 42);
    });

    test('foreignComponent helper creates ForeignComponent', () {
      final node = foreignComponent(
        'Card',
        props: {'label': 'hi'},
        children: ['child'],
      );
      expect(node.name, 'Card');
      expect(node.props['label'], 'hi');
      expect((node.children.single as Text).value, 'child');
    });

    test('Component stores id and props', () {
      const id = ComponentId('app#MyComp');
      const node = Component<String>(id, 'props', children: [Text('c')]);
      expect(node.id.value, 'app#MyComp');
      expect(node.props, 'props');
      expect(node.children, hasLength(1));
    });

    test('Text stores value', () {
      const t = Text('hello');
      expect(t.value, 'hello');
    });

    test('Fragment stores children and key', () {
      const f = Fragment([Text('a'), Text('b')], key: 'frag');
      expect(f.children, hasLength(2));
      expect(f.key, 'frag');
    });

    test('Empty is a node', () {
      expect(const Empty(), isA<ReactNode>());
    });

    test('ComponentId is extension type of String', () {
      const id = ComponentId('foo#bar');
      expect(id.value, 'foo#bar');
    });
  });

  group('ReactContext', () {
    test('provider creates ContextProvider node', () {
      const ctx = ReactContext<int>(42);
      final node = ctx.provider(100, const [Text('child')]);
      expect(node, isA<ContextProvider<int>>());
      final provider = node as ContextProvider<int>;
      expect(provider.value, 100);
      expect(provider.children, hasLength(1));
    });

    test('defaultValue is preserved', () {
      const ctx = ReactContext<String>('default');
      expect(ctx.defaultValue, 'default');
    });
  });

  group('ReactRef', () {
    test('current getter/setter', () {
      final ref = ReactRef<int>(42);
      expect(ref.current, 42);
      ref.current = 100;
      expect(ref.current, 100);
    });

    test('linked ref notifies onChanged', () {
      Object? notified;
      final ref = ReactRef<String>.linked('initial', (v) => notified = v);
      ref.current = 'updated';
      expect(notified, 'updated');
      expect(ref.current, 'updated');
    });

    test('initial value can be null', () {
      final ref = ReactRef<String>();
      expect(ref.current, isNull);
    });
  });

  group('dom helpers', () {
    test('div creates HostNode', () {
      final node = dom.div(children: const ['hi']);
      expect(node, isA<HostNode>());
      final host = node as HostNode;
      expect(host.type.name, 'div');
      expect(host.children, hasLength(1));
    });

    test('button with onClick creates callback prop', () {
      var clicked = false;
      final node = dom.button(onClick: () => clicked = true);
      expect(node, isA<HostNode>());
      final host = node as HostNode<Map<String, Object?>>;
      expect(host.props.containsKey('onClick'), isTrue);
      final cb = host.props['onClick'] as ReactCallback;
      cb.invoke([]);
      expect(clicked, isTrue);
    });

    test('button without onClick has no callback', () {
      final node = dom.button();
      final host = node as HostNode<Map<String, Object?>>;
      expect(host.props.containsKey('onClick'), isFalse);
    });
  });

  group('ergonomic APIs', () {
    test('conditional and repeated children remain portable', () {
      final children = normalizeChildren([
        when(true, text('shown')),
        unless(true, text('hidden')),
        ...each([1, 2], (value, index) => text('$index:$value')),
      ]);

      expect(children.map((child) => (child as Text).value), [
        'shown',
        '0:1',
        '1:2',
      ]);
    });

    test('css handles strings, maps, iterables, and empty values', () {
      expect(
        joinClassNames(
          'button',
          {'active': true, 'disabled': false},
          ['rounded', null],
        ),
        'button active rounded',
      );
    });

    test('component factory creates a keyed component node', () {
      final factory = component<String>(
        const ComponentId('example#Greeting'),
        metadata: const ReactComponentMetadata(
          name: 'Greeting',
          propsType: 'String',
        ),
      );
      final node = factory('hello', children: ['world'], key: 'greeting');

      expect(node, isA<Component<String>>());
      final componentNode = node as Component<String>;
      expect(componentNode.id.value, 'example#Greeting');
      expect(componentNode.props, 'hello');
      expect(componentNode.key, 'greeting');
      expect(componentNode.children.single, isA<Text>());
      expect(factory.metadata?.name, 'Greeting');
    });

    test('state controller preserves value and setter', () {
      final setter = StateSetter<int>((_) {}, (_) {});
      final state = StateController(1, setter);
      expect(state.value, 1);
      expect(state.set, same(setter));
    });
  });

  group('ReactValueKind', () {
    test('constants are distinct', () {
      expect(reactVoid.kind, ReactValueKind.void_);
      expect(reactString.kind, ReactValueKind.string);
      expect(reactInt.kind, ReactValueKind.integer);
      expect(reactBool.kind, ReactValueKind.boolean);
      expect(reactAny.kind, ReactValueKind.any);
      expect(reactHostValue.kind, ReactValueKind.hostValue);
    });

    test('nullable variants', () {
      expect(reactNullableString.nullable, isTrue);
      expect(reactString.nullable, isFalse);
    });
  });

  group('ReactCallback', () {
    test('stores signature and invoke', () {
      final cb = ReactCallback(
        signature: const (
          positional: [],
          result: reactVoid,
          asynchronous: false,
        ),
        invoke: (args) => 'result',
      );
      expect(cb.invoke([]), 'result');
      expect(cb.signature.positional, isEmpty);
    });

    test('ReactEventProp wraps callback', () {
      final cb = ReactCallback(
        signature: const (
          positional: [],
          result: reactVoid,
          asynchronous: false,
        ),
        invoke: (_) => null,
      );
      final prop = ReactEventProp(cb);
      expect(prop.callback, same(cb));
    });

    test('ReactRefProp wraps callback', () {
      final cb = ReactCallback(
        signature: const (
          positional: [],
          result: reactVoid,
          asynchronous: false,
        ),
        invoke: (_) => null,
      );
      final prop = ReactRefProp(cb);
      expect(prop.callback, same(cb));
    });
  });
}
