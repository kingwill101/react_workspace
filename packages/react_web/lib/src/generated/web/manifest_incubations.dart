// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: manifest-incubations
// ignore_for_file: type=lint

typedef AppBannerPromptOutcome = String;

abstract interface class PromptResponseObject {
  AppBannerPromptOutcome? get userChoice;
  set userChoice(AppBannerPromptOutcome? value);
}

final class PromptResponseObjectValue implements PromptResponseObject {
  @override
  AppBannerPromptOutcome? userChoice;

  PromptResponseObjectValue({this.userChoice});
}
