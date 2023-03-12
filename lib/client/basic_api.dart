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
      if (response['result'] == false) return null;
      return Device.fromClient(response['device']);
    }catch (e){
      print('failed to get device: ${e}');
      throw e;
    }
  }

  addDevice(Device device) async{
    try {
      final response = await post(_uri, '/users/device', body: device.toJson());
      if (response['result'] == false) return Model.UNDEFINED_VALUE_INT;
      return response['uid'];
    }catch (e){
      print('failed to add device: ${e}');
      throw e;
    }
  }

  updateDevice(Device device) async{
    try {
      final response = await put(_uri, '/users/device', body: device.toJson());
      return response['result'];
    }catch (e){
      print('failed to update device: ${e}');
      throw e;
    }
  }
}
