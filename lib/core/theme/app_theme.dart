import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';

final ThemeData appTheme = ThemeData(
  fontFamily: 'Pretendard', // ✅ 전역 폰트 설정
  scaffoldBackgroundColor: AppColors.background,
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: AppColors.primaryText,
    background: AppColors.background,
    surface: AppColors.surface,
  ),
  textTheme: const TextTheme(
    bodyLarge: AppTextStyles.body1,
    bodyMedium: AppTextStyles.body2,
    labelLarge: AppTextStyles.caption,
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: AppColors.surface,
    elevation: 0,
    titleTextStyle: TextStyle(
      fontFamily: 'Pretendard', // ✅ AppBar에도 적용
      fontWeight: FontWeight.bold,
      fontSize: 18,
      color: AppColors.primaryText,
    ),
  ),
);
