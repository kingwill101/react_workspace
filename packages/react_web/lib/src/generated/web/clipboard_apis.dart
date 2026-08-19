// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: clipboard-apis
// ignore_for_file: type=lint

import 'html.dart';
import 'dom.dart';
import 'fileapi.dart';
import 'permissions.dart';
import 'package:react_web/src/web_runtime.dart';

abstract interface class Clipboard {
  Future<ClipboardItems> read([ClipboardUnsanitizedFormats? formats]);
  Future<String> readText();
  Future<void> write(ClipboardItems data);
  Future<void> writeText(String data);
}

abstract interface class ClipboardEvent {
  factory ClipboardEvent(String type_, [ClipboardEventInit? eventInitDict]) =>
      WebRuntime.current.createWebObject<ClipboardEvent>('ClipboardEvent', [
        type_,
        eventInitDict,
      ]);
  DataTransfer? get clipboardData;
}

abstract interface class ClipboardEventInit {
  DataTransfer? get clipboardData;
  set clipboardData(DataTransfer? value);
}

final class ClipboardEventInitValue implements ClipboardEventInit {
  @override
  DataTransfer? clipboardData;

  ClipboardEventInitValue({this.clipboardData});
}

abstract interface class ClipboardItem {
  factory ClipboardItem(
    Map<String, ClipboardItemData> items, [
    ClipboardItemOptions? options,
  ]) => WebRuntime.current.createWebObject<ClipboardItem>('ClipboardItem', [
    items,
    options,
  ]);
  PresentationStyle get presentationStyle;
  List<String> get types;
  Future<Blob> getType(String type_);
}

typedef ClipboardItemData = Future<Object>;

abstract interface class ClipboardItemOptions {
  PresentationStyle? get presentationStyle;
  set presentationStyle(PresentationStyle? value);
}

final class ClipboardItemOptionsValue implements ClipboardItemOptions {
  @override
  PresentationStyle? presentationStyle;

  ClipboardItemOptionsValue({this.presentationStyle});
}

typedef ClipboardItems = List<ClipboardItem>;

abstract interface class ClipboardPermissionDescriptor {
  bool? get allowWithoutGesture;
  set allowWithoutGesture(bool? value);
}

final class ClipboardPermissionDescriptorValue
    implements ClipboardPermissionDescriptor {
  @override
  bool? allowWithoutGesture;

  ClipboardPermissionDescriptorValue({this.allowWithoutGesture});
}

abstract interface class ClipboardUnsanitizedFormats {
  List<String>? get unsanitized;
  set unsanitized(List<String>? value);
}

final class ClipboardUnsanitizedFormatsValue
    implements ClipboardUnsanitizedFormats {
  @override
  List<String>? unsanitized;

  ClipboardUnsanitizedFormatsValue({this.unsanitized});
}

typedef PresentationStyle = String;
