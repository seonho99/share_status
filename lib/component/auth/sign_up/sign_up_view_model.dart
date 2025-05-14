import 'package:flutter/material.dart';

import '../../../domain/model/user_model.dart';
import '../../../domain/usecase/sign_up_usecase.dart';
import '../../../domain/usecase/user_usecase.dart';
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
    _state = _state.copyWith(id: value);
    notifyListeners();
  }

  Future<void> signUp({
    required String imageUrl,
    required VoidCallback onSuccess,
    required void Function(String error) onError,
  }) async {
    // 입력값 유효성 검사
    if (!state.isNicknameValid) {
      onError('닉네임은 5자 이하로 입력해주세요.');
      return;
    }
    if (!state.isEmailValid) {
      onError('올바른 이메일 형식을 입력해주세요.');
      return;
    }
    if (!state.isPasswordValid) {
      onError('비밀번호는 8자 이상이어야 합니다.');
      return;
    }
    if (!state.isConfirmPasswordValid) {
      onError('비밀번호가 일치하지 않습니다.');
      return;
    }
    if (state.id.isEmpty) {
      onError('ID를 입력해주세요.');
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      // 1. ID 중복 체크 - 에러 처리 구체화
      print('ID 중복 체크 시작: ${state.id}');
      _state = _state.copyWith(isCheckingId: true);
      notifyListeners();

      final isAvailable = await _userUseCase.callId(state.id);
      print('ID 중복 체크 결과: $isAvailable');

      _state = _state.copyWith(
          isCheckingId: false,
          isIdAvailable: isAvailable
      );
      notifyListeners();

      if (!isAvailable) {
        _isLoading = false;
        notifyListeners();
        onError('이미 사용 중인 아이디입니다.');
        return;
      }

      // 2. Firebase Authentication에 사용자 생성
      print('Firebase Authentication 사용자 생성 시작');
      final uid = await _signUpUseCase.call(
        email: state.email,
        password: state.password,
      );
      print('Firebase Authentication 사용자 생성 완료: $uid');

      // 3. Firestore에 사용자 정보 저장
      print('Firestore 사용자 정보 저장 시작');
      final user = UserModel(
        uid: uid,
        email: state.email,
        id: state.id,
        nickname: state.nickname,
        imageUrl: imageUrl,
      );

      await _userUseCase.call(user);
      print('Firestore 사용자 정보 저장 완료');

      onSuccess();
    } catch (e) {
      print('회원가입 중 오류 발생: $e');
      onError('회원가입 중 오류가 발생했습니다.\n${e.toString()}');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

}
