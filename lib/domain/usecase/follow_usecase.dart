import '../../core/result.dart';
import '../model/follow_request.dart';
import '../model/user_model.dart';
import '../repository/firebase_repository.dart';

class FollowUseCase {
  final FirebaseRepository _repository;

  FollowUseCase(this._repository);

  // 사용자 검색
  Future<Result<List<UserModel>>> searchUsers(String query) async {
    try {
      final users = await _repository.searchUsers(query);
      return Result.success(users);
    } catch (error, stackTrace) {
      final failure = _mapErrorToFailure(error, stackTrace);
      return Result.error(failure);
    }
  }

  // 팔로우 요청 보내기
  Future<Result<void>> sendFollowRequest({
    required String toUserId,
    required String toUserName,
    required String toUserImageUrl,
  }) async {
    try {
      final currentUserId = _repository.currentUserId;
      if (currentUserId == null) {
        return Result.error(
          Failure(
            FailureType.unauthorized,
            '로그인이 필요합니다.',
          ),
        );
      }

      final request = FollowRequest(
        fromUserId: currentUserId,
        toUserId: toUserId,
        toUserName: toUserName,
        toUserImageUrl: toUserImageUrl,
        createdAt: DateTime.now(),
      );

      await _repository.sendFollowRequest(request);
      return const Result.success(null);
    } catch (error, stackTrace) {
      final failure = _mapErrorToFailure(error, stackTrace);
      return Result.error(failure);
    }
  }

  // 받은 팔로우 요청 목록 조회
  Future<Result<List<FollowRequest>>> getReceivedFollowRequests() async {
    try {
      final currentUserId = _repository.currentUserId;
      if (currentUserId == null) {
        return Result.error(
          Failure(
            FailureType.unauthorized,
            '로그인이 필요합니다.',
          ),
        );
      }

      final requests = await _repository.getReceivedFollowRequests(currentUserId);
      return Result.success(requests);
    } catch (error, stackTrace) {
      final failure = _mapErrorToFailure(error, stackTrace);
      return Result.error(failure);
    }
  }

  // 보낸 팔로우 요청 목록 조회
  Future<Result<List<FollowRequest>>> getSentFollowRequests() async {
    try {
      final currentUserId = _repository.currentUserId;
      if (currentUserId == null) {
        return Result.error(
          Failure(
            FailureType.unauthorized,
            '로그인이 필요합니다.',
          ),
        );
      }

      final requests = await _repository.getSentFollowRequests(currentUserId);
      return Result.success(requests);
    } catch (error, stackTrace) {
      final failure = _mapErrorToFailure(error, stackTrace);
      return Result.error(failure);
    }
  }

  // 팔로우 요청 수락
  Future<Result<void>> acceptFollowRequest({
    required String requestId,
    required String fromUserId,
  }) async {
    try {
      final currentUserId = _repository.currentUserId;
      if (currentUserId == null) {
        return Result.error(
          Failure(
            FailureType.unauthorized,
            '로그인이 필요합니다.',
          ),
        );
      }

      await _repository.acceptFollowRequest(requestId, fromUserId, currentUserId);
      return const Result.success(null);
    } catch (error, stackTrace) {
      final failure = _mapErrorToFailure(error, stackTrace);
      return Result.error(failure);
    }
  }

  // 팔로우 요청 거절
  Future<Result<void>> rejectFollowRequest(String requestId) async {
    try {
      await _repository.rejectFollowRequest(requestId);
      return const Result.success(null);
    } catch (error, stackTrace) {
      final failure = _mapErrorToFailure(error, stackTrace);
      return Result.error(failure);
    }
  }

  // 팔로우 관계 확인
  Future<Result<bool>> isFollowing(String toUserId) async {
    try {
      final currentUserId = _repository.currentUserId;
      if (currentUserId == null) {
        return Result.error(
          Failure(
            FailureType.unauthorized,
            '로그인이 필요합니다.',
          ),
        );
      }

      final isFollowing = await _repository.isFollowing(currentUserId, toUserId);
      return Result.success(isFollowing);
    } catch (error, stackTrace) {
      final failure = _mapErrorToFailure(error, stackTrace);
      return Result.error(failure);
    }
  }

  // 언팔로우
  Future<Result<void>> unfollow(String toUserId) async {
    try {
      final currentUserId = _repository.currentUserId;
      if (currentUserId == null) {
        return Result.error(
          Failure(
            FailureType.unauthorized,
            '로그인이 필요합니다.',
          ),
        );
      }

      await _repository.unfollow(currentUserId, toUserId);
      return const Result.success(null);
    } catch (error, stackTrace) {
      final failure = _mapErrorToFailure(error, stackTrace);
      return Result.error(failure);
    }
  }

  // 팔로우한 사용자 목록 조회
  Future<Result<List<UserModel>>> getFollowingUsers() async {
    try {
      final currentUserId = _repository.currentUserId;
      if (currentUserId == null) {
        return Result.error(
          Failure(
            FailureType.unauthorized,
            '로그인이 필요합니다.',
          ),
        );
      }

      final users = await _repository.getFollowingUsers(currentUserId);
      return Result.success(users);
    } catch (error, stackTrace) {
      final failure = _mapErrorToFailure(error, stackTrace);
      return Result.error(failure);
    }
  }

  // 팔로워 목록 조회
  Future<Result<List<UserModel>>> getFollowers() async {
    try {
      final currentUserId = _repository.currentUserId;
      if (currentUserId == null) {
        return Result.error(
          Failure(
            FailureType.unauthorized,
            '로그인이 필요합니다.',
          ),
        );
      }

      final users = await _repository.getFollowers(currentUserId);
      return Result.success(users);
    } catch (error, stackTrace) {
      final failure = _mapErrorToFailure(error, stackTrace);
      return Result.error(failure);
    }
  }

  // 에러를 Failure로 맵핑
  Failure _mapErrorToFailure(Object error, StackTrace stackTrace) {
    final errorString = error.toString();

    if (errorString.contains('network')) {
      return Failure(
        FailureType.network,
        '네트워크 연결을 확인해주세요.',
        cause: error,
        stackTrace: stackTrace,
      );
    } else if (errorString.contains('timeout')) {
      return Failure(
        FailureType.timeout,
        '요청 시간이 초과되었습니다.',
        cause: error,
        stackTrace: stackTrace,
      );
    } else {
      return Failure(
        FailureType.unknown,
        '팔로우 기능 중 오류가 발생했습니다: $error',
        cause: error,
        stackTrace: stackTrace,
      );
    }
  }
}