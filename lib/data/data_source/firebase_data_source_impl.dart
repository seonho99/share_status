import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../dto/user_dto.dart';
import 'firebase_data_source.dart';

class FirebaseDataSourceImpl implements FirebaseDataSource {
  final _users = FirebaseFirestore.instance.collection('users');
  final _auth = FirebaseAuth.instance;

  @override
  Future<void> saveUser(UserDto user) async {
    await _users.doc(user.uid).set(user.toJson());
  }

  @override
  Future<bool> checkIdExists(String id) async {
    final querySnapshot = await _users.where('id', isEqualTo: id).get();

    return querySnapshot.docs.isEmpty;
  }

  @override
  Future<String> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential.user?.uid ?? '';
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
          throw Exception('해당 이메일로 등록된 계정이 없습니다.');
        case 'wrong-password':
          throw Exception('비밀번호가 올바르지 않습니다.');
        case 'invalid-email':
          throw Exception('유효하지 않은 이메일 형식입니다.');
        case 'user-disabled':
          throw Exception('이 계정은 비활성화되었습니다.');
        case 'too-many-requests':
          throw Exception('너무 많은 로그인 시도가 있었습니다. 잠시 후 다시 시도해주세요.');
        default:
          throw Exception('로그인 중 오류가 발생했습니다: ${e.message}');
      }
    } catch (e) {
      throw Exception('로그인 중 알 수 없는 오류가 발생했습니다: ${e.toString()}');
    }
  }

  @override
  Future<String> signUpWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential.user?.uid ?? '';
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'weak-password':
          throw Exception('비밀번호가 너무 약합니다.');
        case 'email-already-in-use':
          throw Exception('이미 등록된 이메일입니다.');
        case 'invalid-email':
          throw Exception('유효하지 않은 이메일 형식입니다.');
        default:
          throw Exception('회원가입 중 오류가 발생했습니다: ${e.message}');
      }
    } catch (e) {
      throw Exception('회원가입 중 알 수 없는 오류가 발생했습니다: ${e.toString()}');
    }
  }

  @override
  Future<void> signOut() async {
    await _auth.signOut();
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
          throw Exception('해당 이메일로 등록된 계정이 없습니다.');
        case 'invalid-email':
          throw Exception('유효하지 않은 이메일 형식입니다.');
        default:
          throw Exception('비밀번호 재설정 이메일 전송 중 오류가 발생했습니다: ${e.message}');
      }
    } catch (e) {
      throw Exception('비밀번호 재설정 이메일 전송 중 알 수 없는 오류가 발생했습니다: ${e.toString()}');
    }
  }

  @override
  String? get currentUserId => _auth.currentUser?.uid;

  @override
  bool get isSignedIn => _auth.currentUser != null;
}
