import 'package:flutter/material.dart';

import '../../core/result.dart';
import '../../domain/usecase/delete_account_use_case.dart';

class TermsViewModel extends ChangeNotifier {
  final DeleteAccountUseCase _deleteAccountUseCase;

  TermsViewModel(this._deleteAccountUseCase);

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> deleteAccount({
    required String password,
    required VoidCallback onSuccess,
    required void Function(String error) onError,
  }) async {
    _isLoading = true;
    notifyListeners();

    final result = await _deleteAccountUseCase.call(password: password);

    _isLoading = false;
    notifyListeners();

    switch (result) {
      case Success<void>():
        onSuccess();
        break;
      case Error<void>():
        onError(result.failure.message);
        break;
    }
  }
}