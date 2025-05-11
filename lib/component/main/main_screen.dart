import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/result.dart';
import '../../core/route/routes.dart';
import '../../data/repository/firebase_repository_impl.dart';
import '../../domain/usecase/status_usecase.dart';
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
  String _statusMessage = '';
  String _statusTime = '';
  Color _statusColor = Color(0xFFD9D9D9);

  // 화면에 진입할 때마다 팔로우 목록을 새로고침
  @override
  void initState() {
    super.initState();
    _loadFollowingUsers();
    _loadUserStatus();
  }

  void _loadFollowingUsers() {
    final viewModel = context.read<MainViewModel>();
    viewModel.loadFollowingUsers();
  }

  void _loadUserStatus() async {
    final repository = context.read<FirebaseRepositoryImpl>();
    final statusUseCase = StatusUseCase(repository);

    final result = await statusUseCase.getUserStatus();

    if (result is Success && result.data != null) {
      final statusData = result.data!;
      setState(() {
        _statusMessage = statusData['statusMessage'] ?? '';
        _statusTime = statusData['statusTime'] ?? '';
        _statusColor = Color(statusData['colorStatus'] ?? 0xFFD9D9D9);
      });
    }
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
                        onTap: () async {
                          // 팔로우 요청 화면에서 돌아올 때 목록 새로고침
                          final result = await context.push(
                            '/main/${Routes.followRequest}',
                          );
                          if (result == true) {
                            _loadFollowingUsers();
                          }
                        },
                        child: Icon(Icons.person_add, size: 30),
                      ),
                      SizedBox(width: 16),
                      GestureDetector(
                        onTap: () {
                          context.go('/main/${Routes.follow}');
                        },
                        child: Icon(Icons.search, size: 30),
                      ),
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
                                onSaved: (message, time, color)async {
                                  setState(() {
                                    _statusMessage = message;
                                    _statusTime = time;
                                    _statusColor = color;
                                  });

                                  // Firebase에 상태 저장
                                  final repository = context.read<
                                      FirebaseRepositoryImpl>();
                                  final statusUseCase = StatusUseCase(
                                      repository);

                                  await statusUseCase.saveStatus(
                                      statusMessage: message,
                                      statusTime: time,
                                      colorStatus:color.value,
                                  );
                                  },
                              ),
                            ),
                      );
                    },
                    // 자신의 상태 표시
                    child: MainItem(
                      name: '나의 상태',
                      statusTime: _statusTime,
                      statusMessage:
                      _statusMessage.isEmpty
                          ? '상태를 설정해보세요'
                          : _statusMessage,
                      statusColor: _statusColor,
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

                // 로딩 상태
                if (state.isLoading)
                  Expanded(child: Center(child: CircularProgressIndicator()))
                // 에러 상태
                else
                  if (state.errorMessage != null)
                    Expanded(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              state.errorMessage!,
                              style: TextStyle(color: Colors.red, fontSize: 16),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: _loadFollowingUsers,
                              child: Text('다시 시도'),
                            ),
                          ],
                        ),
                      ),
                    )
                  // 팔로우한 사용자가 없는 경우
                  else
                    if (state.followingUsers.isEmpty)
                      Expanded(
                        child: Center(
                          child: Text(
                            '팔로우한 사용자가 없습니다.\n사용자를 검색하여 팔로우를 요청해보세요.',
                            style: TextStyle(color: Colors.grey, fontSize: 16),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      )
                    // 팔로우한 사용자 목록 표시
                    else
                      Expanded(
                        child: ListView.builder(
                          padding: const EdgeInsets.all(20),
                          itemCount: state.followingUsers.length,
                          itemBuilder: (context, index) {
                            final user = state.followingUsers[index];
                            return MainItem(
                              name: user.nickname,
                              statusTime: '', // 상태 시간은 별도로 구현 필요
                              statusMessage: '', // 상태 메시지는 별도로 구현 필요
                              statusColor: Color(0xFFD9D9D9), // 기본 회색
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
