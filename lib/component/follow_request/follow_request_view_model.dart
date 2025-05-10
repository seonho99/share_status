import 'package:flutter/material.dart';

import '../../core/result.dart';
import '../../domain/usecase/follow_usecase.dart';
import 'follow_request_state.dart';

class FollowRequestViewModel extends ChangeNotifier {
  final FollowUseCase _followUseCase;

  FollowRequestViewModel(this._followUseCase);

  FollowRequestState _state = FollowRequestState.initial();

  FollowRequestState get state => _state;

  // 팔로우 요청 목록 로드
  Future<void> loadFollowRequests() async {
    _state = _state.copyWith(isLoading: true, errorMessage: null);
    notifyListeners();

    final result = await _followUseCase.getReceivedFollowRequests();

    switch (result) {
      case Success():
        _state = _state.copyWith(
          followRequests: result.data,
          isLoading: false,
          errorMessage: null,
        );
        break;
      case Error():
        _state = _state.copyWith(
          followRequests: [],
          isLoading: false,
          errorMessage: result.failure.message,
        );
        break;
    }
    notifyListeners();
  }

  // 팔로우 요청 수락
  Future<void> acceptFollowRequest({
    required String requestId,
    required String fromUserId,
    required VoidCallback onSuccess,
    required void Function(String error) onError,
  }) async {
    if (_state.isRequestProcessing(requestId)) {
      return;
    }

    // 처리 중 상태 추가
    final newProcessingSet = Set<String>.from(_state.processingRequests);
    newProcessingSet.add(requestId);
    _state = _state.copyWith(processingRequests: newProcessingSet);
    notifyListeners();

    final result = await _followUseCase.acceptFollowRequest(
      requestId: requestId,
      fromUserId: fromUserId,
    );

    // 처리 완료, 상태 제거
    final updatedProcessingSet = Set<String>.from(_state.processingRequests);
    updatedProcessingSet.remove(requestId);

    switch (result) {
      case Success():
      // 수락된 요청을 목록에서 제거
        final updatedRequests = _state.followRequests
            .where((request) => request.id != requestId)
            .toList();

        _state = _state.copyWith(
          followRequests: updatedRequests,
          processingRequests: updatedProcessingSet,
        );
        notifyListeners();
        onSuccess();
        break;
      case Error():
        _state = _state.copyWith(processingRequests: updatedProcessingSet);
        notifyListeners();
        onError(result.failure.message);
        break;
    }
  }

  // 팔로우 요청 거절
  Future<void> rejectFollowRequest({
    required String requestId,
    required VoidCallback onSuccess,
    required void Function(String error) onError,
  }) async {
    if (_state.isRequestProcessing(requestId)) {
      return;
    }

    // 처리 중 상태 추가
    final newProcessingSet = Set<String>.from(_state.processingRequests);
    newProcessingSet.add(requestId);
    _state = _state.copyWith(processingRequests: newProcessingSet);
    notifyListeners();

    final result = await _followUseCase.rejectFollowRequest(requestId);

    // 처리 완료, 상태 제거
    final updatedProcessingSet = Set<String>.from(_state.processingRequests);
    updatedProcessingSet.remove(requestId);

    switch (result) {
      case Success():
      // 거절된 요청을 목록에서 제거
        final updatedRequests = _state.followRequests
            .where((request) => request.id != requestId)
            .toList();

        _state = _state.copyWith(
          followRequests: updatedRequests,
          processingRequests: updatedProcessingSet,
        );
        notifyListeners();
        onSuccess();
        break;
      case Error():
        _state = _state.copyWith(processingRequests: updatedProcessingSet);
        notifyListeners();
        onError(result.failure.message);
        break;
    }
  }

  // 상태 초기화
  void reset() {
    _state = FollowRequestState.initial();
    notifyListeners();
  }
}