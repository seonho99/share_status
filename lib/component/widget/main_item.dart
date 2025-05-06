import 'package:flutter/material.dart';

class MainItem extends StatelessWidget {
  final String name;
  final String statusMessage;
  final String timestamp;
  final Color statusColor;

  const MainItem({
    super.key,
    required this.name,
    required this.statusMessage,
    required this.timestamp,
    required this.statusColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            border: Border.all(color: Color(0xFFD9D9D9), width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.25),
                blurRadius: 4,
                spreadRadius: 0,
                offset: Offset(0, 4),
              ),
            ],
          ),
        ),
        SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  name,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
                SizedBox(width: 20),
                Text(timestamp, style: TextStyle(fontSize: 17)),
              ],
            ),
            Row(
              children: [
                Container(
                  width: 14,
                  height: 14,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: statusColor,
                  ),
                ),
                SizedBox(width: 20),
                Text(statusMessage, style: TextStyle(fontSize: 17)),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
