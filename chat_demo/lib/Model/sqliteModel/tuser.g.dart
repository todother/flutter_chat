// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tuser.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Tuser _$TuserFromJson(Map<String, dynamic> json) {
  return Tuser(
    avatar: json['avatar'] as String,
    userId: json['userId'] as String,
    userName: json['userName'] as String,
  );
}

Map<String, dynamic> _$TuserToJson(Tuser instance) => <String, dynamic>{
      'userId': instance.userId,
      'userName': instance.userName,
      'avatar': instance.avatar,
    };
