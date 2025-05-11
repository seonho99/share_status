import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/result.dart';
import '../../core/route/routes.dart';
import '../../data/repository/firebase_repository_impl.dart';
import '../../domain/usecase/status_usecase.dart';
import '../../domain/usecase/profile_usecase.dart';
import '../bottom_sheet/bottom_sheet_screen.dart';
import '../bottom_sheet/bottom_sheet_view_model.dart';
import '../widget/main_item.dart';
import '../navigation/navigation_view_model.dart'; // 추가
import 'main_view_model.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with WidgetsBindingObserver {
  String _statusMessage = '';
  String _statusTime = '';
  Color _statusColor = Color(0xFFD9D9D9);
  String _myNickname = '나의 상태'; // 닉네임 상태 추가

  @override
  void initState() {
    super.initState();

    // 생명주기 옵저버 등록
    WidgetsBinding.instance.addObserver(this);

    // 비동기 작업을 addPostFrameCallback으로 감싸기
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadInitialData();
    });
  }

  @override
  void dispose() {
    // 생명주기 옵저버 제거
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    // 앱이 foreground로 돌아왔을 때 상태 새로고침
    if (state == AppLifecycleState.resumed) {
      // build 중이 아닐 때만 실행
      if (mounted) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _loadUserStatus();
          _loadUserProfile(); // 프로필도 새로고침
        });
      }
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // NavigationViewModel을 통해 프로필 업데이트 확인
    final navigationViewModel = context.watch<NavigationViewModel>();
    if (navigationViewModel.shouldRefreshMain) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _loadUserProfile();
        navigationViewModel.clearProfileUpdateFlag();
      });
    }
  }

  // 초기 데이터 로드
  void _loadInitialData() {
    if (!mounted) return;

    _loadFollowingUsers();
    _loadUserStatus();
    _loadUserProfile(); // 닉네임 로드
  }

  void _loadFollowingUsers() {
    if (!mounted) return;

    final viewModel = context.read<MainViewModel>();
    viewModel.loadFollowingUsers();
  }

  void _loadUserStatus() async {
    if (!mounted) return;

    final repository = context.read<FirebaseRepositoryImpl>();
    final statusUseCase = StatusUseCase(repository);

    final result = await statusUseCase.getUserStatus();

    // 비동기 작업 후 mounted 체크
    if (!mounted) return;

    switch (result) {
      case Success<Map<String, dynamic>?>():
        if (result.data != null) {
          final statusData = result.data!;
          // setState를 다음 프레임에서 실행
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              setState(() {
                _statusMessage = statusData['statusMessage'] ?? '';
                _statusTime = statusData['statusTime'] ?? '';
                _statusColor = Color(statusData['colorStatus'] ?? 0xFFD9D9D9);
              });
            }
          });
        }
        break;
      case Error<Map<String, dynamic>?>():
        debugPrint('상태 로드 실패: ${result.failure.message}');
        break;
    }
  }

  // 사용자 프로필(닉네임) 로드
  void _loadUserProfile() async {
    if (!mounted) return;

    final repository = context.read<FirebaseRepositoryImpl>();
    final profileUseCase = ProfileUseCase(repository);

    final result = await profileUseCase.getCurrentUserProfile();

    // 비동기 작업 후 mounted 체크
    if (!mounted) return;

    switch (result) {
      case Success():
      // setState를 다음 프레임에서 실행
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            setState(() {
              _myNickname = result.data.nickname;
            });
          }
        });
        break;
      case Error():
        debugPrint('프로필 로드 실패: ${result.failure.message}');
        // 에러가 발생해도 기본값 유지
        break;
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
                          final result = await context.push(
                            '/main/${Routes.followRequest}',
                          );
                          if (result == true && mounted) {
                            // 비동기 작업을 다음 프레임으로 연기
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              _loadFollowingUsers();
                            });
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
                        builder: (context) => ChangeNotifierProvider(
                          create: (_) => BottomSheetViewModel(),
                          child: BottomSheetScreen(
                            onSaved: (message, time, color) async {
                              // 즉시 UI 업데이트
                              if (mounted) {
                                setState(() {
                                  _statusMessage = message;
                                  _statusTime = time;
                                  _statusColor = color;
                                });
                              }

                              // Firebase에 상태 저장
                              final repository = context.read<FirebaseRepositoryImpl>();
                              final statusUseCase = StatusUseCase(repository);

                              final result = await statusUseCase.saveStatus(
                                statusMessage: message,
                                statusTime: time,
                                colorStatus: color.value,
                              );

                              // 저장 결과 처리
                              if (!mounted) return;

                              switch (result) {
                                case Success():
                                // 저장 성공하면 다시 로드해서 확인
                                  WidgetsBinding.instance.addPostFrameCallback((_) {
                                    _loadUserStatus();
                                  });
                                  break;
                                case Error():
                                // 저장 실패 시 스낵바 표시
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('상태 저장 실패: ${result.failure.message}'),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                  break;
                              }
                            },
                          ),
                        ),
                      );
                    },
                    child: MainItem(
                      name: _myNickname,
                      statusTime: _statusTime,
                      statusMessage: _statusMessage.isEmpty ? '상태를 설정해보세요' : _statusMessage,
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
                else if (state.errorMessage != null)
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
                            onPressed: () {
                              _loadFollowingUsers();
                              _loadUserProfile(); // 프로필도 새로고침
                            },
                            child: Text('다시 시도'),
                          ),
                        ],
                      ),
                    ),
                  )
                // 팔로우한 사용자가 없는 경우
                else if (state.followingUsers.isEmpty)
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

                          // 해당 사용자의 상태 정보 가져오기
                          final userStatus = state.followingUsersStatus[user.uid];
                          final statusMessage = userStatus?['statusMessage'] ?? '';
                          final statusTime = userStatus?['statusTime'] ?? '';
                          final colorStatus = userStatus?['colorStatus'] ?? 0xFFD9D9D9;

                          return MainItem(
                            name: user.nickname,
                            statusTime: statusTime,
                            statusMessage: statusMessage.isEmpty ? '' : statusMessage,
                            statusColor: Color(colorStatus),
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