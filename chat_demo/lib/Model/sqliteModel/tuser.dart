

import 'package:json_annotation/json_annotation.dart';
part 'tuser.g.dart';
@JsonSerializable()

class Tuser{
  String userId;
  String userName;
  String avatar;
  Tuser({this.avatar,this.userId,this.userName});

  factory Tuser.fromJson(Map<String, dynamic> json) =>
      _$TuserFromJson(json);
  Map<String, dynamic> toJson() => _$TuserToJson(this);
}