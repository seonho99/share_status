import '../../domain/model/user_model.dart';
import '../../domain/repository/firestore_repository.dart';
import '../data_source/firestore_data_source.dart';
import '../mapper/user_mapper.dart';

class FirestoreRepositoryImpl implements FirestoreRepository {
  final FirestoreDataSource _dataSource;

  FirestoreRepositoryImpl(this._dataSource);

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
