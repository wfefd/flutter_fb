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
    return CustomContainerDivided(
      header: const Text('각성 선택', style: TextStyle()),
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: awakenings.map((awakening) {
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
                      border: Border.all(
                        color: isSelected
                            ? Colors.transparent
                            : AppColors.border,
                      ),
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
                    child: Text(
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
