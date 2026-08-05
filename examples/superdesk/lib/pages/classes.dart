import 'package:react_web/react_web.dart';


@reactComponent
ReactNode ClassesPage(({Function(String) onToast}) props) {
  final classes = [
    {'id': 'c1', 'name': 'Grade 1A', 'color': '#FFE8A3', 'students': [
      {'id': 's1', 'name': 'Alice'}, {'id': 's2', 'name': 'Bob'}, {'id': 's3', 'name': 'Carlos'},
    ]},
    {'id': 'c2', 'name': 'Grade 1B', 'color': '#C8F5D4', 'students': [
      {'id': 's4', 'name': 'Diana'}, {'id': 's5', 'name': 'Ethan'},
    ]},
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
            children: [Text('My Classes')],
          ),
          div(
            className: 'grid md:grid-cols-2 gap-4',
            children: [
              for (final cls in classes)
                div(
                  key: cls['id'] as String,
                  className: 'border-3 border-dark rounded-[20px] shadow-chunky p-4',
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
                          className: 'text-[12px] font-bold bg-white border-2 border-dark rounded-full px-2 py-0.5',
                          children: [Text('${(cls['students'] as List).length} students')],
                        ),
                      ],
                    ),
                    div(
                      className: 'flex flex-wrap gap-2',
                      children: [
                        for (final s in cls['students'] as List)
                          span(
                            className: 'text-[12px] font-bold bg-white border-2 border-dark rounded-full px-2 py-1',
                            children: [Text(s['name'] as String)],
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