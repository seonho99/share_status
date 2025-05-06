
import '../../domain/model/enum/color_status.dart';
import '../../domain/model/status.dart';
import '../dto/status_dto.dart';

extension StatusMapper on StatusDto {
  Status toStatus() {
    return Status(
      name: name ?? '제목 없음',
      statusTime: statusTime ?? DateTime.now(),
      colorStatus: colorStatus != null ? FilterColor.fromInt(colorStatus!) : FilterColor.grey,
      statusMessage: statusMessage ?? '',
    );
  }
}