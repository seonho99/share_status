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
  final _statuses = FirebaseFirestore.instance.collection('user_statuses');

  @override
  Future<void> saveUser(UserDto user) async {
    await _users.doc(user.uid).set(user.toJson());
  }

  @override
  Future<bool> checkIdExists(String id) async {
    try {
      print('ID 중복 확인 시작: $id');
      final querySnapshot = await _users.where('id', isEqualTo: id).get();
      final isEmpty = querySnapshot.docs.isEmpty;
      print('ID 중복 확인 결과 - 사용 가능: $isEmpty (문서 수: ${querySnapshot.docs.length})');
      return isEmpty;
    } catch (e) {
      print('ID 중복 확인 중 오류 발생: $e');
      throw Exception('ID 중복 확인 중 오류가 발생했습니다: $e');
    }
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
  Future<List<FollowRequestDto>> getReceivedFollowRequests(
    String userId,
  ) async {
    try {
      final querySnapshot =
          await _followRequests.where('toUserId', isEqualTo: userId).get();

      // 데이터를 가져온 후 메모리에서 정렬
      final requests =
          querySnapshot.docs
              .map(
                (doc) => FollowRequestDto.fromJson({
                  ...doc.data(),
                  'id': doc.id, // 문서 ID 추가
                }),
              )
              .toList();

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
          await _followRequests.where('fromUserId', isEqualTo: userId).get();

      // 데이터를 가져온 후 메모리에서 정렬
      final requests =
          querySnapshot.docs
              .map(
                (doc) => FollowRequestDto.fromJson({
                  ...doc.data(),
                  'id': doc.id, // 문서 ID 추가
                }),
              )
              .toList();

      requests.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      return requests;
    } catch (e) {
      throw Exception('보낸 팔로우 요청 조회 중 오류가 발생했습니다: ${e.toString()}');
    }
  }

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

  // 상태 저장
  @override
  Future<void> saveUserStatus({
    required String userId,
    required String statusMessage,
    required String statusTime,
    required int colorStatus,
  }) async {
    try {
      await _statuses.doc(userId).set({
        'statusMessage': statusMessage,
        'statusTime': statusTime,
        'colorStatus': colorStatus,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('상태 저장 중 오류가 발생했습니다: ${e.toString()}');
    }
  }

  // 상태 조회
  @override
  Future<Map<String, dynamic>?> getUserStatus(String userId) async {
    try {
      final doc = await _statuses.doc(userId).get();
      if (doc.exists) {
        return doc.data();
      }
      return null;
    } catch (e) {
      throw Exception('상태 조회 중 오류가 발생했습니다: ${e.toString()}');
    }
  }

  // 팔로우한 사용자들의 상태 조회
  @override
  Future<Map<String, Map<String, dynamic>>> getFollowingUsersStatus(
    List<String> userIds,
  ) async {
    try {
      final statusMap = <String, Map<String, dynamic>>{};

      if (userIds.isEmpty) return statusMap;

      // 최대 10개씩 쿼리하기 (Firestore의 'whereIn' 제한)
      final chunks = <List<String>>[];
      for (var i = 0; i < userIds.length; i += 10) {
        chunks.add(
          userIds.sublist(i, i + 10 > userIds.length ? userIds.length : i + 10),
        );
      }

      for (final chunk in chunks) {
        final querySnapshot =
            await _statuses.where(FieldPath.documentId, whereIn: chunk).get();

        for (final doc in querySnapshot.docs) {
          if (doc.exists) {
            statusMap[doc.id] = doc.data();
          }
        }
      }

      return statusMap;
    } catch (e) {
      throw Exception('사용자 상태 조회 중 오류가 발생했습니다: ${e.toString()}');
    }
  }

  // 프로필 관련 메서드 추가
  @override
  Future<Map<String, dynamic>?> getUserProfile(String userId) async {
    try {
      final doc = await _users.doc(userId).get();
      if (doc.exists) {
        return {...doc.data()!, 'uid': doc.id};
      }
      return null;
    } catch (e) {
      throw Exception('사용자 프로필 조회 중 오류가 발생했습니다: ${e.toString()}');
    }
  }

  @override
  Future<void> updateUserProfile({
    required String userId,
    required String nickname,
    required String imageUrl,
  }) async {
    try {
      await _users.doc(userId).update({
        'nickname': nickname,
        'imageUrl': imageUrl,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('사용자 프로필 업데이트 중 오류가 발생했습니다: ${e.toString()}');
    }
  }

  @override
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      final user = _auth.currentUser;
      if (user == null || user.email == null) {
        throw Exception('로그인된 사용자가 없습니다.');
      }

      // 재인증용 credential 생성
      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: currentPassword,
      );

      // 사용자 재인증
      await user.reauthenticateWithCredential(credential);

      // 비밀번호 변경
      await user.updatePassword(newPassword);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'wrong-password':
          throw Exception('현재 비밀번호가 올바르지 않습니다.');
        case 'invalid-credential':
          throw Exception('인증 정보가 유효하지 않습니다.');
        case 'requires-recent-login':
          throw Exception('보안을 위해 다시 로그인 후 시도해주세요.');
        case 'weak-password':
          throw Exception('새 비밀번호가 너무 약합니다.');
        default:
          throw Exception('비밀번호 변경 중 오류가 발생했습니다: ${e.message}');
      }
    } catch (e) {
      throw Exception('비밀번호 변경 중 알 수 없는 오류가 발생했습니다: ${e.toString()}');
    }
  }

  @override
  Future<void> deleteAccount({required String password}) async {
    try {
      final user = _auth.currentUser;
      if (user == null || user.email == null) {
        throw Exception('로그인된 사용자가 없습니다.');
      }

      // 사용자 재인증
      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: password,
      );
      await user.reauthenticateWithCredential(credential);

      // 사용자 데이터 삭제
      final userId = user.uid;

      // Firestore에서 사용자 관련 데이터 삭제 (트랜잭션으로 처리)
      final batch = FirebaseFirestore.instance.batch();

      // 사용자 정보 삭제
      batch.delete(_users.doc(userId));

      // 사용자 상태 삭제
      batch.delete(_statuses.doc(userId));

      // 배치 실행
      await batch.commit();

      // 사용자 계정 삭제
      await user.delete();
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'wrong-password':
          throw Exception('비밀번호가 올바르지 않습니다.');
        case 'invalid-credential':
          throw Exception('인증 정보가 유효하지 않습니다.');
        case 'requires-recent-login':
          throw Exception('보안을 위해 다시 로그인 후 시도해주세요.');
        default:
          throw Exception('계정 삭제 중 오류가 발생했습니다: ${e.message}');
      }
    } catch (e) {
      throw Exception('계정 삭제 중 알 수 없는 오류가 발생했습니다: ${e.toString()}');
    }
  }
}
