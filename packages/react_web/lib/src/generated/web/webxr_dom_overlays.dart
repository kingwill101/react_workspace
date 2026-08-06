// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: webxr-dom-overlays
// ignore_for_file: constant_identifier_names, unnecessary_late, non_constant_identifier_names, unused_local_variable, camel_case_types, unused_import

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

