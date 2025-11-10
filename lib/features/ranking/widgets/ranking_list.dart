import 'package:flutter/material.dart';
import 'package:flutter_fb/core/theme/app_colors.dart';
import 'package:flutter_fb/core/theme/app_text_styles.dart';
import 'package:flutter_fb/core/theme/app_spacing.dart';
import 'package:flutter_fb/core/widgets/custom_container_with_subtitle.dart';

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
    return CustomContainerWithSubtitle(
      header: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$job > $awakening 랭킹',
            style: AppTextStyles.body1.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.primaryText,
            ),
          ),
          Opacity(opacity: 0.3),
        ],
      ),

      // ✅ 소제목 영역 (회색 배경)
      subtitle: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '순위 / 캐릭터',
            style: AppTextStyles.body2.copyWith(color: AppColors.secondaryText),
          ),
          Text(
            '명성',
            style: AppTextStyles.body2.copyWith(color: AppColors.secondaryText),
          ),
        ],
      ),

      // ✅ 본문 영역
      children: [
        ...rankingData.asMap().entries.map((entry) {
          final player = entry.value;
          final rank = player['rank'] as int;
          final isTop3 = rank <= 3;

          return Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: GestureDetector(
              onTap: () => onTapCharacter?.call(player),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.sm,
                ),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      offset: const Offset(0, 2),
                      blurRadius: 4,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
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
                    Text(
                      '명성 ${player['score']}',
                      style: AppTextStyles.body2.copyWith(
                        color: AppColors.secondaryText,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ],
    );
  }
}

/// ✅ 순위 뱃지
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
