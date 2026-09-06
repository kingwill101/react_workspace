import 'package:react_dom/react_dom.dart';
import 'package:react_web/web.dart' show HTMLInputElement;

import '../../utils.dart';

/// A command-palette item. Items are kept as Dart data so filtering is
/// deterministic in SSR and can later be replaced by a remote search.
final class UiCommandItem {
  /// Creates a command item.
  const UiCommandItem({
    required this.value,
    required this.label,
    this.keywords = const [],
    this.disabled = false,
  });

  final String value;
  final String label;
  final List<String> keywords;
  final bool disabled;

  bool matches(String query) {
    final normalized = query.trim().toLowerCase();
    if (normalized.isEmpty) return true;
    return '$label ${keywords.join(' ')}'.toLowerCase().contains(normalized);
  }
}

/// A compact command palette equivalent to the local `cmdk` wrapper.
ReactNode uiCommand({
  required String query,
  required void Function(String) onQueryChanged,
  required List<UiCommandItem> items,
  required void Function(UiCommandItem item) onSelected,
  String placeholder = 'Search commands...',
  String emptyLabel = 'No commands found.',
  String? className,
}) {
  final visible = items.where((item) => item.matches(query)).toList();
  return div(
    className: cn([
      'flex h-full w-full flex-col overflow-hidden rounded-md bg-popover text-popover-foreground',
      className,
    ]),
    role: 'combobox',
    additionalProps: {'aria-expanded': true, 'aria-label': 'Command menu'},
    children: [
      div(
        className: 'flex items-center border-b border-border px-3',
        children: [
          span(
            className: 'mr-2 text-sm opacity-50',
            children: const [Text('⌕')],
          ),
          input(
            value: query,
            placeholder: placeholder,
            className: 'flex h-11 w-full rounded-md bg-transparent py-3 text-sm outline-none placeholder:text-muted-foreground',
            additionalProps: {'aria-label': placeholder},
            onChange: (event) =>
                onQueryChanged((event.target as HTMLInputElement).value),
          ),
        ],
      ),
      div(
        className: 'max-h-72 overflow-auto p-1',
        role: 'listbox',
        children: visible.isEmpty
            ? [
                p(
                  className: 'py-6 text-center text-sm text-muted-foreground',
                  children: [Text(emptyLabel)],
                ),
              ]
            : [
                for (final item in visible)
                  uiCommandItem(item: item, onSelected: () => onSelected(item)),
              ],
      ),
    ],
  );
}

/// A command item button with disabled and selection semantics.
ReactNode uiCommandItem({
  required UiCommandItem item,
  required void Function() onSelected,
  String? className,
}) => button(
  type: 'button',
  disabled: item.disabled,
  className: cn([
    'relative flex w-full cursor-default select-none items-center rounded-sm px-2 py-2 text-left text-sm outline-none hover:bg-accent hover:text-accent-foreground',
    item.disabled ? 'pointer-events-none opacity-50' : null,
    className,
  ]),
  role: 'option',
  onClick: (_) => onSelected(),
  children: [Text(item.label)],
);

/// Groups command items beneath a visible heading.
ReactNode uiCommandGroup({
  required String heading,
  required ReactChildren children,
  String? className,
}) => div(
  className: cn(['overflow-hidden p-1 text-foreground', className]),
  role: 'group',
  children: [
    p(
      className: 'px-2 py-1.5 text-xs font-medium text-muted-foreground',
      children: [Text(heading)],
    ),
    ...children,
  ],
);
