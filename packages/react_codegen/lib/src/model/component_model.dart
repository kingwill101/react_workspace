import 'type_ref.dart';

final class ReactPropModel {
  final String name;
  final ReactTypeRef type;
  final bool required;

  const ReactPropModel({
    required this.name,
    required this.type,
    this.required = true,
  });
}

final class ReactComponentModel {
  final String name;
  final String componentId;
  final ReactTypeRef returnType;
  final List<ReactPropModel> props;
  final ReactTypeRef propsRecord;

  const ReactComponentModel({
    required this.name,
    required this.componentId,
    required this.returnType,
    this.props = const [],
    required this.propsRecord,
  });
}

final class ReactLibraryModel {
  final String inputFile;
  final String reactFile;
  final List<ReactComponentModel> components;

  const ReactLibraryModel({
    required this.inputFile,
    required this.reactFile,
    this.components = const [],
  });

  bool get isEmpty => components.isEmpty;
}
