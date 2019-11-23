// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'userModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) {
  return UserModel(
    ifMale: json['ifMale'] as bool,
    userId: json['userId'] as String,
    userName: json['userName'] as String,
    avatarUrl: json['avatarUrl'] as String,
  );
}

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'userId': instance.userId,
      'userName': instance.userName,
      'ifMale': instance.ifMale,
      'avatarUrl': instance.avatarUrl,
    };
