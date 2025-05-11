import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;

import '../../core/result.dart';
import '../../domain/model/user_model.dart';
import '../../domain/repository/firebase_repository.dart';
import 'profile_edit_state.dart';

class ProfileEditViewModel extends ChangeNotifier {
  final FirebaseRepository _repository;
  final ImagePicker _imagePicker = ImagePicker();
  final FirebaseStorage _storage = FirebaseStorage.instance;

  ProfileEditViewModel(this._repository);

  ProfileEditState _state = ProfileEditState.initial();

  ProfileEditState get state => _state;

  // 초기 사용자 정보 로드
  Future<void> loadUserProfile() async {
    _state = _state.copyWith(isLoading: true, errorMessage: null);
    notifyListeners();

    try {
      final uid = _repository.currentUserId;
      if (uid == null) {
        _state = _state.copyWith(
          isLoading: false,
          errorMessage: '로그인이 필요합니다.',
        );
        return;
      }

      // Firestore에서 사용자 정보 조회
      final userData = await _getUserData(uid);
      if (userData != null) {
        _state = _state.copyWith(
          nickname: userData['nickname'] ?? '',
          imageUrl: userData['imageUrl'] ?? '',
          isLoading: false,
        );
      } else {
        _state = _state.copyWith(
          isLoading: false,
          errorMessage: '사용자 정보를 찾을 수 없습니다.',
        );
      }
    } catch (e) {
      _state = _state.copyWith(
        isLoading: false,
        errorMessage: '프로필 로딩 중 오류가 발생했습니다: ${e.toString()}',
      );
    }
    notifyListeners();
  }

  // Firestore에서 사용자 데이터 조회 (임시 구현)
  Future<Map<String, dynamic>?> _getUserData(String uid) async {
    // 실제 구현에서는 _repository를 통해 Firestore 조회
    // 현재는 임시 데이터 반환
    return {
      'nickname': '현재닉네임',
      'imageUrl': 'https://example.com/default_profile.png',
    };
  }

  // 닉네임 변경
  void onNicknameChanged(String value) {
    _state = _state.copyWith(nickname: value, errorMessage: null);
    notifyListeners();
  }

  // 이미지 선택
  Future<void> pickImage({bool fromCamera = false}) async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: fromCamera ? ImageSource.camera : ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 80,
      );

      if (image != null) {
        _state = _state.copyWith(
          selectedImage: File(image.path),
          errorMessage: null,
        );
        notifyListeners();
      }
    } catch (e) {
      _state = _state.copyWith(
        errorMessage: '이미지 선택 중 오류가 발생했습니다: ${e.toString()}',
      );
      notifyListeners();
    }
  }

  // 이미지 업로드
  Future<String?> _uploadImage(File imageFile) async {
    try {
      final uid = _repository.currentUserId;
      if (uid == null) return null;

      final fileName = 'profile_$uid${path.extension(imageFile.path)}';
      final ref = _storage.ref().child('profile_images/$fileName');

      // 업로드 상태 업데이트
      _state = _state.copyWith(isUploading: true);
      notifyListeners();

      final uploadTask = ref.putFile(imageFile);
      final snapshot = await uploadTask;
      final downloadUrl = await snapshot.ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      _state = _state.copyWith(
        errorMessage: '이미지 업로드 중 오류가 발생했습니다: ${e.toString()}',
      );
      notifyListeners();
      return null;
    } finally {
      _state = _state.copyWith(isUploading: false);
      notifyListeners();
    }
  }

  // 프로필 저장
  Future<void> saveProfile({
    required VoidCallback onSuccess,
    required void Function(String error) onError,
  }) async {
    if (!state.canSave) {
      onError(state.nicknameError ?? '입력값을 확인해주세요.');
      return;
    }

    _state = _state.copyWith(isLoading: true, errorMessage: null);
    notifyListeners();

    try {
      final uid = _repository.currentUserId;
      if (uid == null) {
        onError('로그인이 필요합니다.');
        return;
      }

      String? imageUrl = state.imageUrl;

      // 새로운 이미지가 선택된 경우 업로드
      if (state.selectedImage != null) {
        imageUrl = await _uploadImage(state.selectedImage!);
        if (imageUrl == null) {
          onError('이미지 업로드에 실패했습니다.');
          return;
        }
      }

      // Firestore 업데이트
      await _updateUserProfile(uid, state.nickname, imageUrl!);

      _state = _state.copyWith(
        isLoading: false,
        imageUrl: imageUrl,
        selectedImage: null, // 업로드 완료 후 선택된 이미지 제거
      );
      notifyListeners();

      onSuccess();
    } catch (e) {
      _state = _state.copyWith(
        isLoading: false,
        errorMessage: '프로필 업데이트 중 오류가 발생했습니다: ${e.toString()}',
      );
      notifyListeners();
      onError(_state.errorMessage!);
    }
  }

  // Firestore에 사용자 프로필 업데이트 (임시 구현)
  Future<void> _updateUserProfile(String uid, String nickname, String imageUrl) async {
    // 실제 구현에서는 _repository를 통해 Firestore 업데이트
    // 현재는 임시 구현
    await Future.delayed(Duration(seconds: 1)); // 서버 통신 시뮬레이션
  }

  // 상태 초기화
  void reset() {
    _state = ProfileEditState.initial();
    notifyListeners();
  }
}