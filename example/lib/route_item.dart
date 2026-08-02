import 'package:react_router/react_router.dart';
import 'package:react_router/react_router_hooks.dart';
import 'package:react_web/react_web.dart' hide link; // <link> collides with router Link

/// Renders a matched `/items/:id` route and reads `:id` with `useParams`.
@reactComponent
ReactNode ItemDetail(({bool hidden}) props) {
  final params = useParams();
  final id = params['id'] ?? '?';

  return div(
    key: 'route-item',
    children: [
      Text('Item #$id — useParams works: ${params.entries.map((e) => '${e.key}=${e.value}').join(', ')}'),
      div(children: [
        link('/items/7', children: [const Text('← back to item 7')]),
      ]),
    ],
  );
}
