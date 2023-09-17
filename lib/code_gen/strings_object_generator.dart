import 'dart:convert';

import 'package:analyzer/dart/element/element.dart';
import 'package:build/src/builder/build_step.dart';
import 'package:kowanas_util/code_gen/translator/translator_google.dart';
import 'package:source_gen/source_gen.dart';

import 'annotations.dart';
import 'model_visitor.dart';
import 'translator/translation.dart';

class StringsObjectGenerator extends GeneratorForAnnotation<StringsGen>{
  @override
  generateForAnnotatedElement(Element element, ConstantReader annotation,
      BuildStep buildStep) async{
    final visitor = ModelVisitor();
    element.visitChildren(visitor);

    final accesskey = visitor.trFields['accessKey'].toStringValue();
    final baseLanguage = visitor.trFields['baseLanguage'].toStringValue();
    final allLanguages = visitor.trFields['allLanguages'].toBoolValue();
    final languages = visitor.trFields['languages'].toListValue().map((e) => e.toStringValue()).toList();
    final strings = visitor.trFields['strings'].toListValue().map((e) => e.toStringValue()).toList();
    final translator = TranslatorGoogle(accessKey:accesskey);
    if (allLanguages == true){
      languages.clear();
      languages.addAll(await translator.getLanguages());
    }

    final languagesWithoutEnglish = languages.where((e) => e != 'en');
    final translations = Map<String, Translation>();
    for (final language in languagesWithoutEnglish){
      final translation = Translation(language:language);
      translations[language] = translation;
      await translation.load();
      for (final String string in strings) {
        if (string.startsWith('_') == false) {
          var translated = translation.getCache(string);
          if (translated == null) {
            translated = await translator
                .translate(string, language, source:baseLanguage);
            translation.add(string, translated ?? string);
          }
        }
      }
      await translation.save();
    }

    final buffer = StringBuffer();
    buffer.writeln('part of \'strings.dart\';\n');
    buffer.writeln('\n');
    buffer.writeln('class _Translated {\n');
    buffer.writeln('\tstatic Map<String, Map<String, String>> get keys => {\n');
    for (final language in languages){
      buffer.writeln("\t\t\'${language}\' : {");
      final translation = translations[language];
      for (String string in strings){
        final translated = translation?.getCache(string) ?? string;
        if (string.startsWith('_'))
          string = string.substring(1);
        buffer.writeln("\t\t\t\'${string}\' : \'${translated}\',");
      }
      buffer.writeln("\t\t\},");
    }
    buffer.writeln('\t};\n');
    buffer.writeln('}\n');
    return buffer.toString();
  }
}