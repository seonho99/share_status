import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PasswordResetScreen extends StatefulWidget {
  const PasswordResetScreen({Key? key}) : super(key: key);

  @override
  State<PasswordResetScreen> createState() => _PasswordResetScreenState();
}

class _PasswordResetScreenState extends State<PasswordResetScreen> {
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                // 상단 제목과 설명 텍스트 스택
                Column(
                  children: [
                    Text(
                      '비밀번호 재설정',
                      style: Theme.of(context).textTheme.headlineLarge,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '입력하신 이메일로 비밀번호를 재설정 할 수 있는 링크를 전송합니다. 이메일을 작성해주세요.',
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                // 이메일 입력 필드
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
                      child: Text(
                        '이메일',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                    TextField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        hintText: '이메일 를 입력해주세요.',
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 14.0,
                        ),
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                // 이메일 발송 버튼
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () {
                      // 이메일 발송 로직 구현
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('이메일이 발송되었습니다.'),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF228B22),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      '이메일 발송',
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                // 로그인 화면으로 돌아가기 텍스트 버튼
                TextButton(
                  onPressed: () {
                    // 로그인 화면으로 이동 로직
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    '로그인 화면으로 돌아가기',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: const Color(0xFF228B22),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                // 하단 이미지
                Container(
                  width: double.infinity,
                  height: 200,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/image_1.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}