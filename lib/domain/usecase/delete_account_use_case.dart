import '../../core/result.dart';
import '../repository/firebase_repository.dart';

class DeleteAccountUseCase {
  final FirebaseRepository _repository;

  DeleteAccountUseCase(this._repository);

  Future<Result<void>> call({
    required String password,
  }) async {
    try {
      await _repository.deleteAccount(password: password);
      return const Result.success(null);
    } catch (error, stackTrace) {
      // Firebase 에러를 Failure로 매핑
      final failure = _mapErrorToFailure(error, stackTrace);
      return Result.error(failure);
    }
  }

  Failure _mapErrorToFailure(Object error, StackTrace stackTrace) {
    final errorString = error.toString();

    if (errorString.contains('wrong-password')) {
      return Failure(
        FailureType.unauthorized,
        '비밀번호가 올바르지 않습니다.',
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
        '계정 삭제 중 오류가 발생했습니다: ${error}',
        cause: error,
        stackTrace: stackTrace,
      );
    }
  }
}