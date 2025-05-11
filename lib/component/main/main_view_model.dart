import 'package:flutter/material.dart';

import '../../core/result.dart';
import '../../domain/usecase/follow_usecase.dart';
import 'main_state.dart';

class MainViewModel extends ChangeNotifier {
  final FollowUseCase _followUseCase;

  MainViewModel(this._followUseCase);

  MainState _state = MainState.initial();

  MainState get state => _state;

  // 팔로우한 사용자 목록 로드
  Future<void> loadFollowingUsers() async {
    _state = _state.copyWith(isLoading: true, errorMessage: null);
    notifyListeners();

    final result = await _followUseCase.getFollowingUsers();

    switch (result) {
      case Success():
        _state = _state.copyWith(
          followingUsers: result.data,
          isLoading: false,
          errorMessage: null,
        );
        break;
      case Error():
        _state = _state.copyWith(
          followingUsers: [],
          isLoading: false,
          errorMessage: result.failure.message,
        );
        break;
    }
    notifyListeners();
  }

  // 상태 초기화
  void reset() {
    _state = MainState.initial();
    notifyListeners();
  }
}