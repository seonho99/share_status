import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/utils/time_unit_options.dart';
import 'bottom_sheet_view_model.dart';

class BottomSheetScreen extends StatelessWidget {
  const BottomSheetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<BottomSheetViewModel>(context);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 월/일/시/분 드롭다운 Row
          Row(
            children: [
              DropdownButton<int>(
                value: vm.month == 0 ? null : vm.month,
                hint: Text('월'),
                items: TimeUnitOptions.months
                    .map((m) => DropdownMenuItem(value: m, child: Text('$m월')))
                    .toList(),
                onChanged: vm.onMonthChanged,
              ),
              // ... 일/시/분도 동일하게
            ],
          ),
          // 상태 메시지, 색상, 저장 버튼 등도 여기에 배치
        ],
      ),
    );
  }
}
