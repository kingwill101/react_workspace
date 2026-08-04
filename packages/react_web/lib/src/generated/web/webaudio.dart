// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: webaudio
// ignore_for_file: constant_identifier_names, unnecessary_late, non_constant_identifier_names, unused_local_variable, camel_case_types, unused_import

import 'html.dart';
import 'audio_output.dart';
import 'mediacapture_streams.dart';
import 'capture_handle_identity.dart';
import 'dom.dart';
import 'hr_time.dart';
import 'webidl.dart';

abstract interface class AnalyserNode {
  void getFloatFrequencyData(Object array);
  void getByteFrequencyData(Object array);
  void getFloatTimeDomainData(Object array);
  void getByteTimeDomainData(Object array);
  int get fftSize;
   set fftSize(int value);
  int get frequencyBinCount;
  double get minDecibels;
   set minDecibels(double value);
  double get maxDecibels;
   set maxDecibels(double value);
  double get smoothingTimeConstant;
   set smoothingTimeConstant(double value);
}

abstract interface class AnalyserOptions {
  int get fftSize;
  set fftSize(int value);
  double get maxDecibels;
  set maxDecibels(double value);
  double get minDecibels;
  set minDecibels(double value);
  double get smoothingTimeConstant;
  set smoothingTimeConstant(double value);
}

abstract interface class AudioBuffer {
  double get sampleRate;
  int get length;
  double get duration;
  int get numberOfChannels;
  Object getChannelData(int channel);
  void copyFromChannel(Object destination, int channelNumber, [int? bufferOffset]);
  void copyToChannel(Object source, int channelNumber, [int? bufferOffset]);
}

abstract interface class AudioBufferOptions {
  int get numberOfChannels;
  set numberOfChannels(int value);
  int get length;
  set length(int value);
  double get sampleRate;
  set sampleRate(double value);
}

abstract interface class AudioBufferSourceNode {
  AudioBuffer? get buffer;
   set buffer(AudioBuffer? value);
  AudioParam get playbackRate;
  AudioParam get detune;
  bool get loop;
   set loop(bool value);
  double get loopStart;
   set loopStart(double value);
  double get loopEnd;
   set loopEnd(double value);
  void start([double? when_, double? offset, double? duration]);
}

abstract interface class AudioBufferSourceOptions {
  AudioBuffer? get buffer;
  set buffer(AudioBuffer? value);
  double get detune;
  set detune(double value);
  bool get loop;
  set loop(bool value);
  double get loopEnd;
  set loopEnd(double value);
  double get loopStart;
  set loopStart(double value);
  double get playbackRate;
  set playbackRate(double value);
}

abstract interface class AudioContext {
  double get baseLatency;
  double get outputLatency;
  Object get sinkId;
  AudioRenderCapacity get renderCapacity;
  EventHandler get onsinkchange;
   set onsinkchange(EventHandler value);
  EventHandler get onerror;
   set onerror(EventHandler value);
  AudioTimestamp getOutputTimestamp();
  Future<void> resume();
  Future<void> suspend();
  Future<void> close();
  Future<void> setSinkId(Object sinkId);
  MediaElementAudioSourceNode createMediaElementSource(HTMLMediaElement mediaElement);
  MediaStreamAudioSourceNode createMediaStreamSource(MediaStream mediaStream);
  MediaStreamTrackAudioSourceNode createMediaStreamTrackSource(MediaStreamTrack mediaStreamTrack);
  MediaStreamAudioDestinationNode createMediaStreamDestination();
}

typedef AudioContextLatencyCategory = String;

abstract interface class AudioContextOptions {
  Object get latencyHint;
  set latencyHint(Object value);
  double get sampleRate;
  set sampleRate(double value);
  Object get sinkId;
  set sinkId(Object value);
  Object get renderSizeHint;
  set renderSizeHint(Object value);
}

typedef AudioContextRenderSizeCategory = String;

typedef AudioContextState = String;

abstract interface class AudioDestinationNode {
  int get maxChannelCount;
}

abstract interface class AudioListener {
  AudioParam get positionX;
  AudioParam get positionY;
  AudioParam get positionZ;
  AudioParam get forwardX;
  AudioParam get forwardY;
  AudioParam get forwardZ;
  AudioParam get upX;
  AudioParam get upY;
  AudioParam get upZ;
  void setPosition(double x, double y, double z);
  void setOrientation(double x, double y, double z, double xUp, double yUp, double zUp);
}

abstract interface class AudioNode {
  AudioNode connect(AudioNode destinationNode, [int? output, int? input]);
  void disconnect(AudioNode destinationNode, int output, int input);
  BaseAudioContext get context;
  int get numberOfInputs;
  int get numberOfOutputs;
  int get channelCount;
   set channelCount(int value);
  ChannelCountMode get channelCountMode;
   set channelCountMode(ChannelCountMode value);
  ChannelInterpretation get channelInterpretation;
   set channelInterpretation(ChannelInterpretation value);
}

