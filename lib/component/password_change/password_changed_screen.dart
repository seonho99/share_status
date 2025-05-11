import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_status/component/password_change/password_change_state.dart';

import '../widget/click_button.dart';
import '../widget/input_field.dart';
import 'password_change_view_model.dart';

class PasswordChangeScreen extends StatefulWidget {
  const PasswordChangeScreen({super.key});

  @override
  State<PasswordChangeScreen> createState() => _PasswordChangeScreenState();
}

class _PasswordChangeScreenState extends State<PasswordChangeScreen> {
  final TextEditingController _currentPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // ViewModel의 상태와 컨트롤러를 동기화
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final viewModel = context.read<PasswordChangeViewModel>();
      _currentPasswordController.addListener(() {
        viewModel.onCurrentPasswordChanged(_currentPasswordController.text);
      });
      _newPasswordController.addListener(() {
        viewModel.onNewPasswordChanged(_newPasswordController.text);
      });
      _confirmPasswordController.addListener(() {
        viewModel.onConfirmPasswordChanged(_confirmPasswordController.text);
      });

      // 화면에 진입할 때마다 상태 초기화
      viewModel.resetState();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PasswordChangeViewModel>(
      builder: (context, viewModel, child) {
        final state = viewModel.state;

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
              '비밀번호 수정',
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            centerTitle: true,
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  const Text(
                    '보안을 위해 현재 비밀번호와 새 비밀번호를\n입력해주세요.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 40),

                  // 현재 비밀번호 입력 필드
                  InputField(
                    label: '현재 비밀번호',
                    hintText: '현재 비밀번호를 입력해주세요.',
                    controller: _currentPasswordController,
                    obscureText: !state.currentPasswordVisible,
                    suffixIcon: IconButton(
                      icon: Icon(
                        state.currentPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        viewModel.toggleCurrentPasswordVisibility();
                      },
                    ),
                  ),
                  const SizedBox(height: 8),
                  // 현재 비밀번호 에러 메시지
                  if (state.currentPasswordError != null)
                    Text(
                      state.currentPasswordError!,
                      style: const TextStyle(
                        color: Colors.red,
                        fontSize: 14,
                      ),
                    ),
                  const SizedBox(height: 20),

                  // 새 비밀번호 입력 필드
                  InputField(
                    label: '새 비밀번호',
                    hintText: '새 비밀번호를 입력해주세요.',
                    controller: _newPasswordController,
                    obscureText: !state.newPasswordVisible,
                    suffixIcon: IconButton(
                      icon: Icon(
                        state.newPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        viewModel.toggleNewPasswordVisibility();
                      },
                    ),
                  ),
                  const SizedBox(height: 8),
                  // 새 비밀번호 에러 메시지
                  if (state.newPasswordError != null)
                    Text(
                      state.newPasswordError!,
                      style: const TextStyle(
                        color: Colors.red,
                        fontSize: 14,
                      ),
                    ),
                  const SizedBox(height: 20),

                  // 새 비밀번호 확인 입력 필드
                  InputField(
                    label: '새 비밀번호 확인',
                    hintText: '새 비밀번호를 다시 입력해주세요.',
                    controller: _confirmPasswordController,
                    obscureText: !state.confirmPasswordVisible,
                    suffixIcon: IconButton(
                      icon: Icon(
                        state.confirmPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        viewModel.toggleConfirmPasswordVisibility();
                      },
                    ),
                  ),
                  const SizedBox(height: 8),
                  // 새 비밀번호 확인 에러 메시지
                  if (state.confirmPasswordError != null)
                    Text(
                      state.confirmPasswordError!,
                      style: const TextStyle(
                        color: Colors.red,
                        fontSize: 14,
                      ),
                    ),
                  const SizedBox(height: 40),

                  // 성공 메시지
                  if (state.isSuccess)
                    Container(
                      margin: const EdgeInsets.only(bottom: 20),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.green.withOpacity(0.3)),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.check_circle, color: Colors.green, size: 20),
                          SizedBox(width: 8),
                          Text(
                            '비밀번호가 성공적으로 변경되었습니다.',
                            style: TextStyle(
                              color: Colors.green,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),

                  const Spacer(),

                  // 비밀번호 변경 버튼
                  ClickButton(
                    buttonText: state.isLoading ? '변경 중...' : '비밀번호 변경',
                    onPressed: state.isLoading
                        ? null
                        : () {
                      viewModel.changePassword(
                        onSuccess: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('비밀번호가 성공적으로 변경되었습니다.'),
                              backgroundColor: Colors.green,
                            ),
                          );
                          // 성공 후 잠시 대기 후 이전 화면으로 이동
                          Future.delayed(const Duration(seconds: 1), () {
                            if (context.mounted) {
                              Navigator.of(context).pop();
                            }
                          });
                        },
                        onError: _showError,
                      );
                    },
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

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}