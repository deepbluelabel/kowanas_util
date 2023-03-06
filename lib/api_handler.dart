import 'dart:convert';
import 'dart:typed_data';

import 'package:cp949_codec/cp949_codec.dart';
import 'package:http/http.dart' as http;

class ApiHandler{
  String token = '';
  int tokenExpiration = 0;

  _getHeader({header}){
    if (header == null) return {'token':token};
    else{
      header['token'] = token;
      return header;
    }
  }

  jsonToString(Map<String, String> data){
    if (data.length <= 0) return '';
    StringBuffer buffer = StringBuffer();
    for(final entry in data.entries){
      buffer.write('${entry.key}=${entry.value}&');
    }
    final length = buffer.length;
    return buffer.toString().substring(0, length-1);
  }

  get(uri, path, {Map<String, dynamic>? body}) async{
    final client = http.Client();
    final url = Uri.parse(uri+path);
    final http.Response response = await client.get(url, headers: _getHeader());
    return jsonDecode(utf8.decode(response.bodyBytes));
  }

  download(uri) async{
    final client = http.Client();
    final url = Uri.parse(uri);
    final http.Response response = await client.get(url, headers: _getHeader());
    return cp949.decode(response.bodyBytes);
  }

  postWithHeader(uri, path, header) async{
    try {
      final client = http.Client();
      final url = Uri.parse(uri + path);
      header['Content-Type'] = 'application/json; charset=UTF-8';
      final http.Response response = await client.post(url,
          headers: header);
      print(response.body);
      return jsonDecode(response.body);
    }catch (e){
      print (e);
    }
  }

  post(uri, path, {Map<String, dynamic>? body}) async {
    final client = http.Client();
    final url = Uri.parse(uri + path);
    final http.Response response = await client.post(url,
        headers: _getHeader(
            header: {'Content-Type': 'application/json; charset=UTF-8'}),
        body: json.encode(body));
    print(response.body);
    return jsonDecode(response.body);
  }

  put(uri, path, {Map<String, dynamic>? body}) async {
    final client = http.Client();
    final url = Uri.parse(uri + path);
    final http.Response response = await client.put(url,
        headers: _getHeader(
            header: {'Content-Type': 'application/json; charset=UTF-8'}),
        body: json.encode(body));
    return jsonDecode(response.body);
  }

  delete(uri, path, {Map<String, dynamic>? body}) async {
    final client = http.Client();
    final url = Uri.parse(uri + path);
    final http.Response response = await client.delete(
        url, headers: _getHeader());
    print(response.body);
    return jsonDecode(response.body);
  }

  upload(uri, path, {Uint8List? bytes}) async {
    print('upload ${uri} ${path}}');
    if (bytes != null) print('length ${bytes.length}');
    try {
      final client = http.Client();
      final url = Uri.parse(uri + path);
      await client.put(url,
          headers: _getHeader(
              header: {'Content-Type': 'application/json; charset=UTF-8'}),
          body: bytes);
      return true;
    } catch (e) {
      return false;
    }
  }
}
