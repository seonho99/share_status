import '../../core/result.dart';
import '../repository/firebase_repository.dart';

class StatusUseCase {
  final FirebaseRepository _repository;

  StatusUseCase(this._repository);

  Future<Result<void>> saveStatus({
    required String statusMessage,
    required String statusTime,
    required int colorStatus,
  }) async {
    try {
      await _repository.saveUserStatus(
        statusMessage: statusMessage,
        statusTime: statusTime,
        colorStatus: colorStatus,
      );
      return const Result.success(null);
    } catch (error, stackTrace) {
      final failure = _mapErrorToFailure(error, stackTrace);
      return Result.error(failure);
    }
  }

  Future<Result<Map<String, dynamic>?>> getUserStatus() async {
    try {
      final status = await _repository.getUserStatus();
      return Result.success(status);
    } catch (error, stackTrace) {
      final failure = _mapErrorToFailure(error, stackTrace);
      return Result.error(failure);
    }
  }

  Failure _mapErrorToFailure(Object error, StackTrace stackTrace) {
    final errorString = error.toString();

    if (errorString.contains('network')) {
      return Failure(
        FailureType.network,
        '네트워크 연결을 확인해주세요.',
        cause: error,
        stackTrace: stackTrace,
      );
    } else {
      return Failure(
        FailureType.unknown,
        '상태 관련 작업 중 오류가 발생했습니다: $error',
        cause: error,
        stackTrace: stackTrace,
      );
    }
  }
}