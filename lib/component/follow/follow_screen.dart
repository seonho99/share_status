import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'follow_state.dart';
import 'follow_view_model.dart';

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

    // ViewModel과 검색어 동기화
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final viewModel = context.read<FollowViewModel>();
      _searchController.addListener(() {
        viewModel.onSearchQueryChanged(_searchController.text);
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

    return Consumer<FollowViewModel>(
      builder: (context, viewModel, child) {
        final state = viewModel.state;

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

                    // 검색어 표시
                    if (state.searchQuery.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0, top: 8.0, bottom: 16.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            state.searchQuery,
                            style: TextStyle(
                              color: const Color(0xFFD9D9D9),
                              fontSize: 17,
                            ),
                          ),
                        ),
                      ),

                    // 검색 결과 또는 로딩/에러 표시
                    Expanded(
                      child: _buildSearchResults(state),
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
      },
    );
  }

  Widget _buildSearchResults(FollowState state) {
    // 로딩 상태
    if (state.isSearching) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    // 에러 상태
    if (state.errorMessage != null && state.searchQuery.isNotEmpty) {
      return Center(
        child: Text(
          state.errorMessage!,
          style: const TextStyle(
            color: Colors.red,
            fontSize: 16,
          ),
          textAlign: TextAlign.center,
        ),
      );
    }

    // 검색 결과가 없는 경우
    if (state.searchResults.isEmpty && state.searchQuery.isNotEmpty && !state.isSearching) {
      return const Center(
        child: Text(
          '검색 결과가 없습니다.',
          style: TextStyle(
            color: Colors.grey,
            fontSize: 16,
          ),
        ),
      );
    }

    // 검색 결과 표시
    if (state.searchResults.isNotEmpty) {
      return ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        itemCount: state.searchResults.length,
        separatorBuilder: (context, index) => const SizedBox(height: 20),
        itemBuilder: (context, index) {
          final user = state.searchResults[index];
          return _buildUserItem(
            user: user,
            isRequestSending: state.isRequestSending(user.uid),
          );
        },
      );
    }

    // 초기 상태 (아무 검색어도 입력하지 않은 경우)
    return const Center(
      child: Text(
        '사용자를 검색해보세요.',
        style: TextStyle(
          color: Colors.grey,
          fontSize: 16,
        ),
      ),
    );
  }

  Widget _buildUserItem({required user, required bool isRequestSending}) {
    final viewModel = context.read<FollowViewModel>();

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
            // 프로필 이미지 표시 (이미 URL이 있다면)
            child: user.imageUrl.isEmpty
                ? Center(
              child: Icon(
                Icons.person,
                size: 30,
                color: Colors.grey[300],
              ),
            )
                : ClipOval(
              child: Image.network(
                user.imageUrl,
                width: 56,
                height: 56,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Center(
                    child: Icon(
                      Icons.person,
                      size: 30,
                      color: Colors.grey[300],
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(width: 16),
          // 사용자 정보
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  user.nickname,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Inter',
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  user.id,
                  style: const TextStyle(
                    fontSize: 17,
                    fontFamily: 'Inter',
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          // 팔로우 요청 버튼
          SizedBox(
            width: 100,
            height: 36,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: isRequestSending ? Colors.grey : const Color(0xFF2E8B57),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                elevation: 0,
              ),
              onPressed: isRequestSending
                  ? null
                  : () {
                viewModel.sendFollowRequest(
                  toUserId: user.uid,
                  toUserName: user.nickname,
                  toUserImageUrl: user.imageUrl,
                  onSuccess: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${user.nickname}님에게 팔로우 요청을 보냈습니다.'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  },
                  onError: (error) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(error),
                        backgroundColor: Colors.red,
                      ),
                    );
                  },
                );
              },
              child: isRequestSending
                  ? const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
                  : const Text(
                '요청',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}