// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'goReceiveMsgModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GoReceiveMsgModel _$GoReceiveMsgModelFromJson(Map<String, dynamic> json) {
  return GoReceiveMsgModel(
    callbackName: json['callbackName'] as String,
    jsonResponse: json['jsonResponse'] as String,
  );
}

Map<String, dynamic> _$GoReceiveMsgModelToJson(GoReceiveMsgModel instance) =>
    <String, dynamic>{
      'callbackName': instance.callbackName,
      'jsonResponse': instance.jsonResponse,
    };
