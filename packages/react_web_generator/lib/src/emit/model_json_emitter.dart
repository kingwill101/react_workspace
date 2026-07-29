import 'dart:io';

import '../model/model.dart';

final class ModelJsonEmitter {
  final NeutralWebModel model;

  const ModelJsonEmitter(this.model);

  void writeTo(String outputPath) {
    final file = File(outputPath);
    file.createSync(recursive: true);
    file.writeAsStringSync(model.toJsonString());
  }
}
