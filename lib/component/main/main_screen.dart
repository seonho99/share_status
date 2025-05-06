import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../bottom_sheet/bottom_sheet_screen.dart';
import '../bottom_sheet/bottom_sheet_view_model.dart';
import '../widget/main_item.dart';

class MainScreen extends StatefulWidget {

  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 20, top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text('동료 추가', style: TextStyle()),
                  SizedBox(width: 10),
                  Icon(Icons.search, size: 24),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(20.0),
              child: GestureDetector(
                onTap: () {
                  showBottomSheet(
                    context: context,
                    backgroundColor: Colors.white,
                    builder:
                        (context) =>
                        ChangeNotifierProvider(
                          create: (_) => BottomSheetViewModel(),
                          child: BottomSheetScreen(
                            onSaved: (message, time, color) {
                              setState(() {
                                _statusMessage = message;
                                _statusTime = time;
                                _statusColor = color;
                              });
                            },
                          ),
                        ),
                  );
                },
                child: MainItem(
                  name:,
                  statusTime:,
                  statusMessage:,
                  statusColor:,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Row(
                children: [
                  Text(
                    '목록',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFB0B0B0),
                    ),
                  ),
                  SizedBox(width: 10),
                  Text(
                    '100',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFB0B0B0),
                    ),
                  ),
                  SizedBox(width: 16),
                ],
              ),
            ),

            Divider(color: Color(0xFFD9D9D9), thickness: 1),

            // 프로필 목록
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    MainItem(
                      name: '철수',
                      statusTime: '29일 11 : 40',
                      statusColor: Colors.red,
                      statusMessage: '운전중여서 통화 및 문자 x',
                    ),

                    // 프로필 아이템 3 - 영희
                    MainItem(
                      name: '영희',
                      statusTime: '',
                      statusMessage: '근무 중 입니다.',
                      statusColor: Color(0xFF41CC3E), // 녹색
                    ),

                    // 프로필 아이템 4 - 일런 머스크
                    MainItem(
                      name: '일런 머스크',
                      statusTime: '28일 22 : 00',
                      statusMessage: '운전 중 입니다.',
                      statusColor: Color(0xFFF4F900), // 노란색
                    ),

                    // 프로필 아이템 5 - 도넛트럼프
                    MainItem(
                      name: '도넛트럼프',
                      statusTime: '',
                      statusMessage: '자리 비움',
                      statusColor: Color(0xFFD9D9D9), // 회색
                    ),

                    // 프로필 아이템 6 - 해외미팅자
                    MainItem(
                      name: '해외미팅자',
                      statusTime: '28일 22 : 00',
                      statusMessage: '여행 중 5/30 - 7/1',
                      statusColor: Color(0xFFF9000F), // 빨간색
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
