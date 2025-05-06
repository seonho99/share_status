import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'component/sign_up/sign_up_view_model.dart';
import 'data/data_source/firebase_data_source_impl.dart';
import 'data/repository/firestore_repository_impl.dart';
import 'domain/usecase/sign_up_usecase.dart';
import 'domain/usecase/user_usecase.dart';
import 'firebase_options.dart';

import 'component/bottom_sheet/bottom_sheet_view_model.dart';
import 'core/route/router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => BottomSheetViewModel()),
        ChangeNotifierProvider(
          create:
              (_) => SignUpViewModel(
                SignUpUseCase(),
                UserUseCase(FirestoreRepositoryImpl(FirestoreDataSourceImpl())),
              ),
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
