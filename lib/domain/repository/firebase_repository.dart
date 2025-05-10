import '../model/user_model.dart';

abstract interface class FirebaseRepository {
  Future<void> createUser(UserModel user);
  Future<bool> isIdAvailable(String id);

  Future<String> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<void> signOut();

  Future<void> sendPasswordResetEmail(String email);

  String? get currentUserId;

  bool get isSignedIn;
}
