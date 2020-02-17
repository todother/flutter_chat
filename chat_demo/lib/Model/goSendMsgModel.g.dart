// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'goSendMsgModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SendMessageModel _$SendMessageModelFromJson(Map<String, dynamic> json) {
  return SendMessageModel(
    content: json['content'] as String,
    to: json['to'] as String,
    from: json['from'] as String,
  );
}

Map<String, dynamic> _$SendMessageModelToJson(SendMessageModel instance) =>
    <String, dynamic>{
      'from': instance.from,
      'to': instance.to,
      'content': instance.content,
    };
