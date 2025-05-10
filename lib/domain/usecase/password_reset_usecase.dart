import '../../core/result.dart';
import '../repository/firebase_repository.dart';

class PasswordResetUseCase {
  final FirebaseRepository _repository;

  PasswordResetUseCase(this._repository);

  Future<Result<void>> call(String email) async {
    try {
      await _repository.sendPasswordResetEmail(email);
      return const Result.success(null);
    } catch (error, stackTrace) {
      // Firebase 에러를 Failure로 맵핑
      final failure = _mapFirebaseErrorToFailure(error, stackTrace);
      return Result.error(failure);
    }
  }

  Failure _mapFirebaseErrorToFailure(Object error, StackTrace stackTrace) {
    final errorString = error.toString();

    if (errorString.contains('user-not-found')) {
      return Failure(
        FailureType.unauthorized,
        '해당 이메일로 등록된 계정이 없습니다.',
        cause: error,
        stackTrace: stackTrace,
      );
    } else if (errorString.contains('invalid-email')) {
      return Failure(
        FailureType.parsing,
        '올바른 이메일 형식이 아닙니다.',
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
        '비밀번호 재설정 이메일 전송 중 오류가 발생했습니다: ${error}',
        cause: error,
        stackTrace: stackTrace,
      );
    }
  }
}