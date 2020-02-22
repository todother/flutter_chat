import 'package:flutter/material.dart';

import 'package:json_annotation/json_annotation.dart';
part 'userLoginModel.g.dart';

@JsonSerializable()

class UserLoginModel{
  String loginId;
  DateTime loginDate;
  String imei;

  UserLoginModel({this.loginDate,this.loginId,this.imei});

  factory UserLoginModel.fromJson(Map<String, dynamic> json) =>
      _$UserLoginModelFromJson(json);
  Map<String, dynamic> toJson() => _$UserLoginModelToJson(this);
} 