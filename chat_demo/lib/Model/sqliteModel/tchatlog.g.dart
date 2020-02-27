// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tchatlog.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TChatLog _$TChatLogFromJson(Map<String, dynamic> json) {
  return TChatLog(
    loginId: json['loginId'] as String,
    contentType: json['contentType'] as int,
    toUser: json['toUser'] as String,
    content: json['content'] as String,
    fromUser: json['fromUser'] as String,
    grpId: json['grpId'] as String,
    imgPath: json['imgPath'] as String,
    insertTime: json['insertTime'] == null
        ? null
        : DateTime.parse(json['insertTime'] as String),
    videoPath: json['videoPath'] as String,
    voiceLength: json['voiceLength'] as int,
    voicePath: json['voicePath'] as String,
    otherId: json['otherId'] as String,
    locaddress: json['locaddress'] as String,
    imgHeight: (json['imgHeight'] as num)?.toDouble(),
    imgWidth: (json['imgWidth'] as num)?.toDouble(),
    locationImg: json['locationImg'] as String,
    title: json['title'] as String,
  );
}

Map<String, dynamic> _$TChatLogToJson(TChatLog instance) => <String, dynamic>{
      'loginId': instance.loginId,
      'toUser': instance.toUser,
      'fromUser': instance.fromUser,
      'content': instance.content,
      'contentType': instance.contentType,
      'insertTime': instance.insertTime?.toIso8601String(),
      'imgPath': instance.imgPath,
      'videoPath': instance.videoPath,
      'voicePath': instance.voicePath,
      'voiceLength': instance.voiceLength,
      'otherId': instance.otherId,
      'grpId': instance.grpId,
      'locaddress': instance.locaddress,
      'imgWidth': instance.imgWidth,
      'imgHeight': instance.imgHeight,
      'title': instance.title,
      'locationImg': instance.locationImg,
    };
