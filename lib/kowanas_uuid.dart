import 'package:uuid/uuid.dart';

import 'preference/preference.dart';

class KowanasUUID{
  static get uuid => Uuid().v4();

  static get uuidSaved async {
    final pref = await Preference.instance;
    String? uuid;
    if (pref.containsKey('uuid') == true) {
      uuid = pref.getString('uuid');
    }else{
      uuid = KowanasUUID.uuid;
      pref.setString('uuid', uuid);
    }
    return uuid;
  }
}