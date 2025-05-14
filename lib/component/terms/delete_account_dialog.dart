import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/route/routes.dart';
import '../widget/input_field.dart';
import 'terms_view_model.dart';

class DeleteAccountDialog extends StatefulWidget {
  const DeleteAccountDialog({super.key});

  @override
  State<DeleteAccountDialog> createState() => _DeleteAccountDialogState();
}

class _DeleteAccountDialogState extends State<DeleteAccountDialog> {
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      title: const Text(
        '회원 탈퇴',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.red,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '탈퇴하면 모든 데이터가 삭제되며 이 작업은 되돌릴 수 없습니다. 정말 탈퇴하시겠습니까?',
            style: TextStyle(
              fontSize: 14,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 20),
          InputField(
            label: '비밀번호 확인',
            hintText: '비밀번호를 입력해주세요',
            controller: _passwordController,
            obscureText: true,
          ),
          if (_errorMessage != null)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                _errorMessage!,
                style: const TextStyle(
                  color: Colors.red,
                  fontSize: 12,
                ),
              ),
            ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text(
            '취소',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 16,
            ),
          ),
        ),
        _isLoading
            ? const Padding(
          padding: EdgeInsets.all(8.0),
          child: SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
            ),
          ),
        )
            : TextButton(
          onPressed: () {
            _deleteAccount(context);
          },
          child: const Text(
            '탈퇴하기',
            style: TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }

  void _deleteAccount(BuildContext context) {
    if (_passwordController.text.isEmpty) {
      setState(() {
        _errorMessage = '비밀번호를 입력해주세요.';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final viewModel = context.read<TermsViewModel>();

    viewModel.deleteAccount(
      password: _passwordController.text,
      onSuccess: () {
        // 성공 시 로그인 화면으로 이동
        context.go(Routes.signIn);
      },
      onError: (error) {
        // 에러 처리
        setState(() {
          _isLoading = false;
          _errorMessage = error;
        });
      },
    );
  }
}