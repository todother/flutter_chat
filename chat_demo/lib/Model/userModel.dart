import 'package:json_annotation/json_annotation.dart';
part 'userModel.g.dart';

@JsonSerializable()


class UserModel {
  String userId;
  String userName;
  bool ifMale;
  String avatarUrl;
  

  UserModel({this.ifMale,this.userId,this.userName,this.avatarUrl});

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}
