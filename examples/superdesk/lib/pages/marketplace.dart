import 'package:react_web/react_web.dart';


@reactComponent
ReactNode MarketplacePage(({Function(String) onToast}) props) {
  final items = [
    {'name': 'Colors Bingo', 'author': 'Sarah M.', 'price': 'Free', 'badge': 'Popular', 'color': '#FFE8A3'},
    {'name': 'Verb Conjugation', 'author': 'Carlos R.', 'price': '\$2.99', 'badge': 'New', 'color': '#C8E8FF'},
    {'name': 'Food Vocabulary', 'author': 'Yuki T.', 'price': 'Free', 'badge': '', 'color': '#C8F5D4'},
    {'name': 'Travel Phrases', 'author': 'Marie L.', 'price': '\$1.99', 'badge': 'Premium', 'color': '#FFC9CE'},
  ];

  return div(
    className: 'space-y-5',
    children: [
      div(
        className: 'bg-white border-3 border-dark rounded-[28px] shadow-[6px_6px_0px_#111] p-5',
        children: [
          h4(
            className: 'font-black mb-4',
            style: {'fontFamily': 'Fredoka'},
            children: [Text('Lesson Marketplace')],
          ),
          div(
            className: 'grid md:grid-cols-2 lg:grid-cols-4 gap-4',
            children: [
              for (final item in items)
                div(
                  key: item['name'] as String,
                  className: 'bg-cream border-3 border-dark rounded-[20px] shadow-chunky p-4 flex flex-col gap-3',
                  style: {'background': item['color'] as String},
                  children: [
                    div(
                      className: 'flex items-center justify-between',
                      children: [
                        span(
                          className: 'font-black text-[14px]',
                          children: [Text(item['name'] as String)],
                        ),
                        if (item['badge'] != null && item['badge']!.isNotEmpty)
                          span(
                            className: 'text-[10px] font-black bg-white border-2 border-dark rounded-full px-2 py-0.5',
                            children: [Text(item['badge'] as String)],
                          ),
                      ],
                    ),
                    p(
                      className: 'text-[12px] font-bold text-gray-600',
                      children: [Text('by ${item['author']}')],
                    ),
                    div(
                      className: 'mt-auto flex items-center justify-between',
                      children: [
                        span(
                          className: 'font-black text-[16px]',
                          children: [Text(item['price'] as String)],
                        ),
                        button(
                          onClick: (_) => props.onToast('Cloned to library ✨'),
                          className: 'h-[32px] px-3 bg-white border-2 border-dark rounded-full font-black text-[11px] flex items-center gap-1',
                          children: [Text('Clone')],
                        ),
                        button(
                          onClick: (_) => props.onToast('Added to cart! 🛒'),
                          className: 'h-[32px] px-4 bg-dark text-white rounded-full font-black text-[12px]',
                          children: [Text('Add')],
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