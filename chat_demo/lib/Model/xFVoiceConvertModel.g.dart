// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'xFVoiceConvertModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

XFVoiceConvertModel _$XFVoiceConvertModelFromJson(Map<String, dynamic> json) {
  return XFVoiceConvertModel(
    code: json['code'] as int,
    sid: json['sid'] as String,
    data: json['data'] == null
        ? null
        : XFVoiceConvertDataModel.fromJson(
            json['data'] as Map<String, dynamic>),
    message: json['message'] as String,
  );
}

Map<String, dynamic> _$XFVoiceConvertModelToJson(
        XFVoiceConvertModel instance) =>
    <String, dynamic>{
      'code': instance.code,
      'sid': instance.sid,
      'message': instance.message,
      'data': instance.data,
    };
