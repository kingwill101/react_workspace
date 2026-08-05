import 'package:react/react.dart';
import 'package:react_web/react_web.dart';

@reactComponent
ReactNode SettingsPage(({Map<String, dynamic>? user, Function() onLogout, Function() onReset}) props) {
  return div(
    className: 'space-y-5',
    children: [
      div(
        className: 'bg-white border-3 border-dark rounded-[28px] shadow-[6px_6px_0px_#111] p-5',
        children: [
          h4(
            className: 'font-black mb-4',
            style: {'fontFamily': 'Fredoka'},
            children: [Text('Settings')],
          ),
          div(
            className: 'space-y-4',
            children: [
              div(
                className: 'flex items-center justify-between',
                children: [
                  span(className: 'font-bold text-[14px]', children: [Text('Display Name')]),
                  input(
                    type: 'text',
                    value: props.user?['name'] ?? '',
                    className: 'h-[36px] px-3 bg-cream border-2 border-dark rounded-[12px] font-bold text-[13px] w-[200px]',
                  ),
                ],
              ),
              div(
                className: 'flex items-center justify-between',
                children: [
                  span(className: 'font-bold text-[14px]', children: [Text('Email')]),
                  span(className: 'text-[13px] font-bold text-gray-500', children: [Text(props.user?['email'] as String? ?? '—')]),
                ],
              ),
            ],
          ),
        ],
      ),
      div(
        className: 'bg-white border-3 border-dark rounded-[28px] shadow-[6px_6px_0px_#111] p-5',
        children: [
          h4(
            className: 'font-black mb-4',
            style: {'fontFamily': 'Fredoka'},
            children: [Text('Danger Zone')],
          ),
          div(
            className: 'space-y-3',
            children: [
              button(
                onClick: (_) => props.onLogout(),
                className: 'w-full h-[44px] bg-white border-3 border-dark rounded-full font-black text-[13px] hover:bg-cream transition-colors',
                children: [Text('Sign Out')],
              ),
              button(
                onClick: (_) => props.onReset(),
                className: 'w-full h-[44px] bg-[#FFC9CE] border-3 border-dark rounded-full font-black text-[13px] hover:bg-[#ffe0e0] transition-colors',
                children: [Text('Reset All Data')],
              ),
            ],
          ),
        ],
      ),
    ],
  );
}