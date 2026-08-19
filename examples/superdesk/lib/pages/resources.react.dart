import 'package:react/react.dart';

const idResourcesPage = ComponentId(
  'package:superdesk/lib/pages/resources.dart#ResourcesPage',
);

ReactNode ResourcesPage({
  required String filter,
  required dynamic Function() onAdd,
  required dynamic Function(Map<String, dynamic>) onDelete,
  required dynamic Function(Map<String, dynamic>) onDuplicate,
  required dynamic Function(Map<String, dynamic>) onEdit,
  required dynamic Function(String) onFilter,
  required dynamic Function(String) onSearch,
  required dynamic Function(String) onToast,
  required List<Map<String, dynamic>> resources,
  required String search,
  String? key,
  List<ReactNode> children = const [],
}) {
  final props = (
    filter: filter,
    onAdd: onAdd,
    onDelete: onDelete,
    onDuplicate: onDuplicate,
    onEdit: onEdit,
    onFilter: onFilter,
    onSearch: onSearch,
    onToast: onToast,
    resources: resources,
    search: search,
  );
  return Component(idResourcesPage, props, key: key, children: children);
}
