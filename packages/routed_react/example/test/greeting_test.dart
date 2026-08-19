import 'package:react_testing/react_testing.dart';
import 'package:test/test.dart';

import 'package:example/greeting.action.g.dart' show greetRef;
import 'package:example/greeting.dart';

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

      final client = harness.createClient();
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
    });

    test('unauthenticated handling', () async {
      final harness = ServerFunctionHarness(authenticate: (_) => null);
      harness.registry.register(greetRef, (args, ctx) {
        // Example: require auth
        // ctx.requireUser();
        return greet(ctx, name: args.name);
      });
      // If greet required auth, this would assertUnauthenticated
      final client = harness.createClient();
      final resp = await client.postJson(
        '/__react/actions',
        harness.envelope(greetRef, (name: 'Ada')),
      );
      // Greet does not require auth, so it succeeds — this demonstrates the harness can test both
      resp.assertStatus(200);
    });
  });
}

// Minimal fake to show pattern when you add auth-gated functions
// harness.expectFailure(ref, args, code: 'unauthenticated');
