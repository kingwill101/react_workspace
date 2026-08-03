import 'package:react/react.dart';

const idStateSection = ComponentId('package:example/lib/state_pages.dart#StateSection');

ReactNode StateSection({
  required String title,
  String? key,
  List<ReactNode> children = const []
}) {
  final props = (title: title);
  return Component(idStateSection, props, key: key, children: children);
}

const idStateOverview = ComponentId('package:example/lib/state_pages.dart#StateOverview');

ReactNode StateOverview({
  required String title,
  String? key,
  List<ReactNode> children = const []
}) {
  final props = (title: title);
  return Component(idStateOverview, props, key: key, children: children);
}

const idZustandPage = ComponentId('package:example/lib/state_pages.dart#ZustandPage');

ReactNode ZustandPage({
  required String title,
  String? key,
  List<ReactNode> children = const []
}) {
  final props = (title: title);
  return Component(idZustandPage, props, key: key, children: children);
}

const idRiverpodPage = ComponentId('package:example/lib/state_pages.dart#RiverpodPage');

ReactNode RiverpodPage({
  required String title,
  String? key,
  List<ReactNode> children = const []
}) {
  final props = (title: title);
  return Component(idRiverpodPage, props, key: key, children: children);
}

const idBlocPage = ComponentId('package:example/lib/state_pages.dart#BlocPage');

ReactNode BlocPage({
  required String title,
  String? key,
  List<ReactNode> children = const []
}) {
  final props = (title: title);
  return Component(idBlocPage, props, key: key, children: children);
}

const idTodosPage = ComponentId('package:example/lib/state_pages.dart#TodosPage');

ReactNode TodosPage({
  required String title,
  String? key,
  List<ReactNode> children = const []
}) {
  final props = (title: title);
  return Component(idTodosPage, props, key: key, children: children);
}

