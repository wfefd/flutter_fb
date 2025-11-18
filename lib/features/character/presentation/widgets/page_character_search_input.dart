import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class CharacterSearchInputFull extends StatelessWidget {
  final String selectedServer;
  final List<String> servers;
  final TextEditingController controller;
  final ValueChanged<String> onServerChanged;
  final VoidCallback onSearch;

  const CharacterSearchInputFull({
    super.key,
    required this.selectedServer,
    required this.servers,
    required this.controller,
    required this.onServerChanged,
    required this.onSearch,
  });

  void _handleSearch(BuildContext context) {
    final name = controller.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('캐릭터 이름을 입력하세요.')));
      return;
    }
    onSearch(); // ✅ CharacterSearchTab의 _searchCharacter 호출
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset('assets/images/logo_done_big.png', height: 180),
        const SizedBox(height: 24),
        Row(
          children: [
            Container(
              height: 44,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: AppColors.surface,
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
                    color: AppColors.primaryText,
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
                            vertical: 11,
                          ),
                        ),
                        onSubmitted: (_) => _handleSearch(context),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.search),
                      color: AppColors.secondaryText,
                      onPressed: () => _handleSearch(context),
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
