import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:share_status/component/setting/setting_screen.dart';

import 'component/follow/follow_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '동료 추가',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Noto Sans',
      ),
      home: const SettingsScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

