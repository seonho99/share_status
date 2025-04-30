import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '프로필',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Noto Sans',
      ),
      home: const ProfilePage(),
    );
  }
}

}