abstract interface class AudioNodeOptions {
  int get channelCount;
  set channelCount(int value);
  ChannelCountMode get channelCountMode;
  set channelCountMode(ChannelCountMode value);
  ChannelInterpretation get channelInterpretation;
  set channelInterpretation(ChannelInterpretation value);
}

abstract interface class AudioParam {
  double get value;
   set value(double value);
  AutomationRate get automationRate;
   set automationRate(AutomationRate value);
  double get defaultValue;
  double get minValue;
  double get maxValue;
  AudioParam setValueAtTime(double value, double startTime);
  AudioParam linearRampToValueAtTime(double value, double endTime);
  AudioParam exponentialRampToValueAtTime(double value, double endTime);
  AudioParam setTargetAtTime(double target, double startTime, double timeConstant);
  AudioParam setValueCurveAtTime(List<double> values, double startTime, double duration);
  AudioParam cancelScheduledValues(double cancelTime);
  AudioParam cancelAndHoldAtTime(double cancelTime);
}

abstract interface class AudioParamDescriptor {
  String get name;
  set name(String value);
  double get defaultValue;
  set defaultValue(double value);
  double get minValue;
  set minValue(double value);
  double get maxValue;
  set maxValue(double value);
  AutomationRate get automationRate;
  set automationRate(AutomationRate value);
}

abstract interface class AudioParamMap {
   Iterable<String> get keys;
   Iterable<AudioParam> get values;
   Iterable<MapEntry<String, AudioParam>> get entries;
   AudioParam? operator [](Object key);
   bool has(Object key);
}

abstract interface class AudioProcessingEvent {
  double get playbackTime;
  AudioBuffer get inputBuffer;
  AudioBuffer get outputBuffer;
}

abstract interface class AudioProcessingEventInit {
  double get playbackTime;
  set playbackTime(double value);
  AudioBuffer get inputBuffer;
  set inputBuffer(AudioBuffer value);
  AudioBuffer get outputBuffer;
  set outputBuffer(AudioBuffer value);
}

abstract interface class AudioRenderCapacity {
  void start([AudioRenderCapacityOptions? options]);
  void stop();
  EventHandler get onupdate;
   set onupdate(EventHandler value);
}

abstract interface class AudioRenderCapacityEvent {
  double get timestamp;
  double get averageLoad;
  double get peakLoad;
  double get underrunRatio;
}

abstract interface class AudioRenderCapacityEventInit {
  double get timestamp;
  set timestamp(double value);
  double get averageLoad;
  set averageLoad(double value);
  double get peakLoad;
  set peakLoad(double value);
  double get underrunRatio;
  set underrunRatio(double value);
}

abstract interface class AudioRenderCapacityOptions {
  double get updateInterval;
  set updateInterval(double value);
}

abstract interface class AudioScheduledSourceNode {
  EventHandler get onended;
   set onended(EventHandler value);
  void start([double? when_]);
  void stop([double? when_]);
}

abstract interface class AudioSinkInfo {
  AudioSinkType get type;
}

abstract interface class AudioSinkOptions {
  AudioSinkType get type;
  set type(AudioSinkType value);
}

typedef AudioSinkType = String;

abstract interface class AudioTimestamp {
  double get contextTime;
  set contextTime(double value);
  DOMHighResTimeStamp get performanceTime;
  set performanceTime(DOMHighResTimeStamp value);
}

abstract interface class AudioWorklet {
  MessagePort get port;
}

abstract interface class AudioWorkletGlobalScope {
  void registerProcessor(String name, AudioWorkletProcessorConstructor processorCtor);
  int get currentFrame;
  double get currentTime;
  double get sampleRate;
  int get renderQuantumSize;
  MessagePort get port;
}

abstract interface class AudioWorkletNode {
  AudioParamMap get parameters;
  MessagePort get port;
  EventHandler get onprocessorerror;
   set onprocessorerror(EventHandler value);
}

abstract interface class AudioWorkletNodeOptions {
  int get numberOfInputs;
  set numberOfInputs(int value);
  int get numberOfOutputs;
  set numberOfOutputs(int value);
  List<int> get outputChannelCount;
  set outputChannelCount(List<int> value);
  Map<String, double> get parameterData;
  set parameterData(Map<String, double> value);
  Object get processorOptions;
  set processorOptions(Object value);
}

typedef AudioWorkletProcessCallback = bool Function(List<List<Object>> inputs, List<List<Object>> outputs, Object parameters,);

abstract interface class AudioWorkletProcessor {
  MessagePort get port;
}

typedef AudioWorkletProcessorConstructor = AudioWorkletProcessor Function(Object options,);

