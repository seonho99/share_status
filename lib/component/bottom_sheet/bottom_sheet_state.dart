import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/model/enum/color_status.dart';

part 'bottom_sheet_state.freezed.dart';

@freezed
class BottomSheetState with _$BottomSheetState {
  final int month;
  final int day;
  final int hour;
  final int minute;
  final FilterColor selectedColor;
  final String message;
  final int maxMessageLength;

  BottomSheetState({
    required this.month,
    required this.day,
    required this.hour,
    required this.minute,
    required this.selectedColor,
    required this.message,
    required this.maxMessageLength,
  });
}

extension BottomSheetStateX on BottomSheetState {
  String get formattedTime =>
      '${month}월 ${day}일 ${hour.toString().padLeft(2, '0')}시 ${minute.toString().padLeft(2, '0')}분';
}
