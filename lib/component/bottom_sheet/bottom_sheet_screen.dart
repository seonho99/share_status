import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_status/component/bottom_sheet/bottom_sheet_state.dart';

import '../../core/utils/time_unit_options.dart';
import '../../domain/model/enum/color_status.dart';
import 'bottom_sheet_view_model.dart';

class BottomSheetScreen extends StatelessWidget {
  final void Function(String message, String time, Color color) onSaved;
  final String currentMessage;
  final String currentTime;
  final Color currentColor;

  const BottomSheetScreen({
    super.key,
    required this.onSaved,
    required this.currentMessage,
    required this.currentTime,
    required this.currentColor,
  });

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<BottomSheetViewModel>();
    final state = vm.state;

    // 첫 로드 시 현재 상태로 초기화
    WidgetsBinding.instance.addPostFrameCallback((_) {
      vm.initializeWithCurrentStatus(
        currentMessage: currentMessage,
        currentTime: currentTime,
        currentColor: currentColor,
      );
    });

    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        left: 20,
        right: 20,
        top: 20,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 핸들 바
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // 날짜 선택
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                DropdownButtonHideUnderline(
                  child: DropdownButton<int>(
                    value: state.month == 0 ? null : state.month,
                    hint: const Text('월', style: TextStyle(color: Colors.black)),
                    dropdownColor: Colors.white,
                    icon: const Icon(Icons.arrow_drop_down, color: Colors.black),
                    items: TimeUnitOptions.months
                        .map((m) => DropdownMenuItem(
                      value: m,
                      child: Text('$m월', style: const TextStyle(color: Colors.black)),
                    ))
                        .toList(),
                    onChanged: vm.onMonthChanged,
                    selectedItemBuilder: (BuildContext context) {
                      return TimeUnitOptions.months.map<Widget>((m) {
                        return Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            '${m}월',
                            style: const TextStyle(color: Colors.black),
                          ),
                        );
                      }).toList();
                    },
                  ),
                ),
                DropdownButtonHideUnderline(
                  child: DropdownButton<int>(
                    value: state.day == 0 ? null : state.day,
                    hint: const Text('일', style: TextStyle(color: Colors.black)),
                    dropdownColor: Colors.white,
                    icon: const Icon(Icons.arrow_drop_down, color: Colors.black),
                    items: TimeUnitOptions.days
                        .map((d) => DropdownMenuItem(
                      value: d,
                      child: Text('$d일', style: const TextStyle(color: Colors.black)),
                    ))
                        .toList(),
                    onChanged: vm.onDayChanged,
                    selectedItemBuilder: (BuildContext context) {
                      return TimeUnitOptions.days.map<Widget>((d) {
                        return Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            '${d}일',
                            style: const TextStyle(color: Colors.black),
                          ),
                        );
                      }).toList();
                    },
                  ),
                ),
                DropdownButtonHideUnderline(
                  child: DropdownButton<int>(
                    value: state.hour,
                    dropdownColor: Colors.white,
                    icon: const Icon(Icons.arrow_drop_down, color: Colors.black),
                    items: TimeUnitOptions.hours
                        .map((h) => DropdownMenuItem(
                      value: h,
                      child: Text('$h시', style: const TextStyle(color: Colors.black)),
                    ))
                        .toList(),
                    onChanged: vm.onHourChanged,
                    selectedItemBuilder: (BuildContext context) {
                      return TimeUnitOptions.hours.map<Widget>((h) {
                        return Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            '$h시',
                            style: const TextStyle(color: Colors.black),
                          ),
                        );
                      }).toList();
                    },
                  ),
                ),
                DropdownButtonHideUnderline(
                  child: DropdownButton<int>(
                    value: state.minute,
                    dropdownColor: Colors.white,
                    icon: const Icon(Icons.arrow_drop_down, color: Colors.black),
                    items: TimeUnitOptions.minutes
                        .map((m) => DropdownMenuItem(
                      value: m,
                      child: Text('$m분', style: const TextStyle(color: Colors.black)),
                    ))
                        .toList(),
                    onChanged: vm.onMinuteChanged,
                    selectedItemBuilder: (BuildContext context) {
                      return TimeUnitOptions.minutes.map<Widget>((m) {
                        return Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            '$m분',
                            style: const TextStyle(color: Colors.black),
                          ),
                        );
                      }).toList();
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // 상태 메시지 입력
            TextField(
              controller: TextEditingController(text: state.message)
                ..selection = TextSelection.fromPosition(
                  TextPosition(offset: state.message.length),
                ),
              onChanged: vm.onMessageChanged,
              maxLength: state.maxMessageLength,
              style: const TextStyle(color: Colors.black),
              decoration: const InputDecoration(
                labelText: '상태 메시지',
                labelStyle: TextStyle(color: Colors.grey),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                ),
                counterStyle: TextStyle(color: Colors.grey),
              ),
            ),
            const SizedBox(height: 16),

            // 색상 선택 - 탭 영역 확대
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: FilterColor.values.map((color) {
                return GestureDetector(
                  onTap: () {
                    print('색상 선택: ${color.toString()}'); // 디버그용
                    vm.onColorChanged(color);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0), // 탭 영역 확대
                    child: Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: color.color,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: color == state.selectedColor
                              ? Colors.black
                              : Colors.transparent,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),

            // 취소/저장 버튼
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text(
                      '취소',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: vm.isFormValid ? () {
                      onSaved(
                        state.message,
                        state.formattedTime,
                        state.selectedColor.color,
                      );
                      Navigator.of(context).pop();
                    } : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2E8B57),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      '저장',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}