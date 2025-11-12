import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/custom_container_divided.dart';

class AwakeningSelector extends StatelessWidget {
  final String job;
  final List<String> awakenings;
  final String? selectedAwakening;
  final ValueChanged<String> onAwakeningSelected;

  const AwakeningSelector({
    super.key,
    required this.job,
    required this.awakenings,
    required this.selectedAwakening,
    required this.onAwakeningSelected,
  });

  @override
  Widget build(BuildContext context) {
    // ✅ "전체"를 포함한 리스트
    final allAwakenings = ['전체', ...awakenings];

    return CustomContainerDivided(
      header: const Text(
        '각성 선택',
        style: TextStyle(color: AppColors.primaryText),
      ),
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: allAwakenings.map((awakening) {
              final isSelected = selectedAwakening == awakening;

              return Padding(
                padding: const EdgeInsets.only(right: AppSpacing.sm),
                child: GestureDetector(
                  onTap: () => onAwakeningSelected(awakening),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primaryText.withOpacity(0.9)
                          : AppColors.surface,
                      borderRadius: BorderRadius.circular(12),

                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: AppColors.primaryText.withOpacity(0.2),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ]
                          : [],
                    ),
                    child: Row(
                      children: [
                        // ✅ "전체"일 경우 아이콘 표시
                        if (awakening == '전체') ...[
                          const Icon(
                            Icons.all_inclusive_rounded,
                            size: 24,
                            color: AppColors.secondaryText,
                          ),
                          const SizedBox(width: 6),
                        ],
                        Text(
                          awakening,
                          style: TextStyle(
                            color: isSelected
                                ? Colors.white
                                : AppColors.primaryText,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.w500,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
