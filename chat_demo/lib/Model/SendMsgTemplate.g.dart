// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'SendMsgTemplate.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SendMsgTemplate _$SendMsgTemplateFromJson(Map<String, dynamic> json) {
  return SendMsgTemplate(
    fromUser: json['fromUser'] as String,
    content: json['content'] as String,
    toUser: json['toUser'] as String,
    voiceLength: json['voiceLength'] as int,
    contentType: json['contentType'] as int,
  );
}

Map<String, dynamic> _$SendMsgTemplateToJson(SendMsgTemplate instance) =>
    <String, dynamic>{
      'fromUser': instance.fromUser,
      'toUser': instance.toUser,
      'content': instance.content,
      'voiceLength': instance.voiceLength,
      'contentType': instance.contentType,
    };
