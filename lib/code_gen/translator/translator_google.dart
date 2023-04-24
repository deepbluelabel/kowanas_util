import 'package:kowanas_util/api_handler.dart';
import 'package:kowanas_util/code_gen/translator/translator.dart';

class TranslatorGoogle extends ApiHandler implements Translator{
  final accessKey;
  TranslatorGoogle({required this.accessKey}){
    token = accessKey;
  }
  final baseUrl = 'https://translation.googleapis.com/language/translate/v2/';

  // {data: {languages: [{language: af}, ...
  @override
  getLanguages() async{
    try {
      final response = await get(baseUrl, 'languages?key=${accessKey}');
      return response['data']['languages'].map((e) => e['language']);
    }catch (e){
      print ('A getting languages is failed ${e}');
      return [];
    }
  }

  // {data: {translations: [
  //     {translatedText: 안녕하세요, detectedSourceLanguage: en}
  //     ]}}
  @override
  translate(value, language, {source='en'}) async{
    if (language == source) return null;
    final body = Map<String, dynamic>();
    body['q'] = [value];
    body['source'] = source;
    body['target'] = language;
    try {
      print ('translate ${value} in ${language}');
      final response = await post(baseUrl, '?key=${accessKey}', body:body);
      return response['data']['translations'][0]['translatedText'];
    } catch (e){
      print ('Translation is failed ${e}');
      return null;
    }
  }
}