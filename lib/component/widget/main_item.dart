import 'package:flutter/material.dart';

class MainItem extends StatelessWidget {
  final String name;
  final String statusMessage;
  final String statusTime;
  final Color statusColor;
  final String? imageUrl; // 이미지 URL 추가

  const MainItem({
    super.key,
    required this.name,
    required this.statusMessage,
    required this.statusTime,
    required this.statusColor,
    this.imageUrl, // 이미지 URL은 선택적 파라미터
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
          child: ClipOval(
            child: imageUrl != null && imageUrl!.isNotEmpty
                ? Image.network(
              imageUrl!,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                        : null,
                    strokeWidth: 2,
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                // 이미지 로딩 실패 시 기본 아이콘 표시
                return Icon(
                  Icons.person,
                  size: 30,
                  color: Colors.grey[400],
                );
              },
            )
                : Icon(
              Icons.person,
              size: 30,
              color: Colors.grey[400],
            ),
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
                Text(statusTime, style: TextStyle(fontSize: 17)),
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