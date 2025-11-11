import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/custom_container_divided.dart';

class SkillBloomTab extends StatelessWidget {
  const SkillBloomTab({super.key});

  static const List<Map<String, dynamic>> _skillBloomList = [
    {
      'baseSkill': {'image': 'assets/images/sample_weapon.png', 'name': '발도'},
      'bloom1': {
        'image': 'assets/images/sample_weapon.png',
        'name': '맹가의 손놀림',
        'level': 1,
        'highlight': true,
      },
      'bloom2': {
        'image': 'assets/images/sample_weapon.png',
        'name': '속전속결',
        'level': 2,
        'highlight': false,
      },
    },
    {
      'baseSkill': {
        'image': 'assets/images/sample_weapon.png',
        'name': '맹룡단공참',
      },
      'bloom1': {
        'image': 'assets/images/sample_weapon.png',
        'name': '맹룡선풍참',
        'level': 1,
        'highlight': false,
      },
      'bloom2': {
        'image': 'assets/images/sample_weapon.png',
        'name': '파죽지세',
        'level': 2,
        'highlight': false,
      },
    },
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      itemCount: _skillBloomList.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final item = _skillBloomList[index];
        return CustomContainerDivided(
          header: index == 0
              ? const Text(
                  '스킬 개화',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: AppColors.primaryText,
                  ),
                )
              : null,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.border, width: 1),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildSkillItem(item['baseSkill'], isBase: true),
                  const SizedBox(width: 10),
                  Expanded(child: _buildSkillItem(item['bloom1'])),
                  const SizedBox(width: 6),
                  Expanded(child: _buildSkillItem(item['bloom2'])),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSkillItem(Map<String, dynamic>? skill, {bool isBase = false}) {
    if (skill == null) return const SizedBox();
    final highlight = skill['highlight'] == true;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 6),
      decoration: BoxDecoration(
        color: highlight ? const Color(0xFFF4ECFF) : Colors.transparent,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: [
          Image.asset(
            skill['image'],
            width: isBase ? 40 : 32,
            height: isBase ? 40 : 32,
            fit: BoxFit.cover,
            cacheWidth: isBase ? 80 : 64, // 🔹 성능 최적화
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              skill['name'],
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryText,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (!isBase && skill['level'] != null)
            Container(
              width: 20,
              height: 20,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: highlight ? Colors.purple : Colors.grey.shade400,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                '${skill['level']}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
