import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;

import '../../core/result.dart';
import '../../domain/usecase/profile_usecase.dart';
import 'profile_edit_state.dart';

class ProfileEditViewModel extends ChangeNotifier {
  final ProfileUseCase _profileUseCase;
  final ImagePicker _imagePicker = ImagePicker();
  final FirebaseStorage _storage = FirebaseStorage.instance;

  ProfileEditViewModel(this._profileUseCase);

  ProfileEditState _state = ProfileEditState.initial();

  ProfileEditState get state => _state;

  // 초기 사용자 정보 로드
  Future<void> loadUserProfile() async {
    _state = _state.copyWith(isLoading: true, errorMessage: null);
    notifyListeners();

    try {
      final result = await _profileUseCase.getCurrentUserProfile();

      switch (result) {
        case Success():
          _state = _state.copyWith(
            nickname: result.data.nickname,
            imageUrl: result.data.imageUrl,
            isLoading: false,
          );
          break;
        case Error():
          _state = _state.copyWith(
            isLoading: false,
            errorMessage: result.failure.message,
          );
          break;
      }
    } catch (e) {
      _state = _state.copyWith(
        isLoading: false,
        errorMessage: '프로필 로딩 중 오류가 발생했습니다: ${e.toString()}',
      );
    }
    notifyListeners();
  }

  // 닉네임 변경
  void onNicknameChanged(String value) {
    _state = _state.copyWith(nickname: value, errorMessage: null);
    notifyListeners();
  }

  // 이미지 선택
  Future<void> pickImage({bool fromCamera = false}) async {
    try {
      print('이미지 선택 시작: ${fromCamera ? "카메라" : "갤러리"}');

      final XFile? image = await _imagePicker.pickImage(
        source: fromCamera ? ImageSource.camera : ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 80,
      );

      if (image != null) {
        print('이미지 선택 완료: ${image.path}');
        final imageFile = File(image.path);
        final fileSize = await imageFile.length();
        print('파일 크기: ${(fileSize / (1024 * 1024)).toStringAsFixed(2)}MB');

        _state = _state.copyWith(
          selectedImage: imageFile,
          errorMessage: null,
        );
        notifyListeners();
      } else {
        print('이미지 선택 취소됨');
      }
    } catch (e) {
      print('이미지 선택 오류: $e');
      _state = _state.copyWith(
        errorMessage: '이미지 선택 중 오류가 발생했습니다: ${e.toString()}',
      );
      notifyListeners();
    }
  }

  // 이미지 업로드 (디버깅 정보 추가 버전)
  Future<String?> _uploadImage(File imageFile) async {
    try {
      print('\n=== 이미지 업로드 시작 ===');
      print('파일 경로: ${imageFile.path}');

      // 파일 크기 확인 (5MB 제한)
      final fileSizeInBytes = await imageFile.length();
      final fileSizeInMB = fileSizeInBytes / (1024 * 1024);
      print('파일 크기: ${fileSizeInMB.toStringAsFixed(2)}MB');

      if (fileSizeInMB > 5) {
        print('⚠️ 파일 크기 초과 (5MB 제한)');
        _state = _state.copyWith(
          errorMessage: '이미지 파일 크기가 5MB를 초과할 수 없습니다.',
        );
        notifyListeners();
        return null;
      }

      // 현재 사용자의 ID를 사용하여 고유한 경로 생성
      final userId = _profileUseCase.repository.currentUserId;
      print('사용자 ID: $userId');

      if (userId == null) {
        print('⚠️ 로그인된 사용자 없음');
        throw Exception('로그인된 사용자가 없습니다.');
      }

      // 이전 이미지 삭제 (선택사항)
      if (_state.imageUrl.isNotEmpty && _state.imageUrl.contains('profile_images/')) {
        print('기존 이미지 삭제 시도: ${_state.imageUrl}');
        try {
          await _storage.refFromURL(_state.imageUrl).delete();
          print('✓ 기존 이미지 삭제 성공');
        } catch (e) {
          print('⚠️ 기존 이미지 삭제 실패: $e');
        }
      }

      // 현재 시간을 사용하여 고유한 파일명 생성
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final fileName = 'profile_${userId}_$timestamp${path.extension(imageFile.path)}';
      final ref = _storage.ref().child('profile_images/$fileName');
      print('업로드 경로: profile_images/$fileName');

      // 업로드 상태 업데이트
      _state = _state.copyWith(isUploading: true);
      notifyListeners();

      // 메타데이터 설정
      final metadata = SettableMetadata(
        contentType: 'image/${path.extension(imageFile.path).substring(1)}',
        customMetadata: {
          'userId': userId,
          'uploadedAt': DateTime.now().toIso8601String(),
        },
      );
      print('메타데이터: ${metadata.customMetadata}');

      // 업로드 실행
      print('업로드 시작...');
      final uploadTask = ref.putFile(imageFile, metadata);

      // 업로드 진행률 모니터링
      uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
        final progress = (snapshot.bytesTransferred / snapshot.totalBytes) * 100;
        print('업로드 진행률: ${progress.toStringAsFixed(1)}%');
      });

