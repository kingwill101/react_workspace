import 'dart:convert';

import 'package:react/react.dart';
import 'package:react_web/react_web.dart';
import 'package:react_web/web.dart' show HTMLInputElement;

import 'pages/dashboard.dart';
import 'pages/resources.dart';
import 'pages/marketplace.dart';
import 'pages/syllabus.dart';
import 'pages/classes.dart';
import 'pages/builder.dart';
import 'pages/arcade.dart';
import 'pages/analytics.dart';
import 'pages/live_board.dart';
import 'pages/settings.dart';

final _appId = 'superdesk';

@reactComponent
ReactNode App(({String title}) props) {
  final (page, setPage) = useState<String>('Dashboard');
  final (user, setUser) = useState<Map<String, dynamic>?>(null);
  final (toast, setToast) = useState<String?>('');
  final (resources, setResources) = useState<List<Map<String, dynamic>>>([]);
  final (phases, setPhases) = useState<List<Map<String, dynamic>>>([]);
  final (lessonName, setLessonName) = useState<String>('');
  final (search, setSearch) = useState<String>('');
  final (filter, setFilter) = useState<String>('all');
  final (showNewRes, setShowNewRes) = useState<bool>(false);
  final (editingRes, setEditingRes) = useState<Map<String, dynamic>?>(null);
  final (expandedUnits, setExpandedUnits) = useState<List<String>>([]);
  final (selectedSyllabus, setSelectedSyllabus) = useState<String>('s1');
  final (arcadeGame, setArcadeGame) = useState<String>('wordpop');
  final (wordPopActive, setWordPopActive) = useState<bool>(false);
  final (score, setScore) = useState<int>(0);
  final (liveJoined, setLiveJoined) = useState<int>(1);
  final (liveCode, setLiveCode) = useState<String>('RIVERA');
  final (email, setEmail) = useState<String>('');
  final (password, setPassword) = useState<String>('');

  useEffect(() {
    final saved = window.localStorage.getItem('superdesk_user');
    if (saved != null) {
      setUser(jsonDecode(saved) as Map<String, dynamic>);
    }
    final savedResources = window.localStorage.getItem('superdesk_resources');
    if (savedResources != null) {
      setResources(List<Map<String, dynamic>>.from(
        (jsonDecode(savedResources) as List).map((e) => Map<String, dynamic>.from(e as Map)),
      ));
    }
    final savedPhases = window.localStorage.getItem('superdesk_phases');
    if (savedPhases != null) {
      setPhases(List<Map<String, dynamic>>.from(
        (jsonDecode(savedPhases) as List).map((e) => Map<String, dynamic>.from(e as Map)),
      ));
    }
  }, []);

  useEffect(() {
    if (user != null) {
      window.localStorage.setItem('superdesk_user', jsonEncode(user));
    }
  }, [user]);

  useEffect(() {
    window.localStorage.setItem('superdesk_resources', jsonEncode(resources));
  }, [resources]);

  useEffect(() {
    window.localStorage.setItem('superdesk_phases', jsonEncode(phases));
  }, [phases]);

  final liveJoinedRef = useRef<int>(0);
  useEffect(() {
    liveJoinedRef.current = liveJoined;
  }, [liveJoined]);

  final bc = useRef<BroadcastChannel?>(null);
  useEffect(() {
    final channel = BroadcastChannel('superdesk-live');
    channel.onmessage = (Event event) {
      final data = (event as dynamic).data;
      if (data == '{"type":"join"}') {
        setLiveJoined((liveJoinedRef.current ?? 0) + 1);
      }
      return event;
    };
    bc.current = channel;
    return () {
      bc.current?.close();
    };
  }, []);

  final pages = [
    'Dashboard', 'Resources', 'Marketplace', 'Syllabus', 'Classes',
    'Builder', 'Arcade', 'Analytics', 'Live Board', 'Settings',
  ];

  return html(
    lang: 'en',
    dir: 'ltr',
    style: {'fontFamily': 'Nunito, Fredoka, sans-serif'},
    children: [
      head(children: [
        meta(name: 'viewport', content: 'width=device-width, initial-scale=1.0'),
        title(children: [Text('SUPERDESK v6')]),
        link(href: 'https://fonts.googleapis.com/css2?family=Fredoka:wght@400;600;700&family=Nunito:wght@400;700;800;900&display=swap', rel: 'stylesheet'),
        link(rel: 'stylesheet', href: 'styles.css'),
      ]),
      body(children: [
        div(
          className: 'min-h-screen bg-cream text-dark',
          style: {'fontFamily': 'Nunito, Fredoka, sans-serif'},
          children: [
            if (user == null) ...[
              div(
                className: 'min-h-screen flex items-center justify-center p-4',
                style: {'backgroundColor': '#FFFBF0'},
                children: [
                  div(
                    className: 'w-full max-w-[420px] bg-white border-3 border-dark rounded-3xl shadow-chunky-lg p-8',
                    children: [
                      div(
                        className: 'text-center mb-8',
                        children: [
                          div(className: 'text-[48px] leading-none mb-3', children: [Text('☀️')]),
                          h1(
                            className: 'text-[32px] font-black tracking-tight',
                            style: {'fontFamily': 'Fredoka'},
                            children: [Text('SUPERDESK')],
                          ),
                          p(
                            className: 'text-[15px] font-bold text-gray-500 mt-1',
                            children: [Text('The Super Toolkit for Language Teachers')],
                          ),
                        ],
                      ),
                      form(
                        onSubmit: (e) {
                          e.preventDefault();
                          final name = email.isEmpty ? 'Rivera' : email.split('@').first;
                          setUser({'email': email, 'name': name});
                          setToast('Welcome back! ☀️');
                        },
                        children: [
                          input(
                            name: 'email',
                            value: email,
                            onChange: (e) => setEmail((e.target as HTMLInputElement).value),
                            required_: true,
                            placeholder: 'Email',
                            className: 'w-full h-[48px] px-4 bg-white border-2 border-dark rounded-[16px] font-bold outline-none focus:shadow-[3px_3px_0px_#111]',
                          ),
                          input(
                            name: 'password',
                            type: 'password',
                            value: password,
                            onChange: (e) => setPassword((e.target as HTMLInputElement).value),
                            required_: true,
                            placeholder: 'Password',
                            className: 'w-full h-[48px] px-4 bg-white border-2 border-dark rounded-[16px] font-bold outline-none focus:shadow-[3px_3px_0px_#111]',
                          ),
                          button(
                            type: 'submit',
                            className: 'w-full h-[52px] bg-dark text-white rounded-full font-black text-[16px] border-3 border-dark shadow-[0px_4px_0px_#111] active:translate-y-[2px] active:shadow-[0px_2px_0px_#111]',
                            children: [Text('Continue')],
                          ),
                          button(
                            type: 'button',
                            onClick: (_) {
                              setUser({'email': 'guest@superdesk', 'name': 'Rivera'});
                              setToast('Demo mode ☀️');
                            },
                            className: 'w-full h-[48px] bg-white border-3 border-dark rounded-full font-black',
                            children: [Text('Demo as Guest')],
                          ),
                        ],
                      ),
                      p(
                        className: 'text-center text-[12px] font-bold text-gray-400 mt-6',
                        children: [Text('Playful • Warm • Chunky • Teacher-friendly')],
                      ),
                    ],
                  ),
                ],
              ),
            ] else ...[
              div(className: 'min-h-screen bg-cream text-dark', children: [
                header(
                  className: 'sticky top-0 z-30 bg-cream/90 backdrop-blur-xl border-b-3 border-dark',
                  children: [
                    div(
                      className: 'max-w-[1280px] mx-auto px-4 md:px-6 h-[72px] flex items-center justify-between gap-4',
                      children: [
                        div(
                          className: 'flex items-center gap-3',
                          children: [
                            div(
                              className: 'w-[44px] h-[44px] bg-yellow-200 border-3 border-dark rounded-[14px] shadow-chunky grid place-items-center text-[20px]',
                              children: [Text('☀️')],
                            ),
                            div(
                              className: 'leading-tight',
                              children: [
                                div(
                                  className: 'font-black text-[20px]',
                                  style: {'fontFamily': 'Fredoka'},
                                  children: [Text('SUPERDESK')],
                                ),
                                div(
                                  className: 'text-[10px] font-black uppercase tracking-widest',
                                  children: [Text('v6 • Warm')],
                                ),
                              ],
                            ),
                          ],
                        ),
                        div(
                          className: 'hidden lg:flex items-center gap-2 overflow-x-auto',
                          children: [
                            for (final item in [
                              {'k': 'Dashboard', 'icon': 'bookmark'},
                              {'k': 'Resources', 'icon': 'book-open'},
                              {'k': 'Marketplace', 'icon': 'store'},
                              {'k': 'Syllabus', 'icon': 'layers'},
                              {'k': 'Classes', 'icon': 'users'},
                              {'k': 'Builder', 'icon': 'hammer'},
                              {'k': 'Arcade', 'icon': 'gamepad'},
                              {'k': 'Analytics', 'icon': 'bar-chart-3'},
                              {'k': 'Live Board', 'icon': 'monitor'},
                            ])
                              button(
                                key: item['k'],
                                onClick: (_) => setPage(item['k'] as String),
                                className: 'h-[40px] px-4 rounded-full border-2.5 border-dark font-black text-[13px] flex items-center gap-1.5 whitespace-nowrap transition-all ${page == item['k'] ? "bg-dark text-white shadow-[3px_3px_0px_#111]" : "bg-white hover:shadow-[3px_3px_0px_#111]"}',
                                children: [Text(item['k'] as String)],
                              ),
                          ],
                        ),
                        div(
                          className: 'flex items-center gap-2',
                          children: [
                            div(
                              className: 'hidden md:flex items-center gap-2 bg-white border-2.5 border-dark rounded-full h-[40px] px-3 shadow-[3px_3px_0px_#111]',
                              children: [
                                span(className: 'text-[16px]', children: [Text('🔍')]),
                                input(
                                  value: search,
                                  onChange: (e) => setSearch((e.target as HTMLInputElement).value),
                                  placeholder: 'Search...',
                                  className: 'bg-transparent outline-none w-[100px] font-bold text-[13px]',
                                ),
                              ],
                            ),
                            div(
                              className: 'w-[40px] h-[40px] rounded-full bg-pink-200 border-3 border-dark grid place-items-center font-black',
                              children: [Text('R')],
                            ),
                          ],
                        ),
                      ],
                    ),
                    div(
                      className: 'lg:hidden px-3 pb-3 flex gap-2 overflow-x-auto scrollbar-none',
                      children: [
                        for (final k in ['Dashboard','Resources','Marketplace','Syllabus','Classes','Builder','Arcade','Analytics','Live Board'])
                          button(
                            key: k,
                            onClick: (_) => setPage(k),
                            className: 'h-[36px] px-4 rounded-full border-2 border-dark font-black text-[12px] whitespace-nowrap ${page == k ? "bg-dark text-white" : "bg-white"}',
                            children: [Text(k)],
                          ),
                      ],
                    ),
                  ],
                ),
                main(
                  className: 'max-w-[1280px] mx-auto px-4 md:px-6 py-6',
                  children: [
                    if (page == 'Dashboard') DashboardPage((
                      user: user,
                      templates: _templates,
                      lessons: _lessons,
                      units: _units,
                      onNavigate: setPage.call,
                      onToast: setToast.call,
                    )),
                    if (page == 'Resources') ResourcesPage((
                      resources: resources,
                      search: search,
                      filter: filter,
                      onFilter: setFilter.call,
                      onSearch: setSearch.call,
                      onAdd: () => setShowNewRes(true),
                      onEdit: (r) => setEditingRes(r),
                      onDelete: (r) => setResources(resources.where((x) => x['id'] != r['id']).toList()),
                      onDuplicate: (r) => setResources([...resources, {...r, 'id': 'r${DateTime.now().millisecondsSinceEpoch}', 'name': '${r['name']} Copy'}]),
                      onToast: setToast.call,
                    )),
                    if (page == 'Marketplace') MarketplacePage((onToast: setToast.call)),
                    if (page == 'Syllabus') SyllabusPage((
                      selectedSyllabus: selectedSyllabus,
                      onSelect: setSelectedSyllabus.call,
                      expandedUnits: expandedUnits,
                      onToggle: (id) => setExpandedUnits(expandedUnits.contains(id) ? expandedUnits.where((x) => x != id).toList() : [...expandedUnits, id]),
                      onToast: setToast.call,
                    )),
                    if (page == 'Classes') ClassesPage((onToast: setToast.call)),
                    if (page == 'Builder') BuilderPage((
                      lessonName: lessonName,
                      onLessonName: setLessonName.call,
                      phases: phases,
                      onPhases: setPhases.call,
                      resources: resources,
                      templates: _templates,
                      onToast: setToast.call,
                    )),
                    if (page == 'Arcade') ArcadePage((
                      arcadeGame: arcadeGame,
                      onGame: setArcadeGame.call,
                      wordPopActive: wordPopActive,
                      onWordPop: setWordPopActive.call,
                      score: score,
                      onScore: setScore.call,
                      onToast: setToast.call,
                    )),
                    if (page == 'Analytics') AnalyticsPage((title: null)),
                    if (page == 'Live Board') LiveBoardPage((
                      phases: phases,
                      liveJoined: liveJoined,
                      liveCode: liveCode,
                      onJoin: () {
                        BroadcastChannel('superdesk-live').postMessage(jsonEncode({'type': 'join'}));
                        setToast('Simulated join in other tab – open duplicate tab!');
                      },
                      onToast: setToast.call,
                    )),
                    if (page == 'Settings') SettingsPage((
                      user: user,
                      onLogout: () {
                        setUser(null);
                        window.localStorage.removeItem('superdesk_user');
                      },
                      onReset: () {
                        window.localStorage.clear();
                        window.location.reload();
                      },
                    )),
                  ],
                ),
                if (toast != null)
                  div(
                    className: 'fixed bottom-6 left-1/2 -translate-x-1/2 bg-dark text-white px-5 py-3 rounded-full font-black text-[13px] shadow-[4px_4px_0px_#FFC9CE] z-50 border-2 border-white',
                    children: [Text(toast)],
                  ),
              ]),
            ],
          ],
        ),
      ]),
    ],
  );
}

