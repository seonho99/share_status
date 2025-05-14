import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'component/auth/password_reset/password_reset_view_model.dart';
import 'component/auth/sign_up/sign_up_view_model.dart';
import 'component/auth/sign_in/sign_in_view_model.dart';
import 'component/follow/follow_view_model.dart';
import 'component/follow_request/follow_request_view_model.dart';
import 'component/main/main_view_model.dart';
import 'component/navigation/navigation_view_model.dart';
import 'component/password_change/password_change_view_model.dart';
import 'component/profile_edit/profile_edit_view_model.dart';
import 'data/data_source/firebase_data_source_impl.dart';
import 'data/repository/firebase_repository_impl.dart';
import 'domain/usecase/password_change_use_case.dart';
import 'domain/usecase/profile_usecase.dart';
import 'domain/usecase/sign_up_usecase.dart';
import 'domain/usecase/sign_in_use_case.dart';
import 'domain/usecase/password_reset_usecase.dart';
import 'domain/usecase/status_usecase.dart';
import 'domain/usecase/user_usecase.dart';
import 'domain/usecase/follow_usecase.dart';
import 'firebase_options.dart';

import 'component/bottom_sheet/bottom_sheet_view_model.dart';
import 'core/route/router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  FirebaseFirestore.instance.settings = Settings(
    persistenceEnabled: true,
    cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
  );

  // 공통 인스턴스들
  final dataSource = FirebaseDataSourceImpl();
  final repository = FirebaseRepositoryImpl(dataSource);

  runApp(
    MultiProvider(
      providers: [
        Provider(create: (_) => repository),

        ChangeNotifierProvider(create: (_) => NavigationViewModel()),
        ChangeNotifierProvider(create: (_) => BottomSheetViewModel()),
        ChangeNotifierProvider(
          create:
              (_) => SignUpViewModel(SignUpUseCase(), UserUseCase(repository)),
        ),
        ChangeNotifierProvider(
          create: (_) => SignInViewModel(SignInUseCase(repository)),
        ),
        ChangeNotifierProvider(
          create:
              (_) => PasswordResetViewModel(PasswordResetUseCase(repository)),
        ),
        ChangeNotifierProvider(
          create: (_) => FollowViewModel(FollowUseCase(repository)),
        ),
        ChangeNotifierProvider(
          create: (_) => FollowRequestViewModel(FollowUseCase(repository)),
        ),
        ChangeNotifierProvider(
          create: (_) => MainViewModel(FollowUseCase(repository)),
        ),
        ChangeNotifierProvider(
          create: (_) => ProfileEditViewModel(ProfileUseCase(repository)),
        ),
        Provider(create: (_) => StatusUseCase(repository)), // 필요시 추가
        ChangeNotifierProvider(
          create: (_) => PasswordChangeViewModel(PasswordChangeUseCase(repository)),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}
