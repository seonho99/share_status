import '../dto/follow_request_dto.dart';
import '../dto/user_dto.dart';

abstract interface class FirebaseDataSource {
  Future<void> saveUser(UserDto user);

  Future<bool> checkIdExists(String id);

  Future<String> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<String> signUpWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<void> signOut();

  Future<void> sendPasswordResetEmail(String email);

  String? get currentUserId;

  bool get isSignedIn;

  // 사용자 검색
  Future<List<Map<String, dynamic>>> searchUsers(String query);

  // 팔로우 요청 보내기
  Future<void> sendFollowRequest(FollowRequestDto request);

  // 받은 팔로우 요청 목록 조회
  Future<List<FollowRequestDto>> getReceivedFollowRequests(String userId);

  // 보낸 팔로우 요청 목록 조회
  Future<List<FollowRequestDto>> getSentFollowRequests(String userId);

  // 팔로우 요청 수락
  Future<void> acceptFollowRequest(String requestId, String fromUserId, String toUserId);

  // 팔로우 요청 거절
  Future<void> rejectFollowRequest(String requestId);

  // 팔로우 관계 확인
  Future<bool> isFollowing(String fromUserId, String toUserId);

  // 언팔로우
  Future<void> unfollow(String fromUserId, String toUserId);

  // 팔로우한 사용자 목록 조회
  Future<List<Map<String, dynamic>>> getFollowingUsers(String userId);

  // 팔로워 목록 조회
  Future<List<Map<String, dynamic>>> getFollowers(String userId);

}
