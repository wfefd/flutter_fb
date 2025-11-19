import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/custom_container_divided.dart';
import '../../models/ui/basic_stat.dart';

class StatTab extends StatelessWidget {
  // ❌ 예전: 고정 mock 데이터만 쓰던 버전
  // const StatTab({super.key});
  // List<BasicStat> get _stats => const [ ... ];

  // ✅ NEW: 외부에서 스탯 리스트를 주입받음
  final List<BasicStat> stats; // ★ NEW

  const StatTab({
    super.key,
    required this.stats, // ★ CHANGED
  });

  @override
  Widget build(BuildContext context) {
    // 혹시 null/빈 리스트면 안내만
    if (stats.isEmpty) {
      // ★ NEW
      return const Center(
        child: Text(
          '스탯 정보가 없습니다.',
          style: TextStyle(color: AppColors.secondaryText),
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: CustomContainerDivided(
        header: const Text(
          '스탯',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: AppColors.primaryText,
          ),
        ),
        // ❌ 예전: final stats = _stats;
        // ✅ 이제는 생성자로 받은 stats 사용
        children: List.generate((stats.length / 2).ceil(), (index) {
          final left = stats[index * 2];
          final right = index * 2 + 1 < stats.length
              ? stats[index * 2 + 1]
              : null;

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              children: [
                Expanded(child: _buildStatBox(left)),
                const SizedBox(width: 8),
                Expanded(
                  child: right != null
                      ? _buildStatBox(right)
                      : const SizedBox(), // 홀수일 때 빈 공간
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildStatBox(BasicStat stat) {
    return Container(
      height: 42,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border, width: 1),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Image.asset(
                stat.iconPath,
                width: 18,
                height: 18,
                errorBuilder: (_, __, ___) =>
                    const Icon(Icons.circle, size: 12),
              ),
              const SizedBox(width: 6),
              Text(
                stat.name,
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.primaryText,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          Text(
            stat.value,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.primaryText,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
