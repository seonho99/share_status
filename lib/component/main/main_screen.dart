import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // 상단바 (상태바 아래 영역)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '목록',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFB0B0B0),
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        '100',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFFB0B0B0),
                        ),
                      ),
                      SizedBox(width: 16),
                      Icon(Icons.search, size: 24),
                    ],
                  ),
                ],
              ),
            ),

            // 구분선
            Divider(
              color: Color(0xFFD9D9D9),
              thickness: 2,
            ),

            // 프로필 목록
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                children: [
                  // 프로필 아이템 1 - 간단한 프로필
                  MainItem(
                    name: '철수',
                    timestamp: '29일 11 : 40 - 13 : 10',
                    statusMessage: '',
                    statusColor: Colors.transparent,
                  ),

                  // 프로필 아이템 2 - 운전중
                  MainItem(
                    name: '철수',
                    timestamp: '29일 11 : 40 - 13 : 10',
                    statusMessage: '운전중여서 통화 및 문자 x',
                    statusColor: Colors.red,
                  ),

                  // 프로필 아이템 3 - 영희
                  MainItem(
                    name: '영희',
                    timestamp: '',
                    statusMessage: '근무 중 입니다.',
                    statusColor: Color(0xFF41CC3E), // 녹색
                  ),

                  // 프로필 아이템 4 - 일런 머스크
                  MainItem(
                    name: '일런 머스크',
                    timestamp: '28일 22 : 00 - 23 : 10',
                    statusMessage: '운전 중 입니다.',
                    statusColor: Color(0xFFF4F900), // 노란색
                  ),

                  // 프로필 아이템 5 - 도넛트럼프
                  MainItem(
                    name: '도넛트럼프',
                    timestamp: '',
                    statusMessage: '자리 비움',
                    statusColor: Color(0xFFD9D9D9), // 회색
                  ),

                  // 프로필 아이템 6 - 해외미팅자
                  MainItem(
                    name: '해외미팅자',
                    timestamp: '28일 22 : 00 - 23 : 10',
                    statusMessage: '여행 중 5/30 - 7/1',
                    statusColor: Color(0xFFF9000F), // 빨간색
                  ),

                  // 동료 추가 버튼
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Text(
                      '동료 추가',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // 하단 탭바
            Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.75),
                border: Border(
                  top: BorderSide(
                    color: Colors.black.withOpacity(0.3),
                    width: 0.33,
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildTabItem(isActive: true, label: 'Tab Name'),
                  _buildTabItem(isActive: false, label: 'Tab Name'),
                  _buildTabItem(isActive: false, label: 'Tab Name'),
                  _buildTabItem(isActive: false, label: 'Tab Name'),
                  _buildTabItem(isActive: false, label: 'Tab Name'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabItem({required bool isActive, required String label}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            CupertinoIcons.circle,
            size: 24,
            color: isActive ? Colors.blue : Colors.grey,
          ),
          SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: isActive ? Colors.blue : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}

class MainItem extends StatelessWidget {
  final String name;
  final String statusMessage;
  final String timestamp;
  final Color statusColor;

  const MainItem({
    Key? key,
    required this.name,
    required this.statusMessage,
    required this.timestamp,
    required this.statusColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 프로필 이미지 (원형)
          Stack(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  border: Border.all(
                    color: Color(0xFFD9D9D9),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.25),
                      blurRadius: 4,
                      spreadRadius: 0,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
              ),
              if (statusColor != Colors.transparent)
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    width: 14,
                    height: 14,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: statusColor,
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(width: 12),

          // 이름과 상태 메시지
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (statusMessage.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Text(
                      statusMessage,
                      style: TextStyle(
                        fontSize: 17,
                      ),
                    ),
                  ),
                if (timestamp.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Text(
                      timestamp,
                      style: TextStyle(
                        fontSize: 17,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
