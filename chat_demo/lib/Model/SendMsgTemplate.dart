import 'package:json_annotation/json_annotation.dart';

part 'SendMsgTemplate.g.dart';
@JsonSerializable()

class SendMsgTemplate{
  String fromWho;
  String toWho;
  String message;
  String voiceLength;
  SendMsgTemplate({this.fromWho,this.message,this.toWho,this.voiceLength});

  factory SendMsgTemplate.fromJson(Map<String, dynamic> json) => _$SendMsgTemplateFromJson(json);
  Map<String, dynamic> toJson() => _$SendMsgTemplateToJson(this);
}

