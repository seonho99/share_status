import 'package:flutter/material.dart';

class ClickButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback onPressed;

  const ClickButton({
    super.key,
    required this.buttonText,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: double.infinity,
        height: 56,
        decoration: BoxDecoration(
          color: const Color(0xFF2E8B57),
          borderRadius: BorderRadius.circular(10),
        ),
        alignment: Alignment.center,
        child: Text(
          buttonText,
          style: const TextStyle(
            fontFamily: 'Noto Sans',
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
