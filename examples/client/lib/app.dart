import 'package:react_web/react_web.dart';

import 'shadcn.dart';

/// Root component — client-only, no server functions.
@reactComponent
ReactNode App(({String title}) props) {
  final (message, setMessage) = useState<String?>('Hello from the client');
  final (clicks, setClicks) = useState(0);
  final (language, setLanguage) = useState<String>('ar');
  final arabic = language == 'ar';
  final direction = arabic ? 'rtl' : 'ltr';
  final label = arabic ? 'التعليقات' : 'Feedback';
  final placeholder = arabic
      ? 'تعليقاتك تساعدنا على التحسين...'
      : 'Your feedback helps us improve...';
  final description = arabic
      ? 'شاركنا أفكارك حول الخدمة.'
      : 'Share your thoughts about our service.';

  return div(
    children: [
      shadcnCard(
        className: 'mx-auto mt-16 max-w-lg p-6',
        children: [
          h1(children: [Text(props.title)]),
          p(children: [Text(message!)]),
          p(children: [Text('Pressed $clicks times')]),
          shadcnField(
            className: 'mt-4 w-full max-w-xs',
            dir: direction,
            children: [
              shadcnFieldLabel(
                htmlFor: 'feedback',
                dir: direction,
                children: [Text(label)],
              ),
              shadcnTextarea(
                id: 'feedback',
                className: 'min-h-24',
                placeholder: placeholder,
                dir: direction,
                rows: 4,
              ),
              shadcnFieldDescription(
                dir: direction,
                children: [Text(description)],
              ),
            ],
          ),
          shadcnButton(
            size: 'lg',
            onClick: ReactCallback.zero(() {
              setClicks(clicks + 1);
              setMessage('The click was handled by Dart.');
              setLanguage(arabic ? 'en' : 'ar');
            }),
            children: [
              Text(arabic ? 'Switch to English' : 'التبديل إلى العربية'),
            ],
          ),
        ],
      ),
    ],
  );
}
