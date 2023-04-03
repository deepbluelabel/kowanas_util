import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

import 'strings_object_generator.dart';

Builder stringsObjectBuilder(BuilderOptions options) => LibraryBuilder(
    StringsObjectGenerator(),
    generatedExtension: '.g.dart'
);
