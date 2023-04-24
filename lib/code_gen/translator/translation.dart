import 'dart:convert';
import 'dart:io';

class Translation{
  final _path = './translation_cache/';
  final language;
  final _translations = Map<String, String>();

  Translation({required this.language});

  _createDir() async{
    final dir = Directory(_path);
    if (dir.existsSync() == false){
      dir.createSync();
    }
  }

  getCache(String key){
    if(_translations.containsKey(key)) return _translations[key];
    return null;
  }

  add(key, value){
    _translations[key] = value;
  }

  save() async{
    await _createDir();
    final file = await File('${_path}${language}.tr');
    file.writeAsStringSync(json.encode(_translations));
  }

  load() async{
    try {
      final file = await File('${_path}${language}.tr');
      final values = json.decode(file.readAsStringSync());
      for (final entry in values.entries)
        _translations[entry.key] = entry.value;
    }catch (e){
      print (e);
    }
  }
}