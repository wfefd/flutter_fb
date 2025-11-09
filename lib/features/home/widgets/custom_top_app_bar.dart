import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';

import '../../../core/theme/app_text_styles.dart';

class CustomTopAppBar extends StatefulWidget implements PreferredSizeWidget {
  final bool showTabBar;
  const CustomTopAppBar({super.key, this.showTabBar = true});

  @override
  State<CustomTopAppBar> createState() => _CustomTopAppBarState();

  @override
  Size get preferredSize =>
      Size.fromHeight(kToolbarHeight + (showTabBar ? kTextTabBarHeight : 0.0));
}

class _CustomTopAppBarState extends State<CustomTopAppBar> {
  final TextEditingController _controller = TextEditingController();

  void _onSearch() {
    final query = _controller.text.trim();
    if (query.isEmpty) return;
    Navigator.pushNamed(context, '/character_search', arguments: query);
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.surface,
      elevation: 0,
      titleSpacing: AppSpacing.sm,
      title: Row(
        children: [
          // 로고 이미지로 교체 가능
          Image.asset('assets/images/logo_done.png', height: 52),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Container(
              height: 38,
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      onSubmitted: (_) => _onSearch(),
                      decoration: InputDecoration(
                        hintText: '던전앤파이터 캐릭터 검색',
                        hintStyle: AppTextStyles.body2.copyWith(
                          color: AppColors.secondaryText,
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.md,
                          vertical: AppSpacing.sm,
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.search),
                    color: AppColors.secondaryText,
                    onPressed: _onSearch,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
