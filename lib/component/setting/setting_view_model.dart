import 'package:flutter/material.dart';

import '../../domain/usecase/sign_out_usecase.dart';

class SettingViewModel extends ChangeNotifier {
  final SignOutUseCase _signOutUseCase;

  SettingViewModel(this._signOutUseCase);

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> signOut({
    required VoidCallback onSuccess,
    required void Function(String error) onError,
  }) async {
    try {
      _isLoading = true;
      notifyListeners();

      await _signOutUseCase.call();

      onSuccess();
    } catch (e) {
      onError('로그아웃 중 오류가 발생했습니다: ${e.toString()}');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}