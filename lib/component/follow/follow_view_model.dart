import 'dart:async';

import 'package:flutter/material.dart';

import '../../core/result.dart';
import '../../domain/usecase/follow_usecase.dart';
import 'follow_state.dart';

class FollowViewModel extends ChangeNotifier {
  final FollowUseCase _followUseCase;

  FollowViewModel(this._followUseCase);

  FollowState _state = FollowState.initial();

  FollowState get state => _state;

  // 검색어 변경
  void onSearchQueryChanged(String query) {
    _state = _state.copyWith(searchQuery: query);
    notifyListeners();

    // 디바운싱 적용 (500ms)
    _debounceSearch();
  }

  Timer? _debounceTimer;

  void _debounceSearch() {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      if (_state.searchQuery.isNotEmpty) {
        searchUsers();
      } else {
        _state = _state.copyWith(searchResults: [], errorMessage: null);
        notifyListeners();
      }
    });
  }

  // 사용자 검색
  Future<void> searchUsers() async {
    if (_state.searchQuery.trim().isEmpty) {
      _state = _state.copyWith(
        searchResults: [],
        errorMessage: null,
        isSearching: false,
      );
      notifyListeners();
      return;
    }

    _state = _state.copyWith(isSearching: true, errorMessage: null);
    notifyListeners();

    final result = await _followUseCase.searchUsers(_state.searchQuery.trim());

    switch (result) {
      case Success<List<UserModel>>():
        _state = _state.copyWith(
          searchResults: result.data,
          isSearching: false,
          errorMessage: null,
        );
        break;
      case Error<List<UserModel>>():
        _state = _state.copyWith(
          searchResults: [],
          isSearching: false,
          errorMessage: result.failure.message,
        );
        break;
    }
    notifyListeners();
  }

  // 팔로우 요청 보내기
  Future<void> sendFollowRequest({
    required String toUserId,
    required String toUserName,
    required String toUserImageUrl,
    required VoidCallback onSuccess,
    required void Function(String error) onError,
  }) async {
    // 이미 요청 중인 사용자인지 확인
    if (_state.isRequestSending(toUserId)) {
      return;
    }

    // 요청 전송 중 상태 추가
    _state = _state.copyWith(
      sendingRequestTo: {..._state.sendingRequestTo, toUserId},
    );
    notifyListeners();

    final result = await _followUseCase.sendFollowRequest(
      toUserId: toUserId,
      toUserName: toUserName,
      toUserImageUrl: toUserImageUrl,
    );

    // 요청 전송 완료, 상태 제거
    final newSendingSet = Set<String>.from(_state.sendingRequestTo);
    newSendingSet.remove(toUserId);

    switch (result) {
      case Success<void>():
        _state = _state.copyWith(sendingRequestTo: newSendingSet);
        notifyListeners();
        onSuccess();
        break;
      case Error<void>():
        _state = _state.copyWith(sendingRequestTo: newSendingSet);
        notifyListeners();
        onError(result.failure.message);
        break;
    }
  }

  // 초기화
  void reset() {
    _state = FollowState.initial();
    notifyListeners();
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }
}