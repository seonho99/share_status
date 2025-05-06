import 'package:cloud_firestore/cloud_firestore.dart';
import '../dto/user_dto.dart';
import 'firestore_data_source.dart';

class FirestoreDataSourceImpl implements FirestoreDataSource {
  final _users = FirebaseFirestore.instance.collection('users');

  @override
  Future<void> saveUser(UserDto user) async {
    await _users.doc(user.uid).set(user.toJson());
  }
  @override
  Future<bool> checkIdExists(String id) async {
    final querySnapshot = await _users.where('id', isEqualTo: id).get();

    return querySnapshot.docs.isEmpty;
  }
}
