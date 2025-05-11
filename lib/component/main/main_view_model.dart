import 'package:flutter/material.dart';
import '../../core/result.dart';
import '../../domain/model/user_model.dart';
import '../../domain/usecase/follow_usecase.dart';
import 'main_state.dart';

class MainViewModel extends ChangeNotifier {
  final FollowUseCase _followUseCase;

  MainViewModel(this._followUseCase);

  MainState _state = MainState.initial();

  MainState get state => _state;

  // 팔로우한 사용자 목록 로드
  Future<void> loadFollowingUsers() async {
    _state = _state.copyWith(isLoading: true);
    notifyListeners();

    final result = await _followUseCase.getFollowingUsers();

    switch (result) {
      case Success<List<UserModel>>():
        _state = _state.copyWith(
          followingUsers: result.data,
          isLoading: false,
          errorMessage: null,
        );
        break;
      case Error<List<UserModel>>():
        _state = _state.copyWith(
          isLoading: false,
          errorMessage: result.failure.message,
        );
        break;
    }
    notifyListeners();
  }

  // 상태 메시지 업데이트
  void updateStatusMessage(String message, String time, Color color) {
    // 여기에 상태 메시지 업데이트 로직 구현
    // Firebase에 저장하거나 상태를 업데이트하는 코드 추가
  }
}