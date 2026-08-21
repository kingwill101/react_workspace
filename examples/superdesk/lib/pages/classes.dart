import 'package:react_web/react_web.dart';

@reactComponent
ReactNode ClassesPage(
  ({List<Map<String, dynamic>> classes, Function(String) onToast}) props,
) {
  return div(
    className: 'space-y-5',
    children: [
      div(
        className:
            'bg-white border-3 border-dark rounded-[28px] shadow-[6px_6px_0px_#111] p-5',
        children: [
          h4(
            className: 'font-black mb-4',
            style: {'fontFamily': 'Fredoka'},
            children: [const Text('My Classes')],
          ),
          div(
            className: 'grid md:grid-cols-2 gap-4',
            children: [
              for (final cls in props.classes)
                div(
                  key: cls['id'] as String,
                  className:
                      'border-3 border-dark rounded-[20px] shadow-chunky p-4',
                  style: {'background': cls['color'] as String},
                  children: [
                    div(
                      className: 'flex items-center justify-between mb-3',
                      children: [
                        span(
                          className: 'font-black text-[18px]',
                          children: [Text(cls['name'] as String)],
                        ),
                        span(
                          className:
                              'text-[12px] font-bold bg-white border-2 border-dark rounded-full px-2 py-0.5',
                          children: [
                            Text(
                              '${(cls['students'] as List).length} students',
                            ),
                          ],
                        ),
                      ],
                    ),
                    div(
                      className: 'flex flex-wrap gap-2',
                      children: [
                        for (final s in cls['students'] as List)
                          span(
                            className:
                                'text-[12px] font-bold bg-white border-2 border-dark rounded-full px-2 py-1',
                            children: [Text(s['name'] as String)],
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
              h4(
                className: 'font-black mb-2',
                style: {'fontFamily': 'Fredoka'},
                children: [const Text('Group Maker')],
              ),
              div(
                className: 'flex items-center gap-3',
                children: [
                  span(
                    className: 'font-black text-[12px]',
                    children: [const Text('Groups:')],
                  ),
                  input(
                    type: 'range',
                    min: '2',
                    max: '6',
                    defaultValue: '3',
                    className: 'flex-1 accent-dark',
                  ),
                  button(
                    onClick: (_) => props.onToast('Shuffled ✨'),
                    className:
                        'h-[36px] px-4 bg-cream border-2 border-dark rounded-full font-black text-[12px]',
                    children: [const Text('Shuffle ✨')],
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
