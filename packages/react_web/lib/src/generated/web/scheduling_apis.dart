// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: scheduling-apis
// ignore_for_file: type=lint

import 'dom.dart';
import 'html.dart';
import 'package:react_web/src/web_runtime.dart';

typedef ContinuationPriority = String;

abstract interface class Scheduler {
  Future<Object> postTask(
    SchedulerPostTaskCallback callback, [
    SchedulerPostTaskOptions? options,
  ]);
}

typedef SchedulerPostTaskCallback = Object Function();

abstract interface class SchedulerPostTaskOptions {
  AbortSignal? get signal;
  set signal(AbortSignal? value);
  TaskPriority? get priority;
  set priority(TaskPriority? value);
  int? get delay;
  set delay(int? value);
}

final class SchedulerPostTaskOptionsValue implements SchedulerPostTaskOptions {
  @override
  AbortSignal? signal;
  @override
  TaskPriority? priority;
  @override
  int? delay;

  SchedulerPostTaskOptionsValue({this.signal, this.priority, this.delay});
}

typedef SchedulerSignalInherit = String;

abstract interface class SchedulerYieldOptions {
  Object? get signal;
  set signal(Object? value);
  ContinuationPriority? get priority;
  set priority(ContinuationPriority? value);
}

final class SchedulerYieldOptionsValue implements SchedulerYieldOptions {
  @override
  Object? signal;
  @override
  ContinuationPriority? priority;

  SchedulerYieldOptionsValue({this.signal, this.priority});
}

abstract interface class TaskController {
  factory TaskController([TaskControllerInit? init]) => WebRuntime.current
      .createWebObject<TaskController>('TaskController', [init]);
  void setPriority(TaskPriority priority);
}

abstract interface class TaskControllerInit {
  TaskPriority? get priority;
  set priority(TaskPriority? value);
}

final class TaskControllerInitValue implements TaskControllerInit {
  @override
  TaskPriority? priority;

  TaskControllerInitValue({this.priority});
}

typedef TaskPriority = String;

abstract interface class TaskPriorityChangeEvent {
  factory TaskPriorityChangeEvent(
    String type_,
    TaskPriorityChangeEventInit priorityChangeEventInitDict,
  ) => WebRuntime.current.createWebObject<TaskPriorityChangeEvent>(
    'TaskPriorityChangeEvent',
    [type_, priorityChangeEventInitDict],
  );
  TaskPriority get previousPriority;
}

abstract interface class TaskPriorityChangeEventInit {
  TaskPriority get previousPriority;
  set previousPriority(TaskPriority value);
}

final class TaskPriorityChangeEventInitValue
    implements TaskPriorityChangeEventInit {
  @override
  TaskPriority previousPriority;

  TaskPriorityChangeEventInitValue({required this.previousPriority});
}

abstract interface class TaskSignal {
  TaskPriority get priority;
  EventHandler get onprioritychange;
  set onprioritychange(EventHandler value);
}

abstract interface class TaskSignalAnyInit {
  Object? get priority;
  set priority(Object? value);
}

final class TaskSignalAnyInitValue implements TaskSignalAnyInit {
  @override
  Object? priority;

  TaskSignalAnyInitValue({this.priority});
}
