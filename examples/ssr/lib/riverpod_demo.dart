import 'package:react_riverpod/react_riverpod.dart';
import 'package:react_web/react_web.dart';
import 'package:riverpod/riverpod.dart';

/// A pure-Dart Riverpod counter (see the wrapper package `react_riverpod`).
///
/// No shim, no npm, no bundling: `useRiverpod` subscribes through
/// `container.listen` and SSR reads the provider synchronously, so the
/// server markup and the hydrated client agree on the initial state.
///
/// The app renders this inside `riverpodScope(riverpodContainer, ...)`.
final riverpodCounter = NotifierProvider<RiverpodCounterNotifier, int>(
  RiverpodCounterNotifier.new,
);

final class RiverpodCounterNotifier extends Notifier<int> {
  @override
  int build() => 0;

  void increment() => state = state + 1;
}

/// Shared container: the same instance is used by SSR and the client, which
/// is what makes hydration start from identical state.
final ProviderContainer riverpodContainer = ProviderContainer();

@reactComponent
ReactNode RiverpodDemo(({bool hidden}) props) {
  final count = useRiverpod(riverpodCounter);

  return div(
    key: 'riverpod-demo',
    children: [
      const Text('Count (riverpod): '),
      Text('$count'),
      button(
        key: 'riverpod-inc',
        onClick: (_) =>
            riverpodContainer.read(riverpodCounter.notifier).increment(),
        children: const [Text('+1')],
      ),
    ],
  );
}
