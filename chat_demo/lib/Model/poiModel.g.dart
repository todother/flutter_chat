// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'poiModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PoiModel _$PoiModelFromJson(Map<String, dynamic> json) {
  return PoiModel(
    lati: (json['lati'] as num)?.toDouble(),
    longi: (json['longi'] as num)?.toDouble(),
    address: json['address'] as String,
    distance: json['distance'] as int,
    title: json['title'] as String,
  );
}

Map<String, dynamic> _$PoiModelToJson(PoiModel instance) => <String, dynamic>{
      'distance': instance.distance,
      'address': instance.address,
      'title': instance.title,
      'lati': instance.lati,
      'longi': instance.longi,
    };
