import 'package:react_web/react_web.dart';


@reactComponent
ReactNode SyllabusPage(
  ({
    String selectedSyllabus,
    Function(String) onSelect,
    List<String> expandedUnits,
    Function(String) onToggle,
    Function(String) onToast,
  })
  props,
) {
  final syllabuses = [
    {'id': 's1', 'name': 'Fall Semester', 'color': '#FFE8A3'},
    {'id': 's2', 'name': 'Spring Semester', 'color': '#C8F5D4'},
  ];

  final units = [
    {
      'id': 'u1',
      'name': 'Unit 1: Greetings',
      'emoji': '👋',
      'resources': 8,
      'color': '#FFE8A3',
      'syllabusId': 's1',
      'parentId': null,
    },
    {
      'id': 'u2',
      'name': 'Unit 2: Colors',
      'emoji': '🎨',
      'resources': 12,
      'color': '#C8F5D4',
      'syllabusId': 's1',
      'parentId': null,
    },
    {
      'id': 'u3',
      'name': 'Unit 3: Animals',
      'emoji': '🐾',
      'resources': 10,
      'color': '#FFC9CE',
      'syllabusId': 's1',
      'parentId': null,
    },
    {
      'id': 'u4',
      'name': 'Sub: Pets',
      'emoji': '🐱',
      'resources': 4,
      'color': '#FFF4E0',
      'syllabusId': 's1',
      'parentId': 'u2',
    },
    {
      'id': 'u5',
      'name': 'Sub: Farm Animals',
      'emoji': '🐄',
      'resources': 3,
      'color': '#FFF4E0',
      'syllabusId': 's1',
      'parentId': 'u2',
    },
  ];

  return div(
    className: 'space-y-5',
    children: [
      div(
        className: 'flex gap-2 mb-2',
        children: [
          for (final s in syllabuses)
            button(
              key: s['id'] as String,
              onClick: (_) => props.onSelect(s['id'] as String),
              className:
                  'h-[40px] px-4 rounded-full border-3 border-dark font-black text-[13px] ${props.selectedSyllabus == s['id'] ? "bg-dark text-white" : "bg-white"}',
              children: [Text(s['name'] as String)],
            ),
        ],
      ),
      div(
        className: 'space-y-3',
        children: [
          for (final unit in units.where(
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
                      for (final sub in units.where(
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
    ],
  );
}
