import 'package:chat_demo/Model/userModel.dart';
import 'package:json_annotation/json_annotation.dart';

part 'chatContentModel.g.dart';

@JsonSerializable()


class ChatContentModel{
  List<UserModel> userIds;
  String lastContent;
  String lastUpdateTime;
  bool ifRead;
  

  ChatContentModel({this.ifRead,this.lastContent,this.lastUpdateTime,this.userIds});

  factory ChatContentModel.fromJson(Map<String, dynamic> json) =>
      _$ChatContentModelFromJson(json);
  Map<String, dynamic> toJson() => _$ChatContentModelToJson(this);
}

