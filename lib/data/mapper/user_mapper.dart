import '../../domain/model/user_model.dart';
import '../dto/user_dto.dart';

import '../../domain/model/user_model.dart';
import '../dto/user_dto.dart';

extension UserDtoMapper on UserDto {
  UserModel toDomain() {
    return UserModel(
      uid: uid,
      email: email,
      id: id,
      nickname: nickname,
      imageUrl: imageUrl,
    );
  }
}

extension UserDomainMapper on UserModel {
  UserDto toDto() {
    return UserDto(
      uid: uid,
      email: email,
      id: id,
      nickname: nickname,
      imageUrl: imageUrl,
    );
  }
}

