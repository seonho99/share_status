import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/route/routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    setState(() {
      Future.delayed(Duration(seconds: 1), () {
        context.go(Routes.signIn);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/image/status_splash.png'),
            ),
          ),
        ),
      ),
    );
  }
}
