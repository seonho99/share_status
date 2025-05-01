import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';


class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
        ),
        title: const Text(
          '환경설정',
          style: TextStyle(
            color: Color(0xFF1D1B20),
            fontFamily: 'Roboto',
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          padding: const EdgeInsets.all(8.0),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    _buildSettingsItem('서비스 이용 약관', context),
                    const Divider(height: 1, thickness: 0.3),
                    _buildSettingsItem('비밀번호 수정', context),
                    const Divider(height: 1, thickness: 0.3),
                    _buildSettingsItem('공지 사항', context),
                    const Divider(height: 1, thickness: 0.3),
                    _buildSettingsItem('프로필 수정', context),
                    const Divider(height: 1, thickness: 0.3),
                    const Spacer(),
                    const Padding(
                      padding: EdgeInsets.only(bottom: 20.0),
                      child: Text(
                        '버전 1.0.0v',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                          fontFamily: 'Roboto',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            _buildBottomTabBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsItem(String title, BuildContext context) {
    return InkWell(
      onTap: () {
        // 각 설정 아이템 클릭 시 처리
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$title 선택됨')),
        );
      },
      child: Container(
        height: 40,
        margin: const EdgeInsets.symmetric(vertical: 5),
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w400,
              ),
            ),
            const Icon(
              Icons.keyboard_arrow_right,
              size: 20,
              color: Colors.black,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomTabBar() {
    return Container(
      height: 83,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
            color: Color(0x4D000000),
            width: 0.33,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
          ),
        ],
      ),
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildTabItem(icon: Icons.home, label: 'Tab', isSelected: true),
              _buildTabItem(icon: Icons.favorite_outline, label: 'Tab'),
              _buildTabItem(icon: Icons.add_circle_outline, label: 'Tab'),
              _buildTabItem(icon: Icons.notifications_none_outlined, label: 'Tab'),
              _buildTabItem(icon: Icons.person_outline, label: 'Tab'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabItem({
    required IconData icon,
    required String label,
    bool isSelected = false
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          color: isSelected ? const Color(0xFF007AFF) : const Color(0xFF999999),
          size: 24,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: isSelected ? const Color(0xFF007AFF) : const Color(0xFF999999),
            fontSize: 10,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}