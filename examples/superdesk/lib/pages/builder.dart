import 'package:react_web/react_web.dart';
import 'package:react_web/web.dart' show HTMLInputElement;

@reactComponent
ReactNode BuilderPage(
  ({
    String lessonName,
    Function(String) onLessonName,
    List<Map<String, dynamic>> phases,
    Function(List<Map<String, dynamic>>) onPhases,
    List<Map<String, dynamic>> resources,
    List<Map<String, dynamic>> templates,
    Function(String) onToast,
  })
  props,
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
            children: [const Text('Lesson Builder')],
          ),
          input(
            value: props.lessonName,
            onChange: (e) =>
                props.onLessonName((e.target as HTMLInputElement).value),
            placeholder: 'Lesson name...',
            className:
                'w-full h-[44px] px-4 bg-cream border-3 border-dark rounded-[16px] font-bold text-[15px] outline-none focus:shadow-[3px_3px_0px_#111]',
          ),
          div(
            className: 'mt-4 space-y-3',
            children: [
              for (final t in props.templates)
                div(
                  key: t['id'] as String,
                  className:
                      'flex items-center gap-3 p-3 bg-cream border-2 border-dark rounded-[12px] cursor-pointer hover:shadow-[2px_2px_0px_#111] transition-shadow',
                  onClick: (_) {
                    props.onPhases([
                      ...props.phases,
                      {'id': t['id'], 'title': t['title'], 'resources': []},
                    ]);
                    props.onToast('Template loaded: ${t['title']} ✨');
                  },
                  children: [
                    div(
                      className:
                          'w-[40px] h-[40px] rounded-[12px] grid place-items-center text-[18px]',
                      style: {'background': t['color'] as String},
                      children: [const Text('📝')],
                    ),
                    div(
                      className: 'flex-1',
                      children: [
                        span(
                          className: 'font-black text-[13px]',
                          children: [Text(t['title'] as String)],
                        ),
                        p(
                          className: 'text-[11px] font-bold text-gray-500',
                          children: [Text(t['desc'] as String)],
                        ),
                      ],
                    ),
                    span(
                      className: 'text-[11px] font-bold text-gray-400',
                      children: [Text(t['duration'] as String)],
                    ),
                  ],
                ),
            ],
          ),
          button(
            onClick: (_) => props.onToast('AI phases added ✨'),
            className:
                'w-full h-[40px] px-4 bg-cream border-2 border-dark rounded-full font-black text-[12px] flex items-center justify-center gap-2',
            children: [const Text('✨ AI Suggest Phases')],
          ),
          if (props.phases.isNotEmpty) ...[
            h5(
              className: 'font-black mt-6 mb-3',
              style: {'fontFamily': 'Fredoka'},
              children: [Text('Phases (${props.phases.length})')],
            ),
            div(
              className: 'space-y-2',
              children: [
                for (final phase in props.phases)
                  div(
                    key: phase['id'] as String,
                    className:
                        'flex items-center gap-3 p-3 bg-white border-2 border-dark rounded-[12px]',
                    children: [
                      span(
                        className: 'font-black text-[14px]',
                        children: [const Text('📋')],
                      ),
                      span(
                        className: 'flex-1 font-bold text-[13px]',
                        children: [Text(phase['title'] as String)],
                      ),
                      span(
                        className: 'text-[11px] font-bold text-gray-400',
                        children: [
                          Text(
                            '${(phase['resources'] as List).length} resources',
                          ),
                        ],
                      ),
                      button(
                        onClick: (_) {
                          props.onPhases(
                            props.phases
                                .where((p) => p['id'] != phase['id'])
                                .toList(),
                          );
                        },
                        className:
                            'w-[28px] h-[28px] bg-cream border-2 border-dark rounded-full font-black text-[12px]',
                        children: [const Text('✕')],
                      ),
                    ],
                  ),
              ],
            ),
          ],
        ],
      ),
    ],
  );
}