final _templates = [
  {'id': 't1', 'title': 'Colors Bingo', 'desc': 'Students identify and match colors in a fun bingo format.', 'duration': '15 min', 'badge': 'Popular', 'color': '#FFE8A3'},
  {'id': 't2', 'title': 'Vocabulary Flashcards', 'desc': 'Quick vocabulary review with image cards.', 'duration': '10 min', 'badge': 'Quick', 'color': '#C8F5D4'},
  {'id': 't3', 'title': 'Story Builder', 'desc': 'Collaborative story creation with vocabulary prompts.', 'duration': '25 min', 'badge': 'Creative', 'color': '#FFC9CE'},
  {'id': 't4', 'title': 'Listen & Repeat', 'desc': 'Audio pronunciation practice with shadow reading.', 'duration': '12 min', 'badge': 'Audio', 'color': '#C8E8FF'},
];

final _lessons = [
  {'id': 'l1', 'title': 'Colors and Shapes', 'date': 'Today', 'students': 24},
  {'id': 'l2', 'title': 'Animals Vocabulary', 'date': 'Yesterday', 'students': 22},
  {'id': 'l3', 'title': 'Family Members', 'date': 'Mon', 'students': 25},
];

final _units = [
  {'id': 'u1', 'name': 'Unit 1: Greetings', 'emoji': '👋', 'resources': 8, 'color': '#FFE8A3', 'syllabusId': 's1', 'parentId': null},
  {'id': 'u2', 'name': 'Unit 2: Colors', 'emoji': '🎨', 'resources': 12, 'color': '#C8F5D4', 'syllabusId': 's1', 'parentId': null},
  {'id': 'u3', 'name': 'Unit 3: Animals', 'emoji': '🐾', 'resources': 10, 'color': '#FFC9CE', 'syllabusId': 's1', 'parentId': null},
  {'id': 'u4', 'name': 'Sub: Pets', 'emoji': '🐱', 'resources': 4, 'color': '#FFF4E0', 'syllabusId': 's1', 'parentId': 'u2'},
  {'id': 'u5', 'name': 'Sub: Farm Animals', 'emoji': '🐄', 'resources': 3, 'color': '#FFF4E0', 'syllabusId': 's1', 'parentId': 'u2'},
];

final _syllabuses = [
  {'id': 's1', 'name': 'Fall Semester', 'color': '#FFE8A3'},
  {'id': 's2', 'name': 'Spring Semester', 'color': '#C8F5D4'},
];

final _classes = [
  {'id': 'c1', 'name': 'Grade 1A', 'color': '#FFE8A3', 'students': [
    {'id': 's1', 'name': 'Alice'}, {'id': 's2', 'name': 'Bob'}, {'id': 's3', 'name': 'Carlos'},
  ]},
  {'id': 'c2', 'name': 'Grade 1B', 'color': '#C8F5D4', 'students': [
    {'id': 's4', 'name': 'Diana'}, {'id': 's5', 'name': 'Ethan'},
  ]},
];