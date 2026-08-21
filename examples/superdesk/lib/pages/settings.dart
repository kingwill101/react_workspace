import 'package:react_web/react_web.dart';
import 'package:react_web/web.dart'
    show HTMLInputElement, FileReader, Event, Blob;

@reactComponent
ReactNode SettingsPage(
  ({
    Map<String, dynamic>? user,
    Function() onLogout,
    Function() onReset,
    Function() onExport,
    Function(String) onImport,
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
            children: [const Text('Settings')],
          ),
          div(
            className: 'space-y-4',
            children: [
              div(
                className: 'flex items-center justify-between',
                children: [
                  span(
                    className: 'font-bold text-[14px]',
                    children: [const Text('Display Name')],
                  ),
                  input(
                    type: 'text',
                    value: props.user?['name'] ?? '',
                    className:
                        'h-[36px] px-3 bg-cream border-2 border-dark rounded-[12px] font-bold text-[13px] w-[200px]',
                  ),
                ],
              ),
              div(
                className: 'flex items-center justify-between',
                children: [
                  span(
                    className: 'font-bold text-[14px]',
                    children: [const Text('Email')],
                  ),
                  span(
                    className: 'text-[13px] font-bold text-gray-500',
                    children: [Text(props.user?['email'] as String? ?? '—')],
                  ),
                ],
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
            children: [const Text('💾 Data Backup & Restore')],
          ),
          div(
            className: 'space-y-3',
            children: [
              button(
                onClick: (_) => props.onExport(),
                className:
                    'w-full h-[44px] bg-cream border-3 border-dark rounded-full font-black text-[13px] hover:bg-[#ffe8a3] transition-colors',
                children: [const Text('📥 Export Settings JSON')],
              ),
              label(
                className:
                    'w-full h-[44px] bg-cream border-3 border-dark rounded-full font-black text-[13px] hover:bg-[#c8f5d4] transition-colors flex items-center justify-center cursor-pointer',
                children: [
                  const Text('📤 Import Settings JSON'),
                  input(
                    type: 'file',
                    accept: '.json',
                    className: 'hidden',
                    onChange: (e) {
                      final files = (e.target as HTMLInputElement).files;
                      if (files != null && files.length > 0) {
                        final file = files.item(0)!;
                        final reader = FileReader();
                        reader.onloadend = (Event event) {
                          final result = reader.result.toString();
                          if (result.isNotEmpty) {
                            props.onImport(result);
                          }
                          return event;
                        };
                        reader.readAsText(file as Blob);
                      }
                    },
                  ),
                ],
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
            children: [const Text('Danger Zone')],
          ),
          div(
            className: 'space-y-3',
            children: [
              button(
                onClick: (_) => props.onLogout(),
                className:
                    'w-full h-[44px] bg-white border-3 border-dark rounded-full font-black text-[13px] hover:bg-cream transition-colors',
                children: [const Text('Sign Out')],
              ),
              button(
                onClick: (_) => props.onReset(),
                className:
                    'w-full h-[44px] bg-[#FFC9CE] border-3 border-dark rounded-full font-black text-[13px] hover:bg-[#ffe0e0] transition-colors',
                children: [const Text('Reset All Data')],
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
