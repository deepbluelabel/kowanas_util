import '../api_handler.dart';
import '../model.dart';
import '../models/device.dart';

class BasicAPI extends ApiHandler {
  BasicAPI._internal();

  static final _instance = BasicAPI._internal();

  factory BasicAPI() => _instance;
  final _uri = 'https://api.deepbluelabel.com/basic';

  getDevice(uuid) async{
    try {
      final response = await get(_uri, '/users/device?uuid=${uuid}');
      print (response);
      if (response['result'] == false) throw Exception();
      return Device.fromClient(response['device']);
    }catch (e){
      print('failed to get device: ${e}');
      throw Exception();
    }
  }

  addDevice(Device device) async{
    try {
      final response = await post(_uri, '/users/device', body: device.toJson());
      print (response);
      if (response['result'] == false) throw Exception();
      return response['uid'];
    }catch (e){
      print('failed to add device: ${e}');
      return Model.UNDEFINED_VALUE_INT;
    }
  }
}
