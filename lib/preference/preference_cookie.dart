import 'package:kowanas_util/preference/preference.dart';
import 'package:universal_html/html.dart';

class PreferenceCookie extends Preference{
  PreferenceCookie._internal();
  static final PreferenceCookie _instance = PreferenceCookie._internal();
  factory PreferenceCookie() => _instance;

  Storage? cookie;

  @override
  containsKey(key) => cookie!.containsKey(key);

  @override
  getBool(key) => cookie![key]! == 'true';

  @override
  getInt(key) => int.parse(cookie![key]!);

  @override
  getString(key) => cookie![key];

  @override
  get internalInstance {
    if (cookie == null)
      cookie = window.localStorage;
    return _instance;
  }

  @override
  setBool(key, value) => cookie![key] = value.toString();

  @override
  setInt(key, value) => cookie![key] = value.toString();

  @override
  setString(key, value) => cookie![key] = value;
}