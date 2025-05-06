import '../model/user_model.dart';
import '../repository/firestore_repository.dart';

class UserUseCase {
  final FirestoreRepository _repository;

  UserUseCase(this._repository);

  Future<void> call(UserModel user) => _repository.createUser(user);

  Future<bool> callId(String id) => _repository.isIdAvailable(id);
}
