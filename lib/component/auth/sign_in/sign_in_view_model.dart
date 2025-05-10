import 'package:flutter/material.dart';

import '../../../core/result.dart';
import '../../../domain/usecase/sign_in_use_case.dart';
import 'sign_in_state.dart';

class SignInViewModel extends ChangeNotifier {
  final SignInUseCase _signInUseCase;

  SignInViewModel(this._signInUseCase);

  SignInState _state = SignInState.initial();

  SignInState get state => _state;

  void onEmailChanged(String value) {
    _state = _state.copyWith(email: value);
    notifyListeners();
  }

  void onPasswordChanged(String value) {
    _state = _state.copyWith(password: value);
    notifyListeners();
  }

  void togglePasswordVisibility() {
    _state = _state.copyWith(obscurePassword: !_state.obscurePassword);
    notifyListeners();
  }

  Future<void> signIn({
    required VoidCallback onSuccess,
    required void Function(String error) onError,
  }) async {
    // 입력값 유효성 검사
    if (!state.isFormValid) {
      if (!state.isEmailValid) {
        onError(state.emailError ?? '이메일을 확인해주세요.');
        return;
      }
      if (!state.isPasswordValid) {
        onError(state.passwordError ?? '비밀번호를 확인해주세요.');
        return;
      }
    }

    // 로딩 시작
    _state = _state.copyWith(isLoading: true, errorMessage: null);
    notifyListeners();

    // 로그인 시도
    final result = await _signInUseCase.call(
      email: state.email,
      password: state.password,
    );

    // 결과 처리 (freezed 3.0 방식)
    switch (result) {
      case Success<String>():
        _state = _state.copyWith(isLoading: false);
        notifyListeners();
        onSuccess();
        break;
      case Error<String>():
        _state = _state.copyWith(
          isLoading: false,
          errorMessage: result.failure.message,
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
}