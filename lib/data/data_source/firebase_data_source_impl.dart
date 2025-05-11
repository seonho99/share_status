import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../dto/follow_request_dto.dart';
import '../dto/user_dto.dart';
import 'firebase_data_source.dart';

class FirebaseDataSourceImpl implements FirebaseDataSource {
  final _users = FirebaseFirestore.instance.collection('users');
  final _auth = FirebaseAuth.instance;
  final _followRequests = FirebaseFirestore.instance.collection(
    'follow_requests',
  );
  final _follows = FirebaseFirestore.instance.collection('follows');

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

  // 사용자 검색
  @override
  Future<List<Map<String, dynamic>>> searchUsers(String query) async {
    try {
      // 현재 사용자 UID 제외하고 검색
      final currentUserId = _auth.currentUser?.uid;

      // ID로만 검색 (부분 일치)
      final querySnapshot =
      await _users
          .where('id', isGreaterThanOrEqualTo: query)
          .where('id', isLessThanOrEqualTo: '$query\uf8ff')
          .get();

      // 결과에서 현재 사용자 제외
      final results = <Map<String, dynamic>>[];
      for (final doc in querySnapshot.docs) {
        if (doc.id != currentUserId) {
          results.add({...doc.data(), 'uid': doc.id});
        }
      }

      return results;
    } catch (e) {
      throw Exception('사용자 검색 중 오류가 발생했습니다: ${e.toString()}');
    }
  }
  // 팔로우 요청 보내기
  @override
  Future<void> sendFollowRequest(FollowRequestDto request) async {
    try {
      // 기존 팔로우 요청이 있는지 확인
      final existingRequest =
          await _followRequests
              .where('fromUserId', isEqualTo: request.fromUserId)
              .where('toUserId', isEqualTo: request.toUserId)
              .get();

      if (existingRequest.docs.isNotEmpty) {
        throw Exception('이미 팔로우 요청을 보냈습니다.');
      }

      // 이미 팔로우 중인지 확인
      final isAlreadyFollowing = await this.isFollowing(
        request.fromUserId,
        request.toUserId,
      );
      if (isAlreadyFollowing) {
        throw Exception('이미 팔로우 중입니다.');
      }

      // 팔로우 요청 생성
      await _followRequests.add(request.toJson());
    } catch (e) {
      throw Exception('팔로우 요청 전송 중 오류가 발생했습니다: ${e.toString()}');
    }
  }

  // 받은 팔로우 요청 목록 조회
  @override
  Future<List<FollowRequestDto>> getReceivedFollowRequests(String userId) async {
    try {
      // orderBy 제거하고 where만 사용
      final querySnapshot = await _followRequests
          .where('toUserId', isEqualTo: userId)
          .get();

      // 데이터를 가져온 후 메모리에서 정렬
      final requests = querySnapshot.docs
          .map((doc) => FollowRequestDto.fromJson({
        ...doc.data(),
        'id': doc.id, // 문서 ID 추가
      }))
          .toList();

      // createdAt 기준으로 내림차순 정렬 (최신순)
      requests.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      return requests;
    } catch (e) {
      throw Exception('받은 팔로우 요청 조회 중 오류가 발생했습니다: ${e.toString()}');
    }
  }

  // 보낸 팔로우 요청 목록 조회
  @override
  Future<List<FollowRequestDto>> getSentFollowRequests(String userId) async {
    try {
      // orderBy 제거하고 where만 사용
      final querySnapshot =
      await _followRequests
          .where('fromUserId', isEqualTo: userId)
          .get();

      // 데이터를 가져온 후 메모리에서 정렬
      final requests = querySnapshot.docs
          .map((doc) => FollowRequestDto.fromJson({
        ...doc.data(),
        'id': doc.id, // 문서 ID 추가
      }))
          .toList();

      // createdAt 기준으로 내림차순 정렬 (최신순)
      requests.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      return requests;
    } catch (e) {
      throw Exception('보낸 팔로우 요청 조회 중 오류가 발생했습니다: ${e.toString()}');
    }
  }

