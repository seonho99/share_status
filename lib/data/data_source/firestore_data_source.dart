import '../dto/user_dto.dart';

abstract interface class FirestoreDataSource {
  Future<void> saveUser(UserDto user);

  Future<bool> checkIdExists(String id);

  Future<String> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<String> signUpWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<void> signOut();

  Future<void> sendPasswordResetEmail(String email);

  String? get currentUserId;

  bool get isSignedIn;
}
