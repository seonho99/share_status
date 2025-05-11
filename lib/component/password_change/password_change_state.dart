import 'package:freezed_annotation/freezed_annotation.dart';

part 'password_change_state.freezed.dart';

@freezed
class PasswordChangeState with _$PasswordChangeState {
  const PasswordChangeState({
    required this.currentPassword,
    required this.newPassword,
    required this.confirmPassword,
    required this.isLoading,
    required this.currentPasswordVisible,
    required this.newPasswordVisible,
    required this.confirmPasswordVisible,
    this.errorMessage,
    required this.isSuccess,
  });

  factory PasswordChangeState.initial() => const PasswordChangeState(
    currentPassword: '',
    newPassword: '',
    confirmPassword: '',
    isLoading: false,
    currentPasswordVisible: false,
    newPasswordVisible: false,
    confirmPasswordVisible: false,
    errorMessage: null,
    isSuccess: false,
  );

  final String currentPassword;
  final String newPassword;
  final String confirmPassword;
  final bool isLoading;
  final bool currentPasswordVisible;
  final bool newPasswordVisible;
  final bool confirmPasswordVisible;
  final String? errorMessage;
  final bool isSuccess;
}

extension PasswordChangeStateX on PasswordChangeState {
  bool get isCurrentPasswordValid => currentPassword.isNotEmpty;
  bool get isNewPasswordValid => newPassword.length >= 8;
  bool get isConfirmPasswordValid => confirmPassword == newPassword && confirmPassword.isNotEmpty;

  bool get canSubmit =>
      isCurrentPasswordValid &&
          isNewPasswordValid &&
          isConfirmPasswordValid &&
          !isLoading;

  String? get currentPasswordError =>
      !isCurrentPasswordValid ? '현재 비밀번호를 입력해주세요.' : null;
  String? get newPasswordError =>
      newPassword.isEmpty ? '새 비밀번호를 입력해주세요.'
          : !isNewPasswordValid ? '비밀번호는 8자 이상이어야 합니다.'
          : null;
  String? get confirmPasswordError =>
      confirmPassword.isEmpty ? '비밀번호 확인을 입력해주세요.'
          : !isConfirmPasswordValid ? '비밀번호가 일치하지 않습니다.'
          : null;
}