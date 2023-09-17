abstract class Model{
  static const String UNDEFINED_VALUE = 'undefined';
  static const int UNDEFINED_VALUE_INT = -1;

  String getUniqueKey();
}

class Field{
  final String type;
  final String name;
  final bool required;
  final bool primary;

  Field(this.type, this.name, this.required, this.primary);
}