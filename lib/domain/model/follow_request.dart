import 'package:freezed_annotation/freezed_annotation.dart';

part 'follow_request.freezed.dart';

@freezed
class FollowRequest with _$FollowRequest {
  const FollowRequest({
    this.id,
    required this.fromUserId,
    required this.toUserId,
    required this.toUserName,
    required this.toUserImageUrl,
    required this.createdAt,
  });

  final String? id;
  final String fromUserId;
  final String toUserId;
  final String toUserName;
  final String toUserImageUrl;
  final DateTime createdAt;
}