import 'package:analyzer/dart/element/element.dart';
import 'package:build/src/builder/build_step.dart';
import 'package:source_gen/source_gen.dart';

import 'annotations.dart';
import 'model_visitor.dart';

class StringsObjectGenerator extends GeneratorForAnnotation<ModelGen>{
  @override
  generateForAnnotatedElement(Element element, ConstantReader annotation,
      BuildStep buildStep) {
    final visitor = ModelVisitor();
    element.visitChildren(visitor);
    final buffer = StringBuffer();
    buffer.writeln('part of \'strings.g.dart\';\n');
    buffer.writeln('\n');
    buffer.writeln('class String extends Translation {\n');
    buffer.writeln('\t@override\n');
    buffer.writeln('\tMap<String, Map<String, String>> get keys => {\n');
    buffer.writeln('\t};\n');
    buffer.writeln('}\n');
    return buffer.toString();
  }
}