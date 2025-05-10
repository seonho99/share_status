import 'package:freezed_annotation/freezed_annotation.dart';

part 'password_reset_state.freezed.dart';

@freezed
class PasswordResetState with _$PasswordResetState {
  final String email;
  final bool isLoading;
  final String? errorMessage;
  final bool isSuccess;

  const PasswordResetState({
    required this.email,
    required this.isLoading,
    this.errorMessage,
    required this.isSuccess,
  });

  factory PasswordResetState.initial() => const PasswordResetState(
    email: '',
    isLoading: false,
    errorMessage: null,
    isSuccess: false,
  );
}

extension PasswordResetStateX on PasswordResetState {
  bool get isEmailValid {
    final regex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    return regex.hasMatch(email);
  }

  bool get canSubmit => isEmailValid && !isLoading;

  String? get emailError => isEmailValid ? null : '올바른 이메일 형식을 입력해주세요.';
}