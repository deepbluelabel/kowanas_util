// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// ModelObjectGenerator
// **************************************************************************

part of 'user.dart';

abstract class _User extends Model {
  int uid;
  final String uuid;
  String deviceId;
  final dynamic createTime;
  final String package;

  _User({
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
    return other is User && other.uuid == uuid;
  }

  String getUniqueKey() {
    return uuid.toString() + '_' + '';
  }
}

_UserFromJson(json) {
  return User(
    uid: json['uid'],
    uuid: json['uuid'],
    deviceId: json['deviceId'],
    createTime: json['createTime'],
    package: json['package'],
  );
}
