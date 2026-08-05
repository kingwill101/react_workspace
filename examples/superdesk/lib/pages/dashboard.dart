import 'package:react_web/react_web.dart';

@reactComponent
ReactNode DashboardPage(({
  Map<String, dynamic>? user,
  List<Map<String, dynamic>> templates,
  List<Map<String, dynamic>> lessons,
  List<Map<String, dynamic>> units,
  Function(String) onNavigate,
  Function(String) onToast,
}) props) {
  return div(
    className: 'space-y-6',
    children: [
      div(
        className: 'flex flex-wrap items-center justify-between gap-4',
        children: [
          div(
            children: [
              h1(
                className: 'text-[28px] md:text-[34px] font-black leading-tight',
                style: {'fontFamily': 'Fredoka'},
                children: [Text('${props.user?['name']} ☀️')],
              ),
              p(
                className: 'font-bold text-[#555]',
                children: [Text('Good morning! Ready to build magical lessons?')],
              ),
            ],
          ),
          div(
            className: 'flex gap-2',
            children: [
              button(
                onClick: (_) => props.onNavigate('Builder'),
                className: 'h-[44px] px-5 bg-dark text-white rounded-full border-3 border-dark font-black shadow-[4px_4px_0px_#111] flex items-center gap-2',
                children: [
                  span(className: 'text-[18px]', children: [Text('+')]),
                  Text(' New Lesson'),
                ],
              ),
            ],
          ),
        ],
      ),
      div(
        children: [
          div(
            className: 'flex items-center gap-2 mb-3',
            children: [
              span(
                className: 'text-[20px] font-black flex items-center gap-2',
                style: {'fontFamily': 'Fredoka'},
                children: [Text('✨ Lesson Templates')],
              ),
              span(
                className: 'ml-auto text-[12px] font-black bg-dark text-white rounded-full px-3 py-1',
                children: [Text('${props.templates.length} templates')],
              ),
            ],
          ),
          div(
            className: 'grid md:grid-cols-2 lg:grid-cols-4 gap-4',
            children: [
              for (final t in props.templates)
                div(
                  key: t['id'] as String,
                  className: 'min-w-[300px] max-w-[320px] border-3 border-dark rounded-[24px] shadow-chunky-lg p-4 flex flex-col gap-3',
                  style: {'background': t['color'] as String},
                  children: [
                    if (t['badge'] != null)
                      span(
                        className: 'self-start bg-dark text-white text-[10px] font-black px-2.5 py-1 rounded-full tracking-widest',
                        children: [Text(t['badge'] as String)],
                      ),
                    h3(
                      className: 'font-black text-[18px] leading-tight',
                      children: [Text(t['title'] as String)],
                    ),
                    p(
                      className: 'text-[12px] font-bold text-[#333] leading-snug',
                      children: [Text(t['desc'] as String)],
                    ),
                    div(
                      className: 'flex items-center justify-between mt-auto',
                      children: [
                        span(
                          className: 'text-[11px] font-bold text-gray-500',
                          children: [Text(t['duration'] as String)],
                        ),
                        button(
                          onClick: (_) {
                            props.onNavigate('Builder');
                            props.onToast('Template loaded: ${t['title']} ✨');
                          },
                          className: 'h-[32px] px-4 bg-dark text-white rounded-full font-black text-[12px]',
                          children: [Text('Use')],
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
        children: [
          h3(
            className: 'font-black text-[18px] mb-4',
            style: {'fontFamily': 'Fredoka'},
            children: [Text('Recent Lessons')],
          ),
          div(
            className: 'space-y-3',
            children: [
              for (final l in props.lessons)
                div(
                  key: l['id'] as String,
                  onClick: (_) => props.onNavigate('Builder'),
                  className: 'bg-[#FFF4E0] border-2 border-dark rounded-[16px] p-3 flex items-center gap-3 cursor-pointer hover:shadow-[2px_2px_0px_#111] transition-shadow',
                  children: [
                    div(
                      className: 'w-[40px] h-[40px] bg-white border-2 border-dark rounded-[12px] grid place-items-center text-[20px]',
                      children: [Text('📚')],
                    ),
                    div(
                      className: 'flex-1',
                      children: [
                        span(
                          className: 'font-black text-[14px]',
                          children: [Text(l['title'] as String)],
                        ),
                        p(
                          className: 'text-[11px] font-bold text-gray-500',
                          children: [Text('${l['date']} • ${l['students']} students')],
                        ),
                      ],
                    ),
                    span(
                      className: 'font-black text-[12px] text-gray-400',
                      children: [Text('→')],
                    ),
                  ],
                ),
            ],
          ),
        ],
      ),
      div(
        children: [
          h3(
            className: 'font-black text-[18px]',
            style: {'fontFamily': 'Fredoka'},
            children: [Text('My Units')],
          ),
          div(
            className: 'grid md:grid-cols-3 gap-3',
            children: [
              for (final u in props.units)
                div(
                  key: u['id'] as String,
                  className: 'bg-white border-3 border-dark rounded-[20px] p-3 flex items-center gap-3',
                  children: [
                    span(className: 'text-[28px]', children: [Text(u['emoji'] as String)]),
                    div(
                      className: 'flex-1',
                      children: [
                        span(
                          className: 'font-black text-[13px]',
                          children: [Text(u['name'] as String)],
                        ),
                        p(
                          className: 'text-[11px] font-bold text-gray-400',
                          children: [Text('${u['resources']} resources')],
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