import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_status/component/profile_edit/profile_edit_state.dart';

import '../widget/click_button.dart';
import '../widget/input_field.dart';
import 'profile_edit_view_model.dart';

class ProfileEditScreen extends StatefulWidget {
  const ProfileEditScreen({super.key});

  @override
  State<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  final TextEditingController _nicknameController = TextEditingController();
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();

    // 화면 진입 시 사용자 프로필 로드
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final viewModel = context.read<ProfileEditViewModel>();
      viewModel.loadUserProfile();

      // 닉네임 컨트롤러 동기화
      _nicknameController.addListener(() {
        viewModel.onNicknameChanged(_nicknameController.text);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileEditViewModel>(
      builder: (context, viewModel, child) {
        final state = viewModel.state;

        // 프로필 로딩 완료 시 한 번만 닉네임 값 설정
        if (!_isInitialized && state.nickname.isNotEmpty && !state.isLoading) {
          // 빌드 후 다음 프레임에서 실행
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              _nicknameController.text = state.nickname;
              _isInitialized = true;
            }
          });
        }

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: const Text(
              '프로필 수정',
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            centerTitle: true,
          ),
          body: state.isLoading
              ? const Center(child: CircularProgressIndicator())
              : SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  // 프로필 이미지
                  _buildProfileImage(state, viewModel),
                  const SizedBox(height: 40),
                  // 닉네임 입력 필드
                  InputField(
                    label: '닉네임',
                    hintText: '닉네임을 입력해주세요.',
                    controller: _nicknameController,
                  ),
                  const SizedBox(height: 8),
                  // 에러 메시지
                  if (state.nicknameError != null)
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        state.nicknameError!,
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  const Spacer(),
                  // 저장 버튼
                  ClickButton(
                    buttonText: state.isUploading
                        ? '업로드 중...'
                        : state.isLoading
                        ? '저장 중...'
                        : '저장',
                    onPressed: state.canSave
                        ? () {
                      viewModel.saveProfile(
                        onSuccess: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('프로필이 성공적으로 저장되었습니다.'),
                              backgroundColor: Colors.green,
                            ),
                          );
                          // 성공적으로 저장되면 이전 화면으로 돌아가면서 true 반환
                          Navigator.of(context).pop(true);
                        },
                        onError: (error) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(error),
                              backgroundColor: Colors.red,
                            ),
                          );
                        },
                      );
                    }
                        : null,
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildProfileImage(state, ProfileEditViewModel viewModel) {
    return Stack(
      children: [
        // 프로필 이미지
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.grey[200],
            border: Border.all(color: Colors.grey[300]!, width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipOval(
            child: _buildImageContent(state),
          ),
        ),
        // 편집 버튼
        Positioned(
          bottom: 0,
          right: 0,
          child: GestureDetector(
            onTap: () => _showImagePickerOptions(context, viewModel),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF2E8B57),
                border: Border.all(color: Colors.white, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(
                Icons.camera_alt,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildImageContent(state) {
    // 새로 선택된 이미지가 있으면 표시
    if (state.selectedImage != null) {
      return Image.file(
        state.selectedImage!,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return _buildDefaultProfileIcon();
        },
      );
    }

    // 기존 이미지 URL이 있으면 표시
    if (state.imageUrl.isNotEmpty) {
      return Image.network(
        state.imageUrl,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                  loadingProgress.expectedTotalBytes!
                  : null,
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return _buildDefaultProfileIcon();
        },
      );
    }

    // 기본 프로필 아이콘
    return _buildDefaultProfileIcon();
  }

  Widget _buildDefaultProfileIcon() {
    return Icon(
      Icons.person,
      size: 60,
      color: Colors.grey[400],
    );
  }

  void _showImagePickerOptions(BuildContext context, ProfileEditViewModel viewModel) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 핸들 바
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              // 카메라 옵션
              ListTile(
                leading: Icon(Icons.camera_alt, color: Colors.grey[700]),
                title: const Text('카메라로 촬영'),
                onTap: () {
                  Navigator.pop(context);
                  viewModel.pickImage(fromCamera: true);
                },
              ),
              // 갤러리 옵션
              ListTile(
                leading: Icon(Icons.photo_library, color: Colors.grey[700]),
                title: const Text('갤러리에서 선택'),
                onTap: () {
                  Navigator.pop(context);
                  viewModel.pickImage(fromCamera: false);
                },
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nicknameController.dispose();
    super.dispose();
  }
}