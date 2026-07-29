/// Web host factories for React.
///
/// Provides the generated Web IDL bindings for HTML elements, event types,
/// and refs.  Re-exports the core renderer-neutral API so web applications
/// normally need only this single import.
library react_web;

export 'package:react/react.dart';

export 'src/event_interfaces.dart';
export 'src/generated/elements.dart';
export 'src/types/html_interfaces.dart' hide Text, HTMLDivElement, HTMLSpanElement, HTMLButtonElement, HTMLInputElement, HTMLFormElement, HTMLLabelElement, HTMLTextAreaElement, HTMLSelectElement, HTMLOptionElement, HTMLAnchorElement, HTMLImageElement;
