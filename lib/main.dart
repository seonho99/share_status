
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_status/component/auth/sign_up_screen.dart';

import 'component/auth/sign_in_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '로그인 화면',
      theme: ThemeData(
        primarySwatch: Colors.green,
        fontFamily: 'Noto Sans',
      ),
      home: SignUpScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
