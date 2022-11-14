import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:shared_preferences/shared_preferences.dart';

import 'preference_cookie.dart';

abstract class Preference{
  get internalInstance;
  getString(key);
  getInt(key);
  getBool(key);
  setString(key, value);
  setInt(key, value);
  setBool(key, value);

  static get instance async{
    final prefs = (kIsWeb) ? PreferenceCookie(): PreferenceNative();
    return await prefs.internalInstance;
  }
}

class PreferenceNative extends Preference{
  PreferenceNative._internal();
  static final PreferenceNative _instance = PreferenceNative._internal();
  factory PreferenceNative() => _instance;

  SharedPreferences? prefs;

  @override
  getBool(key) => prefs!.getBool(key);

  @override
  getInt(key) => prefs!.getInt(key);

  @override
  getString(key) => prefs!.getString(key);

  @override
  get internalInstance async{
    if (prefs == null) {
      prefs = await SharedPreferences.getInstance();
    }
    return _instance;
  }

  @override
  setBool(key, value) => prefs!.setBool(key, value);

  @override
  setInt(key, value) => prefs!.setInt(key, value);

  @override
  setString(key, value) => prefs!.setString(key, value);
}