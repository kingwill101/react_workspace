import 'package:react/react.dart';

/// Shared accent context used by the example application.
final appAccentContext = createContext<String>('#7257ff');

/// Small external store used to demonstrate SSR-safe subscriptions.
final exampleActivityStore = _ExampleActivityStore();

final class _ExampleActivityStore {
  int _version = 0;
  final _listeners = <void Function()>{};

  int snapshot() => _version;

  void mark() {
    _version++;
    for (final listener in List<void Function()>.of(_listeners)) {
      listener();
    }
  }

  void Function() subscribe(void Function() listener) {
    _listeners.add(listener);
    return () => _listeners.remove(listener);
  }
}
