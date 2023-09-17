import 'package:sqflite/sqflite.dart';

import '../../model.dart';
import '../kowanas_db.dart';

class SqlliteDB<T> extends KowanasDB{
  final bool _DEBUG = true;
  final List<Field> fields;
  Database? database;

  SqlliteDB({required this.fields});

  void _print(data){
    if (_DEBUG) print (data);
  }

  String _getFieldNames(){
    StringBuffer buffer = StringBuffer();
    for (final Field field in fields){
      buffer.write("${field.name}");
      if (field != fields.last) buffer.write(', ');
    }
    return buffer.toString();
  }

  String _getFieldNamesForUpdating(){
    StringBuffer buffer = StringBuffer();
    for (final Field field in fields){
      buffer.write("${field.name} = ?");
      if (field != fields.last) buffer.write(',');
      buffer.write(' ');
    }
    return buffer.toString();
  }

  String _getFieldWhereForUpdating(record){
    final json = record.toJson();
    StringBuffer buffer = StringBuffer();
    int count = 0;
    final requiredFields = fields.where((e) => e.required);
    for (final Field field in requiredFields){
      if (field.required) {
        buffer.write("${field.name} = ${json[field.name]}");
        if (count < requiredFields.length-1) buffer.write(' AND ');
        count++;
      }
    }
    return buffer.toString();
  }

  String _getValues(values){
    StringBuffer buffer = StringBuffer();
    int count = 0;
    for (final value in values){
      if (fields[count].type == "TEXT") buffer.write("\"$value\"");
      else buffer.write("$value");
      if (count < values.length-1) buffer.write(', ');
      count++;
    }
    return buffer.toString();
  }

  String _getTableString(){
    StringBuffer buffer = StringBuffer();
    for (final Field field in fields){
      final String primary = (field.primary) ? 'PRIMARY KEY AUTOINCREMENT' : '';
      buffer.write("${field.name} ${field.type} $primary");
      if (field != fields.last) buffer.write(', ');
    }
    return buffer.toString();
  }

  @override
  add(record) async{
    final fieldNames = _getFieldNames();
    final values = _getValues(record.toJson().values);
    final insertSQL = '''INSERT INTO ${T.toString()}($fieldNames) VALUES($values)''';
    _print(insertSQL);
    int result = -1;
    await database?.transaction((txn) async {
      result = await txn.rawInsert(insertSQL);
    });
    return result;
  }

  @override
  connect(name, adapter) async{
    final databasePath = await getDatabasesPath();
    final path = '$databasePath/kowanas.db';
    database = await openDatabase(path, version: 1);
    await _create();
  }

  _create() async{
    final tableString = _getTableString();
    final createSQL = '''CREATE TABLE IF NOT EXISTS ${T.toString()} ($tableString)''';
    _print(createSQL);
    await database?.execute(createSQL);
  }

  @override
  delete(record) async{
    final where = _getFieldWhereForUpdating(record);
    final deleteSQL = '''DELETE FROM ${T.toString()} WHERE $where''';
    _print(deleteSQL);
    final result = await database?.rawDelete(deleteSQL);
    _print('delete $result');
  }

  @override
  read({where}) async{
    final selectSQL = '''SELECT * FROM ${T.toString()}''';
    final whereSQL = (where == null) ? '' : ' WHERE ${where}';
    _print(selectSQL+whereSQL);
    final records = await database?.rawQuery(selectSQL+whereSQL);
    _print('read $records');
    return records;
  }

  @override
  update(record) async{
    final fieldNames = _getFieldNamesForUpdating();
    final where = _getFieldWhereForUpdating(record);
    final updateSQL = '''UPDATE ${T.toString()} SET $fieldNames WHERE $where''';
    _print(updateSQL);
    final result = await database?.rawUpdate(updateSQL, record.toJson().values);
    _print('update $result');
  }

  @override
  close() async{
    await database?.close();
  }
}