import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../theme/app_spacing.dart';

/// 섹션 공통 컨테이너
/// - 상단 제목 + 우측 trailing(로고/버튼 등)
/// - 제목 아래 Divider
/// - (옵션) 테이블 헤더 행
/// - 본문 child
class SectionContainer extends StatelessWidget {
  final String title;
  final Widget? trailing; // 우측 로고/버튼
  final List<HeaderColumn>? header; // 테이블 헤더 컬럼(옵션)
  final Widget? child;

  final EdgeInsetsGeometry margin;
  final EdgeInsetsGeometry padding;
  final double radius;
  final bool hasShadow;
  final bool showTitleDivider; // 제목 아래 구분선 표시 여부

  const SectionContainer({
    super.key,
    required this.title,
    this.trailing,
    this.header,
    this.child,
    this.margin = const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    this.padding = const EdgeInsets.all(16),
    this.radius = 12,
    this.hasShadow = true,
    this.showTitleDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(radius),
        boxShadow: hasShadow
            ? [
                // Figma: x:0, y:2, blur:4, #000 10%
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  offset: const Offset(0, 2),
                  blurRadius: 4,
                ),
              ]
            : const [],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 제목 줄
          Padding(
            padding: padding,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    title,
                    style: AppTextStyles.subtitle.copyWith(
                      color: AppColors.primaryText,
                      fontWeight: FontWeight.w700,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (trailing != null) trailing!,
              ],
            ),
          ),

          if (showTitleDivider)
            Divider(height: 1, thickness: 0.6, color: AppColors.border),

          // 헤더 행 (옵션)
          if (header != null && header!.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                children: header!
                    .map(
                      (h) => Expanded(
                        flex: h.flex,
                        child: Text(
                          h.label,
                          textAlign: h.align,
                          style: AppTextStyles.body2.copyWith(
                            color: AppColors.secondaryText,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
            Divider(height: 1, thickness: 0.6, color: AppColors.border),
          ],

          // 본문 (옵션)
          if (child != null) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(16, AppSpacing.md, 16, 16),
              child: child!,
            ),
          ],
        ],
      ),
    );
  }
}

/// 테이블 헤더 컬럼 정의용
class HeaderColumn {
  final String label;
  final int flex;
  final TextAlign align;

  const HeaderColumn(this.label, {this.flex = 1, this.align = TextAlign.start});
}
