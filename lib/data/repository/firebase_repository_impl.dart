import 'package:share_status/data/mapper/follow_request_mapper.dart';

import '../../domain/model/follow_request.dart';
import '../../domain/model/user_model.dart';
import '../../domain/repository/firebase_repository.dart';
import '../data_source/firebase_data_source.dart';
import '../dto/user_dto.dart';
import '../mapper/user_mapper.dart';

class FirebaseRepositoryImpl implements FirebaseRepository {
  final FirebaseDataSource _dataSource;

  FirebaseRepositoryImpl(this._dataSource);

  @override
  Future<void> createUser(UserModel user) {
    final dto = user.toDto();
    return _dataSource.saveUser(dto);
  }

  @override
  Future<bool> isIdAvailable(String id) {
    return _dataSource.checkIdExists(id);
  }

  @override
  Future<String> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) {
    return _dataSource.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  @override
  Future<void> signOut() {
    return _dataSource.signOut();
  }

  @override
  Future<void> sendPasswordResetEmail(String email) {
    return _dataSource.sendPasswordResetEmail(email);
  }

  @override
  String? get currentUserId => _dataSource.currentUserId;

  @override
  bool get isSignedIn => _dataSource.isSignedIn;

  // 팔로우 관련 메서드
  @override
  Future<List<UserModel>> searchUsers(String query) async {
    final data = await _dataSource.searchUsers(query);
    return data.map((json) => UserDto.fromJson(json).toDomain()).toList();
  }

  @override
  Future<void> sendFollowRequest(FollowRequest request) {
    final dto = request.toDto();
    return _dataSource.sendFollowRequest(dto);
  }

  @override
  Future<List<FollowRequest>> getReceivedFollowRequests(String userId) async {
    final dtos = await _dataSource.getReceivedFollowRequests(userId);
    return dtos.map((dto) => dto.toDomain()).toList();
  }

  @override
  Future<List<FollowRequest>> getSentFollowRequests(String userId) async {
    final dtos = await _dataSource.getSentFollowRequests(userId);
    return dtos.map((dto) => dto.toDomain()).toList();
  }

  @override
  Future<void> acceptFollowRequest(String requestId,
      String fromUserId,
      String toUserId,) {
    return _dataSource.acceptFollowRequest(requestId, fromUserId, toUserId);
  }

  @override
  Future<void> rejectFollowRequest(String requestId) {
    return _dataSource.rejectFollowRequest(requestId);
  }

  @override
  Future<bool> isFollowing(String fromUserId, String toUserId) {
    return _dataSource.isFollowing(fromUserId, toUserId);
  }

  @override
  Future<void> unfollow(String fromUserId, String toUserId) {
    return _dataSource.unfollow(fromUserId, toUserId);
  }

  @override
  Future<List<UserModel>> getFollowingUsers(String userId) async {
    final data = await _dataSource.getFollowingUsers(userId);
    return data.map((json) => UserDto.fromJson(json).toDomain()).toList();
  }

  @override
  Future<List<UserModel>> getFollowers(String userId) async {
    final data = await _dataSource.getFollowers(userId);
    return data.map((json) => UserDto.fromJson(json).toDomain()).toList();
  }

  @override
  Future<void> saveUserStatus({
    required String statusMessage,
    required String statusTime,
    required int colorStatus,
  }) async {
    final userId = _dataSource.currentUserId;
    if (userId == null) {
      throw Exception('로그인된 사용자가 없습니다.');
    }

    return _dataSource.saveUserStatus(
      userId: userId,
      statusMessage: statusMessage,
      statusTime: statusTime,
      colorStatus: colorStatus,
    );
  }

  @override
  Future<Map<String, dynamic>?> getUserStatus() async {
    final userId = _dataSource.currentUserId;
    if (userId == null) {
      throw Exception('로그인된 사용자가 없습니다.');
    }

    return _dataSource.getUserStatus(userId);
  }

  @override
  Future<Map<String, Map<String, dynamic>>> getFollowingUsersStatus(
      List<String> userIds,) async {
    return _dataSource.getFollowingUsersStatus(userIds);
  }

  // 프로필 관련 메서드 추가
  @override
  Future<UserModel> getUserProfile(String userId) async {
    final data = await _dataSource.getUserProfile(userId);
    if (data == null) {
      throw Exception('사용자 정보를 찾을 수 없습니다.');
    }
    return UserDto.fromJson(data).toDomain();
  }

  @override
  Future<void> updateUserProfile({
    required String userId,
    required String nickname,
    required String imageUrl,
  }) async {
    return _dataSource.updateUserProfile(
      userId: userId,
      nickname: nickname,
      imageUrl: imageUrl,
    );
  }

  // 비밀번호 변경 메서드 추가
  @override
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    return _dataSource.changePassword(
      currentPassword: currentPassword,
      newPassword: newPassword,
    );
  }

  @override
  Future<void> deleteAccount({required String password}) async {
    return _dataSource.deleteAccount(password: password);
  }
}