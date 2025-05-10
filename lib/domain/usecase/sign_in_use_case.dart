import '../../core/result.dart';
import '../repository/firebase_repository.dart';

class SignInUseCase {
  final FirebaseRepository _repository;

  SignInUseCase(this._repository);

  Future<Result<String>> call({
    required String email,
    required String password,
  }) async {
    try {
      final uid = await _repository.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return Result.success(uid);
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
        '등록되지 않은 이메일입니다.',
        cause: error,
        stackTrace: stackTrace,
      );
    } else if (errorString.contains('wrong-password')) {
      return Failure(
        FailureType.unauthorized,
        '비밀번호가 올바르지 않습니다.',
        cause: error,
        stackTrace: stackTrace,
      );
    } else if (errorString.contains('too-many-requests')) {
      return Failure(
        FailureType.timeout,
        '너무 많은 시도가 있었습니다. 잠시 후 다시 시도해주세요.',
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
        '로그인 중 오류가 발생했습니다: ${error}',
        cause: error,
        stackTrace: stackTrace,
      );
    }
  }
}