  // 팔로우 요청 수락
  // 팔로우 요청 수락
  @override
  Future<void> acceptFollowRequest(
      String requestId,
      String fromUserId,
      String toUserId,
      ) async {
    try {
      final batch = FirebaseFirestore.instance.batch();

      // 1. 팔로우 관계 생성 (요청자 → 수락자)
      final followRef1 = _follows.doc('${fromUserId}_${toUserId}');
      batch.set(followRef1, {
        'fromUserId': fromUserId,
        'toUserId': toUserId,
        'createdAt': DateTime.now().toIso8601String(),
      });

      // 2. 역방향 팔로우 관계 생성 (수락자 → 요청자)
      final followRef2 = _follows.doc('${toUserId}_${fromUserId}');
      batch.set(followRef2, {
        'fromUserId': toUserId,
        'toUserId': fromUserId,
        'createdAt': DateTime.now().toIso8601String(),
      });

      // 3. 팔로우 요청 삭제
      final requestRef = _followRequests.doc(requestId);
      batch.delete(requestRef);

      await batch.commit();
    } catch (e) {
      throw Exception('팔로우 요청 수락 중 오류가 발생했습니다: ${e.toString()}');
    }
  }

  // 팔로우 요청 거절
  @override
  Future<void> rejectFollowRequest(String requestId) async {
    try {
      await _followRequests.doc(requestId).delete();
    } catch (e) {
      throw Exception('팔로우 요청 거절 중 오류가 발생했습니다: ${e.toString()}');
    }
  }

  // 팔로우 관계 확인
  @override
  Future<bool> isFollowing(String fromUserId, String toUserId) async {
    try {
      final doc = await _follows.doc('${fromUserId}_${toUserId}').get();
      return doc.exists;
    } catch (e) {
      throw Exception('팔로우 관계 확인 중 오류가 발생했습니다: ${e.toString()}');
    }
  }

  // 언팔로우
  @override
  Future<void> unfollow(String fromUserId, String toUserId) async {
    try {
      await _follows.doc('${fromUserId}_${toUserId}').delete();
    } catch (e) {
      throw Exception('언팔로우 중 오류가 발생했습니다: ${e.toString()}');
    }
  }

  // 팔로우한 사용자 목록 조회
  @override
  Future<List<Map<String, dynamic>>> getFollowingUsers(String userId) async {
    try {
      final querySnapshot =
          await _follows.where('fromUserId', isEqualTo: userId).get();

      final userIds =
          querySnapshot.docs
              .map((doc) => doc.data()['toUserId'] as String)
              .toList();

      if (userIds.isEmpty) return [];

      // 사용자 정보 조회
      final users = <Map<String, dynamic>>[];
      for (final uid in userIds) {
        final userDoc = await _users.doc(uid).get();
        if (userDoc.exists) {
          users.add({...userDoc.data()!, 'uid': uid});
        }
      }

      return users;
    } catch (e) {
      throw Exception('팔로우한 사용자 목록 조회 중 오류가 발생했습니다: ${e.toString()}');
    }
  }

  // 팔로워 목록 조회
  @override
  Future<List<Map<String, dynamic>>> getFollowers(String userId) async {
    try {
      final querySnapshot =
          await _follows.where('toUserId', isEqualTo: userId).get();

      final userIds =
          querySnapshot.docs
              .map((doc) => doc.data()['fromUserId'] as String)
              .toList();

      if (userIds.isEmpty) return [];

      // 사용자 정보 조회
      final users = <Map<String, dynamic>>[];
      for (final uid in userIds) {
        final userDoc = await _users.doc(uid).get();
        if (userDoc.exists) {
          users.add({...userDoc.data()!, 'uid': uid});
        }
      }

      return users;
    } catch (e) {
      throw Exception('팔로워 목록 조회 중 오류가 발생했습니다: ${e.toString()}');
    }
  }
}
