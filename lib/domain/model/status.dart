import 'package:freezed_annotation/freezed_annotation.dart';

import 'enum/color_status.dart';

part 'status.freezed.dart';

@freezed
class Status with _$Status {
  final String name;
  final DateTime statusTime;
  final FilterColor colorStatus;
  final String statusMessage;

  const Status({
    required this.name,
    required this.statusTime,
    required this.colorStatus,
    required this.statusMessage,
  });
}