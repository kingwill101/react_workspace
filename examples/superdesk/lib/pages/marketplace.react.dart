import 'package:react/react.dart';

const idMarketplacePage = ComponentId(
  'package:superdesk/lib/pages/marketplace.dart#MarketplacePage',
);

ReactNode MarketplacePage({
  required dynamic Function(String) onToast,
  String? key,
  List<ReactNode> children = const [],
}) {
  final props = (onToast: onToast);
  return Component(idMarketplacePage, props, key: key, children: children);
}
