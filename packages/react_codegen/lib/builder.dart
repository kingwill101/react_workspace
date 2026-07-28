import 'package:build/build.dart';
import 'src/generator.dart';
import 'src/aggregate.dart';

Builder componentBuilder(BuilderOptions o) => ComponentBuilder();

/// Combining builder that reads all generated [.react.g.dart] files and
/// produces [react_components.g.dart] with a single [registerReactComponents]
/// function.
Builder aggregateBuilder(BuilderOptions o) => AggregateBuilder();