      // 업로드 완료 대기
      final snapshot = await uploadTask;
      print('업로드 완료, 다운로드 URL 가져오는 중...');
      final downloadUrl = await snapshot.ref.getDownloadURL();

      print('✓ 업로드 성공: $downloadUrl');
      print('=== 이미지 업로드 종료 ===\n');
      return downloadUrl;
    } on FirebaseException catch (e) {
      print('⚠️ Firebase 예외 발생:');
      print('  코드: ${e.code}');
      print('  메시지: ${e.message}');
      print('  상세: $e');

      String errorMessage;
      switch (e.code) {
        case 'storage/unauthorized':
          errorMessage = '업로드 권한이 없습니다. Firebase Console에서 Storage 보안 규칙을 확인하세요.';
          break;
        case 'storage/canceled':
          errorMessage = '업로드가 취소되었습니다.';
          break;
        case 'storage/unknown':
          errorMessage = '알 수 없는 오류가 발생했습니다.';
          break;
        case 'storage/quota-exceeded':
          errorMessage = '저장소 용량이 초과되었습니다.';
          break;
        case 'storage/invalid-format':
          errorMessage = '지원하지 않는 이미지 형식입니다.';
          break;
        default:
          errorMessage = '이미지 업로드 중 오류가 발생했습니다: ${e.message}';
      }

      _state = _state.copyWith(errorMessage: errorMessage);
      notifyListeners();
      return null;
    } catch (e) {
      print('⚠️ 일반 예외 발생: $e');
      _state = _state.copyWith(
        errorMessage: '이미지 업로드 중 오류가 발생했습니다: ${e.toString()}',
      );
      notifyListeners();
      return null;
    } finally {
      _state = _state.copyWith(isUploading: false);
      notifyListeners();
      print('업로드 상태 초기화 완료');
    }
  }

  // 프로필 저장
  Future<void> saveProfile({
    required VoidCallback onSuccess,
    required void Function(String error) onError,
  }) async {
    print('\n=== 프로필 저장 시작 ===');
    print('닉네임: ${state.nickname}');
    print('선택된 이미지: ${state.selectedImage?.path ?? "없음"}');

    if (!state.canSave) {
      print('⚠️ 저장 불가능: ${state.nicknameError ?? "유효성 검사 실패"}');
      onError(state.nicknameError ?? '입력값을 확인해주세요.');
      return;
    }

    _state = _state.copyWith(isLoading: true, errorMessage: null);
    notifyListeners();

    try {
      String? imageUrl = state.imageUrl;
      print('기존 이미지 URL: $imageUrl');

      // 새로운 이미지가 선택된 경우 업로드
      if (state.selectedImage != null) {
        print('새로운 이미지 업로드 시작...');
        imageUrl = await _uploadImage(state.selectedImage!);
        if (imageUrl == null) {
          print('⚠️ 이미지 업로드 실패');
          _state = _state.copyWith(isLoading: false);
          notifyListeners();
          onError('이미지 업로드에 실패했습니다. 다시 시도해주세요.');
          return;
        }
        print('✓ 새로운 이미지 URL: $imageUrl');
      }

      // 프로필 업데이트
      print('프로필 업데이트 시작...');
      final result = await _profileUseCase.updateUserProfile(
        nickname: state.nickname,
        imageUrl: imageUrl!,
      );

      switch (result) {
        case Success():
          print('✓ 프로필 업데이트 성공');
          _state = _state.copyWith(
            isLoading: false,
            imageUrl: imageUrl,
            selectedImage: null, // 업로드 완료 후 선택된 이미지 제거
          );
          notifyListeners();
          onSuccess();
          break;
        case Error():
          print('⚠️ 프로필 업데이트 실패: ${result.failure.message}');
          _state = _state.copyWith(
            isLoading: false,
            errorMessage: result.failure.message,
          );
          notifyListeners();
          onError(result.failure.message);
          break;
      }
    } catch (e) {
      print('⚠️ 프로필 저장 중 예외 발생: $e');
      _state = _state.copyWith(
        isLoading: false,
        errorMessage: '프로필 업데이트 중 오류가 발생했습니다: ${e.toString()}',
      );
      notifyListeners();
      onError(_state.errorMessage!);
    }
    print('=== 프로필 저장 종료 ===\n');
  }

  // 상태 초기화
  void reset() {
    _state = ProfileEditState.initial();
    notifyListeners();
  }
}