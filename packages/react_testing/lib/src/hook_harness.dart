import 'package:react_core/react.dart';

import 'component_harness.dart';

/// A single component's state, memo, ref, and effect lifecycle in native Dart.
///
/// Call [render] again to observe async state changes. Effects commit after a
/// successful render; replacement and disposal run cleanup. This harness does
/// not simulate browser scheduling, concurrent rendering, or nested components.
final class HookTestHarness {
  HookTestHarness({bool server = false}) {
    _binding = _HookBinding(effects: !server);
    _runtime = ReactRuntime(
      target: server ? ReactRenderTarget.server : ReactRenderTarget.test,
      capabilities: server
          ? ReactRuntimeCapabilities.server
          : ReactRuntimeCapabilities.browser,
      binding: _binding,
      renderer: TestReactRenderer(),
    );
  }
  late final _HookBinding _binding;
  late final ReactRuntime _runtime;

  T render<T>(T Function() component) {
    if (_binding.disposed) throw StateError('Harness has been disposed.');
    _binding.cursor = 0;
    _binding.pending.clear();
    final result = runWithReactRuntime(_runtime, component);
    if (_binding.cursor != _binding.slots.length) {
      throw StateError('Hook count changed.');
    }
    _binding.rendered = true;
    for (final effect in _binding.pending) {
      effect();
    }
    _binding.pending.clear();
    return result;
  }

  void dispose() {
    if (_binding.disposed) return;
    _binding.disposed = true;
    for (final slot in _binding.slots) {
      if (slot is _EffectSlot) slot.cleanup?.call();
    }
  }
}

final class _StateSlot<T> {
  _StateSlot(this.value);
  T value;
  late StateSetter<T> setter;
}

final class _EffectSlot {
  List<Object?>? deps;
  EffectCleanup? cleanup;
  bool committed = false;
}

final class _MemoSlot<T> {
  _MemoSlot(this.value, this.deps);
  T value;
  List<Object?>? deps;
}

bool _sameDeps(List<Object?>? first, List<Object?>? second) =>
    first != null &&
    second != null &&
    first.length == second.length &&
    List.generate(
      first.length,
      (i) => identical(first[i], second[i]),
    ).every((same) => same);

final class _HookBinding extends TestReactBinding {
  _HookBinding({required this.effects});
  final bool effects;
  bool disposed = false;
  bool rendered = false;
  int cursor = 0;
  final slots = <Object>[];
  final pending = <void Function()>[];

  int nextSlot() {
    if (rendered && cursor >= slots.length) {
      throw StateError('Hook count changed.');
    }
    return cursor++;
  }

  @override
  T useMemo<T>(T Function() factory, List<Object?>? deps) {
    final index = nextSlot();
    if (index == slots.length) {
      slots.add(_MemoSlot<T>(factory(), deps == null ? null : List.of(deps)));
    } else {
      final slot = slots[index] as _MemoSlot<T>;
      if (!_sameDeps(slot.deps, deps)) {
        slot.value = factory();
        slot.deps = deps == null ? null : List.of(deps);
      }
    }
    return (slots[index] as _MemoSlot<T>).value;
  }

  @override
  T useCallback<T extends Function>(T callback, List<Object?>? deps) =>
      useMemo(() => callback, deps);

  @override
  ReactRef<T> useRef<T>(T? initialValue) =>
      useMemo(() => ReactRef<T>(initialValue), const []);

  @override
  (T, StateSetter<T>) useState<T>(T initial) {
    final index = nextSlot();
    if (index == slots.length) {
      final slot = _StateSlot<T>(initial);
      slot.setter = StateSetter<T>(
        (value) {
          if (!disposed) slot.value = value;
        },
        (update) {
          if (!disposed) slot.value = update(slot.value);
        },
      );
      slots.add(slot);
    }
    final slot = slots[index] as _StateSlot<T>;
    return (slot.value, slot.setter);
  }

  @override
  void useEffect(EffectCallback effect, List<Object?>? deps) {
    final index = nextSlot();
    if (index == slots.length) slots.add(_EffectSlot());
    final slot = slots[index] as _EffectSlot;
    final same = slot.committed && _sameDeps(deps, slot.deps);
    if (!effects || same) return;
    pending.add(() {
      slot.cleanup?.call();
      slot.cleanup = null;
      final cleanup = effect();
      if (cleanup is EffectCleanup) slot.cleanup = cleanup;
      slot.deps = deps == null ? null : List.of(deps);
      slot.committed = true;
    });
  }
}
