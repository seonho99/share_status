import '../model/user_model.dart';
import '../repository/firebase_repository.dart';

class UserUseCase {
  final FirebaseRepository _repository;

  UserUseCase(this._repository);

  Future<void> call(UserModel user) => _repository.createUser(user);

  Future<bool> callId(String id) => _repository.isIdAvailable(id);
}
