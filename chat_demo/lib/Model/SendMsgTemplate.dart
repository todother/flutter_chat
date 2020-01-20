import 'package:json_annotation/json_annotation.dart';

part 'SendMsgTemplate.g.dart';
@JsonSerializable()

class SendMsgTemplate{
  String fromWho;
  String toWho;
  String message;
  int voiceLength;
  String makerName;
  String avatarUrl;
  SendMsgTemplate({this.fromWho,this.message,this.toWho,this.voiceLength,this.avatarUrl,this.makerName});

  factory SendMsgTemplate.fromJson(Map<String, dynamic> json) => _$SendMsgTemplateFromJson(json);
  Map<String, dynamic> toJson() => _$SendMsgTemplateToJson(this);
}

