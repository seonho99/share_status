import 'package:flutter/material.dart';

import '../../domain/model/enum/color_status.dart';
import 'bottom_sheet_state.dart';

class BottomSheetViewModel extends ChangeNotifier {
  BottomSheetState _state = BottomSheetState(
    month: 0,
    day: 0,
    hour: 0,
    minute: 0,
    selectedColor: FilterColor.red,
    message: '',
    maxMessageLength: 15,
  );

  bool _isInitialized = false; // 초기화 상태 확인용

  BottomSheetState get state => _state;

  // 초기 값 설정 메서드 개선
  void initializeWithCurrentStatus({
    required String currentMessage,
    required String currentTime,
    required Color currentColor,
  }) {
    if (_isInitialized) return; // 이미 초기화되었으면 리턴

    // 현재 시간에서 월, 일, 시, 분 추출
    final now = DateTime.now();
    int parsedMonth = now.month;
    int parsedDay = now.day;
    int parsedHour = now.hour;
    int parsedMinute = now.minute;

    // 시간 파싱 개선
    if (currentTime.isNotEmpty) {
      final regex = RegExp(r'(\d+)월\s*(\d+)일\s*(\d+)시\s*(\d+)분');
      final match = regex.firstMatch(currentTime);

      if (match != null) {
        parsedMonth = int.tryParse(match.group(1) ?? '') ?? now.month;
        parsedDay = int.tryParse(match.group(2) ?? '') ?? now.day;
        parsedHour = int.tryParse(match.group(3) ?? '') ?? now.hour;
        parsedMinute = int.tryParse(match.group(4) ?? '') ?? now.minute;
      }
    }

    // 색상 매칭 개선
    FilterColor matchedColor = FilterColor.red;
    for (final color in FilterColor.values) {
      if (color.color.value == currentColor.value) {
        matchedColor = color;
        break;
      }
    }

    _state = _state.copyWith(
      month: parsedMonth,
      day: parsedDay,
      hour: parsedHour,
      minute: parsedMinute,
      selectedColor: matchedColor,
      message: currentMessage,
    );

    _isInitialized = true; // 초기화 완료 표시
    notifyListeners();
  }

  void onMonthChanged(int? value) {
    if (value == null) return;
    _state = _state.copyWith(month: value);
    notifyListeners();
  }

  void onDayChanged(int? value) {
    if (value == null) return;
    _state = _state.copyWith(day: value);
    notifyListeners();
  }

  void onHourChanged(int? value) {
    if (value == null) return;
    _state = _state.copyWith(hour: value);
    notifyListeners();
  }

  void onMinuteChanged(int? value) {
    if (value == null) return;
    _state = _state.copyWith(minute: value);
    notifyListeners();
  }

  void onColorChanged(FilterColor color) {
    _state = _state.copyWith(selectedColor: color);
    notifyListeners();
  }

  void onMessageChanged(String value) {
    _state = _state.copyWith(message: value);
    notifyListeners();
  }

  bool get isFormValid =>
      _state.message.length <= _state.maxMessageLength &&
          _state.month > 0 &&
          _state.day > 0;

  String get formattedTime =>
      '${_state.month}월 ${_state.day}일 ${_state.hour}시 ${_state.minute}분';

  // 초기화 상태 리셋
  void reset() {
    _isInitialized = false;
    _state = BottomSheetState(
      month: 0,
      day: 0,
      hour: 0,
      minute: 0,
      selectedColor: FilterColor.red,
      message: '',
      maxMessageLength: 15,
    );
  }
}