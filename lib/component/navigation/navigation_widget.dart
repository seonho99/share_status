import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'navigation_view_model.dart';

class NavigationWidget extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const NavigationWidget({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return Consumer<NavigationViewModel>(
      builder: (context, viewModel, child) {
        // navigationShell의 currentIndex와 동기화
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (viewModel.state.currentIndex != navigationShell.currentIndex) {
            viewModel.updateCurrentIndex(navigationShell.currentIndex);
          }
        });

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
                    viewModel.navigateToMain(navigationShell.goBranch);
                  },
                  child: Icon(
                    Icons.home,
                    size: 24,
                    color: navigationShell.currentIndex == 0
                        ? const Color(0xFF2E8B57)
                        : Colors.grey,
                  ),
                ),
                const SizedBox(width: 40),
                InkWell(
                  onTap: () async {
                    viewModel.navigateToSettings(navigationShell.goBranch);

                    // 설정 화면으로 이동하고 결과를 기다림
                    final result = await context.push('/settings');

                    // 프로필 업데이트가 완료된 경우
                    if (result == 'profile_updated' && context.mounted) {
                      viewModel.setProfileUpdated();
                      viewModel.navigateToMain(navigationShell.goBranch);
                    }
                  },
                  child: Icon(
                    Icons.settings,
                    size: 24,
                    color: navigationShell.currentIndex == 1
                        ? const Color(0xFF2E8B57)
                        : Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}