typedef AutomationRate = String;

abstract interface class BaseAudioContext {
  AudioDestinationNode get destination;
  double get sampleRate;
  double get currentTime;
  AudioListener get listener;
  AudioContextState get state;
  int get renderQuantumSize;
  AudioWorklet get audioWorklet;
  EventHandler get onstatechange;
   set onstatechange(EventHandler value);
  AnalyserNode createAnalyser();
  BiquadFilterNode createBiquadFilter();
  AudioBuffer createBuffer(int numberOfChannels, int length, double sampleRate);
  AudioBufferSourceNode createBufferSource();
  ChannelMergerNode createChannelMerger([int? numberOfInputs]);
  ChannelSplitterNode createChannelSplitter([int? numberOfOutputs]);
  ConstantSourceNode createConstantSource();
  ConvolverNode createConvolver();
  DelayNode createDelay([double? maxDelayTime]);
  DynamicsCompressorNode createDynamicsCompressor();
  GainNode createGain();
  IIRFilterNode createIIRFilter(List<double> feedforward, List<double> feedback);
  OscillatorNode createOscillator();
  PannerNode createPanner();
  PeriodicWave createPeriodicWave(List<double> real, List<double> imag, [PeriodicWaveConstraints? constraints]);
  ScriptProcessorNode createScriptProcessor([int? bufferSize, int? numberOfInputChannels, int? numberOfOutputChannels]);
  StereoPannerNode createStereoPanner();
  WaveShaperNode createWaveShaper();
  Future<AudioBuffer> decodeAudioData(Object audioData, [DecodeSuccessCallback? successCallback, DecodeErrorCallback? errorCallback]);
}

abstract interface class BiquadFilterNode {
  BiquadFilterType get type;
   set type(BiquadFilterType value);
  AudioParam get frequency;
  AudioParam get detune;
  AudioParam get Q;
  AudioParam get gain;
  void getFrequencyResponse(Object frequencyHz, Object magResponse, Object phaseResponse);
}

abstract interface class BiquadFilterOptions {
  BiquadFilterType get type;
  set type(BiquadFilterType value);
  double get Q;
  set Q(double value);
  double get detune;
  set detune(double value);
  double get frequency;
  set frequency(double value);
  double get gain;
  set gain(double value);
}

typedef BiquadFilterType = String;

typedef ChannelCountMode = String;

typedef ChannelInterpretation = String;

abstract interface class ChannelMergerNode {
}

abstract interface class ChannelMergerOptions {
  int get numberOfInputs;
  set numberOfInputs(int value);
}

abstract interface class ChannelSplitterNode {
}

abstract interface class ChannelSplitterOptions {
  int get numberOfOutputs;
  set numberOfOutputs(int value);
}

abstract interface class ConstantSourceNode {
  AudioParam get offset;
}

abstract interface class ConstantSourceOptions {
  double get offset;
  set offset(double value);
}

abstract interface class ConvolverNode {
  AudioBuffer? get buffer;
   set buffer(AudioBuffer? value);
  bool get normalize;
   set normalize(bool value);
}

abstract interface class ConvolverOptions {
  AudioBuffer? get buffer;
  set buffer(AudioBuffer? value);
  bool get disableNormalization;
  set disableNormalization(bool value);
}

typedef DecodeErrorCallback = void Function(DOMException error,);

typedef DecodeSuccessCallback = void Function(AudioBuffer decodedData,);

abstract interface class DelayNode {
  AudioParam get delayTime;
}

abstract interface class DelayOptions {
  double get maxDelayTime;
  set maxDelayTime(double value);
  double get delayTime;
  set delayTime(double value);
}

typedef DistanceModelType = String;

abstract interface class DynamicsCompressorNode {
  AudioParam get threshold;
  AudioParam get knee;
  AudioParam get ratio;
  double get reduction;
  AudioParam get attack;
  AudioParam get release;
}

abstract interface class DynamicsCompressorOptions {
  double get attack;
  set attack(double value);
  double get knee;
  set knee(double value);
  double get ratio;
  set ratio(double value);
  double get release;
  set release(double value);
  double get threshold;
  set threshold(double value);
}

abstract interface class GainNode {
  AudioParam get gain;
}

abstract interface class GainOptions {
  double get gain;
  set gain(double value);
}

abstract interface class IIRFilterNode {
  void getFrequencyResponse(Object frequencyHz, Object magResponse, Object phaseResponse);
}

abstract interface class IIRFilterOptions {
  List<double> get feedforward;
  set feedforward(List<double> value);
  List<double> get feedback;
  set feedback(List<double> value);
}

abstract interface class MediaElementAudioSourceNode {
  HTMLMediaElement get mediaElement;
}

