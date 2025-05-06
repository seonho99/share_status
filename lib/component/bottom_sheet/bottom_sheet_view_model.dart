import 'package:flutter/material.dart';

import '../../domain/model/enum/color_status.dart';

class BottomSheetViewModel extends ChangeNotifier {
  int _month = 0;
  int _day = 0;
  int _hour = 0;
  int _minute = 0;
  FilterColor _selectedColor = FilterColor.red;
  final TextEditingController messageController = TextEditingController();
  final int maxMessageLength = 15;

  int get month => _month;
  int get day => _day;
  int get hour => _hour;
  int get minute => _minute;
  FilterColor get selectedColor => _selectedColor;

  void onMonthChanged(int? value) {
    if (value == null) return;
    _month = value;
    notifyListeners();
  }

  void onDayChanged(int? value) {
    if (value == null) return;
    _day = value;
    notifyListeners();
  }

  void onHourChanged(int? value) {
    if (value == null) return;
    _hour = value;
    notifyListeners();
  }

  void onMinuteChanged(int? value) {
    if (value == null) return;
    _minute = value;
    notifyListeners();
  }

  void onColorChanged(FilterColor color) {
    _selectedColor = color;
    notifyListeners();
  }

  bool get isMessageValid => messageController.text.length <= maxMessageLength;

  bool get isFormValid {
    return isMessageValid &&
        _month > 0 &&
        _day > 0 &&
        _hour >= 0 &&
        _minute >= 0;
  }

  String get formattedTime => '${_month}월 ${_day}일 ${_hour}시 ${_minute}분';

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }
}
