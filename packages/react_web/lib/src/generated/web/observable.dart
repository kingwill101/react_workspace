// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: observable
// ignore_for_file: constant_identifier_names, unnecessary_late, non_constant_identifier_names, unused_local_variable, camel_case_types, unused_import

import 'webidl.dart';
import 'dom.dart';

typedef CatchCallback = Object Function(Object value,);

typedef Mapper = Object Function(Object value, int index,);

abstract interface class Observable {
  void subscribe([ObserverUnion? observer, SubscribeOptions? options]);
  Observable takeUntil(Object value);
  Observable map(Mapper mapper);
  Observable filter(Predicate predicate);
  Observable take(int amount);
  Observable drop(int amount);
  Observable flatMap(Mapper mapper);
  Observable switchMap(Mapper mapper);
  Observable inspect([ObservableInspectorUnion? inspectorUnion]);
  Observable catch_(CatchCallback callback);
  Observable finally_(VoidFunction callback);
  Future<List<Object>> toArray([SubscribeOptions? options]);
  Future<void> forEach(Visitor callback, [SubscribeOptions? options]);
  Future<bool> every(Predicate predicate, [SubscribeOptions? options]);
  Future<Object> first([SubscribeOptions? options]);
  Future<Object> last([SubscribeOptions? options]);
  Future<Object> find(Predicate predicate, [SubscribeOptions? options]);
  Future<bool> some(Predicate predicate, [SubscribeOptions? options]);
  Future<Object> reduce(Reducer reducer, [Object? initialValue, SubscribeOptions? options]);
}

abstract interface class ObservableEventListenerOptions {
  bool get capture;
  set capture(bool value);
  bool get passive;
  set passive(bool value);
}

abstract interface class ObservableInspector {
  ObservableSubscriptionCallback get next;
  set next(ObservableSubscriptionCallback value);
  ObservableSubscriptionCallback get error;
  set error(ObservableSubscriptionCallback value);
  VoidFunction get complete;
  set complete(VoidFunction value);
  VoidFunction get subscribe;
  set subscribe(VoidFunction value);
  ObservableInspectorAbortHandler get abort;
  set abort(ObservableInspectorAbortHandler value);
}

typedef ObservableInspectorAbortHandler = void Function(Object value,);

typedef ObservableInspectorUnion = Object;

typedef ObservableSubscriptionCallback = void Function(Object value,);

typedef ObserverUnion = Object;

typedef Predicate = bool Function(Object value, int index,);

typedef Reducer = Object Function(Object accumulator, Object currentValue, int index,);

typedef SubscribeCallback = void Function(Subscriber subscriber,);

abstract interface class SubscribeOptions {
  AbortSignal get signal;
  set signal(AbortSignal value);
}

abstract interface class Subscriber {
  void next(Object value);
  void error(Object error);
  void complete();
  void addTeardown(VoidFunction teardown);
  bool get active;
  AbortSignal get signal;
}

abstract interface class SubscriptionObserver {
  ObservableSubscriptionCallback get next;
  set next(ObservableSubscriptionCallback value);
  ObservableSubscriptionCallback get error;
  set error(ObservableSubscriptionCallback value);
  VoidFunction get complete;
  set complete(VoidFunction value);
}

typedef Visitor = void Function(Object value, int index,);

