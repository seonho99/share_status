import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/model/follow_request.dart';

part 'follow_request_state.freezed.dart';

@freezed
class FollowRequestState with _$FollowRequestState {
  const FollowRequestState({
    required this.followRequests,
    required this.isLoading,
    required this.errorMessage,
    required this.processingRequests,
  });

  factory FollowRequestState.initial() => const FollowRequestState(
    followRequests: [],
    isLoading: false,
    errorMessage: null,
    processingRequests: {},
  );

  final List<FollowRequest> followRequests;
  final bool isLoading;
  final String? errorMessage;
  final Set<String> processingRequests; // 현재 처리 중인 요청 ID들
}

extension FollowRequestStateX on FollowRequestState {
  bool isRequestProcessing(String requestId) => processingRequests.contains(requestId);
}