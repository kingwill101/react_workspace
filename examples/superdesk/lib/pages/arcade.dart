import 'package:react_web/react_web.dart';
import 'package:react_web/web.dart' show HTMLSelectElement;

@reactComponent
ReactNode ArcadePage(
  ({
    String arcadeGame,
    Function(String) onGame,
    bool wordPopActive,
    Function(bool) onWordPop,
    int score,
    Function(int) onScore,
    Function(String) onToast,
  })
  props,
) {
  final carouselCards = [
    {'emoji': '🔴', 'es': 'rojo', 'en': 'red', 'color': '#FFC9CE'},
    {'emoji': '🔵', 'es': 'azul', 'en': 'blue', 'color': '#C8E8FF'},
    {'emoji': '🟡', 'es': 'amarillo', 'en': 'yellow', 'color': '#FFE8A3'},
    {'emoji': '🟢', 'es': 'verde', 'en': 'green', 'color': '#C8F5D4'},
  ];

  return div(
    className: 'space-y-5',
    children: [
      div(
        className:
            'bg-white border-3 border-dark rounded-[28px] shadow-[6px_6px_0px_#111] p-4 flex flex-wrap gap-3 items-center justify-between',
        children: [
          h2(
            className: 'font-black text-[20px] flex items-center gap-2',
            style: {'fontFamily': 'Fredoka'},
            children: [const Text('🎮 Arcade • 3D + Mini-Games')],
          ),
          div(
            className: 'flex gap-2',
            children: [
              select(
                value: props.arcadeGame,
                onChange: (e) =>
                    props.onGame((e.target as HTMLSelectElement).value),
                className:
                    'h-[40px] bg-cream border-3 border-dark rounded-full px-3 font-black text-[12px]',
                children: [
                  option(value: 'wordpop', children: [const Text('Word Pop')]),
                  option(
                    value: 'carousel',
                    children: [const Text('3D Carousel')],
                  ),
                  option(value: 'memory', children: [const Text('Memory 3D')]),
                ],
              ),
              select(
                className:
                    'h-[40px] bg-white border-2 border-dark rounded-full px-3 font-black text-[12px]',
                children: [
                  option(value: 'easy', children: [const Text('Easy')]),
                  option(value: 'medium', children: [const Text('Medium')]),
                  option(value: 'hard', children: [const Text('Hard')]),
                ],
              ),
              button(
                onClick: (_) {
                  props.onWordPop(!props.wordPopActive);
                  if (!props.wordPopActive) props.onScore(0);
                },
                className:
                    'h-[36px] px-4 rounded-full border-2 border-dark font-black text-[12px] ${props.wordPopActive ? "bg-[#FFC9CE]" : "bg-dark text-white"}',
                children: [Text(props.wordPopActive ? '⏸ Pause' : '▶ Play')],
              ),
            ],
          ),
        ],
      ),
      if (props.arcadeGame == 'carousel')
        div(
          className:
              'bg-white border-3 border-dark rounded-[28px] shadow-[6px_6px_0px_#111] p-5',
          children: [
            div(
              className: 'flex items-center justify-between mb-4',
              children: [
                h3(
                  className: 'font-black text-[18px]',
                  style: {'fontFamily': 'Fredoka'},
                  children: [const Text('🎠 3D Vocab Carousel')],
                ),
                span(
                  className:
                      'text-[11px] font-black bg-[#FFE8A3] border-2 border-dark rounded-full px-3 py-1',
                  children: [const Text('Tap a card to hear pronunciation')],
                ),
              ],
            ),
            div(
              className:
                  'grid sm:grid-cols-2 md:grid-cols-4 gap-4 p-4 bg-cream border-3 border-dark rounded-[24px]',
              children: [
                for (final card in carouselCards)
                  div(
                    key: card['es'] as String,
                    onClick: (_) => props.onToast(
                      'Selected: ${card['es']} • ${card['en']} ${card['emoji']}',
                    ),
                    className:
                        'border-3 border-dark rounded-[20px] p-4 flex flex-col items-center justify-center gap-2 cursor-pointer shadow-chunky hover:scale-105 transition-transform',
                    style: {'background': card['color'] as String},
                    children: [
                      span(
                        className: 'text-[44px]',
                        children: [Text(card['emoji'] as String)],
                      ),
                      span(
                        className: 'font-black text-[18px]',
                        children: [Text(card['es'] as String)],
                      ),
                      span(
                        className: 'font-bold text-[13px] text-gray-600',
                        children: [Text(card['en'] as String)],
                      ),
                    ],
                  ),
              ],
            ),
          ],
        )
      else
        div(
          className: 'grid lg:grid-cols-[1.2fr_0.8fr] gap-4',
          children: [
            div(
              className:
                  'bg-white border-3 border-dark rounded-[28px] shadow-[6px_6px_0px_#111] p-3 overflow-hidden',
              children: [
                div(
                  className: 'flex items-center justify-between px-2 py-2',
                  children: [
                    span(
                      className: 'font-black',
                      children: [Text('Word Pop 🎈 Score: ${props.score}')],
                    ),
                  ],
                ),
                canvas(
                  ref: null,
                  width: 640,
                  height: 420,
                  className:
                      'w-full bg-cream border-3 border-dark rounded-[20px] touch-none',
                  style: {'touchAction': 'none'},
                ),
                p(
                  className: 'text-[11px] font-bold text-[#666] mt-2 px-2',
                  children: [
                    const Text('Tap balloons that match the target word!'),
                  ],
                ),
              ],
            ),
            div(
              className: 'space-y-3',
              children: [
                for (final name in ['Word Pop', '3D Carousel', 'Memory Match'])
                  div(
                    key: name,
                    className:
                        'bg-cream border-3 border-dark rounded-[24px] shadow-[4px_4px_0px_#111] p-4 opacity-70',
                    children: [
                      div(
                        className: 'font-black text-[14px]',
                        children: [Text('$name • Coming Soon')],
                      ),
                      p(
                        className: 'text-[11px] font-bold text-[#666] mt-1',
                        children: [
                          const Text(
                            'Chunky 3D cards, warm neobrutalist style, Promethean-ready',
                          ),
                        ],
                      ),
                      div(
                        className:
                            'mt-3 h-[80px] bg-white border-2 border-dark rounded-[16px] grid place-items-center font-black text-[24px]',
                        children: [const Text('🔒')],
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
