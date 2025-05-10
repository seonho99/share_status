import 'package:freezed_annotation/freezed_annotation.dart';

part 'sign_up_state.freezed.dart';

@freezed
class SignUpState with _$SignUpState {
  final String nickname;
  final String email;
  final String password;
  final String confirmPassword;
  final String id;
  final bool isCheckingId;
  final bool isIdAvailable;

  const SignUpState({
    required this.nickname,
    required this.email,
    required this.password,
    required this.confirmPassword,
    required this.id,
    required this.isCheckingId,
    required this.isIdAvailable,
  });
}

extension SignUpStateX on SignUpState {
  // 유효성 여부
  bool get isNicknameValid => nickname.length <= 5;
  bool get isEmailValid {
    final regex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    return regex.hasMatch(email);
  }
  bool get isPasswordValid => password.length >= 8;
  bool get isConfirmPasswordValid => confirmPassword == password;
  bool get isIdValid => id.isNotEmpty && isIdAvailable;

  bool get isFormValid =>
      isNicknameValid &&
          isEmailValid &&
          isPasswordValid &&
          isConfirmPasswordValid &&
          isIdValid;

  String? get nicknameError =>
      isNicknameValid ? null : '닉네임은 5자 이하로 입력해주세요.';
  String? get emailError =>
      isEmailValid ? null : '올바른 이메일 형식을 입력해주세요.';
  String? get passwordError =>
      isPasswordValid ? null : '비밀번호는 8자 이상 입력해주세요.';
  String? get confirmPasswordError =>
      isConfirmPasswordValid ? null : '비밀번호가 일치하지 않습니다.';
  String? get idError =>
      isIdValid ? null : '아이디가 중복되었거나 입력되지 않았습니다.';
}

