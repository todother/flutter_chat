import 'package:chat_demo/Model/chatContentModel.dart';
import 'package:json_annotation/json_annotation.dart';

part 'chatModel.g.dart';

@JsonSerializable()

class ChatModel{
  String chatId;
  ChatContentModel contentModel;

  ChatModel({this.chatId,this.contentModel});

  factory ChatModel.fromJson(Map<String, dynamic> json) =>
      _$ChatModelFromJson(json);
  Map<String, dynamic> toJson() => _$ChatModelToJson(this);
}