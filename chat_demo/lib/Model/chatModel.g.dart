// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chatModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatModel _$ChatModelFromJson(Map<String, dynamic> json) {
  return ChatModel(
    chatId: json['chatId'] as String,
    contentModel: json['contentModel'] == null
        ? null
        : ChatContentModel.fromJson(
            json['contentModel'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$ChatModelToJson(ChatModel instance) => <String, dynamic>{
      'chatId': instance.chatId,
      'contentModel': instance.contentModel,
    };
