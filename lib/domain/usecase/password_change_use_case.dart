import '../../core/result.dart';
import '../repository/firebase_repository.dart';

class PasswordChangeUseCase {
  final FirebaseRepository _repository;

  PasswordChangeUseCase(this._repository);

  Future<Result<void>> call({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      await _repository.changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
      );
      return const Result.success(null);
    } catch (error, stackTrace) {
      // Firebase 에러를 Failure로 맵핑
      final failure = _mapFirebaseErrorToFailure(error, stackTrace);
      return Result.error(failure);
    }
  }

  Failure _mapFirebaseErrorToFailure(Object error, StackTrace stackTrace) {
    final errorString = error.toString();

    if (errorString.contains('wrong-password')) {
      return Failure(
        FailureType.unauthorized,
        '현재 비밀번호가 올바르지 않습니다.',
        cause: error,
        stackTrace: stackTrace,
      );
    } else if (errorString.contains('requires-recent-login')) {
      return Failure(
        FailureType.unauthorized,
        '보안을 위해 다시 로그인 후 시도해주세요.',
        cause: error,
        stackTrace: stackTrace,
      );
    } else if (errorString.contains('weak-password')) {
      return Failure(
        FailureType.parsing,
        '새 비밀번호가 너무 약합니다.',
        cause: error,
        stackTrace: stackTrace,
      );
    } else if (errorString.contains('network')) {
      return Failure(
        FailureType.network,
        '네트워크 연결을 확인해주세요.',
        cause: error,
        stackTrace: stackTrace,
      );
    } else {
      return Failure(
        FailureType.unknown,
        '비밀번호 변경 중 오류가 발생했습니다: ${error}',
        cause: error,
        stackTrace: stackTrace,
      );
    }
  }
}