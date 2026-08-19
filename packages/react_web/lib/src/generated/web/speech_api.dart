// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: speech-api
// ignore_for_file: type=lint

import 'html.dart';
import 'dom.dart';
import 'package:react_web/src/web_runtime.dart';

abstract interface class SpeechRecognition {
  factory SpeechRecognition() => WebRuntime.current
      .createWebObject<SpeechRecognition>('SpeechRecognition', []);
  Object get grammars;
  set grammars(Object value);
  String get lang;
  set lang(String value);
  bool get continuous;
  set continuous(bool value);
  bool get interimResults;
  set interimResults(bool value);
  int get maxAlternatives;
  set maxAlternatives(int value);
  void start();
  void stop();
  void abort();
  EventHandler get onaudiostart;
  set onaudiostart(EventHandler value);
  EventHandler get onsoundstart;
  set onsoundstart(EventHandler value);
  EventHandler get onspeechstart;
  set onspeechstart(EventHandler value);
  EventHandler get onspeechend;
  set onspeechend(EventHandler value);
  EventHandler get onsoundend;
  set onsoundend(EventHandler value);
  EventHandler get onaudioend;
  set onaudioend(EventHandler value);
  EventHandler get onresult;
  set onresult(EventHandler value);
  EventHandler get onnomatch;
  set onnomatch(EventHandler value);
  EventHandler get onerror;
  set onerror(EventHandler value);
  EventHandler get onstart;
  set onstart(EventHandler value);
  EventHandler get onend;
  set onend(EventHandler value);
}

abstract interface class SpeechRecognitionAlternative {
  String get transcript;
  double get confidence;
}

typedef SpeechRecognitionErrorCode = String;

abstract interface class SpeechRecognitionErrorEvent {
  factory SpeechRecognitionErrorEvent(
    String type_,
    SpeechRecognitionErrorEventInit eventInitDict,
  ) => WebRuntime.current.createWebObject<SpeechRecognitionErrorEvent>(
    'SpeechRecognitionErrorEvent',
    [type_, eventInitDict],
  );
  SpeechRecognitionErrorCode get error;
  String get message;
}

abstract interface class SpeechRecognitionErrorEventInit {
  SpeechRecognitionErrorCode get error;
  set error(SpeechRecognitionErrorCode value);
  String? get message;
  set message(String? value);
}

final class SpeechRecognitionErrorEventInitValue
    implements SpeechRecognitionErrorEventInit {
  @override
  SpeechRecognitionErrorCode error;
  @override
  String? message;

  SpeechRecognitionErrorEventInitValue({required this.error, this.message});
}

abstract interface class SpeechRecognitionEvent {
  factory SpeechRecognitionEvent(
    String type_,
    SpeechRecognitionEventInit eventInitDict,
  ) => WebRuntime.current.createWebObject<SpeechRecognitionEvent>(
    'SpeechRecognitionEvent',
    [type_, eventInitDict],
  );
  int get resultIndex;
  SpeechRecognitionResultList get results;
}

abstract interface class SpeechRecognitionEventInit {
  int? get resultIndex;
  set resultIndex(int? value);
  SpeechRecognitionResultList get results;
  set results(SpeechRecognitionResultList value);
}

final class SpeechRecognitionEventInitValue
    implements SpeechRecognitionEventInit {
  @override
  int? resultIndex;
  @override
  SpeechRecognitionResultList results;

  SpeechRecognitionEventInitValue({this.resultIndex, required this.results});
}

abstract interface class SpeechRecognitionResult {
  int get length;
  SpeechRecognitionAlternative item(int index);
  bool get isFinal;
}

abstract interface class SpeechRecognitionResultList {
  int get length;
  SpeechRecognitionResult item(int index);
}

abstract interface class SpeechSynthesis {
  bool get pending;
  bool get speaking;
  bool get paused;
  EventHandler get onvoiceschanged;
  set onvoiceschanged(EventHandler value);
  void speak(SpeechSynthesisUtterance utterance);
  void cancel();
  void pause();
  void resume();
  List<SpeechSynthesisVoice> getVoices();
}

typedef SpeechSynthesisErrorCode = String;

abstract interface class SpeechSynthesisErrorEvent {
  factory SpeechSynthesisErrorEvent(
    String type_,
    SpeechSynthesisErrorEventInit eventInitDict,
  ) => WebRuntime.current.createWebObject<SpeechSynthesisErrorEvent>(
    'SpeechSynthesisErrorEvent',
    [type_, eventInitDict],
  );
  SpeechSynthesisErrorCode get error;
}

abstract interface class SpeechSynthesisErrorEventInit {
  SpeechSynthesisErrorCode get error;
  set error(SpeechSynthesisErrorCode value);
}

final class SpeechSynthesisErrorEventInitValue
    implements SpeechSynthesisErrorEventInit {
  @override
  SpeechSynthesisErrorCode error;

  SpeechSynthesisErrorEventInitValue({required this.error});
}

abstract interface class SpeechSynthesisEvent {
  factory SpeechSynthesisEvent(
    String type_,
    SpeechSynthesisEventInit eventInitDict,
  ) => WebRuntime.current.createWebObject<SpeechSynthesisEvent>(
    'SpeechSynthesisEvent',
    [type_, eventInitDict],
  );
  SpeechSynthesisUtterance get utterance;
  int get charIndex;
  int get charLength;
  double get elapsedTime;
  String get name;
}

abstract interface class SpeechSynthesisEventInit {
  SpeechSynthesisUtterance get utterance;
  set utterance(SpeechSynthesisUtterance value);
  int? get charIndex;
  set charIndex(int? value);
  int? get charLength;
  set charLength(int? value);
  double? get elapsedTime;
  set elapsedTime(double? value);
  String? get name;
  set name(String? value);
}

final class SpeechSynthesisEventInitValue implements SpeechSynthesisEventInit {
  @override
  SpeechSynthesisUtterance utterance;
  @override
  int? charIndex;
  @override
  int? charLength;
  @override
  double? elapsedTime;
  @override
  String? name;

  SpeechSynthesisEventInitValue({
    required this.utterance,
    this.charIndex,
    this.charLength,
    this.elapsedTime,
    this.name,
  });
}

abstract interface class SpeechSynthesisUtterance {
  factory SpeechSynthesisUtterance([String? text]) =>
      WebRuntime.current.createWebObject<SpeechSynthesisUtterance>(
        'SpeechSynthesisUtterance',
        [text],
      );
  String get text;
  set text(String value);
  String get lang;
  set lang(String value);
  SpeechSynthesisVoice? get voice;
  set voice(SpeechSynthesisVoice? value);
  double get volume;
  set volume(double value);
  double get rate;
  set rate(double value);
  double get pitch;
  set pitch(double value);
  EventHandler get onstart;
  set onstart(EventHandler value);
  EventHandler get onend;
  set onend(EventHandler value);
  EventHandler get onerror;
  set onerror(EventHandler value);
  EventHandler get onpause;
  set onpause(EventHandler value);
  EventHandler get onresume;
  set onresume(EventHandler value);
  EventHandler get onmark;
  set onmark(EventHandler value);
  EventHandler get onboundary;
  set onboundary(EventHandler value);
}

abstract interface class SpeechSynthesisVoice {
  String get voiceURI;
  String get name;
  String get lang;
  bool get localService;
  bool get default_;
}
