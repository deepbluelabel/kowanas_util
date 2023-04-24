import 'dart:convert';
import 'dart:typed_data';

import 'package:cp949_codec/cp949_codec.dart';
import 'package:http/http.dart' as http;
import 'package:kowanas_util/kowanas_exception.dart';

class ApiHandler{
  String token = '';
  int tokenExpiration = 0;

  _getHeader({header}){
    final headers = Map<String, String>();
    if (header != null) headers.addAll(header);
//    headers['Authorization'] = 'Bearer ${token}';
    headers['Content-Type'] = 'application/json; charset=UTF-8';
    return headers;
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
    if (response.statusCode != 200) throw KowanasException.networkException;
    return jsonDecode(utf8.decode(response.bodyBytes));
  }

  download(uri) async{
    final client = http.Client();
    final url = Uri.parse(uri);
    final http.Response response = await client.get(url, headers: _getHeader());
    if (response.statusCode != 200) throw KowanasException.networkException;
    return cp949.decode(response.bodyBytes);
  }

  postWithHeader(uri, path, header) async{
    final client = http.Client();
    final url = Uri.parse(uri + path);
    header['Content-Type'] = 'application/json; charset=UTF-8';
    final http.Response response = await client.post(url, headers: header);
    if (response.statusCode != 200) throw KowanasException.networkException;
    return jsonDecode(response.body);
  }

  post(uri, path, {Map<String, dynamic>? body}) async {
    final client = http.Client();
    final url = Uri.parse(uri + path);
    try {
      var response;
      final headers = _getHeader();
      if (body == null){
        response = await client.post(url, headers: headers);
      }else {
        response = await client.post(url, headers: headers,
            body: json.encode(body));
      }
      if (response.statusCode != 200) throw KowanasException.networkException;
      return jsonDecode(response.body);
    }catch (e){
      print ('error'+e.toString());
    }
  }

  put(uri, path, {Map<String, dynamic>? body}) async {
    final client = http.Client();
    final url = Uri.parse(uri + path);
    final http.Response response = await client.put(url,
        headers: _getHeader(
            header: {'Content-Type': 'application/json; charset=UTF-8'}),
        body: json.encode(body));
    if (response.statusCode != 200) throw KowanasException.networkException;
    return jsonDecode(response.body);
  }

  delete(uri, path, {Map<String, dynamic>? body}) async {
    final client = http.Client();
    final url = Uri.parse(uri + path);
    final http.Response response = await client.delete(
        url, headers: _getHeader());
    if (response.statusCode != 200) throw KowanasException.networkException;
    return jsonDecode(response.body);
  }

  upload(uri, path, {Uint8List? bytes}) async {
    final client = http.Client();
    final url = Uri.parse(uri + path);
    final http.Response response = await client.put(url,
        headers: _getHeader(
            header: {'Content-Type': 'application/json; charset=UTF-8'}),
        body: bytes);
    if (response.statusCode != 200) throw KowanasException.networkException;
    return true;
  }
}
