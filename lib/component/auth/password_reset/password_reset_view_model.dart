import 'package:flutter/material.dart';


import '../../../core/result.dart';
import '../../../domain/usecase/password_reset_usecase.dart';
import 'password_reset_state.dart';

class PasswordResetViewModel extends ChangeNotifier {
  final PasswordResetUseCase _passwordResetUseCase;

  PasswordResetViewModel(this._passwordResetUseCase);

  PasswordResetState _state = PasswordResetState.initial();

  PasswordResetState get state => _state;

  void onEmailChanged(String value) {
    _state = _state.copyWith(
      email: value,
      errorMessage: null,
      isSuccess: false,
    );
    notifyListeners();
  }

  Future<void> resetPassword({
    required VoidCallback onSuccess,
    required void Function(String error) onError,
  }) async {
    // 이메일 유효성 검사
    if (!state.isEmailValid) {
      onError(state.emailError ?? '이메일을 확인해주세요.');
      return;
    }

    // 로딩 시작
    _state = _state.copyWith(
      isLoading: true,
      errorMessage: null,
      isSuccess: false,
    );
    notifyListeners();

    // 비밀번호 재설정 이메일 전송
    final result = await _passwordResetUseCase.call(state.email);

    // 결과 처리
    switch (result) {
      case Success<void>():
        _state = _state.copyWith(
          isLoading: false,
          isSuccess: true,
        );
        notifyListeners();
        onSuccess();
        break;
      case Error<void>():
        _state = _state.copyWith(
          isLoading: false,
          errorMessage: result.failure.message,
          isSuccess: false,
        );
        notifyListeners();
        onError(result.failure.message);
        break;
    }
  }

  void clearError() {
    _state = _state.copyWith(errorMessage: null);
    notifyListeners();
  }

  void resetState() {
    _state = PasswordResetState.initial();
    notifyListeners();
  }
}