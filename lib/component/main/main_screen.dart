import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../bottom_sheet/bottom_sheet_screen.dart';
import '../bottom_sheet/bottom_sheet_view_model.dart';
import '../widget/main_item.dart';
import 'main_view_model.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  void initState() {
    super.initState();
    // 화면 진입 시 팔로우한 사용자 목록 로드
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final viewModel = context.read<MainViewModel>();
      viewModel.loadFollowingUsers();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MainViewModel>(
      builder: (context, viewModel, child) {
        final state = viewModel.state;

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
                      GestureDetector(
                        onTap: () {
                          context.go('/main/follow_request');
                        },
                        child: Icon(Icons.person_add, size: 30),
                      ),
                      SizedBox(width: 16),
                      GestureDetector(
                        onTap: () {
                          context.go('/main/follow');
                        },
                        child: Icon(Icons.search, size: 30),
                      ),
                    ],
                  ),
                ),

                // 내 상태 표시 영역
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: GestureDetector(
                    onTap: () {
                      showBottomSheet(
                        context: context,
                        backgroundColor: Colors.white,
                        builder: (context) => ChangeNotifierProvider(
                          create: (_) => BottomSheetViewModel(),
                          child: BottomSheetScreen(
                            onSaved: (message, time, color) {
                              viewModel.updateStatusMessage(message, time, color);
                            },
                          ),
                        ),
                      );
                    },
                    child: Container(
                      child: Text('내 상태 클릭해서 설정'), // 임시 UI
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
                        '${state.followingUsers.length}',
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

                // 팔로우한 사용자 목록
                Expanded(
                  child: state.isLoading
                      ? Center(child: CircularProgressIndicator())
                      : state.errorMessage != null
                      ? Center(
                    child: Text(
                      state.errorMessage!,
                      style: TextStyle(color: Colors.red),
                    ),
                  )
                      : state.followingUsers.isEmpty
                      ? Center(
                    child: Text(
                      '팔로우한 사용자가 없습니다.',
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                      : ListView.builder(
                    padding: const EdgeInsets.all(20),
                    itemCount: state.followingUsers.length,
                    itemBuilder: (context, index) {
                      final user = state.followingUsers[index];
                      return MainItem(
                        name: user.nickname,
                        statusTime: '', // 나중에 상태 데이터 연결
                        statusMessage: '', // 나중에 상태 데이터 연결
                        statusColor: Colors.grey, // 나중에 상태 데이터 연결
                      );
                    },
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