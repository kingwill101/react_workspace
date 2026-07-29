import 'dart:core';

import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/nullability_suffix.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

import '../model/model.dart';
import 'type_reader.dart';

final class ReactComponentReader {
  final ReactTypeReader typeReader;
  static const _checker = TypeChecker.fromUrl(
    'package:react/src/annotations.dart#ReactComponent',
  );

  const ReactComponentReader({required this.typeReader});

  ReactLibraryModel read(LibraryElement library, AssetId input) {
    final components = <ReactComponentModel>[];

    for (final annotated in LibraryReader(library).annotatedWith(_checker)) {
      final executable = annotated.element as ExecutableElement;

      if (executable.formalParameters.length != 1) {
        throw InvalidGenerationSourceError(
          '${executable.name} must accept exactly one record parameter.',
          element: executable,
        );
      }

      final parameter = executable.formalParameters.single;
      final record = parameter.type;

      if (record is! RecordType) {
        throw InvalidGenerationSourceError(
          '${executable.name} must accept a record parameter.',
          element: executable,
        );
      }

      if (record.positionalFields.isNotEmpty) {
        throw InvalidGenerationSourceError(
          '${executable.name} props must use named record fields.',
          element: executable,
        );
      }

      final name = executable.name!;

      components.add(
        ReactComponentModel(
          name: name,
          componentId: 'package:${input.package}/${input.path}#$name',
          returnType: typeReader.read(record),
          props: [
            for (final field in record.namedFields)
              ReactPropModel(
                name: field.name,
                type: typeReader.read(field.type),
                required:
                    field.type.nullabilitySuffix != NullabilitySuffix.question,
              ),
          ],
          propsRecord: typeReader.read(record),
        ),
      );
    }

    final inputFile = input.pathSegments.last;

    return ReactLibraryModel(
      inputFile: inputFile,
      reactFile: inputFile.replaceAll('.dart', '.react.dart'),
      components: components,
    );
  }
}
