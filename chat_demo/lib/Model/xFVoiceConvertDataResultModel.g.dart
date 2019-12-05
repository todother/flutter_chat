// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'xFVoiceConvertDataResultModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

XFVoiceConvertDataResultModel _$XFVoiceConvertDataResultModelFromJson(
    Map<String, dynamic> json) {
  return XFVoiceConvertDataResultModel(
    ls: json['ls'] as bool,
    pgs: json['pgs'] as String,
    rg: (json['rg'] as List)?.map((e) => e as int)?.toList(),
    sn: json['sn'] as int,
    ws: (json['ws'] as List)
        ?.map((e) => e == null
            ? null
            : XFVoiceConvertDataResultWSModel.fromJson(
                e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$XFVoiceConvertDataResultModelToJson(
        XFVoiceConvertDataResultModel instance) =>
    <String, dynamic>{
      'sn': instance.sn,
      'ls': instance.ls,
      'pgs': instance.pgs,
      'rg': instance.rg,
      'ws': instance.ws,
    };
