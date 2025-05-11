import 'package:freezed_annotation/freezed_annotation.dart';

part 'navigation_state.freezed.dart';

@freezed
class NavigationState with _$NavigationState {
  const NavigationState({
    required this.currentIndex,
    required this.shouldRefreshMain,
  });

  final int currentIndex;
  final bool shouldRefreshMain;

  factory NavigationState.initial() => const NavigationState(
    currentIndex: 0,
    shouldRefreshMain: false,
  );
}