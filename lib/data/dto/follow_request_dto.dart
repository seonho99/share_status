import 'package:json_annotation/json_annotation.dart';

part 'follow_request_dto.g.dart';

@JsonSerializable(explicitToJson: true)
class FollowRequestDto {
  final String fromUserId;
  final String toUserId;
  final String toUserName;
  final String toUserImageUrl;
  final DateTime createdAt;

  FollowRequestDto({
    required this.fromUserId,
    required this.toUserId,
    required this.toUserName,
    required this.toUserImageUrl,
    required this.createdAt,
  });

  factory FollowRequestDto.fromJson(Map<String, dynamic> json) =>
      _$FollowRequestDtoFromJson(json);

  Map<String, dynamic> toJson() => _$FollowRequestDtoToJson(this);
}