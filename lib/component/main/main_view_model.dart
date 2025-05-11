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

        // 사용자 목록 로드 후 각 사용자의 상태도 로드
        await loadFollowingUsersStatus();
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

  // 팔로우한 사용자들의 상태 로드
  Future<void> loadFollowingUsersStatus() async {
    final result = await _followUseCase.getFollowingUsersStatus();

    switch (result) {
      case Success():
        _state = _state.copyWith(followingUsersStatus: result.data);
        break;
      case Error():
      // 상태 로드 실패는 치명적이지 않으므로 로그만 남김
        print('팔로우 사용자 상태 로드 실패: ${result.failure.message}');
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