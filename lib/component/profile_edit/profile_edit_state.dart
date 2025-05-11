import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:io';

part 'profile_edit_state.freezed.dart';

@freezed
class ProfileEditState with _$ProfileEditState {
  const ProfileEditState({
    required this.nickname,
    required this.imageUrl,
    this.selectedImage,
    required this.isLoading,
    required this.isUploading,
    this.errorMessage,
  });

  factory ProfileEditState.initial() => const ProfileEditState(
    nickname: '',
    imageUrl: '',
    selectedImage: null,
    isLoading: false,
    isUploading: false,
    errorMessage: null,
  );

  final String nickname;
  final String imageUrl;
  final File? selectedImage;
  final bool isLoading;
  final bool isUploading;
  final String? errorMessage;
}

extension ProfileEditStateX on ProfileEditState {
  bool get isNicknameValid => nickname.isNotEmpty && nickname.length <= 5;
  bool get canSave => isNicknameValid && !isLoading && !isUploading;

  String? get nicknameError {
    if (nickname.isEmpty) return '닉네임을 입력해주세요.';
    if (nickname.length > 5) return '닉네임은 5자 이하로 입력해주세요.';
    return null;
  }
}