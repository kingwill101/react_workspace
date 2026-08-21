import 'package:react_web/react_web.dart';

@reactComponent
ReactNode AnalyticsPage(({String? title}) props) {
  final stats = [
    {'label': 'Total Students', 'val': '24', 'bg': '#C8E8FF', 'icon': '👥'},
    {'label': 'Lessons Done', 'val': '18', 'bg': '#C8F5D4', 'icon': '📚'},
    {'label': 'Avg Score', 'val': '87%', 'bg': '#FFE8A3', 'icon': '⭐'},
    {'label': 'Streak', 'val': '12d', 'bg': '#FFC9CE', 'icon': '🔥'},
  ];

  final activities = [
    {'k': 'Vocabulary', 'v': 85},
    {'k': 'Grammar', 'v': 72},
    {'k': 'Reading', 'v': 91},
    {'k': 'Speaking', 'v': 68},
    {'k': 'Listening', 'v': 78},
  ];

  return div(
    className: 'space-y-5',
    children: [
      div(
        className: 'grid md:grid-cols-4 gap-4',
        children: [
          for (final s in stats)
            div(
              key: s['label'] as String,
              className:
                  'border-3 border-dark rounded-[24px] shadow-[4px_4px_0px_#111] p-4',
              style: {'background': s['bg'] as String},
              children: [
                div(
                  className: 'flex items-center justify-between',
                  children: [
                    span(
                      className:
                          'w-[36px] h-[36px] bg-white border-2 border-dark rounded-[12px] grid place-items-center',
                      children: [Text(s['icon'] as String)],
                    ),
                    span(
                      className: 'font-black text-[22px]',
                      children: [Text(s['val'] as String)],
                    ),
                  ],
                ),
                div(
                  className: 'font-black text-[12px] mt-2',
                  children: [Text(s['label'] as String)],
                ),
              ],
            ),
        ],
      ),
      div(
        className: 'grid lg:grid-cols-2 gap-5',
        children: [
          div(
            className:
                'bg-white border-3 border-dark rounded-[28px] shadow-[6px_6px_0px_#111] p-5',
            children: [
              h4(
                className: 'font-black mb-4',
                style: {'fontFamily': 'Fredoka'},
                children: [const Text('Mastery Heatmap')],
              ),
              div(
                className: 'grid grid-cols-8 gap-2',
                children: [
                  for (var i = 0; i < 24; i++)
                    div(
                      key: i.toString(),
                      className:
                          'aspect-square rounded-[8px] border-2 border-dark grid place-items-center font-black text-[10px]',
                      style: {'background': i < 18 ? '#C8F5D4' : '#FFF4E0'},
                      children: [Text('${(i / 24 * 100).toInt()}%')],
                    ),
                ],
              ),
            ],
          ),
          div(
            className:
                'bg-white border-3 border-dark rounded-[28px] shadow-[6px_6px_0px_#111] p-5',
            children: [
              h4(
                className: 'font-black mb-4',
                style: {'fontFamily': 'Fredoka'},
                children: [const Text('Engagement by Activity')],
              ),
              div(
                className: 'space-y-3',
                children: [
                  for (final b in activities)
                    div(
                      key: b['k'] as String,
                      className: 'flex items-center gap-3',
                      children: [
                        span(
                          className: 'w-[70px] font-black text-[12px]',
                          children: [Text(b['k'] as String)],
                        ),
                        div(
                          className:
                              'flex-1 h-[18px] bg-cream border-2 border-dark rounded-full overflow-hidden',
                          children: [
                            div(
                              className:
                                  'h-full bg-yellow-200 border-r-2 border-dark',
                              style: {
                                'width': '${b['v']}%',
                                'transition': 'width 0.3s',
                              },
                            ),
                          ],
                        ),
                        span(
                          className: 'font-black text-[12px]',
                          children: [Text('${b['v']}%')],
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
