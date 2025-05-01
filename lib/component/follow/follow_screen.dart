import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FollowScreen extends StatefulWidget {
  const FollowScreen({super.key});

  @override
  State<FollowScreen> createState() => _FollowScreenState();
}

class _FollowScreenState extends State<FollowScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  bool _isSearchFocused = false;

  @override
  void initState() {
    super.initState();
    _searchFocusNode.addListener(() {
      setState(() {
        _isSearchFocused = _searchFocusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 56,
        automaticallyImplyLeading: false,
        title: const Text(
          '동료 추가',
          style: TextStyle(
            color: Colors.black,
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: false,
      ),
      // 시스템 상태바 영역을 별도로 추가
      extendBodyBehindAppBar: true,
      body: Column(
        children: [
          // 상태바 영역
          Container(
            height: mediaQuery.padding.top,
            color: Colors.white,
            padding: EdgeInsets.only(top: 5, left: 20, right: 20),
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '9:41',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
                Row(
                  children: [
                    const Icon(Icons.signal_cellular_4_bar, size: 16),
                    const SizedBox(width: 4),
                    const Icon(Icons.wifi, size: 16),
                    const SizedBox(width: 4),
                    Row(
                      children: [
                        Container(
                          width: 22,
                          height: 10,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black.withOpacity(0.35)),
                            borderRadius: BorderRadius.circular(2.6),
                          ),
                        ),
                        Container(
                          width: 18,
                          height: 7,
                          margin: const EdgeInsets.only(left: 2),
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(1.3),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          // 앱바 높이만큼 여백 추가
          SizedBox(height: mediaQuery.padding.top + 56),

          // 콘텐츠 영역
          Expanded(
            child: Column(
              children: [
                // 검색창
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xFFCFCFCF), width: 1.3),
                    ),
                    child: TextField(
                      controller: _searchController,
                      focusNode: _searchFocusNode,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: '검색',
                        prefixIcon: Icon(
                          CupertinoIcons.search,
                          color: const Color(0xFFCFCFCF),
                          size: 20,
                        ),
                        contentPadding: const EdgeInsets.symmetric(vertical: 10.0),
                      ),
                    ),
                  ),
                ),

                // 결과 ID 텍스트
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, top: 8.0, bottom: 16.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '12D1',
                      style: TextStyle(
                        color: const Color(0xFFD9D9D9),
                        fontSize: 17,
                      ),
                    ),
                  ),
                ),

                // 사용자 목록
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    children: [
                      _buildUserItem(name: '일런 머스크', id: '12D1ghkro'),
                      const SizedBox(height: 20),
                      _buildUserItem(name: '영희', id: '12D1ghh987'),
                    ],
                  ),
                ),

                // 키보드 표시 영역 (실제 앱에서는 시스템이 표시)
                if (_isSearchFocused)
                  Container(
                    height: 342,
                    width: double.infinity,
                    color: const Color(0xFF939393).withOpacity(0.9),
                    child: Column(
                      children: [
                        // 자동 완성 영역
                        Container(
                          color: Colors.white.withOpacity(0.9),
                          padding: const EdgeInsets.symmetric(vertical: 2),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFEBEDF0),
                                  borderRadius: BorderRadius.circular(4.6),
                                ),
                                child: const Text(
                                  'The',
                                  style: TextStyle(
                                    fontSize: 17,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 20),
                              const Text(
                                'the',
                                style: TextStyle(
                                  fontSize: 17,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(width: 20),
                              const Text(
                                'to',
                                style: TextStyle(
                                  fontSize: 17,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // 키보드는 일반적으로 시스템 UI의 일부이기 때문에 여기서는 단순화된 표현만 포함
                        const Expanded(
                          child: Center(
                            child: Text(
                              '시스템 키보드',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ),

                        // 홈 인디케이터
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Container(
                            width: 134,
                            height: 5,
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(100),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserItem({required String name, required String id}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          // 프로필 이미지
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              border: Border.all(color: const Color(0xFFD9D9D9)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.25),
                  blurRadius: 4,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            // 프로필 이미지가 없는 경우 기본 아이콘 표시
            child: Center(
              child: Icon(
                Icons.person,
                size: 30,
                color: Colors.grey[300],
              ),
            ),
          ),
          const SizedBox(width: 16),
          // 사용자 정보
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Inter',
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                id,
                style: const TextStyle(
                  fontSize: 17,
                  fontFamily: 'Inter',
                  color: Colors.black,
                ),
              ),
            ],
          ),
          const Spacer(),
          // 추가하기 버튼도 필요하다면 여기에 구현할 수 있습니다.
        ],
      ),
    );
  }
}
