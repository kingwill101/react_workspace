/// Web host factories and utilities for React.
library;

export 'package:react/react.dart' hide div, button;

export 'src/generated/react_events.dart';
export 'src/generated/elements.dart'
    hide
        div,
        span,
        button,
        input,
        form,
        label,
        textarea,
        select,
        option,
        a,
        img;
export 'src/generated/dom.dart';
export 'src/generated/svg.dart';
export 'src/generated/web/web.dart'
    hide
        Text,
        EffectCallback,
        HTMLDivElement,
        HTMLSpanElement,
        HTMLButtonElement,
        HTMLInputElement,
        HTMLFormElement,
        HTMLLabelElement,
        HTMLTextAreaElement,
        HTMLSelectElement,
        HTMLOptionElement,
        HTMLAnchorElement,
        HTMLImageElement;
export 'src/generated/browser_adapter_stub.dart'
    if (dart.library.js_interop) 'src/generated/browser_adapter.dart'
    show registerBrowserAdapters, installBrowserWebRuntime;
export 'src/http_server_function_client.dart';
export 'src/props.dart';
export 'src/ssr_metadata.dart';
