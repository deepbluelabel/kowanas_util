import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

import 'model_object_generator.dart';

Builder modelObjectBuilder(BuilderOptions options) => LibraryBuilder(
  ModelObjectGenerator(),
  generatedExtension: '.g.dart'
);