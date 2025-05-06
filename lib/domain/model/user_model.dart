import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.freezed.dart';

@freezed
class UserModel with _$UserModel {
  final String uid;
  final String email;
  final String id;
  final String nickname;
  final String imageUrl;

  const UserModel({
    required this.uid,
    required this.email,
    required this.id,
    required this.nickname,
    required this.imageUrl,
  });
}
