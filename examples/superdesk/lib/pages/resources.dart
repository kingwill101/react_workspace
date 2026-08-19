import 'package:react_web/react_web.dart';
import 'package:react_web/web.dart' show HTMLInputElement, HTMLSelectElement;

@reactComponent
ReactNode ResourcesPage(
  ({
    List<Map<String, dynamic>> resources,
    String search,
    String filter,
    Function(String) onFilter,
    Function(String) onSearch,
    Function() onAdd,
    Function(Map<String, dynamic>) onEdit,
    Function(Map<String, dynamic>) onDelete,
    Function(Map<String, dynamic>) onDuplicate,
    Function(String) onToast,
  })
  props,
) {
  final filtered = props.resources.where((r) {
    final matchesSearch = (r['name'] as String).toLowerCase().contains(
      props.search.toLowerCase(),
    );
    final matchesFilter = props.filter == 'all' || r['badge'] == props.filter;
    return matchesSearch && matchesFilter;
  }).toList();

  return div(
    className: 'space-y-5',
    children: [
      div(
        className: 'flex flex-wrap items-center justify-between gap-3',
        children: [
          h2(
            className: 'font-black text-[20px] flex items-center gap-2',
            style: {'fontFamily': 'Fredoka'},
            children: [Text('📦 Resources')],
          ),
          div(
            className: 'flex gap-2',
            children: [
              input(
                value: props.search,
                onChange: (e) =>
                    props.onSearch((e.target as HTMLInputElement).value),
                placeholder: 'Search...',
                className:
                    'h-[36px] px-3 bg-white border-2 border-dark rounded-full font-bold text-[13px] w-[160px]',
              ),
              select(
                value: props.filter,
                onChange: (e) =>
                    props.onFilter((e.target as HTMLSelectElement).value),
                className:
                    'h-[36px] bg-white border-2 border-dark rounded-full px-3 font-bold text-[13px]',
                children: [
                  option(value: 'all', children: [Text('All')]),
                  option(value: 'Popular', children: [Text('Popular')]),
                  option(value: 'Quick', children: [Text('Quick')]),
                  option(value: 'Creative', children: [Text('Creative')]),
                  option(value: 'Audio', children: [Text('Audio')]),
                  option(value: 'Video', children: [Text('Video')]),
                ],
              ),
              button(
                onClick: (_) => props.onAdd(),
                className:
                    'h-[36px] px-4 bg-dark text-white rounded-full font-black text-[13px] flex items-center gap-1',
                children: [Text('+ New')],
              ),
            ],
          ),
        ],
      ),
      div(
        className: 'grid md:grid-cols-2 lg:grid-cols-3 gap-4',
        children: [
          for (final r in filtered)
            div(
              key: r['id'] as String,
              className:
                  'bg-white border-3 border-dark rounded-[20px] shadow-chunky p-4 flex flex-col gap-2',
              children: [
                div(
                  className: 'flex items-center justify-between',
                  children: [
                    span(
                      className: 'font-black text-[14px]',
                      children: [Text(r['name'] as String)],
                    ),
                    if (r['badge'] != null)
                      span(
                        className:
                            'text-[10px] font-black bg-dark text-white rounded-full px-2 py-0.5',
                        children: [Text(r['badge'] as String)],
                      ),
                  ],
                ),
                p(
                  className: 'text-[12px] font-bold text-gray-500',
                  children: [Text(r['desc'] as String)],
                ),
                div(
                  className:
                      'flex items-center justify-between mt-auto pt-2 border-t-2 border-dark',
                  children: [
                    span(
                      className: 'text-[11px] font-bold text-gray-400',
                      children: [Text(r['duration'] as String)],
                    ),
                    div(
                      className: 'flex gap-1',
                      children: [
                        button(
                          onClick: (_) => props.onEdit(r),
                          className:
                              'w-[32px] h-[32px] bg-cream border-2 border-dark rounded-full font-black text-[12px]',
                          children: [Text('✏️')],
                        ),
                        button(
                          onClick: (_) => props.onDuplicate(r),
                          className:
                              'w-[32px] h-[32px] bg-cream border-2 border-dark rounded-full font-black text-[12px]',
                          children: [Text('📋')],
                        ),
                        button(
                          onClick: (_) => props.onDelete(r),
                          className:
                              'w-[32px] h-[32px] bg-cream border-2 border-dark rounded-full font-black text-[12px]',
                          children: [Text('🗑️')],
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
        ],
      ),
    ],
  );
}
