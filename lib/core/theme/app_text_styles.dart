import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  static const h1 = TextStyle(
    fontSize: 24,
    height: 1.4,
    fontWeight: FontWeight.w700,
    color: AppColors.primaryText,
  );

  static const h2 = TextStyle(
    fontSize: 20,
    height: 1.4,
    fontWeight: FontWeight.w600,
    color: AppColors.primaryText,
  );

  static const subtitle = TextStyle(
    fontSize: 16,
    height: 1.4,
    fontWeight: FontWeight.w600,
    color: AppColors.primaryText,
  );

  static const body1 = TextStyle(
    fontSize: 14,
    height: 1.6,
    fontWeight: FontWeight.w400,
    color: AppColors.primaryText,
  );

  static const body2 = TextStyle(
    fontSize: 12,
    height: 1.6,
    fontWeight: FontWeight.w400,
    color: AppColors.secondaryText,
  );

  static const caption = TextStyle(
    fontSize: 10,
    height: 1.0,
    fontWeight: FontWeight.w400,
    color: AppColors.secondaryText,
  );
}

// Text("던전앤파이터 캐릭터 검색", style: AppTextStyles.h1);
// Text("11월 8일 전체 서버 랭킹", style: AppTextStyles.h2);
// Text("전사A", style: AppTextStyles.subtitle);
// Text("카인 서버", style: AppTextStyles.body2);
// Text("186억 7395만", style: AppTextStyles.body1);
// Text("업데이트 기준: 오늘", style: AppTextStyles.caption);
