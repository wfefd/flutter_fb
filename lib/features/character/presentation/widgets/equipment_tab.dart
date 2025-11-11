import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/custom_container_divided.dart';

class EquipmentTab extends StatelessWidget {
  const EquipmentTab({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> equipmentList = [
      {
        'category': '세트',
        'image': 'assets/images/sample_weapon.png',
        'name': '멸룡 세트',
        'grade': '영웅',
        'option': '+3 세트효과',
        'optionColor': Colors.blue,
        'desc': '모속강 +20, 피해 증가 +10%',
      },
      {
        'category': '무기',
        'image': 'assets/images/sample_weapon.png',
        'name': '멸룡검 발몽',
        'grade': '0',
        'option': '+15 증폭',
        'optionColor': Colors.purple,
        'desc': '모속강 +15 공격력 +30',
      },
      {
        'category': '칭호',
        'image': 'assets/images/sample_weapon.png',
        'name': '영광의 칭호',
        'grade': '에픽',
        'option': '+2 버프레벨',
        'optionColor': Colors.orange,
        'desc': '모든 공격력 +10%',
      },
      {
        'category': '상의',
        'image': 'assets/images/sample_weapon.png',
        'name': '멸룡의 흉갑',
        'grade': '영원',
        'option': '+15 강화',
        'optionColor': Colors.orange,
        'desc': '공격속도 +5%, 크리티컬 +3%',
      },
      {
        'category': '머리어깨',
        'image': 'assets/images/sample_weapon.png',
        'name': '멸룡의 어깨',
        'grade': '영원',
        'option': '+12 강화',
        'optionColor': Colors.orange,
        'desc': '피해 증가 +5%',
      },
      {
        'category': '하의',
        'image': 'assets/images/sample_weapon.png',
        'name': '멸룡의 하의',
        'grade': '영원',
        'option': '+13 강화',
        'optionColor': Colors.orange,
        'desc': '모속강 +10',
      },
      {
        'category': '신발',
        'image': 'assets/images/sample_weapon.png',
        'name': '멸룡의 부츠',
        'grade': '영원',
        'option': '+10 강화',
        'optionColor': Colors.orange,
        'desc': '이동속도 +8%',
      },
      {
        'category': '벨트',
        'image': 'assets/images/sample_weapon.png',
        'name': '멸룡의 벨트',
        'grade': '영원',
        'option': '+11 강화',
        'optionColor': Colors.orange,
        'desc': '공격속도 +3%',
      },
      {
        'category': '목걸이',
        'image': 'assets/images/sample_weapon.png',
        'name': '멸룡의 목걸이',
        'grade': '영원',
        'option': '+14 강화',
        'optionColor': Colors.orange,
        'desc': '모속강 +5',
      },
      {
        'category': '팔찌',
        'image': 'assets/images/sample_weapon.png',
        'name': '멸룡의 팔찌',
        'grade': '영원',
        'option': '+15 강화',
        'optionColor': Colors.orange,
        'desc': '물리 공격력 +5%',
      },
      {
        'category': '반지',
        'image': 'assets/images/sample_weapon.png',
        'name': '멸룡의 반지',
        'grade': '영원',
        'option': '+15 강화',
        'optionColor': Colors.orange,
        'desc': '마법 공격력 +5%',
      },
      {
        'category': '보조장비',
        'image': 'assets/images/sample_weapon.png',
        'name': '멸룡의 부적',
        'grade': '영원',
        'option': '+10 강화',
        'optionColor': Colors.orange,
        'desc': '크리티컬 +3%',
      },
      {
        'category': '마법석',
        'image': 'assets/images/sample_weapon.png',
        'name': '멸룡의 마석',
        'grade': '영원',
        'option': '+15 강화',
        'optionColor': Colors.orange,
        'desc': '속성 피해 +7%',
      },
    ];

    return CustomContainerDivided(
      header: const Text(
        '장착장비',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 14,
          color: AppColors.primaryText,
        ),
      ),
      children: equipmentList.map((item) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 🔹 카테고리
            SizedBox(
              width: 55,
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

            // 🔹 이미지
            Image.asset(
              item['image'],
              width: 36,
              height: 36,
              fit: BoxFit.cover,
            ),
            const SizedBox(width: 8),

            // 🔹 장비명 및 세부정보
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          item['name'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            color: AppColors.primaryText,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        item['grade'],
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.secondaryText,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        item['option'],
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: item['optionColor'],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item['desc'],
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.secondaryText,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      }).toList(),
    );
  }
}
