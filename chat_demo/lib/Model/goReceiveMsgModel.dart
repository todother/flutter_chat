import 'package:json_annotation/json_annotation.dart';

part 'goReceiveMsgModel.g.dart';
@JsonSerializable()

class GoReceiveMsgModel{
  GoReceiveMsgModel({this.callbackName,this.jsonResponse});
  String callbackName;
  String jsonResponse;

    factory GoReceiveMsgModel.fromJson(Map<String, dynamic> json) =>
      _$GoReceiveMsgModelFromJson(json);
  Map<String, dynamic> toJson() => _$GoReceiveMsgModelToJson(this);
}