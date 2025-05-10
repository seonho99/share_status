import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/model/user_model.dart';

part 'follow_state.freezed.dart';

@freezed
class FollowState with _$FollowState {
  const FollowState({
    required this.searchQuery,
    required this.searchResults,
    required this.isSearching,
    required this.errorMessage,
    required this.sendingRequestTo,
  });

  factory FollowState.initial() => const FollowState(
    searchQuery: '',
    searchResults: [],
    isSearching: false,
    errorMessage: null,
    sendingRequestTo: {},
  );

  final String searchQuery;
  final List<UserModel> searchResults;
  final bool isSearching;
  final String? errorMessage;
  final Set<String> sendingRequestTo;
}

extension FollowStateX on FollowState {
  bool isRequestSending(String userId) => sendingRequestTo.contains(userId);
}