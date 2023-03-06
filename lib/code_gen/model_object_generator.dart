
import 'package:analyzer/dart/element/element.dart';
import 'package:build/src/builder/build_step.dart';
import 'package:source_gen/source_gen.dart';

import 'annotations.dart';
import 'model_visitor.dart';

class ModelObjectGenerator extends GeneratorForAnnotation<ModelGen>{
  @override
  generateForAnnotatedElement(Element element, ConstantReader annotation,
      BuildStep buildStep) {
    final visitor = ModelVisitor();
    element.visitChildren(visitor);
    final buffer = StringBuffer();
    // define part of
    buffer.writeln(''); // new line
    buffer.writeln("part of '${visitor.className.toLowerCase()}.dart';");

    // write class
    buffer.writeln(''); // new line
    buffer.writeln("abstract class _${visitor.className} extends Model{");

    // write fields
    for (final field in visitor.fields.entries){
      if (field.value.isFinal)
        buffer.writeln("\tfinal ${field.value.elementType} ${field.key};");
      else
        buffer.writeln("\t${field.value.elementType} ${field.key};");
    }

    // write constructor
    buffer.writeln(''); // new line
    buffer.writeln("\t_${visitor.className}({");
    for (final field in visitor.fields.entries)
      buffer.writeln("\t\trequired this.${field.key},");
    buffer.writeln("\t});");

    // write toJson
    buffer.writeln(''); // new line
    buffer.writeln("\tMap<String, dynamic> toJson(){");
    buffer.writeln("\t\treturn {");
    for (final field in visitor.fields.entries){
      if (field.value.isTypical)
        buffer.writeln("\t\t\t'${field.key}':${field.key},");
      else if (field.value.isEnum)
        buffer.writeln("\t\t\t'${field.key}':${field.key}.index,");
      else
        buffer.writeln("\t\t\t'${field.key}':${field.key}.toJson(),");
    }
    buffer.writeln("\t\t};"); // for return
    buffer.writeln("\t}"); // for toJson function

    // write operator ==
    buffer.writeln(''); // new line
    buffer.writeln("\t@override");
    buffer.writeln("\tbool operator ==(Object other){");
    buffer.writeln("\t\tif(identical(this, other)) return true;");
    buffer.writeln("\t\tif(other.runtimeType != runtimeType) return false;");
    buffer.writeln("\t\treturn other is ${visitor.className}");
    for (final field in visitor.fields.entries){
      if (field.value.isComparator)
        buffer.writeln("\t\t\t&& other.${field.key} == ${field.key}");
    }
    buffer.writeln("\t;"); // for return
    buffer.writeln("\t}"); // for operator == function

    // write getUniqueKey
    buffer.writeln(''); // new Line
    buffer.writeln("\tString getUniqueKey(){");
    buffer.writeln("\t\treturn ");
    for (final field in visitor.fields.entries){
      if (field.value.isComparator)
        if (field.value.isTypical)
          buffer.writeln("\t\t\t${field.key}.toString() + '_' +");
        else
          buffer.writeln("\t\t\t${field.key}.getUniqueKey() + '_' +");
    }
    buffer.writeln("\t\t\t'';");
    buffer.writeln("\t}"); // for getUniqueKey

    buffer.writeln("}"); // for class

    // write FromJson
    buffer.writeln(''); // new line
    buffer.writeln("_${visitor.className}FromJson(json){");
    buffer.writeln("\treturn ${visitor.className}(");
    for (final field in visitor.fields.entries){
      if (field.value.isTypical)
        buffer.writeln("\t\t${field.key}:json['${field.key}'],");
      else if (field.value.isEnum)
        buffer.writeln("\t\t${field.key}:"+
            "${field.value.elementType}.values[json['${field.key}']],");
      else
        buffer.writeln("\t\t${field.key}:"+
            "${field.value.elementType}.fromJson(json['${field.key}']),");
    }
    buffer.writeln("\t);"); // for return
    buffer.writeln("}"); // from fromJson function

    // write FromClient
    buffer.writeln(''); // new line
    buffer.writeln("_${visitor.className}FromClient(json){");
    buffer.writeln('\tfinal ${visitor.className.toLowerCase()} = ${visitor.className}(');
    for (final field in visitor.fields.entries){
      if (field.value.isFinal)
        buffer.writeln('\t\t${field.key}: json[\'${field.key}\'],');
    }
    buffer.writeln('\t);');
    buffer.writeln(''); // new line

    for (final field in visitor.fields.entries){
      if (field.value.isFinal == false)
        buffer.writeln('\t\tif (json[\'${field.key}\'] != null) ${visitor.className.toLowerCase()}.${field.key} = json[\'${field.key}\'];');
    }

    buffer.writeln("\treturn ${visitor.className.toLowerCase()};"); // for return
    buffer.writeln("}"); // from fromJson function
    return buffer.toString();
  }
}