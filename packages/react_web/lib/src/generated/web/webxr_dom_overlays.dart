// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: webxr-dom-overlays
// ignore_for_file: type=lint

import 'css_nav.dart';

abstract interface class XRDOMOverlayInit {
  Element get root;
  set root(Element value);
}

final class XRDOMOverlayInitValue implements XRDOMOverlayInit {
  @override
  Element root;

  XRDOMOverlayInitValue({
    required this.root,
  });
}

abstract interface class XRDOMOverlayState {
  XRDOMOverlayType? get type;
  set type(XRDOMOverlayType? value);
}

final class XRDOMOverlayStateValue implements XRDOMOverlayState {
  @override
  XRDOMOverlayType? type;

  XRDOMOverlayStateValue({
    this.type,
  });
}

typedef XRDOMOverlayType = String;

