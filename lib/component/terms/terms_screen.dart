import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../widget/click_button.dart';
import 'delete_account_dialog.dart';

class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
          '서비스 이용 약관',
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
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '1. 서비스 이용약관',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        '이 약관은 Share Status 서비스(이하 "서비스"라 합니다)를 이용하는 모든 이용자에게 적용됩니다.',
                        style: TextStyle(
                          fontSize: 14,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        '2. 개인정보 처리방침',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        '회사는 이용자의 개인정보를 중요시하며, 개인정보 보호법 등 관련 법령을 준수하고 있습니다. 수집된 개인정보는 서비스 제공, 개선 및 회원관리 등을 위해서만 사용됩니다.',
                        style: TextStyle(
                          fontSize: 14,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        '3. 서비스 이용 제한',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        '회사는 이용자가 법령, 공서양속, 약관에 위배되는 행위를 하는 경우 서비스 이용을 제한할 수 있습니다.',
                        style: TextStyle(
                          fontSize: 14,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 20),
                      // 추가 약관 내용...
                      const SizedBox(height: 40),

                      // 회원 탈퇴 버튼 (작게 표시)
                      Align(
                        alignment: Alignment.center,
                        child: TextButton(
                          onPressed: () {
                            _showDeleteAccountDialog(context);
                          },
                          child: const Text(
                            '회원 탈퇴',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
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
      ),
    );
  }

  void _showDeleteAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const DeleteAccountDialog(),
    );
  }
}