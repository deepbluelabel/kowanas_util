import 'package:kowanas_util/code_gen/annotations.dart';
import 'package:kowanas_util/kowanas_uuid.dart';
import 'package:kowanas_util/memory_db/memory_db.dart';
import 'package:kowanas_util/model.dart';
import 'package:kowanas_util/repository.dart';

part 'device.g.dart';

@ModelObject
class Device extends _Device{
  Device({
    int uid = Model.UNDEFINED_VALUE_INT,
    @comparator @fixed required String uuid,
    String deviceId = Model.UNDEFINED_VALUE,
    @fixed required createTime,
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
  String? uuid;
  DeviceRepository():super(db:MemoryDB());

  @override
  init() async {
    uuid = await KowanasUUID.uuidSaved;
    print (uuid);
    return super.init();
  }
}
