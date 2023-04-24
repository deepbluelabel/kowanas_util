import 'package:analyzer/dart/constant/value.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/visitor.dart';
import 'package:source_gen/source_gen.dart';

import 'simple_field_element.dart';

class ModelVisitor extends SimpleElementVisitor<void>{
  late String className;
  final fields = <String, SimpleFieldElement>{};
  final trFields = <String, dynamic>{};

  @override
  void visitFieldElement(FieldElement element) {
    final value = element.computeConstantValue();
    trFields[element.name] = element.computeConstantValue();
  }

  @override
  void visitConstructorElement(ConstructorElement element){
    className = element.type.returnType.toString().replaceFirst('*', '');
    for (final ParameterElement e in element.parameters){
      if (e.isNamed == false) continue;
      fields[e.name] = SimpleFieldElement(e.name, e.type.toString(), e.metadata);
    }
  }
}