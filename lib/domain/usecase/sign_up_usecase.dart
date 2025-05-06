import 'package:firebase_auth/firebase_auth.dart';

class SignUpUseCase {
  Future<String> call({required String email, required String password}) async {
    final credential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);

    return credential.user?.uid ?? '';
  }
}
