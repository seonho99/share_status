import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/model/user_model.dart';

part 'main_state.freezed.dart';

@freezed
class MainState with _$MainState {
  const MainState({
    required this.followingUsers,
    required this.isLoading,
    this.errorMessage,
    required this.followingUsersStatus,
  });

  factory MainState.initial() => const MainState(
    followingUsers: [],
    isLoading: false,
    errorMessage: null,
    followingUsersStatus: {},
  );

  final List<UserModel> followingUsers;
  final bool isLoading;
  final String? errorMessage;
  final Map<String, Map<String, dynamic>> followingUsersStatus;
}