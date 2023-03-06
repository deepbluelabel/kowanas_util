// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// ModelObjectGenerator
// **************************************************************************

part of 'device.dart';

abstract class _Device extends Model {
  int uid;
  final String uuid;
  String deviceId;
  final dynamic createTime;
  final String package;

  _Device({
    required this.uid,
    required this.uuid,
    required this.deviceId,
    required this.createTime,
    required this.package,
  });

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'uuid': uuid,
      'deviceId': deviceId,
      'createTime': createTime,
      'package': package,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    return other is Device && other.uuid == uuid;
  }

  String getUniqueKey() {
    return uuid.toString() + '_' + '';
  }
}

_DeviceFromJson(json) {
  return Device(
    uid: json['uid'],
    uuid: json['uuid'],
    deviceId: json['deviceId'],
    createTime: json['createTime'],
    package: json['package'],
  );
}

_DeviceFromClient(json) {
  final device = Device(
    uuid: json['uuid'],
    createTime: json['createTime'],
    package: json['package'],
  );

  if (json['uid'] != null) device.uid = json['uid'];
  if (json['deviceId'] != null) device.deviceId = json['deviceId'];
  return device;
}
