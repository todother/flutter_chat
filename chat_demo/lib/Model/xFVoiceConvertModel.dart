import 'package:json_annotation/json_annotation.dart';

import 'xFvoiceConverterDataModel.dart';
part 'xFVoiceConvertModel.g.dart';

@JsonSerializable()

class XFVoiceConvertModel {
  int code;
  String sid;
  String message;
  XFVoiceConvertDataModel data;
  XFVoiceConvertModel({this.code, this.sid, this.data,this.message});

  factory XFVoiceConvertModel.fromJson(Map<String, dynamic> json) =>
      _$XFVoiceConvertModelFromJson(json);
  Map<String, dynamic> toJson() => _$XFVoiceConvertModelToJson(this);
}








