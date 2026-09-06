import 'dart:async';

import 'package:react_core/react.dart';

/// Options for [useRealTimeData].
final class RealTimeDataOptions<T> {
  /// Creates real-time data options.
  const RealTimeDataOptions({
    required this.data,
    this.interval = const Duration(seconds: 3),
    this.enabled = true,
    this.mutator,
  });

  /// Initial rows.
  final List<T> data;

  /// Polling interval used while [enabled].
  final Duration interval;

  /// Whether polling is active.
  final bool enabled;

  /// Optional deterministic update applied to every row on refresh.
  final T Function(T item)? mutator;
}

/// The state returned by [useRealTimeData].
final class RealTimeData<T> {
  /// Creates a real-time data snapshot.
  const RealTimeData({
    required this.data,
    required this.lastUpdated,
    required this.isRefreshing,
    required this.refresh,
  });

  final List<T> data;
  final DateTime lastUpdated;
  final bool isRefreshing;
  final void Function() refresh;
}

/// Keeps a local list fresh using the same refresh and polling semantics as
/// the reference `useRealTimeData` hook.
RealTimeData<T> useRealTimeData<T>(RealTimeDataOptions<T> options) {
  final (data, setData) = useState<List<T>>(List.of(options.data));
  final (lastUpdated, setLastUpdated) = useState(DateTime.now());
  final (isRefreshing, setIsRefreshing) = useState(false);

  void applyMutation() {
    final mutator = options.mutator;
    if (mutator != null) {
      setData.update((previous) => previous.map(mutator).toList());
    }
    setLastUpdated(DateTime.now());
  }

  void refresh() {
    setIsRefreshing(true);
    Future<void>.delayed(const Duration(milliseconds: 300), () {
      applyMutation();
      setIsRefreshing(false);
    });
  }

  useEffect(() {
    if (!options.enabled) return null;
    final timer = Timer.periodic(options.interval, (_) => applyMutation());
    return timer.cancel;
  }, [options.enabled, options.interval, options.mutator]);

  return RealTimeData<T>(
    data: data,
    lastUpdated: lastUpdated,
    isRefreshing: isRefreshing,
    refresh: refresh,
  );
}

/// Formats elapsed time using the same compact labels as the reference app.
String formatTimeSince(DateTime date, {DateTime? now}) {
  final seconds =
      ((now ?? DateTime.now()).difference(date).inMilliseconds / 1000).floor();
  if (seconds < 5) return 'just now';
  if (seconds < 60) return '${seconds}s ago';
  return '${seconds ~/ 60}m ago';
}
