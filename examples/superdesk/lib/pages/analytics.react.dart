import 'package:react/react.dart';

const idAnalyticsPage = ComponentId('package:superdesk/lib/pages/analytics.dart#AnalyticsPage');

ReactNode AnalyticsPage({
  String? title,
  String? key,
  List<ReactNode> children = const []
}) {
  final props = (title: title);
  return Component(idAnalyticsPage, props, key: key, children: children);
}

