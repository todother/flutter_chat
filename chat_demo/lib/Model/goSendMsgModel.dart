import 'package:json_annotation/json_annotation.dart';

part 'goSendMsgModel.g.dart';
@JsonSerializable()

class SendMessageModel {
  SendMessageModel({this.content, this.to, this.from});
  String from;
  String to;
  String content;

  factory SendMessageModel.fromJson(Map<String, dynamic> json) =>
      _$SendMessageModelFromJson(json);
  Map<String, dynamic> toJson() => _$SendMessageModelToJson(this);
}
