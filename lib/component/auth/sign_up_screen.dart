import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:share_status/component/widget/click_button.dart';
import 'package:share_status/component/widget/input_field.dart';
import 'package:share_status/core/route/routes.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _nicknameController = TextEditingController();
  bool _obscurePassword = true;
  bool _agreeToTerms = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          '회원가입',
          style: TextStyle(
            fontFamily: 'Noto Sans',
            color: Colors.black,
            fontSize: 30,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                InputField(
                  label: '닉네임',
                  hintText: '닉네임을 입력해주세요.',
                  controller: _nicknameController,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 20),
                InputField(
                  label: '이메일',
                  hintText: '이메일을 입력해주세요.',
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 20),
                InputField(
                  label: '비밀번호',
                  hintText: '비밀번호를 입력해주세요.',
                  controller: _passwordController,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 20),
                InputField(
                  label: '비밀번호 재확인',
                  hintText: '비밀번호를 입력해주세요.',
                  controller: _confirmPasswordController,
                  obscureText: _obscurePassword,
                  keyboardType: TextInputType.number,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 20),
                InputField(
                  label: 'ID 입력',
                  hintText: 'ID를 입력해주세요.',
                  controller: _idController,
                  keyboardType: TextInputType.number,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Checkbox(
                        value: _agreeToTerms,
                        onChanged: (bool? value) {
                          setState(() {
                            _agreeToTerms = value ?? false;
                          });
                        },
                      ),
                      const Text(
                        '회원가입 약관',
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFFA7A7A7),
                        ),
                      ),
                      const SizedBox(width: 10),
                    ],
                  ),
                ),
                ClickButton(
                  buttonText: '회원가입',
                  onPressed: () {
                    context.go(Routes.signIn);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _idController.dispose();
    _nicknameController.dispose();
    super.dispose();
  }
}
