import 'package:flutter/material.dart';
import 'package:flutter_fb/core/theme/app_colors.dart';
import 'package:flutter_fb/core/theme/app_text_styles.dart';
import 'package:flutter_fb/core/theme/app_spacing.dart';
import '../data/job_image_map.dart';

class JobSelector extends StatelessWidget {
  final List<String> jobs;
  final String? selectedJob;
  final ValueChanged<String> onJobSelected;

  const JobSelector({
    super.key,
    required this.jobs,
    required this.selectedJob,
    required this.onJobSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ✅ 헤더
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '직업 목록',
                  style: AppTextStyles.body1.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryText,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      '더 보기',
                      style: AppTextStyles.body1.copyWith(
                        color: AppColors.secondaryText,
                      ),
                    ),
                    const Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 14,
                      color: AppColors.secondaryText,
                    ),
                  ],
                ),
              ],
            ),
          ),

          // ✅ Divider
          const Divider(height: 1, color: AppColors.border),

          // ✅ 본문
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.xs,
              0, // Divider와 너무 띄워지지 않게
              AppSpacing.xs,
              AppSpacing.xs,
            ),
            child: Wrap(
              spacing: AppSpacing.xs, // 가로 간격
              runSpacing: AppSpacing.xs, // 세로 간격
              children: jobs.map((job) {
                final isSelected = selectedJob == job;
                return GestureDetector(
                  onTap: () => onJobSelected(job),
                  child: SizedBox(
                    width: 60, // 한 칸 고정 폭
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // ✅ 이미지 박스
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.secondaryText
                                  : Colors.transparent,
                              width: isSelected ? 2 : 0,
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: Image.asset(
                              'assets/images/jobs/${JobImageMap.getJobIcon(job)}',
                              width: 42,
                              height: 42,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(
                                    Icons.person,
                                    size: 40,
                                    color: AppColors.secondaryText,
                                  ),
                            ),
                          ),
                        ),

                        // ✅ 직업명
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            job,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.body2.copyWith(
                              fontSize: 11,
                              color: AppColors.primaryText,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
