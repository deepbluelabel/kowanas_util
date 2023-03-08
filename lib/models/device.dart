import 'package:kowanas_util/code_gen/annotations.dart';
import 'package:kowanas_util/kowanas_uuid.dart';
import 'package:kowanas_util/memory_db/memory_db.dart';
import 'package:kowanas_util/model.dart';
import 'package:kowanas_util/repository.dart';

import '../client/basic_api.dart';

part 'device.g.dart';

@ModelObject
class Device extends _Device{
  Device({
    int uid = Model.UNDEFINED_VALUE_INT,
    @comparator @fixed required String uuid,
    String deviceId = Model.UNDEFINED_VALUE,
    @fixed required int createTime,
    @fixed required String package
  }):super(
      uid: uid,
      uuid: uuid,
      deviceId: deviceId,
      createTime: createTime,
      package: package
  );

  factory Device.fromJson(json) => _DeviceFromJson(json);
  factory Device.fromClient(json) => _DeviceFromClient(json);
}

class DeviceRepository extends Repository{
  Device? me;
  DeviceRepository():super(db:MemoryDB());

  @override
  init() async {
    final uuid = await KowanasUUID.uuidSaved;
    print (uuid);
    final api = BasicAPI();
    try {
      me = await api.getDevice(uuid);
    }catch (e){
      me = Device(uuid: uuid, createTime: 112345, package: 'test');
      if (me != null)
        me?.uid = await api.addDevice(me!);
    }
    return super.init();
  }
}
