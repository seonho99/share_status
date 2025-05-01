import 'package:flutter/material.dart';


class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _nicknameController = TextEditingController();
  bool _termsAccepted = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _idController.dispose();
    _nicknameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 상단 상태바는 이미 SafeArea로 처리

                const SizedBox(height: 40),

                // 회원가입 제목
                const Text(
                  '회원가입',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 30),

                // 이메일 입력
                _buildInputLabel('이메일'),
                const SizedBox(height: 8),
                _buildInputField(
                  controller: _emailController,
                  hintText: '이메일 를 입력해주세요.',
                ),

                const SizedBox(height: 20),

                // 비밀번호 입력
                _buildInputLabel('비밀번호'),
                const SizedBox(height: 8),
                _buildInputField(
                  controller: _passwordController,
                  hintText: '비밀번호 를 입력해주세요',
                  isPassword: true,
                ),

                const SizedBox(height: 20),

                // 아이디 입력
                _buildInputLabel('ID 입력'),
                const SizedBox(height: 8),
                _buildInputField(
                  controller: _idController,
                  hintText: 'ID 를 입력해주세요',
                ),

                const SizedBox(height: 20),

                // 닉네임 입력
                _buildInputLabel('닉네임'),
                const SizedBox(height: 8),
                _buildInputField(
                  controller: _nicknameController,
                  hintText: '닉네임 을 입력해주세요',
                ),

                const SizedBox(height: 20),

                // 비밀번호 재확인
                _buildInputLabel('비밀번호 재확인'),
                const SizedBox(height: 8),
                _buildInputField(
                  controller: _confirmPasswordController,
                  hintText: '비밀번호 확인을 위해 입력해주세요',
                  isPassword: true,
                ),

                const SizedBox(height: 30),

                // 회원가입 약관 체크박스
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Text(
                      '회원가입 약관',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFFA7A7A7),
                      ),
                    ),
                    const SizedBox(width: 10),
                    _buildCheckbox(),
                  ],
                ),

                const SizedBox(height: 30),

                // 회원가입 버튼
                SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: ElevatedButton(
                    onPressed: () {
                      // 가입 로직 구현
                      if (_termsAccepted) {
                        // 회원가입 처리
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('회원가입이 완료되었습니다.')),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('약관에 동의해주세요.')),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF228B22),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      '회원 가입',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputLabel(String label) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 17,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String hintText,
    bool isPassword = false,
  }) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: const Color(0xFFCFCFCF),
          width: 1.3,
        ),
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(
            color: Color(0xFFCFCFCF),
            fontSize: 16,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        ),
      ),
    );
  }

  Widget _buildCheckbox() {
    return GestureDetector(
      onTap: () {
        setState(() {
          _termsAccepted = !_termsAccepted;
        });
      },
      child: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          color: _termsAccepted ? const Color(0xFFBEBEBE) : Colors.transparent,
          borderRadius: BorderRadius.circular(2),
          border: Border.all(
            color: const Color(0xFFBEBEBE),
            width: 1,
          ),
        ),
        child: _termsAccepted
            ? const Icon(
          Icons.check,
          size: 18,
          color: Colors.white,
        )
            : null,
      ),
    );
  }
}