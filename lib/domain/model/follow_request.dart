import 'package:freezed_annotation/freezed_annotation.dart';

part 'follow_request.freezed.dart';

@freezed
class FollowRequest with _$FollowRequest {
  final String fromUserId;
  final String toUserId;
  final String toUserName;
  final String toUserImageUrl;
  final DateTime createdAt;

  const FollowRequest({
    required this.fromUserId,
    required this.toUserId,
    required this.toUserName,
    required this.toUserImageUrl,
    required this.createdAt,
  });
}