// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'userLoginModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserLoginModel _$UserLoginModelFromJson(Map<String, dynamic> json) {
  return UserLoginModel(
    loginDate: json['loginDate'] == null
        ? null
        : DateTime.parse(json['loginDate'] as String),
    loginId: json['loginId'] as String,
    imei: json['imei'] as String,
  );
}

Map<String, dynamic> _$UserLoginModelToJson(UserLoginModel instance) =>
    <String, dynamic>{
      'loginId': instance.loginId,
      'loginDate': instance.loginDate?.toIso8601String(),
      'imei': instance.imei,
    };
