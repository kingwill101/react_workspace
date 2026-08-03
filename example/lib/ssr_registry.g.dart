// GENERATED CODE — DO NOT EDIT

import 'package:react/react.dart';
import 'package:example/about_page.react.dart' show idAboutPage;
import 'package:example/app.react.dart' show idApp;
import 'package:example/avatar.react.dart' show idAvatar;
import 'package:example/badge.react.dart' show idBadge;
import 'package:example/bloc_demo.react.dart' show idBlocDemo;
import 'package:example/counter.react.dart' show idCounter;
import 'package:example/home_page.react.dart' show idHomePage;
import 'package:example/hooks_page.react.dart' show idHooksPage;
import 'package:example/not_found_page.react.dart' show idNotFoundPage;
import 'package:example/riverpod_demo.react.dart' show idRiverpodDemo;
import 'package:example/route_item.react.dart' show idItemDetail;
import 'package:example/router_pages.react.dart' show idRouterSection;
import 'package:example/router_pages.react.dart' show idRouterOverview;
import 'package:example/router_pages.react.dart' show idItemPage;
import 'package:example/router_pages.react.dart' show idSearchDemo;
import 'package:example/router_pages.react.dart' show idRedirectDemo;
import 'package:example/site_layout.react.dart' show idSiteLayout;
import 'package:example/state_pages.react.dart' show idStateSection;
import 'package:example/state_pages.react.dart' show idStateOverview;
import 'package:example/state_pages.react.dart' show idZustandPage;
import 'package:example/state_pages.react.dart' show idRiverpodPage;
import 'package:example/state_pages.react.dart' show idBlocPage;
import 'package:example/state_pages.react.dart' show idTodosPage;
import 'package:example/todos/todos_ui.react.dart' show idTodoApp;
import 'package:example/zustand_demo.react.dart' show idZustandDemo;

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
  SsrComponentRegistry.register(    idAboutPage.value, (_) => const Empty());
  SsrComponentRegistry.register(    idApp.value, (_) => const Empty());
  SsrComponentRegistry.register(    idAvatar.value, (_) => const Empty());
  SsrComponentRegistry.register(    idBadge.value, (_) => const Empty());
  SsrComponentRegistry.register(    idBlocDemo.value, (_) => const Empty());
  SsrComponentRegistry.register(    idCounter.value, (_) => const Empty());
  SsrComponentRegistry.register(    idHomePage.value, (_) => const Empty());
  SsrComponentRegistry.register(    idHooksPage.value, (_) => const Empty());
  SsrComponentRegistry.register(    idNotFoundPage.value, (_) => const Empty());
  SsrComponentRegistry.register(    idRiverpodDemo.value, (_) => const Empty());
  SsrComponentRegistry.register(    idItemDetail.value, (_) => const Empty());
  SsrComponentRegistry.register(    idRouterSection.value, (_) => const Empty());
  SsrComponentRegistry.register(    idRouterOverview.value, (_) => const Empty());
  SsrComponentRegistry.register(    idItemPage.value, (_) => const Empty());
  SsrComponentRegistry.register(    idSearchDemo.value, (_) => const Empty());
  SsrComponentRegistry.register(    idRedirectDemo.value, (_) => const Empty());
  SsrComponentRegistry.register(    idSiteLayout.value, (_) => const Empty());
  SsrComponentRegistry.register(    idStateSection.value, (_) => const Empty());
  SsrComponentRegistry.register(    idStateOverview.value, (_) => const Empty());
  SsrComponentRegistry.register(    idZustandPage.value, (_) => const Empty());
  SsrComponentRegistry.register(    idRiverpodPage.value, (_) => const Empty());
  SsrComponentRegistry.register(    idBlocPage.value, (_) => const Empty());
  SsrComponentRegistry.register(    idTodosPage.value, (_) => const Empty());
  SsrComponentRegistry.register(    idTodoApp.value, (_) => const Empty());
  SsrComponentRegistry.register(    idZustandDemo.value, (_) => const Empty());
}
