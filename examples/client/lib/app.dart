import 'package:react_web/react_web.dart';

import 'shadcn.dart';

/// Root component — client-only, no server functions.
@reactComponent
ReactNode App(({String title}) props) {
  final message = useStateController<String?>('Hello from the client');
  final clicks = useStateController(0);
  final language = useStateController<String>('ar');
  final arabic = language.value == 'ar';
  final direction = arabic ? 'rtl' : 'ltr';
  final label = arabic ? 'التعليقات' : 'Feedback';
  final placeholder = arabic
      ? 'تعليقاتك تساعدنا على التحسين...'
      : 'Your feedback helps us improve...';
  final description = arabic
      ? 'شاركنا أفكارك حول الخدمة.'
      : 'Share your thoughts about our service.';
  final feedbackField = shadcnTextareaProps()
    ..id = 'feedback'
    ..className = 'min-h-24'
    ..placeholder = placeholder
    ..dir = direction
    ..rows = 4;

  return div(
    children: [
      shadcnCard(
        className: 'mx-auto mt-16 max-w-lg p-6',
        children: [
          h1(children: [Text(props.title)]),
          p(children: [Text(message.value!)]),
          p(children: [Text('Pressed ${clicks.value} times')]),
          shadcnField(
            className: 'mt-4 w-full max-w-xs',
            dir: direction,
            children: [
              shadcnFieldLabel(
                htmlFor: 'feedback',
                dir: direction,
                children: [Text(label)],
              ),
              feedbackField(),
              shadcnFieldDescription(
                dir: direction,
                children: [Text(description)],
              ),
            ],
          ),
          shadcnButton(
            size: 'lg',
            onClick: ReactCallback.zero(() {
              clicks.set(clicks.value + 1);
              message.set('The click was handled by Dart.');
              language.set(arabic ? 'en' : 'ar');
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
