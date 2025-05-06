import 'package:flutter/material.dart';
import '../../domain/model/user_model.dart';
import '../../domain/usecase/sign_up_usecase.dart';
import '../../domain/usecase/user_usecase.dart';
import 'sign_up_state.dart';

class SignUpViewModel extends ChangeNotifier {
  final SignUpUseCase _signUpUseCase;
  final UserUseCase _userUseCase;

  SignUpViewModel(this._signUpUseCase, this._userUseCase);

  SignUpState _state = const SignUpState(
    nickname: '',
    email: '',
    password: '',
    confirmPassword: '',
    id: '',
    isCheckingId: false,
    isIdAvailable: false,
  );

  bool _isLoading = false;

  SignUpState get state => _state;
  bool get isLoading => _isLoading;

  void onNicknameChanged(String value) {
    _state = _state.copyWith(nickname: value);
    notifyListeners();
  }

  void onEmailChanged(String value) {
    _state = _state.copyWith(email: value);
    notifyListeners();
  }

  void onPasswordChanged(String value) {
    _state = _state.copyWith(password: value);
    notifyListeners();
  }

  void onConfirmPasswordChanged(String value) {
    _state = _state.copyWith(confirmPassword: value);
    notifyListeners();
  }

  void onIdChanged(String value) {
    _state = _state.copyWith(id: value, isIdAvailable: false);
    notifyListeners();
  }

  Future<void> checkId() async {
    _state = _state.copyWith(isCheckingId: true);
    notifyListeners();

    final isAvailable = await _userUseCase.callId(_state.id);

    _state = _state.copyWith(
      isIdAvailable: isAvailable,
      isCheckingId: false,
    );
    notifyListeners();
  }

  Future<void> signUp({
    required String imageUrl,
    required VoidCallback onSuccess,
    required void Function(String error) onError,
  }) async {
    if (!state.isFormValid) {
      onError('입력값을 다시 확인해주세요.');
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      final uid = await _signUpUseCase.call(
        email: state.email,
        password: state.password,
      );

      final user = UserModel(
        uid: uid,
        email: state.email,
        id: state.id,
        nickname: state.nickname,
        imageUrl: imageUrl,
      );

      await _userUseCase.call(user);

      onSuccess();
    } catch (e) {
      onError(e.toString());
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
