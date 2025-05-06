// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'status_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StatusDto _$StatusDtoFromJson(Map<String, dynamic> json) => StatusDto(
  json['name'] as String?,
  json['statusTime'] == null
      ? null
      : DateTime.parse(json['statusTime'] as String),
  (json['colorStatus'] as num?)?.toInt(),
  json['statusMessage'] as String?,
);

Map<String, dynamic> _$StatusDtoToJson(StatusDto instance) => <String, dynamic>{
  'name': instance.name,
  'statusTime': instance.statusTime?.toIso8601String(),
  'colorStatus': instance.colorStatus,
  'statusMessage': instance.statusMessage,
};
