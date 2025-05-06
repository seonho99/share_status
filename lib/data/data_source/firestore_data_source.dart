import '../dto/user_dto.dart';

abstract interface class FirestoreDataSource {
  Future<void> saveUser(UserDto user);
  Future<bool> checkIdExists(String id);
}
