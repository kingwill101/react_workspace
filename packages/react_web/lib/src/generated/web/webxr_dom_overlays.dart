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
  XRDOMOverlayType? get type_;
  set type_(XRDOMOverlayType? value);
}

final class XRDOMOverlayStateValue implements XRDOMOverlayState {
  @override
  XRDOMOverlayType? type_;

  XRDOMOverlayStateValue({
    this.type_,
  });
}

typedef XRDOMOverlayType = String;

