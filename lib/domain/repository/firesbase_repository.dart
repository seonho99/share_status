import '../model/user_model.dart';

abstract interface class FirestoreRepository {
  Future<void> createUser(UserModel user);
  Future<bool> isIdAvailable(String id);
}
