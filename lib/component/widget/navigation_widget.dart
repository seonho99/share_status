import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NavigationWidget extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const NavigationWidget({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,

      bottomNavigationBar: Container(
        height: 106,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 24),
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            InkWell(
              onTap: () {
                navigationShell.goBranch(0);
              },
              child: Icon(
                Icons.home,
                size: 24,
                color: navigationShell.currentIndex == 0 ? null : Colors.grey,
              ),
            ),
            const SizedBox(width: 40),
            InkWell(
              onTap: () {
                navigationShell.goBranch(1);
              },
              child: Icon(
                Icons.settings,
                size: 24,
                color: navigationShell.currentIndex == 1 ? null : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
