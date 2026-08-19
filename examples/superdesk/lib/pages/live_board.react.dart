import 'package:react/react.dart';

const idLiveBoardPage = ComponentId(
  'package:superdesk/lib/pages/live_board.dart#LiveBoardPage',
);

ReactNode LiveBoardPage({
  required String liveCode,
  required int liveJoined,
  required dynamic Function() onJoin,
  required dynamic Function(String) onToast,
  required List<Map<String, dynamic>> phases,
  String? key,
  List<ReactNode> children = const [],
}) {
  final props = (
    liveCode: liveCode,
    liveJoined: liveJoined,
    onJoin: onJoin,
    onToast: onToast,
    phases: phases,
  );
  return Component(idLiveBoardPage, props, key: key, children: children);
}
