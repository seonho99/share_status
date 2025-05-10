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
}
