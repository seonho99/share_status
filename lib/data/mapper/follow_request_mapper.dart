import '../../domain/model/follow_request.dart';
import '../dto/follow_request_dto.dart';

extension FollowRequestMapper on FollowRequestDto {
  FollowRequest toDomain() {
    return FollowRequest(
      id: id,
      fromUserId: fromUserId,
      toUserId: toUserId,
      toUserName: toUserName,
      toUserImageUrl: toUserImageUrl,
      createdAt: createdAt,
    );
  }
}

extension FollowRequestDomainMapper on FollowRequest {
  FollowRequestDto toDto() {
    return FollowRequestDto(
      id: id,
      fromUserId: fromUserId,
      toUserId: toUserId,
      toUserName: toUserName,
      toUserImageUrl: toUserImageUrl,
      createdAt: createdAt,
    );
  }
}