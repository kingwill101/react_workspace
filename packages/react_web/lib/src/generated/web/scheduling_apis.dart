// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: scheduling-apis
// ignore_for_file: constant_identifier_names, unnecessary_late, non_constant_identifier_names, unused_local_variable, camel_case_types, unused_import

import 'dom.dart';
import 'html.dart';
import 'package:react_web/src/web_runtime.dart';

typedef ContinuationPriority = String;

abstract interface class Scheduler {
  Future<Object> postTask(SchedulerPostTaskCallback callback, [SchedulerPostTaskOptions? options]);
}

typedef SchedulerPostTaskCallback = Object Function();

abstract interface class SchedulerPostTaskOptions {
  AbortSignal get signal;
  set signal(AbortSignal value);
  TaskPriority get priority;
  set priority(TaskPriority value);
  int get delay;
  set delay(int value);
}

typedef SchedulerSignalInherit = String;

abstract interface class SchedulerYieldOptions {
  Object get signal;
  set signal(Object value);
  ContinuationPriority get priority;
  set priority(ContinuationPriority value);
}

abstract interface class TaskController {
  factory TaskController([TaskControllerInit? init]) =>
      WebRuntime.current.createWebObject<TaskController>(
        'TaskController',
        [init],
      );
  void setPriority(TaskPriority priority);
}

abstract interface class TaskControllerInit {
  TaskPriority get priority;
  set priority(TaskPriority value);
}

typedef TaskPriority = String;

abstract interface class TaskPriorityChangeEvent {
  factory TaskPriorityChangeEvent(String type, TaskPriorityChangeEventInit priorityChangeEventInitDict) =>
      WebRuntime.current.createWebObject<TaskPriorityChangeEvent>(
        'TaskPriorityChangeEvent',
        [type, priorityChangeEventInitDict],
      );
  TaskPriority get previousPriority;
}

abstract interface class TaskPriorityChangeEventInit {
  TaskPriority get previousPriority;
  set previousPriority(TaskPriority value);
}

abstract interface class TaskSignal {
  TaskPriority get priority;
  EventHandler get onprioritychange;
   set onprioritychange(EventHandler value);
}

abstract interface class TaskSignalAnyInit {
  Object get priority;
  set priority(Object value);
}