abstract interface class MediaElementAudioSourceOptions {
  HTMLMediaElement get mediaElement;
  set mediaElement(HTMLMediaElement value);
}

abstract interface class MediaStreamAudioDestinationNode {
  MediaStream get stream;
}

abstract interface class MediaStreamAudioSourceNode {
  MediaStream get mediaStream;
}

abstract interface class MediaStreamAudioSourceOptions {
  MediaStream get mediaStream;
  set mediaStream(MediaStream value);
}

abstract interface class MediaStreamTrackAudioSourceNode {
}

abstract interface class MediaStreamTrackAudioSourceOptions {
  MediaStreamTrack get mediaStreamTrack;
  set mediaStreamTrack(MediaStreamTrack value);
}

abstract interface class OfflineAudioCompletionEvent {
  AudioBuffer get renderedBuffer;
}

abstract interface class OfflineAudioCompletionEventInit {
  AudioBuffer get renderedBuffer;
  set renderedBuffer(AudioBuffer value);
}

abstract interface class OfflineAudioContext {
  Future<AudioBuffer> startRendering();
  Future<void> resume();
  Future<void> suspend(double suspendTime);
  int get length;
  EventHandler get oncomplete;
   set oncomplete(EventHandler value);
}

abstract interface class OfflineAudioContextOptions {
  int get numberOfChannels;
  set numberOfChannels(int value);
  int get length;
  set length(int value);
  double get sampleRate;
  set sampleRate(double value);
  Object get renderSizeHint;
  set renderSizeHint(Object value);
}

abstract interface class OscillatorNode {
  OscillatorType get type;
   set type(OscillatorType value);
  AudioParam get frequency;
  AudioParam get detune;
  void setPeriodicWave(PeriodicWave periodicWave);
}

abstract interface class OscillatorOptions {
  OscillatorType get type;
  set type(OscillatorType value);
  double get frequency;
  set frequency(double value);
  double get detune;
  set detune(double value);
  PeriodicWave get periodicWave;
  set periodicWave(PeriodicWave value);
}

typedef OscillatorType = String;

typedef OverSampleType = String;

abstract interface class PannerNode {
  PanningModelType get panningModel;
   set panningModel(PanningModelType value);
  AudioParam get positionX;
  AudioParam get positionY;
  AudioParam get positionZ;
  AudioParam get orientationX;
  AudioParam get orientationY;
  AudioParam get orientationZ;
  DistanceModelType get distanceModel;
   set distanceModel(DistanceModelType value);
  double get refDistance;
   set refDistance(double value);
  double get maxDistance;
   set maxDistance(double value);
  double get rolloffFactor;
   set rolloffFactor(double value);
  double get coneInnerAngle;
   set coneInnerAngle(double value);
  double get coneOuterAngle;
   set coneOuterAngle(double value);
  double get coneOuterGain;
   set coneOuterGain(double value);
  void setPosition(double x, double y, double z);
  void setOrientation(double x, double y, double z);
}

abstract interface class PannerOptions {
  PanningModelType get panningModel;
  set panningModel(PanningModelType value);
  DistanceModelType get distanceModel;
  set distanceModel(DistanceModelType value);
  double get positionX;
  set positionX(double value);
  double get positionY;
  set positionY(double value);
  double get positionZ;
  set positionZ(double value);
  double get orientationX;
  set orientationX(double value);
  double get orientationY;
  set orientationY(double value);
  double get orientationZ;
  set orientationZ(double value);
  double get refDistance;
  set refDistance(double value);
  double get maxDistance;
  set maxDistance(double value);
  double get rolloffFactor;
  set rolloffFactor(double value);
  double get coneInnerAngle;
  set coneInnerAngle(double value);
  double get coneOuterAngle;
  set coneOuterAngle(double value);
  double get coneOuterGain;
  set coneOuterGain(double value);
}

typedef PanningModelType = String;

abstract interface class PeriodicWave {
}

abstract interface class PeriodicWaveConstraints {
  bool get disableNormalization;
  set disableNormalization(bool value);
}

abstract interface class PeriodicWaveOptions {
  List<double> get real;
  set real(List<double> value);
  List<double> get imag;
  set imag(List<double> value);
}

abstract interface class ScriptProcessorNode {
  EventHandler get onaudioprocess;
   set onaudioprocess(EventHandler value);
  int get bufferSize;
}

abstract interface class StereoPannerNode {
  AudioParam get pan;
}

abstract interface class StereoPannerOptions {
  double get pan;
  set pan(double value);
}

abstract interface class WaveShaperNode {
  Object get curve;
   set curve(Object value);
  OverSampleType get oversample;
   set oversample(OverSampleType value);
}

abstract interface class WaveShaperOptions {
  List<double> get curve;
  set curve(List<double> value);
  OverSampleType get oversample;
  set oversample(OverSampleType value);
}

