import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:share_status/component/widget/click_button.dart';
import 'package:share_status/core/route/routes.dart';

import '../../widget/input_field.dart';

class PasswordResetScreen extends StatefulWidget {
  PasswordResetScreen({super.key});

  @override
  State<PasswordResetScreen> createState() => _PasswordResetScreenState();
}

class _PasswordResetScreenState extends State<PasswordResetScreen> {
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text(
                    '비밀번호 재설정',
                    style: TextStyle(
                      fontFamily: 'Noto Sans',
                      color: Colors.black,
                      fontSize: 30,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    '입력하신 이메일로 비밀번호를 재설정 할 수 있는 링크를 전송합니다. 이메일을 작성해주세요.',
                    style: TextStyle(
                      fontFamily: 'Noto Sans',
                      color: Colors.black,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              const SizedBox(height: 40),
              // 이메일 입력 필드
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InputField(
                    label: '이메일',
                    hintText: '이메일을 입력해주세요.',
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 40),
                  ClickButton(buttonText: '이메일 발송', onPressed: () {}),
                  const SizedBox(height: 40),
                  GestureDetector(
                    onTap: () {
                      context.go(Routes.signIn);
                    },
                    child: Center(
                      child: Text(
                        '로그인 화면으로 돌아가기',
                        style: TextStyle(
                          fontFamily: 'Noto Sans',
                          color: Color(0xFF2E8B57),
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }
}
