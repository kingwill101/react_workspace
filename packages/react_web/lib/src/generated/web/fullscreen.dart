// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: fullscreen
// ignore_for_file: type=lint

typedef FullscreenNavigationUI = String;

abstract interface class FullscreenOptions {
  FullscreenNavigationUI? get navigationUI;
  set navigationUI(FullscreenNavigationUI? value);
  Object? get screen;
  set screen(Object? value);
}

final class FullscreenOptionsValue implements FullscreenOptions {
  @override
  FullscreenNavigationUI? navigationUI;
  @override
  Object? screen;

  FullscreenOptionsValue({this.navigationUI, this.screen});
}
