import 'package:chat_demo/Model/xFVoiceConvertDataResultModel.dart';
import 'package:json_annotation/json_annotation.dart';
part 'xFVoiceConvertDataModel.g.dart';

@JsonSerializable()

class XFVoiceConvertDataModel {
  int status;
  XFVoiceConvertDataResultModel result;
  XFVoiceConvertDataModel({this.status, this.result});

  factory XFVoiceConvertDataModel.fromJson(Map<String, dynamic> json) =>
      _$XFVoiceConvertDataModelFromJson(json);
  Map<String, dynamic> toJson() => _$XFVoiceConvertDataModelToJson(this);
}