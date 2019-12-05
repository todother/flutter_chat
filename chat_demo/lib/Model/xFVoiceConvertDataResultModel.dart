import 'package:chat_demo/Model/xFVoiceConvertDataResultWSModel.dart';
import 'package:chat_demo/Model/xFVoiceConvertModel.dart';
import 'package:json_annotation/json_annotation.dart';

part 'xFVoiceConvertDataResultModel.g.dart';

@JsonSerializable()
class XFVoiceConvertDataResultModel {
  int sn;
  bool ls;
  String pgs;
  List<int> rg = List<int>();
  List<XFVoiceConvertDataResultWSModel> ws =
      List<XFVoiceConvertDataResultWSModel>();
  XFVoiceConvertDataResultModel({this.ls,this.pgs,this.rg,this.sn,this.ws});
  factory XFVoiceConvertDataResultModel.fromJson(Map<String, dynamic> json) =>
      _$XFVoiceConvertDataResultModelFromJson(json);
  Map<String, dynamic> toJson() => _$XFVoiceConvertDataResultModelToJson(this);
}