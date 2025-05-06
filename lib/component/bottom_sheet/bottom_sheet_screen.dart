import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_status/component/bottom_sheet/bottom_sheet_state.dart';

import '../../../core/utils/time_unit_options.dart';
import '../../../domain/model/enum/color_status.dart';
import 'bottom_sheet_view_model.dart';

class BottomSheetScreen extends StatelessWidget {
  final void Function(String message, String time, Color color) onSaved;

  const BottomSheetScreen({super.key,required this.onSaved});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<BottomSheetViewModel>();
    final state = vm.state;

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 날짜 선택
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              DropdownButton<int>(
                value: state.month == 0 ? null : state.month,
                hint: const Text('월'),
                items: TimeUnitOptions.months
                    .map((m) =>
                    DropdownMenuItem(value: m, child: Text('$m월')))
                    .toList(),
                onChanged: vm.onMonthChanged,
              ),
              DropdownButton<int>(
                value: state.day == 0 ? null : state.day,
                hint: const Text('일'),
                items: TimeUnitOptions.days
                    .map((d) =>
                    DropdownMenuItem(value: d, child: Text('$d일')))
                    .toList(),
                onChanged: vm.onDayChanged,
              ),
              DropdownButton<int>(
                value: state.hour,
                items: TimeUnitOptions.hours
                    .map((h) =>
                    DropdownMenuItem(value: h, child: Text('$h시')))
                    .toList(),
                onChanged: vm.onHourChanged,
              ),
              DropdownButton<int>(
                value: state.minute,
                items: TimeUnitOptions.minutes
                    .map((m) =>
                    DropdownMenuItem(value: m, child: Text('$m분')))
                    .toList(),
                onChanged: vm.onMinuteChanged,
              ),
            ],
          ),
          const SizedBox(height: 16),

          // 상태 메시지 입력
          TextField(
            onChanged: vm.onMessageChanged,
            maxLength: state.maxMessageLength,
            decoration: const InputDecoration(
              labelText: '상태 메시지',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),

          // 색상 선택
          Wrap(
            spacing: 10,
            children: FilterColor.values.map((color) {
              return GestureDetector(
                onTap: () => vm.onColorChanged(color),
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
              );
            }).toList(),
          ),
          const SizedBox(height: 24),

          // 저장 버튼
          ElevatedButton(
            onPressed: vm.isFormValid ? () {
              onSaved(
                state.message,
                state.formattedTime,
                state.selectedColor.color,
              );
              Navigator.of(context).pop(); // 닫기 등
            } : null,
            child: const Text('저장'),
          )
        ],
      ),
    );
  }
}
