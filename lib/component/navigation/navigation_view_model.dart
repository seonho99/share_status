import 'package:flutter/material.dart';
import 'navigation_state.dart';

class NavigationViewModel extends ChangeNotifier {
  NavigationState _state = NavigationState.initial();

  NavigationState get state => _state;

  // 현재 인덱스 업데이트
  void updateCurrentIndex(int index) {
    _state = _state.copyWith(currentIndex: index);
    notifyListeners();
  }

  // 프로필 업데이트 알림 설정
  void setProfileUpdated() {
    _state = _state.copyWith(shouldRefreshMain: true);
    notifyListeners();
  }

  // 메인 화면 새로고침 완료 처리
  void clearProfileUpdateFlag() {
    _state = _state.copyWith(shouldRefreshMain: false);
    notifyListeners();
  }

  // 메인 화면으로 이동하면서 프로필 업데이트 플래그 확인
  void navigateToMain(Function(int) goBranch) {
    goBranch(0);
    updateCurrentIndex(0);

    // 프로필 업데이트가 있었다면 MainScreen에 알림
    if (_state.shouldRefreshMain) {
      // 다음 프레임에서 플래그 클리어
      WidgetsBinding.instance.addPostFrameCallback((_) {
        clearProfileUpdateFlag();
      });
    }
  }

  // 설정 화면으로 이동
  void navigateToSettings(Function(int) goBranch) {
    goBranch(1);
    updateCurrentIndex(1);
  }
}