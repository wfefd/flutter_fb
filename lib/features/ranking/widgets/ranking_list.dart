import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../core/widgets/common_container.dart';

class RankingList extends StatelessWidget {
  final String job;
  final String awakening;
  final List<Map<String, dynamic>> rankingData;
  final Function(Map<String, dynamic>)? onTapCharacter;

  const RankingList({
    super.key,
    required this.job,
    required this.awakening,
    required this.rankingData,
    this.onTapCharacter,
  });

  @override
  Widget build(BuildContext context) {
    return CommonContainer(
      title: '$job > $awakening 랭킹',
      logo: Opacity(
        opacity: 0.3,
        child: Image.asset(
          'assets/images/logo_done_small.png', // 오른쪽 워터마크 느낌
          height: 18,
        ),
      ),
      child: Column(
        children: rankingData.map((player) {
          final rank = player['rank'] as int;
          final isTop3 = rank <= 3;

          return GestureDetector(
            onTap: () => onTapCharacter?.call(player),
            child: Container(
              margin: const EdgeInsets.only(bottom: AppSpacing.xs),
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
              decoration: BoxDecoration(
                color: AppColors.surface, // ✅ 랭킹 행 배경
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(
                      0.1,
                    ), // ✅ x:0 y:2 blur:4 opacity 10%
                    offset: const Offset(0, 2),
                    blurRadius: 4,
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // ✅ 순위 + 이름
                  Row(
                    children: [
                      _RankBadge(rank: rank),
                      const SizedBox(width: AppSpacing.sm),
                      Text(
                        player['name'],
                        style: AppTextStyles.body1.copyWith(
                          color: AppColors.primaryText,
                          fontWeight: isTop3
                              ? FontWeight.w700
                              : FontWeight.w500,
                        ),
                      ),
                    ],
                  ),

                  // ✅ 명성
                  Text(
                    '명성 ${player['score']}',
                    style: AppTextStyles.body2.copyWith(
                      color: AppColors.secondaryText,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

/// 🔹 순위 표시용 뱃지
class _RankBadge extends StatelessWidget {
  final int rank;
  const _RankBadge({required this.rank});

  @override
  Widget build(BuildContext context) {
    final bool isTop3 = rank <= 3;

    Color bgColor;
    switch (rank) {
      case 1:
        bgColor = const Color(0xFFFFD700); // gold
        break;
      case 2:
        bgColor = const Color(0xFFC0C0C0); // silver
        break;
      case 3:
        bgColor = const Color(0xFFCD7F32); // bronze
        break;
      default:
        bgColor = AppColors.border;
    }

    return Container(
      width: 24,
      height: 24,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: isTop3 ? bgColor.withOpacity(0.9) : AppColors.surface,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: isTop3 ? Colors.transparent : AppColors.border,
        ),
      ),
      child: Text(
        '$rank',
        style: AppTextStyles.body2.copyWith(
          color: isTop3 ? Colors.white : AppColors.secondaryText,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
