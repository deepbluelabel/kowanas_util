import '../api_handler.dart';
import '../models/device.dart';

class BasicAPI extends ApiHandler {
  BasicAPI._internal();

  static final _instance = BasicAPI._internal();

  factory BasicAPI() => _instance;
  final _uri = 'https://api.deepbluelabel.com/basic';

  getDevice(uuid) async{
    try {
      final response = await get(_uri, '/users/device?uuid=${uuid}');
      if (response['result'] == false) throw Exception();
      return Device.fromClient(response['device']);
    }catch (e){
      print('failed to get device: ${e}');
      throw Exception();
    }
  }
}
