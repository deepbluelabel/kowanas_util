import 'dart:convert';

import 'package:kowanas_util/database/kowanas_db.dart';
import 'package:kowanas_util/model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'nosql_adapter.dart';

class NosqlDB extends KowanasDB{
  final records = Map<int, Model>();
  late var prefs;
  late String name;
  late NosqlAdapter adapter;

  @override
  add(record) async {
    if(_isExist(record) == false) {
      final id = _getNewId();
      records[id] = record;
      await prefs.setString(name+'keys', jsonEncode(records.keys.toList()));
      await _update(id, record);
      return true;
    }
    return false;
  }

  _getNewId(){
    if (records.isEmpty) return 0;
    return records.keys.last+1;
  }

  _isExist(record) => records.values.any((e)=>e==record);

  @override
  read({where}) {
    return records.values;
  }

  _load() async{
    final keys = await jsonDecode(prefs.getString(name+'keys')) ?? [];
    for (int i = 1; i <= keys; i++){
      final saved = await prefs.getString(name+i.toString());
      if (saved != null){
        final json = jsonDecode(saved);
        final record = adapter.fromJson(json) as Model;
        records[i] = record;
      }
    }
  }

  @override
  connect(name, adapter) async {
    this.name = name;
    this.adapter = adapter;
    prefs = await SharedPreferences.getInstance();
    await _load();
    return this;
  }

  @override
  delete(record) {
  }

  _getKey(record){
    for (final entry in records.entries){
      if (entry.value == record) return entry.key;
    }
  }

  @override
  update(record) async{
    await _update(_getKey(record), record);
  }

  _update(key, record) async{
    await prefs.setString(name+key.toString(),
        jsonEncode(adapter.toJson(record)));
  }
}