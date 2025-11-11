import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/custom_container_divided.dart';

class BuffTab extends StatelessWidget {
  const BuffTab({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> avatarSection = [
      {
        'category': '상의 아바타',
        'image': 'assets/images/sample_weapon.png',
        'name': '레어 상의 크론 아바타',
        'option': '오버드라이브 스킬 Lv +1',
        'optionColor': Colors.orange,
      },
      {
        'category': '하의 아바타',
        'image': 'assets/images/sample_weapon.png',
        'name': '레어 하의 크론 아바타',
        'option': 'HP MAX +400 증가',
        'optionColor': Colors.orange,
      },
    ];

    final Map<String, dynamic> creature = {
      'category': '크리쳐',
      'image': 'assets/images/sample_weapon.png',
      'name': 'SD 건실[단련된]',
      'option': '',
      'optionColor': Colors.purple,
    };

    final List<Map<String, dynamic>> equipmentList = [
      {
        'category': '무기',
        'image': 'assets/images/sample_weapon.png',
        'name': '짙은 심연의 편린 빌소드 : 오버드라이브',
        'option': '+3 강화',
        'optionColor': Colors.purple,
      },
      {
        'category': '칭호',
        'image': 'assets/images/sample_weapon.png',
        'name': '모험가의 엘지[빛]',
        'option': '+2 강화',
        'optionColor': Colors.purple,
      },
      {
        'category': '상의',
        'image': 'assets/images/sample_weapon.png',
        'name': '짙은 심연의 편린 상의 : 오버드라이브',
        'option': '+3 강화',
        'optionColor': Colors.purple,
      },
      {
        'category': '머리어깨',
        'image': 'assets/images/sample_weapon.png',
        'name': '짙은 심연의 편린 어깨 : 오버드라이브',
        'option': '+3 강화',
        'optionColor': Colors.purple,
      },
      {
        'category': '하의',
        'image': 'assets/images/sample_weapon.png',
        'name': '짙은 심연의 편린 하의 : 오버드라이브',
        'option': '+3 강화',
        'optionColor': Colors.purple,
      },
      {
        'category': '신발',
        'image': 'assets/images/sample_weapon.png',
        'name': '짙은 심연의 편린 신발 : 오버드라이브',
        'option': '+3 강화',
        'optionColor': Colors.purple,
      },
      {
        'category': '벨트',
        'image': 'assets/images/sample_weapon.png',
        'name': '짙은 심연의 편린 벨트 : 오버드라이브',
        'option': '+3 강화',
        'optionColor': Colors.purple,
      },
      {
        'category': '목걸이',
        'image': 'assets/images/sample_weapon.png',
        'name': '짙은 심연의 편린 목걸이 : 오버드라이브',
        'option': '+3 강화',
        'optionColor': Colors.purple,
      },
      {
        'category': '팔찌',
        'image': 'assets/images/sample_weapon.png',
        'name': '짙은 심연의 편린 팔찌 : 오버드라이브',
        'option': '+3 강화',
        'optionColor': Colors.purple,
      },
      {
        'category': '반지',
        'image': 'assets/images/sample_weapon.png',
        'name': '짙은 심연의 편린 반지 : 오버드라이브',
        'option': '+3 강화',
        'optionColor': Colors.purple,
      },
      {
        'category': '보조장비',
        'image': 'assets/images/sample_weapon.png',
        'name': '짙은 뒤틀린 심연의 현광 : 오버드라이브',
        'option': '+3 강화',
        'optionColor': Colors.purple,
      },
      {
        'category': '마법석',
        'image': 'assets/images/sample_weapon.png',
        'name': '짙은 뒤틀린 심연의 마법석 : 오버드라이브',
        'option': '+3 강화',
        'optionColor': Colors.purple,
      },
      {
        'category': '귀걸이',
        'image': 'assets/images/sample_weapon.png',
        'name': '짙은 뒤틀린 심연의 귀걸이 : 오버드라이브',
        'option': '+3 강화',
        'optionColor': Colors.purple,
      },
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: CustomContainerDivided(
        header: const Text(
          '버프 강화',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: AppColors.primaryText,
          ),
        ),
        children: [
          // 상의 / 하의 아바타
          ...avatarSection.map((item) => _buildBuffBox(item)),

          const SizedBox(height: 12),

          // 크리쳐
          _buildBuffBox(creature),

          const SizedBox(height: 12),

          // 장착 장비들
          ...equipmentList.map((item) => _buildBuffBox(item)),
        ],
      ),
    );
  }

  Widget _buildBuffBox(Map<String, dynamic> item) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Container(
        height: 80,
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.border, width: 1),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 카테고리
            SizedBox(
              width: 70,
              child: Text(
                item['category'],
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: AppColors.primaryText,
                ),
              ),
            ),
            const SizedBox(width: 4),

            // 이미지
            Image.asset(
              item['image'],
              width: 36,
              height: 36,
              fit: BoxFit.cover,
            ),
            const SizedBox(width: 8),

            // 이름 + 옵션
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    item['name'],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: AppColors.primaryText,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (item['option'] != null && item['option'] != '')
                    Padding(
                      padding: const EdgeInsets.only(top: 3),
                      child: Text(
                        item['option'],
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: item['optionColor'] ?? Colors.purple,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
