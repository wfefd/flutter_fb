import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_spacing.dart';

class CommonContainer extends StatelessWidget {
  final String title; // 섹션 타이틀
  final Widget? logo; // 오른쪽 상단 로고 (선택)
  final Widget? child; // 본문 콘텐츠 (선택)

  const CommonContainer({
    super.key,
    required this.title,
    this.logo,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface, // ✅ 섹션 배경
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(
              0.1,
            ), // ✅ x:0, y:2, blur:4, opacity 10%
            offset: const Offset(0, 2),
            blurRadius: 4,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ✅ 제목 + 로고
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: AppTextStyles.subtitle.copyWith(
                  color: AppColors.primaryText,
                  fontWeight: FontWeight.w700,
                ),
              ),
              if (logo != null) logo!,
            ],
          ),

          const SizedBox(height: AppSpacing.sm),

          // ✅ Divider
          Divider(color: AppColors.border, height: 1, thickness: 0.6),

          if (child != null) ...[const SizedBox(height: AppSpacing.md), child!],
        ],
      ),
    );
  }
}
