import 'package:chat_demo/Model/chatContentModel.dart';
import 'package:chat_demo/Model/sqliteModel/tchatlog.dart';
import 'package:chat_demo/Model/sqliteModel/tuser.dart';
import 'package:json_annotation/json_annotation.dart';

part 'chatModel.g.dart';

@JsonSerializable()

class ChatModel{
  Tuser user;
  TChatLog contentModel;

  ChatModel({this.user,this.contentModel});

  factory ChatModel.fromJson(Map<String, dynamic> json) =>
      _$ChatModelFromJson(json);
  Map<String, dynamic> toJson() => _$ChatModelToJson(this);
}