import 'package:flutter/material.dart';
import 'package:flutter_fb/core/theme/app_colors.dart';
import 'package:flutter_fb/core/theme/app_text_styles.dart';
import 'package:flutter_fb/core/theme/app_spacing.dart';
import '../../../../core/widgets/custom_container_divided.dart';
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
    return CustomContainerDivided(
      header: const Text(
        '직업 선택',
        style: TextStyle(
          // fontWeight: FontWeight.bold,
          color: AppColors.primaryText,
        ),
      ),
      children: [
        ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.5, // 최대 높이만 제한
          ),
          child: SingleChildScrollView(
            child: Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: jobs.map((job) {
                final isSelected = selectedJob == job;

                return GestureDetector(
                  onTap: () => onJobSelected(job),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primaryText.withOpacity(0.9)
                          : AppColors.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected
                            ? Colors.transparent
                            : AppColors.border,
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: AppColors.primaryText.withOpacity(0.15),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ]
                          : [],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: Image.asset(
                            'assets/images/jobs/${JobImageMap.getJobIcon(job)}',
                            width: 26,
                            height: 26,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(
                                  Icons.person,
                                  size: 24,
                                  color: AppColors.secondaryText,
                                ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          job,
                          style: AppTextStyles.body1.copyWith(
                            fontSize: 13,
                            color: isSelected
                                ? Colors.white
                                : AppColors.primaryText,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}
