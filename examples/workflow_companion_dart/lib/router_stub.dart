import 'package:react_dom/react_dom.dart';

ReactNode browserRouter({ReactChildren children = const []}) =>
    fragment(children);

ReactNode routes({ReactChildren children = const []}) => fragment(children);

ReactNode route({
  String? key,
  Object? path,
  ReactNode? element,
  ReactChildren children = const [],
}) => element ?? fragment(children, key: key);

ReactNode navLink({
  String? key,
  required Object? to,
  String? className,
  bool? end,
  ReactChildren children = const [],
}) => a(
  key: key,
  className: className,
  additionalProps: {'href': '$to'},
  children: children,
);

Map<String, String> useParams() => const {};

void Function(Object? to, {bool? replace}) useNavigate() =>
    (Object? to, {bool? replace}) {};
