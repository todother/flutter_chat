// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chatRecordModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatRecord _$ChatRecordFromJson(Map<String, dynamic> json) {
  return ChatRecord(
    sender: json['sender'] as int,
    content: json['content'] as String,
    avatarUrl: json['avatarUrl'] as String,
    chatType: json['chatType'] as int,
    voiceDuration: json['voiceDuration'] as int,
    locationImg: json['locationImg'] as String,
    address: json['address'] as String,
    title: json['title'] as String,
    imgFitType: _$enumDecodeNullable(_$BoxFitEnumMap, json['imgFitType']),
    imgHeight: (json['imgHeight'] as num)?.toDouble(),
    imgWidth: (json['imgWidth'] as num)?.toDouble(),
    videoPath: json['videoPath'] as String,
  );
}

Map<String, dynamic> _$ChatRecordToJson(ChatRecord instance) =>
    <String, dynamic>{
      'sender': instance.sender,
      'content': instance.content,
      'avatarUrl': instance.avatarUrl,
      'chatType': instance.chatType,
      'voiceDuration': instance.voiceDuration,
      'address': instance.address,
      'title': instance.title,
      'locationImg': instance.locationImg,
      'imgHeight': instance.imgHeight,
      'imgWidth': instance.imgWidth,
      'imgFitType': _$BoxFitEnumMap[instance.imgFitType],
      'videoPath': instance.videoPath,
    };

T _$enumDecode<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    throw ArgumentError('A value must be provided. Supported values: '
        '${enumValues.values.join(', ')}');
  }

  final value = enumValues.entries
      .singleWhere((e) => e.value == source, orElse: () => null)
      ?.key;

  if (value == null && unknownValue == null) {
    throw ArgumentError('`$source` is not one of the supported values: '
        '${enumValues.values.join(', ')}');
  }
  return value ?? unknownValue;
}

T _$enumDecodeNullable<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<T>(enumValues, source, unknownValue: unknownValue);
}

const _$BoxFitEnumMap = {
  BoxFit.fill: 'fill',
  BoxFit.contain: 'contain',
  BoxFit.cover: 'cover',
  BoxFit.fitWidth: 'fitWidth',
  BoxFit.fitHeight: 'fitHeight',
  BoxFit.none: 'none',
  BoxFit.scaleDown: 'scaleDown',
};
