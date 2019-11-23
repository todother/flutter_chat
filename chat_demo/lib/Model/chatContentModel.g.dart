// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chatContentModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatContentModel _$ChatContentModelFromJson(Map<String, dynamic> json) {
  return ChatContentModel(
    ifRead: json['ifRead'] as bool,
    lastContent: json['lastContent'] as String,
    lastUpdateTime: json['lastUpdateTime'] as String,
    userIds: (json['userIds'] as List)
        ?.map((e) =>
            e == null ? null : UserModel.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$ChatContentModelToJson(ChatContentModel instance) =>
    <String, dynamic>{
      'userIds': instance.userIds,
      'lastContent': instance.lastContent,
      'lastUpdateTime': instance.lastUpdateTime,
      'ifRead': instance.ifRead,
    };
