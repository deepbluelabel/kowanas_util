
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/visitor.dart';

import 'simple_field_element.dart';

class ModelVisitor extends SimpleElementVisitor<void>{
  late String className;
  final fields = <String, SimpleFieldElement>{};

  @override
  void visitConstructorElement(ConstructorElement element){
    className = element.type.returnType.toString().replaceFirst('*', '');
    for (final ParameterElement e in element.parameters){
      if (e.isNamed == false) continue;
      fields[e.name] = SimpleFieldElement(e.name, e.type.toString(), e.metadata);
    }
  }
}