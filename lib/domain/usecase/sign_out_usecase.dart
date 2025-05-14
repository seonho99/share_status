import '../repository/firebase_repository.dart';

class SignOutUseCase {
  final FirebaseRepository _repository;

  SignOutUseCase(this._repository);

  Future<void> call() async {
    return await _repository.signOut();
  }
}