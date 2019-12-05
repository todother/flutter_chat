

import 'package:chat_demo/Model/xFVoiceConvertModel.dart';
import 'package:json_annotation/json_annotation.dart';
part 'xFVoiceConvertDataResultWSCWModel.g.dart';
@JsonSerializable()

class XFVoiceConvertDataResultWSCWModel {
  int sc;
  String w;
  XFVoiceConvertDataResultWSCWModel({this.sc,this.w});
  factory XFVoiceConvertDataResultWSCWModel.fromJson(
          Map<String, dynamic> json) =>
      _$XFVoiceConvertDataResultWSCWModelFromJson(json);
  Map<String, dynamic> toJson() =>
      _$XFVoiceConvertDataResultWSCWModelToJson(this);
}