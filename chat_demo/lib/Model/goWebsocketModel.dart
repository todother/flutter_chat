
import 'package:json_annotation/json_annotation.dart';

part 'goWebsocketModel.g.dart';
@JsonSerializable()

class GoWebsocketModel{
  GoWebsocketModel({this.args,this.methodName});
  String methodName;
  Map<String,Object> args;


  factory GoWebsocketModel.fromJson(Map<String, dynamic> json) =>
      _$GoWebsocketModelFromJson(json);
  Map<String, dynamic> toJson() => _$GoWebsocketModelToJson(this);
}