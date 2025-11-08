import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class CustomTabBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomTabBar({super.key});

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(kTextTabBarHeight),
      child: Container(
        color: AppColors.surface,
        child: Align(
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8), // ✅ 좌우 8px 동일하게
            child: TabBar(
              // isScrollable: false, // ✅ 모든 탭이 같은 너비 차지
              indicatorColor: AppColors.secondaryText,
              indicatorWeight: 1,
              labelColor: AppColors.secondaryText,
              unselectedLabelColor: AppColors.secondaryText,
              labelStyle: AppTextStyles.body1.copyWith(
                fontWeight: FontWeight.w600,
              ),
              unselectedLabelStyle: AppTextStyles.body2,
              labelPadding: const EdgeInsets.symmetric(horizontal: 16),
              tabs: const [
                Tab(text: '홈'),
                Tab(text: '순위'),
                Tab(text: '경매장'),
                Tab(text: '커뮤니티'),
                Tab(text: '공지사항'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kTextTabBarHeight);
}
