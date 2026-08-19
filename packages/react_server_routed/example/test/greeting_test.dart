import 'package:react_testing/react_testing.dart';
import 'package:react_server_routed/react_server_routed.dart';
import 'package:routed_core/routed_core.dart';
import 'package:routed_testing/routed_testing.dart';
import 'package:server_testing/server_testing.dart';

import 'package:react_server_routed_example/.generated/greeting.action.g.dart' show greetRef;
import 'package:react_server_routed_example/greeting.dart';

void main() {
  group('greet server function (ServerFunctionHarness)', () {
    test('dispatch directly (no HTTP)', () async {
      final harness = ServerFunctionHarness();
      // Register the real greet handler from lib/greeting.dart
      // In a real project this would be generated: registerGreeting(registry)
      // For the starter we wire it manually:
      harness.registry.register(
        greetRef,
        (args, ctx) => greet(ctx, name: args.name),
      );

      final result = await harness.dispatch(greetRef, (name: 'world'));
      expect(result, contains('Hello, world!'));
    });

    test('HTTP envelope + contract validation', () async {
      final harness = ServerFunctionHarness();
      harness.registry.register(
        greetRef,
        (args, ctx) => greet(ctx, name: args.name),
      );

      final client = harness.createClient(_routedHandler(harness));
      final ok = await client.postJson(
        '/__react/actions',
        harness.envelope(greetRef, (name: 'Ada')),
      );
      ok.assertStatus(200);
      // Server-function responses use `application/vnd.react.dart.action+json`;
      // assertStatus is sufficient here. The payload shape is validated below.
      // greet includes a timestamp, so match the prefix, not the exact string.
      final payload = ok.json() as Map;
      expect(payload['ok'], isTrue);
      expect(payload['result'], contains('Hello, Ada!'));

      final stale = await client.postJson(
        '/__react/actions',
        harness.staleEnvelope(greetRef, (name: 'Ada')),
      );
      stale.assertContractMismatch();
      await client.close();
    });

    test('unauthenticated handling', () async {
      final harness = ServerFunctionHarness();
      harness.registry.register(greetRef, (args, ctx) {
        // Example: require auth
        // ctx.requireUser();
        return greet(ctx, name: args.name);
      });
      // If greet required auth, this would assertUnauthenticated
      final client = harness.createClient(
        _routedHandler(harness, authenticate: (_) => null),
      );
      final resp = await client.postJson(
        '/__react/actions',
        harness.envelope(greetRef, (name: 'Ada')),
      );
      // Greet does not require auth, so it succeeds — this demonstrates the harness can test both
      resp.assertStatus(200);
      await client.close();
    });
  });
}

// Minimal fake to show pattern when you add auth-gated functions
// harness.expectFailure(ref, args, code: 'unauthenticated');

RequestHandler _routedHandler(
  ServerFunctionHarness harness, {
  RoutedReactAuthentication? authenticate,
}) {
  final app = RoutedReactApplication(
    actionRegistry: harness.registry,
    staticHandler: (context) => context.string('static'),
    indexTemplate: '{{SSR}}',
    authenticate: authenticate,
  );
  final engine = Engine();
  app.mount(engine);
  return RoutedRequestHandler(engine, true);
}
