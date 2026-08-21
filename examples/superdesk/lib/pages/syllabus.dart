import 'package:react_web/react_web.dart';

@reactComponent
ReactNode SyllabusPage(
  ({
    String selectedSyllabus,
    Function(String) onSelect,
    List<String> expandedUnits,
    Function(String) onToggle,
    List<Map<String, dynamic>> units,
    List<Map<String, dynamic>> syllabuses,
    List<Map<String, dynamic>> classes,
    Function(String) onToast,
  })
  props,
) {
  return div(
    className: 'space-y-5',
    children: [
      div(
        className: 'flex gap-2 mb-2',
        children: [
          for (final s in props.syllabuses)
            button(
              key: s['id'] as String,
              onClick: (_) => props.onSelect(s['id'] as String),
              className:
                  'h-[40px] px-4 rounded-full border-3 border-dark font-black text-[13px] ${props.selectedSyllabus == s['id'] ? "bg-dark text-white" : "bg-white"}',
              children: [Text(s['name'] as String)],
            ),
          button(
            onClick: (_) => props.onToast('New syllabus ✨'),
            className:
                'h-[40px] px-4 bg-cream border-3 border-dashed border-dark rounded-full font-black text-[13px]',
            children: [const Text('+ New')],
          ),
        ],
      ),
      div(
        className: 'space-y-3',
        children: [
          for (final unit in props.units.where(
            (u) => u['syllabusId'] == props.selectedSyllabus,
          ))
            div(
              key: unit['id'] as String,
              children: [
                div(
                  className:
                      'flex items-center gap-3 bg-white border-3 border-dark rounded-[16px] p-3 cursor-pointer hover:shadow-[3px_3px_0px_#111] transition-shadow',
                  onClick: (_) => props.onToggle(unit['id'] as String),
                  children: [
                    span(
                      className: 'text-[24px]',
                      children: [Text(unit['emoji'] as String)],
                    ),
                    div(
                      className: 'flex-1',
                      children: [
                        span(
                          className: 'font-black text-[14px]',
                          children: [Text(unit['name'] as String)],
                        ),
                        span(
                          className: 'text-[11px] font-bold text-gray-500 ml-2',
                          children: [Text('${unit['resources']} resources')],
                        ),
                      ],
                    ),
                    span(
                      className: 'font-black text-[12px]',
                      children: [
                        Text(
                          props.expandedUnits.contains(unit['id'] as String)
                              ? '▼'
                              : '▶',
                        ),
                      ],
                    ),
                  ],
                ),
                if (props.expandedUnits.contains(unit['id'] as String) &&
                    unit['parentId'] == null)
                  div(
                    className: 'ml-6 mt-2 space-y-2',
                    children: [
                      for (final sub in props.units.where(
                        (u) => u['parentId'] == unit['id'],
                      ))
                        div(
                          key: sub['id'] as String,
                          className:
                              'bg-cream border-2 border-dark rounded-[12px] p-3 flex items-center gap-2',
                          children: [
                            span(
                              className: 'text-[18px]',
                              children: [Text(sub['emoji'] as String)],
                            ),
                            span(
                              className: 'font-bold text-[13px]',
                              children: [Text(sub['name'] as String)],
                            ),
                          ],
                        ),
                    ],
                  ),
              ],
            ),
        ],
      ),
      div(
        className: 'mt-4 bg-cream border-2 border-dark rounded-[16px] p-4',
        children: [
          div(
            className: 'flex gap-2 mb-3',
            children: [
              button(
                onClick: (_) {
                  final name = window.prompt('New unit name');
                  if (name != null && name.isNotEmpty) {
                    props.onToast('Unit added ✨');
                  }
                },
                className:
                    'h-[36px] px-4 bg-dark text-white rounded-full font-black text-[12px]',
                children: [const Text('+ Add Unit')],
              ),
            ],
          ),
          textarea(
            className:
                'w-full h-[80px] bg-white border-2 border-dark rounded-[12px] p-2 font-bold text-[12px] outline-none',
            placeholder: 'Learning objectives...',
          ),
          div(
            className: 'flex gap-2 mt-3',
            children: [
              button(
                onClick: (_) => props.onToast('Linked ✨'),
                className:
                    'h-[36px] px-4 bg-dark text-white rounded-full font-black text-[12px]',
                children: [const Text('Link Existing')],
              ),
              button(
                onClick: (_) => props.onToast('Created ✨'),
                className:
                    'h-[36px] px-4 bg-white border-2 border-dark rounded-full font-black text-[12px]',
                children: [const Text('Create New')],
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
