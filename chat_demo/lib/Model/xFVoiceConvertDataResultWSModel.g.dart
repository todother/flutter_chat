// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'xFVoiceConvertDataResultWSModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

XFVoiceConvertDataResultWSModel _$XFVoiceConvertDataResultWSModelFromJson(
    Map<String, dynamic> json) {
  return XFVoiceConvertDataResultWSModel(
    cw: (json['cw'] as List)
        ?.map((e) => e == null
            ? null
            : XFVoiceConvertDataResultWSCWModel.fromJson(
                e as Map<String, dynamic>))
        ?.toList(),
    bg: json['bg'] as int,
  );
}

Map<String, dynamic> _$XFVoiceConvertDataResultWSModelToJson(
        XFVoiceConvertDataResultWSModel instance) =>
    <String, dynamic>{
      'bg': instance.bg,
      'cw': instance.cw,
    };
