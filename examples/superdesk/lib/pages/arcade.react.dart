import 'package:react/react.dart';

const idArcadePage = ComponentId(
  'package:superdesk/lib/pages/arcade.dart#ArcadePage',
);

ReactNode ArcadePage({
  required String arcadeGame,
  required dynamic Function(String) onGame,
  required dynamic Function(int) onScore,
  required dynamic Function(String) onToast,
  required dynamic Function(bool) onWordPop,
  required int score,
  required bool wordPopActive,
  String? key,
  List<ReactNode> children = const [],
}) {
  final props = (
    arcadeGame: arcadeGame,
    onGame: onGame,
    onScore: onScore,
    onToast: onToast,
    onWordPop: onWordPop,
    score: score,
    wordPopActive: wordPopActive,
  );
  return Component(idArcadePage, props, key: key, children: children);
}
