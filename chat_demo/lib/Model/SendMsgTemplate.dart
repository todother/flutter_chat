import 'package:json_annotation/json_annotation.dart';

part 'SendMsgTemplate.g.dart';
@JsonSerializable()

class SendMsgTemplate{
  String fromWho;
  String toWho;
  String message;
  SendMsgTemplate({this.fromWho,this.message,this.toWho});

  factory SendMsgTemplate.fromJson(Map<String, dynamic> json) => _$SendMsgTemplateFromJson(json);
  Map<String, dynamic> toJson() => _$SendMsgTemplateToJson(this);
}

