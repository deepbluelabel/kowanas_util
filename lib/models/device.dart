import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:kowanas_util/code_gen/annotations.dart';
import 'package:kowanas_util/kowanas_exception.dart';
import 'package:kowanas_util/kowanas_uuid.dart';
import 'package:kowanas_util/model.dart';
import 'package:kowanas_util/repository.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../client/basic_api.dart';
import '../database/memory_db/memory_db.dart';
import '../kowanas_datetime.dart';

// flutter pub run build_runner build --delete-conflicting-outputs

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
    String deviceToken = 'no token';
    if (kIsWeb != true)
      deviceToken = await FirebaseMessaging.instance.getToken() ?? deviceToken;
    try {
      me = await api.getDevice(uuid);
      if (me == null){
        PackageInfo packageInfo = await PackageInfo.fromPlatform();
        me = Device(uuid: uuid, createTime: KowanasDateTime.timestamp,
            package: packageInfo.packageName, deviceId: deviceToken);
        final uid = await api.addDevice(me!);
        if (uid == Model.UNDEFINED_VALUE_INT)
          throw KowanasException.networkException;
        else me!.uid = uid;
      }else {
        if (deviceToken != null && deviceToken != me!.deviceId) {
          me!.deviceId = deviceToken;
          if (await api.updateDevice(me!) == false)
            throw KowanasException.networkException;
        }
      }
    }catch (e){
    }
    return super.init();
  }
}
