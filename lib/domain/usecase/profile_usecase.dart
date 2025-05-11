import '../../core/result.dart';
import '../model/user_model.dart';
import '../repository/firebase_repository.dart';

class ProfileUseCase {
  final FirebaseRepository _repository;

  ProfileUseCase(this._repository);

  // 현재 사용자 프로필 조회
  Future<Result<UserModel>> getCurrentUserProfile() async {
    try {
      final currentUserId = _repository.currentUserId;
      if (currentUserId == null) {
        return Result.error(Failure(FailureType.unauthorized, '로그인이 필요합니다.'));
      }

      final userProfile = await _repository.getUserProfile(currentUserId);
      return Result.success(userProfile);
    } catch (error, stackTrace) {
      final failure = _mapErrorToFailure(error, stackTrace);
      return Result.error(failure);
    }
  }

  // 사용자 프로필 업데이트
  Future<Result<void>> updateUserProfile({
    required String nickname,
    required String imageUrl,
  }) async {
    try {
      final currentUserId = _repository.currentUserId;
      if (currentUserId == null) {
        return Result.error(Failure(FailureType.unauthorized, '로그인이 필요합니다.'));
      }

      // 닉네임 유효성 검사
      if (nickname.isEmpty || nickname.length > 5) {
        return Result.error(Failure(
          FailureType.unknown,
          '닉네임은 1자 이상 5자 이하여야 합니다.',
        ));
      }

      await _repository.updateUserProfile(
        userId: currentUserId,
        nickname: nickname,
        imageUrl: imageUrl,
      );

      return const Result.success(null);
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
    } else if (errorString.contains('permission-denied')) {
      return Failure(
        FailureType.unauthorized,
        '권한이 없습니다.',
        cause: error,
        stackTrace: stackTrace,
      );
    } else {
      return Failure(
        FailureType.unknown,
        '프로필 관련 작업 중 오류가 발생했습니다: $error',
        cause: error,
        stackTrace: stackTrace,
      );
    }
  }
}