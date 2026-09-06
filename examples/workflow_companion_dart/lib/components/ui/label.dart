import 'package:react_dom/react_dom.dart';

import '../../utils.dart';

/// An accessible form label.
ReactNode uiLabel({required String text, String? htmlFor, String? className}) =>
    label(
      htmlFor: htmlFor,
      className: cn([
        'text-sm font-medium leading-none peer-disabled:cursor-not-allowed peer-disabled:opacity-70',
        className,
      ]),
      children: [Text(text)],
    );
