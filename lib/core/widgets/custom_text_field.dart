import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../theme/app_spacing.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final TextEditingController? controller;
  final bool isError;
  final String? helperText;

  const CustomTextField({
    super.key,
    required this.hintText,
    this.controller,
    this.isError = false,
    this.helperText,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: AppTextStyles.body2.copyWith(color: AppColors.secondaryText),
        filled: true,
        fillColor: AppColors.background,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: AppColors.secondaryText,
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: AppColors.primaryText,
            width: 1.2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: Color(0xFFD9534F), // Error 빨강
            width: 1.2,
          ),
        ),
        helperText: helperText,
        helperStyle: AppTextStyles.caption.copyWith(
          color: isError ? const Color(0xFFD9534F) : AppColors.secondaryText,
        ),
      ),
      style: AppTextStyles.body1.copyWith(color: AppColors.primaryText),
    );
  }
}
