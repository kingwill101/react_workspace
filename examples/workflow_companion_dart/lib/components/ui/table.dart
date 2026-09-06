import 'package:react_dom/react_dom.dart';

import '../../utils.dart';

/// Table primitives used by the list pages.
ReactNode uiTable({
  ReactChildren children = const [],
  String? className,
  String? key,
}) => table(
  key: key,
  className: cn(['w-full caption-bottom text-sm', className]),
  children: children,
);

ReactNode uiTableHeader({
  ReactChildren children = const [],
  String? className,
  String? key,
}) => thead(
  key: key,
  className: cn(['[&_tr]:border-b', className]),
  children: children,
);

ReactNode uiTableBody({
  ReactChildren children = const [],
  String? className,
  String? key,
}) => tbody(
  key: key,
  className: cn(['[&_tr:last-child]:border-0', className]),
  children: children,
);

ReactNode uiTableRow({
  ReactChildren children = const [],
  String? className,
  String? key,
}) => tr(
  key: key,
  className: cn([
    'border-b transition-colors hover:bg-muted/50 data-[state=selected]:bg-muted',
    className,
  ]),
  children: children,
);

ReactNode uiTableHead(String text, {String? className}) => th(
  className: cn([
    'h-12 px-4 text-left align-middle font-medium text-muted-foreground',
    className,
  ]),
  children: [Text(text)],
);

ReactNode uiTableCell({ReactChildren children = const [], String? className}) =>
    td(className: cn(['p-4 align-middle', className]), children: children);
