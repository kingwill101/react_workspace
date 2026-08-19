import 'package:react_web_generator/src/complete/complete.dart';
import 'package:react_web_generator/src/bcd_filter.dart';

void main() {
  final bcd = BcdFilter.load();
  final raw = CompleteWebModelBuilder(
    webIdlPath: 'tool/web_idl/snapshots/web_apis.json',
    bcdFilter: bcd,
  ).loadRaw();
  final model = mergeRawModel(raw);
  print(
    'callback defs: ${model.callbacks.keys.where((k) => k.contains('EventHandler') || k.contains('Callback')).toList().take(10)}',
  );
  print('EventHandler typedef: ${model.typedefs['EventHandler']?.type}');
  final bc = model.interfaces['BroadcastChannel']!;
  final onm = bc.members.firstWhere((m) => m.name == 'onmessage');
  print('onmessage type: ${(onm as IdlAttribute).type}');
}
