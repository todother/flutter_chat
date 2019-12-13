// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'xFvoiceConverterDataModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

XFVoiceConvertDataModel _$XFVoiceConvertDataModelFromJson(
    Map<String, dynamic> json) {
  return XFVoiceConvertDataModel(
    status: json['status'] as int,
    result: json['result'] == null
        ? null
        : XFVoiceConvertDataResultModel.fromJson(
            json['result'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$XFVoiceConvertDataModelToJson(
        XFVoiceConvertDataModel instance) =>
    <String, dynamic>{
      'status': instance.status,
      'result': instance.result,
    };
