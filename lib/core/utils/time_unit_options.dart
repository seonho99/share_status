class TimeUnitOptions {
  static List<int> months = [for (var i = 1; i <= 12; i++) i];    // 1~12월
  static List<int> days = [for (var i = 1; i <= 31; i++) i];      // 1~31일
  static List<int> hours = [for (var i = 0; i < 24; i++) i];      // 0~23시
  static List<int> minutes = [for (var i = 0; i < 60; i++) i];    // 0~59분
}
