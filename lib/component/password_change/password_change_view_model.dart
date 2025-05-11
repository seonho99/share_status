import 'package:flutter/material.dart';

import '../../core/result.dart';
import '../../domain/usecase/password_change_use_case.dart';
import 'password_change_state.dart';

class PasswordChangeViewModel extends ChangeNotifier {
  final PasswordChangeUseCase _passwordChangeUseCase;

  PasswordChangeViewModel(this._passwordChangeUseCase);

  PasswordChangeState _state = PasswordChangeState.initial();

  PasswordChangeState get state => _state;

  // 현재 비밀번호 변경
  void onCurrentPasswordChanged(String value) {
    _state = _state.copyWith(
      currentPassword: value,
      errorMessage: null,
      isSuccess: false,
    );
    notifyListeners();
  }

  // 새 비밀번호 변경
  void onNewPasswordChanged(String value) {
    _state = _state.copyWith(
      newPassword: value,
      errorMessage: null,
      isSuccess: false,
    );
    notifyListeners();
  }

  // 새 비밀번호 확인 변경
  void onConfirmPasswordChanged(String value) {
    _state = _state.copyWith(
      confirmPassword: value,
      errorMessage: null,
      isSuccess: false,
    );
    notifyListeners();
  }

  // 현재 비밀번호 가시성 토글
  void toggleCurrentPasswordVisibility() {
    _state = _state.copyWith(
      currentPasswordVisible: !_state.currentPasswordVisible,
    );
    notifyListeners();
  }

  // 새 비밀번호 가시성 토글
  void toggleNewPasswordVisibility() {
    _state = _state.copyWith(
      newPasswordVisible: !_state.newPasswordVisible,
    );
    notifyListeners();
  }

  // 새 비밀번호 확인 가시성 토글
  void toggleConfirmPasswordVisibility() {
    _state = _state.copyWith(
      confirmPasswordVisible: !_state.confirmPasswordVisible,
    );
    notifyListeners();
  }

  // 비밀번호 변경
  Future<void> changePassword({
    required VoidCallback onSuccess,
    required void Function(String error) onError,
  }) async {
    // 유효성 검사
    if (!state.canSubmit) {
      if (!state.isCurrentPasswordValid) {
        onError(state.currentPasswordError ?? '현재 비밀번호를 확인해주세요.');
        return;
      }
      if (!state.isNewPasswordValid) {
        onError(state.newPasswordError ?? '새 비밀번호를 확인해주세요.');
        return;
      }
      if (!state.isConfirmPasswordValid) {
        onError(state.confirmPasswordError ?? '비밀번호 확인을 확인해주세요.');
        return;
      }
    }

    // 로딩 시작
    _state = _state.copyWith(
      isLoading: true,
      errorMessage: null,
      isSuccess: false,
    );
    notifyListeners();

    // 비밀번호 변경 시도
    final result = await _passwordChangeUseCase.call(
      currentPassword: state.currentPassword,
      newPassword: state.newPassword,
    );

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

  // 상태 초기화
  void resetState() {
    _state = PasswordChangeState.initial();
    notifyListeners();
  }

  // 에러 초기화
  void clearError() {
    _state = _state.copyWith(errorMessage: null);
    notifyListeners();
  }
}