// GENERATED CODE — DO NOT EDIT

import 'package:react/react.dart';
import 'package:superdesk/app.react.dart' show idApp;
import 'package:superdesk/pages/analytics.react.dart' show idAnalyticsPage;
import 'package:superdesk/pages/arcade.react.dart' show idArcadePage;
import 'package:superdesk/pages/builder.react.dart' show idBuilderPage;
import 'package:superdesk/pages/classes.react.dart' show idClassesPage;
import 'package:superdesk/pages/dashboard.react.dart' show idDashboardPage;
import 'package:superdesk/pages/live_board.react.dart' show idLiveBoardPage;
import 'package:superdesk/pages/marketplace.react.dart' show idMarketplacePage;
import 'package:superdesk/pages/resources.react.dart' show idResourcesPage;
import 'package:superdesk/pages/settings.react.dart' show idSettingsPage;
import 'package:superdesk/pages/syllabus.react.dart' show idSyllabusPage;

/// Maps canonical component IDs to their SSR builders.
final class SsrComponentRegistry {
  SsrComponentRegistry._();

  static final _builders = <String, ReactNode Function(Map<String, dynamic>)>{};

  static void register(String id, ReactNode Function(Map<String, dynamic>) builder) {
    _builders[id] = builder;
  }

  static ReactNode build(String id, Map<String, dynamic> props) {
    final builder = _builders[id];
    if (builder == null) return const Empty();
    return builder(props);
  }

  static Set<String> get knownIds => _builders.keys.toSet();
}

void registerKnownSsComponentIds() {
  SsrComponentRegistry.register(    idApp.value, (_) => const Empty());
  SsrComponentRegistry.register(    idAnalyticsPage.value, (_) => const Empty());
  SsrComponentRegistry.register(    idArcadePage.value, (_) => const Empty());
  SsrComponentRegistry.register(    idBuilderPage.value, (_) => const Empty());
  SsrComponentRegistry.register(    idClassesPage.value, (_) => const Empty());
  SsrComponentRegistry.register(    idDashboardPage.value, (_) => const Empty());
  SsrComponentRegistry.register(    idLiveBoardPage.value, (_) => const Empty());
  SsrComponentRegistry.register(    idMarketplacePage.value, (_) => const Empty());
  SsrComponentRegistry.register(    idResourcesPage.value, (_) => const Empty());
  SsrComponentRegistry.register(    idSettingsPage.value, (_) => const Empty());
  SsrComponentRegistry.register(    idSyllabusPage.value, (_) => const Empty());
}
