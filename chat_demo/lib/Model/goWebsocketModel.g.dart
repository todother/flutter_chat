// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'goWebsocketModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GoWebsocketModel _$GoWebsocketModelFromJson(Map<String, dynamic> json) {
  return GoWebsocketModel(
    args: json['args'] as Map<String, dynamic>,
    methodName: json['methodName'] as String,
  );
}

Map<String, dynamic> _$GoWebsocketModelToJson(GoWebsocketModel instance) =>
    <String, dynamic>{
      'methodName': instance.methodName,
      'args': instance.args,
    };
