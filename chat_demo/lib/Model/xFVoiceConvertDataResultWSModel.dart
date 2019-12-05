import 'package:chat_demo/Model/xFVoiceConvertDataResultWSCWModel.dart';
import 'package:json_annotation/json_annotation.dart';

part 'xFVoiceConvertDataResultWSModel.g.dart';

@JsonSerializable()

class XFVoiceConvertDataResultWSModel{
  int bg;
  List<XFVoiceConvertDataResultWSCWModel> cw=List<XFVoiceConvertDataResultWSCWModel>();
XFVoiceConvertDataResultWSModel({this.cw,this.bg});
factory XFVoiceConvertDataResultWSModel.fromJson(Map<String, dynamic> json) =>
      _$XFVoiceConvertDataResultWSModelFromJson(json);
  Map<String, dynamic> toJson() => _$XFVoiceConvertDataResultWSModelToJson(this);

}