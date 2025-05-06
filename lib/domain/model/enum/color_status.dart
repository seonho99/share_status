import 'package:flutter/material.dart';

enum FilterColor {
  red(0xFFFF0000),      // 응답 못함
  yellow(0xFFF4F900),  // 자리 비움
  green(0xFF41CC3E),   // 응답 가능
  grey(0xFFD9D9D9);    // 오프라인

  final int colorValue;

  const FilterColor(this.colorValue);

  Color get color => Color(colorValue);

  static FilterColor fromInt(int colorValue) {
    return FilterColor.values.firstWhere(
          (e) => e.colorValue == colorValue,
      orElse: () => FilterColor.grey,
    );
  }
}
