import '../../domain/model/user_model.dart';
import '../../domain/repository/firesbase_repository.dart';
import '../data_source/firebase_data_source.dart';
import '../mapper/user_mapper.dart';

class FirebaseRepositoryImpl implements FirebaseRepository {
  final FirebaseDataSource _dataSource;

  FirebaseRepositoryImpl(this._dataSource);

  @override
  Future<void> createUser(UserModel user) {
    final dto = user.toDto();
    return _dataSource.saveUser(dto);
  }

  @override
  Future<bool> isIdAvailable(String id) {
    return _dataSource.checkIdExists(id);
  }

  @override
  Future<String> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) {
    return _dataSource.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  @override
  Future<void> signOut() {
    return _dataSource.signOut();
  }

  @override
  Future<void> sendPasswordResetEmail(String email) {
    return _dataSource.sendPasswordResetEmail(email);
  }

  @override
  String? get currentUserId => _dataSource.currentUserId;

  @override
  bool get isSignedIn => _dataSource.isSignedIn;
}