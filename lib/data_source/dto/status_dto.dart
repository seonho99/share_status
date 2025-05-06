
import 'package:freezed_annotation/freezed_annotation.dart';

part 'status_dto.g.dart';

@JsonSerializable(explicitToJson: true)
class StatusDto {
  final String? name;
  final DateTime? statusTime;
  final int? colorStatus;
  final String? statusMessage;

  StatusDto(this.name, this.statusTime, this.colorStatus,this.statusMessage);

  factory StatusDto.fromJson(Map<String, dynamic> json) =>
      _$StatusDtoFromJson(json);

  Map<String, dynamic> toJson() => _$StatusDtoToJson(this);
}