import 'package:json_annotation/json_annotation.dart';

part 'user_dto.g.dart';

@JsonSerializable(explicitToJson: true)
class UserDto {
  final String uid;
  final String email;
  final String id;
  final String nickname;
  final String imageUrl;

  UserDto({
    required this.uid,
    required this.email,
    required this.id,
    required this.nickname,
    required this.imageUrl,
  });

  factory UserDto.fromJson(Map<String, dynamic> json) => _$UserDtoFromJson(json);

  Map<String, dynamic> toJson() => _$UserDtoToJson(this);
}
