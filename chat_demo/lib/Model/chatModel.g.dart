// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chatModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatModel _$ChatModelFromJson(Map<String, dynamic> json) {
  return ChatModel(
    user: json['user'] == null
        ? null
        : Tuser.fromJson(json['user'] as Map<String, dynamic>),
    contentModel: json['contentModel'] == null
        ? null
        : TChatLog.fromJson(json['contentModel'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$ChatModelToJson(ChatModel instance) => <String, dynamic>{
      'user': instance.user,
      'contentModel': instance.contentModel,
    };
