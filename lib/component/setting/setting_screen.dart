import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'dart:ui';

import '../../core/route/routes.dart';
import 'setting_view_model.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingViewModel>(
      builder: (context, viewModel, child) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            systemOverlayStyle: const SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              statusBarIconBrightness: Brightness.dark,
            ),
            title: const Text(
              '환경설정',
              style: TextStyle(
                color: Color(0xFF1D1B20),
                fontFamily: 'Roboto',
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            centerTitle: true,
            automaticallyImplyLeading: false,
          ),
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 20),
                        _buildSettingsItem(
                          '프로필 수정',
                          context,
                          onTap: () async {
                            // ProfileEditScreen으로 이동하고 결과를 기다림
                            final result = await context.push(
                              '/settings/${Routes.profileEdit}',
                            );

                            // 프로필 수정이 완료되었을 경우, 상위 화면들에 알림
                            if (result == true && context.mounted) {
                              // 홈 화면으로 돌아가면서 프로필 수정 완료를 알림
                              Navigator.of(context).pop('profile_updated');
                            }
                          },
                        ),
                        const Divider(height: 1, thickness: 0.3),
                        _buildSettingsItem(
                          '비밀번호 수정',
                          context,
                          onTap: () {
                            context.push('/settings/${Routes.passwordChange}');
                          },
                        ),
                        const Divider(height: 1, thickness: 0.3),
                        _buildSettingsItem('공지 사항', context),
                        const Divider(height: 1, thickness: 0.3),
                        _buildSettingsItem('서비스 이용 약관', context),
                        const Divider(height: 1, thickness: 0.3),

                        // 로그아웃 버튼 추가
                        _buildSettingsItem(
                          '로그아웃',
                          context,
                          textColor: Colors.red,
                          onTap: () {
                            _showLogoutConfirmDialog(context, viewModel);
                          },
                        ),
                        const Divider(height: 1, thickness: 0.3),

                        const Spacer(),
                        const Padding(
                          padding: EdgeInsets.only(bottom: 20.0),
                          child: Text(
                            '버전 1.0.0v',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                              fontFamily: 'Roboto',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSettingsItem(
      String title,
      BuildContext context, {
        VoidCallback? onTap,
        Color textColor = Colors.black,
      }) {
    return InkWell(
      onTap:
      onTap ??
              () {
            // 기본 동작: 스낵바 표시
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('$title 선택됨')));
          },
      child: Container(
        height: 40,
        margin: const EdgeInsets.symmetric(vertical: 5),
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                color: textColor,
                fontSize: 16,
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w400,
              ),
            ),
            const Icon(
              Icons.keyboard_arrow_right,
              size: 20,
              color: Colors.black,
            ),
          ],
        ),
      ),
    );
  }

  // 로그아웃 확인 다이얼로그
  void _showLogoutConfirmDialog(BuildContext context, SettingViewModel viewModel) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: const Text('로그아웃'),
        content: const Text('정말 로그아웃 하시겠습니까?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();

              viewModel.signOut(
                onSuccess: () {
                  context.go(Routes.signIn);
                },
                onError: (error) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(error)),
                  );
                },
              );
            },
            child: const Text('로그아웃', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}