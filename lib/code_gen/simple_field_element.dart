import 'package:analyzer/dart/element/element.dart';

class SimpleFieldElement{
  final String name;
  final String elementType;
  final List<ElementAnnotation> metadatas;
  bool isFinal = false;
  bool isTypical = true;
  bool isEnum = false;
  bool isComparator = false;

  SimpleFieldElement(this.name, this.elementType, this.metadatas){
    for (final metadata in this.metadatas){
      if (metadata.element!.name == 'generated') isTypical = false;
      else if (metadata.element!.name == 'enumulated'){
        isTypical = false;
        isEnum = true;
      }
      else if (metadata.element!.name == 'fixed') isFinal = true;
      else if (metadata.element!.name == 'comparator') isComparator = true;
    }
  }
}