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

  BottomSheetState get state => _state;

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
          _state.day > 0 &&
          _state.hour >= 0 &&
          _state.minute >= 0;

  String get formattedTime =>
      '${_state.month}월 ${_state.day}일 ${_state.hour}시 ${_state.minute}분';
}
