import 'package:json_annotation/json_annotation.dart';

part 'SendMsgTemplate.g.dart';
@JsonSerializable()

class SendMsgTemplate{
  String fromUser;
  String toUser;
  String content;
  int voiceLength;
  int contentType;
  // String makerName;
  // String avatarUrl;
  SendMsgTemplate({this.fromUser,this.content,this.toUser,this.voiceLength,this.contentType});

  factory SendMsgTemplate.fromJson(Map<String, dynamic> json) => _$SendMsgTemplateFromJson(json);
  Map<String, dynamic> toJson() => _$SendMsgTemplateToJson(this);
}

