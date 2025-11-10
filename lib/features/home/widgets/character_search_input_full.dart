import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class CharacterSearchInput extends StatelessWidget {
  final String selectedServer;
  final List<String> servers;
  final TextEditingController controller;
  final ValueChanged<String> onServerChanged;
  final VoidCallback onSearch;

  const CharacterSearchInput({
    super.key,
    required this.selectedServer,
    required this.servers,
    required this.controller,
    required this.onServerChanged,
    required this.onSearch,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // ✅ 로고
        Image.asset('assets/images/logo_done_big.png', height: 180),

        const SizedBox(height: 24),

        // ✅ 감싸던 Container 완전히 제거
        Row(
          children: [
            // ✅ 서버 선택 드롭다운
            Container(
              height: 44,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: AppColors.surface, // ✅ surface 색상으로 변경
                borderRadius: BorderRadius.circular(8),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: selectedServer,
                  icon: const Icon(
                    Icons.arrow_drop_down,
                    color: AppColors.secondaryText,
                  ),
                  style: AppTextStyles.body1.copyWith(
                    color: AppColors.primaryText, // ✅ 텍스트색 변경
                  ),
                  onChanged: (value) {
                    if (value != null) onServerChanged(value);
                  },
                  items: servers
                      .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                      .toList(),
                ),
              ),
            ),

            const SizedBox(width: 12),

            // ✅ 캐릭터 검색 입력창
            Expanded(
              child: Container(
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: controller,
                        decoration: InputDecoration(
                          hintText: '캐릭터 이름을 입력하세요',
                          hintStyle: AppTextStyles.body1.copyWith(
                            color: AppColors.secondaryText,
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 11, // ✅ 수직 중앙 정렬
                          ),
                        ),
                        onSubmitted: (_) => onSearch(),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.search),
                      color: AppColors.secondaryText,
                      onPressed: onSearch,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 24),
      ],
    );
  }
}
