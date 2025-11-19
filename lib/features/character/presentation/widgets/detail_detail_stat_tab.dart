import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/custom_container_divided.dart';

// 경로는 네 프로젝트에 맞게 맞춰라
import '../../models/domain/character_detail_stats.dart';
import '../../models/ui/detail_stat.dart';

class DetailStatTab extends StatelessWidget {
  // ❌ 예전: 내부에서 Map 리스트 하드코딩
  // const DetailStatTab({super.key});
  //
  // @override
  // Widget build(...) {
  //   final List<Map<String, String>> detailStats = [ ... ];

  // ✅ NEW: 실제 모델을 외부에서 주입
  final CharacterDetailStats detailStats; // 필수: 숫자 기반 세부 스탯
  final List<DetailStat> extraStats; // 선택: 추가 설명형 스탯

  const DetailStatTab({
    super.key,
    required this.detailStats,
    this.extraStats = const [],
  });

  @override
  Widget build(BuildContext context) {
    // 기본 7줄: 숫자 → 문자열 포맷
    final List<Map<String, String>> rows = [
      {
        'name': '공격력 증가',
        'value':
            '${detailStats.attackIncreaseFlat.toStringAsFixed(1)} '
            '(${detailStats.attackIncreasePercent.toStringAsFixed(1)}%)',
      },
      {
        'name': '버프력',
        'value':
            '${detailStats.buffPower} '
            '(${detailStats.buffPowerPercent.toStringAsFixed(1)}%)',
      },
      {
        'name': '최종데미지 증가',
        'value': '${detailStats.finalDamagePercent.toStringAsFixed(1)}%',
      },
      {
        'name': '속강 중첩',
        'value': '${detailStats.elementStackPercent.toStringAsFixed(1)}%',
      },
      {
        'name': '쿨타임 감소\n(구간감소 제외)',
        'value': '${detailStats.cooldownReductionPercent.toStringAsFixed(1)}%',
      },
      {
        'name': '쿨타임 회복\n(구간증가 제외)',
        'value': '${detailStats.cooldownRecoveryPercent.toStringAsFixed(1)}%',
      },
      {
        'name': '총 쿨타임 감소',
        'value':
            '${detailStats.totalCooldownReductionPercent.toStringAsFixed(1)}%',
      },
    ];

    // 추가 DetailStat 있으면 밑에 붙여줌
    for (final ext in extraStats) {
      rows.add({'name': ext.name, 'value': ext.value});
    }

    if (rows.isEmpty) {
      return const Center(
        child: Text(
          '세부 스탯 정보가 없습니다.',
          style: TextStyle(color: AppColors.secondaryText),
        ),
      );
    }

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
        children: rows.map((stat) {
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
