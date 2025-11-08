import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_spacing.dart';

class SearchTextField extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSearch;

  const SearchTextField({
    super.key,
    required this.controller,
    required this.onSearch,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                onSubmitted: (_) => onSearch(),
                decoration: InputDecoration(
                  hintText: '캐릭터 이름을 입력하세요',
                  hintStyle: AppTextStyles.body2.copyWith(
                    color: AppColors.secondaryText,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                  ),
                ),
              ),
            ),
            Container(
              height: double.infinity,
              width: 48,
              decoration: const BoxDecoration(
                color: AppColors.primaryText,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
              ),
              child: IconButton(
                icon: const Icon(Icons.search, color: Colors.white),
                onPressed: onSearch,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
