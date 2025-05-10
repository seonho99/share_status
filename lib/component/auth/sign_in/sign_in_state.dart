import 'package:freezed_annotation/freezed_annotation.dart';

part 'sign_in_state.freezed.dart';

@freezed
class SignInState with _$SignInState {
  final String email;
  final String password;
  final bool isLoading;
  final bool obscurePassword;
  final String? errorMessage;

  const SignInState({
    required this.email,
    required this.password,
    required this.isLoading,
    required this.obscurePassword,
    this.errorMessage,
  });

  factory SignInState.initial() => const SignInState(
    email: '',
    password: '',
    isLoading: false,
    obscurePassword: true,
    errorMessage: null,
  );
}

extension SignInStateX on SignInState {
  bool get isEmailValid {
    final regex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    return regex.hasMatch(email);
  }

  bool get isPasswordValid => password.isNotEmpty;

  bool get isFormValid => isEmailValid && isPasswordValid && !isLoading;

  String? get emailError => isEmailValid ? null : '올바른 이메일 형식을 입력해주세요.';
  String? get passwordError => isPasswordValid ? null : '비밀번호를 입력해주세요.';
}