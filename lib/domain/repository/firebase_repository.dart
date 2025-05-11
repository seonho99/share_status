import '../model/follow_request.dart';
import '../model/user_model.dart';

abstract interface class FirebaseRepository {
  Future<void> createUser(UserModel user);

  Future<bool> isIdAvailable(String id);

  Future<String> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<void> signOut();

  Future<void> sendPasswordResetEmail(String email);

  String? get currentUserId;

  bool get isSignedIn;

  // 팔로우 관련 메서드
  // 사용자 검색
  Future<List<UserModel>> searchUsers(String query);

  // 팔로우 요청 보내기
  Future<void> sendFollowRequest(FollowRequest request);

  // 받은 팔로우 요청 목록 조회
  Future<List<FollowRequest>> getReceivedFollowRequests(String userId);

  // 보낸 팔로우 요청 목록 조회
  Future<List<FollowRequest>> getSentFollowRequests(String userId);

  // 팔로우 요청 수락
  Future<void> acceptFollowRequest(
    String requestId,
    String fromUserId,
    String toUserId,
  );

  // 팔로우 요청 거절
  Future<void> rejectFollowRequest(String requestId);

  // 팔로우 관계 확인
  Future<bool> isFollowing(String fromUserId, String toUserId);

  // 언팔로우
  Future<void> unfollow(String fromUserId, String toUserId);

  // 팔로우한 사용자 목록 조회
  Future<List<UserModel>> getFollowingUsers(String userId);

  // 팔로워 목록 조회
  Future<List<UserModel>> getFollowers(String userId);

  // 상태 관련 메서드 추가
  Future<void> saveUserStatus({
    required String statusMessage,
    required String statusTime,
    required int colorStatus,
  });

  Future<Map<String, dynamic>?> getUserStatus();

  // 팔로우한 사용자들의 상태 조회 메서드 추가
  Future<Map<String, Map<String, dynamic>>> getFollowingUsersStatus(List<String> userIds);
}
