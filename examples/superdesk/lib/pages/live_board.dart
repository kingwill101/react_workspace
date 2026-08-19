import 'package:react_web/react_web.dart';

@reactComponent
ReactNode LiveBoardPage(
  ({
    List<Map<String, dynamic>> phases,
    int liveJoined,
    String liveCode,
    Function(String) onToast,
    Function() onJoin,
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
            children: [Text('Live Board')],
          ),
          div(
            className: 'flex items-center gap-3 mb-4',
            children: [
              span(
                className: 'text-[14px] font-bold',
                children: [Text('Room Code:')],
              ),
              span(
                className:
                    'bg-dark text-white px-3 py-1 rounded-full font-black text-[14px]',
                children: [Text(props.liveCode)],
              ),
              span(
                className: 'text-[12px] font-bold text-gray-500',
                children: [Text('${props.liveJoined} joined')],
              ),
              button(
                onClick: (_) => props.onJoin(),
                className:
                    'h-[32px] px-3 bg-pink-200 border-2 border-dark rounded-full font-black text-[11px]',
                children: [Text('Simulate Join (new tab)')],
              ),
            ],
          ),
          div(
            className: 'grid grid-cols-2 md:grid-cols-3 gap-3',
            children: [
              for (final phase in props.phases)
                div(
                  key: phase['id'] as String,
                  className:
                      'bg-cream border-3 border-dark rounded-[16px] p-4 text-center',
                  children: [
                    span(
                      className: 'text-[24px]',
                      children: [Text(phase['emoji'] as String? ?? '📋')],
                    ),
                    p(
                      className: 'font-black text-[13px] mt-1',
                      children: [Text(phase['name'] as String? ?? 'Phase')],
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
