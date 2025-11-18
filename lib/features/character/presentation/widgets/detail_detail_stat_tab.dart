import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/custom_container_divided.dart';

class DetailStatTab extends StatelessWidget {
  const DetailStatTab({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> detailStats = [
      {'name': '공격력 증가', 'value': '71104.5 (58.0%)'},
      {'name': '버프력', 'value': '272481 (13%)'},
      {'name': '최종데미지 증가', 'value': '4029586%'},
      {'name': '속강 중첩', 'value': '203%'},
      {'name': '쿨타임 감소\n(구간감소 제외)', 'value': '38.3%'},
      {'name': '쿨타임 회복\n(구간증가 제외)', 'value': '0.0%'},
      {'name': '총 쿨타임 감소', 'value': '38.3%'},
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: CustomContainerDivided(
        header: const Text(
          '세부스탯',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: AppColors.primaryText,
          ),
        ),
        children: detailStats.map((stat) {
          return Container(
            height: 46,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.border, width: 1),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    stat['name']!,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.primaryText,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Text(
                  stat['value']!,
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.primaryText,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
