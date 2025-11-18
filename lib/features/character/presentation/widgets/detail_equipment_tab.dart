import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../models/equipment_item.dart';
import '../../../../core/widgets/custom_container_divided.dart';

class EquipmentTab extends StatelessWidget {
  EquipmentTab({super.key});

  // 등급 → 색 매핑은 프론트에서
  Color _getGradeColor(String grade) {
    switch (grade.toLowerCase()) {
      case 'common':
      case '일반':
        return Colors.grey.shade400;
      case 'uncommon':
      case '언커먼':
        return Colors.green.shade600;
      case 'rare':
      case '레어':
        return Colors.blueAccent;
      case 'unique':
      case '유니크':
        return Colors.purpleAccent;
      case 'legendary':
      case '레전더리':
        return Colors.orange;
      case 'epic':
      case '에픽':
        return Colors.yellow.shade700;
      case 'mythic':
      case '신화':
        return const Color(0xFFFFD700); // 금색
      case 'primeval':
      default:
        return AppColors.primaryText;
    }
  }

  // ✅ 모델만 들고 있는 더미 데이터 (Color 없음)
  final List<EquipmentItem> equipmentList = const [
    EquipmentItem(
      category: '세트',
      imagePath: 'assets/images/sample_weapon.png',
      name: '멸룡 세트',
      grade: '레전더리',
      option: '+3 세트효과',
      desc: '모속강 +20, 피해 증가 +10%',
    ),
    EquipmentItem(
      category: '무기',
      imagePath: 'assets/images/sample_weapon.png',
      name: '멸룡검 발몽',
      grade: '일반',
      option: '+15 증폭',
      desc: '모속강 +15 공격력 +30',
    ),
    EquipmentItem(
      category: '칭호',
      imagePath: 'assets/images/sample_weapon.png',
      name: '영광의 칭호',
      grade: '에픽',
      option: '+2 버프레벨',
      desc: '모든 공격력 +10%',
    ),
    EquipmentItem(
      category: '상의',
      imagePath: 'assets/images/sample_weapon.png',
      name: '멸룡의 흉갑',
      grade: 'rare',
      option: '+15 강화',
      desc: '공격속도 +5%, 크리티컬 +3%',
    ),
    EquipmentItem(
      category: '머리어깨',
      imagePath: 'assets/images/sample_weapon.png',
      name: '멸룡의 어깨',
      grade: '태초',
      option: '+12 강화',
      desc: '피해 증가 +5%',
    ),
    EquipmentItem(
      category: '하의',
      imagePath: 'assets/images/sample_weapon.png',
      name: '멸룡의 하의',
      grade: '태초',
      option: '+13 강화',
      desc: '모속강 +10',
    ),
    EquipmentItem(
      category: '신발',
      imagePath: 'assets/images/sample_weapon.png',
      name: '멸룡의 부츠',
      grade: '태초',
      option: '+10 강화',
      desc: '이동속도 +8%',
    ),
    EquipmentItem(
      category: '벨트',
      imagePath: 'assets/images/sample_weapon.png',
      name: '멸룡의 벨트',
      grade: '태초',
      option: '+11 강화',
      desc: '공격속도 +3%',
    ),
    EquipmentItem(
      category: '목걸이',
      imagePath: 'assets/images/sample_weapon.png',
      name: '멸룡의 목걸이',
      grade: '태초',
      option: '+14 강화',
      desc: '모속강 +5',
    ),
    EquipmentItem(
      category: '팔찌',
      imagePath: 'assets/images/sample_weapon.png',
      name: '멸룡의 팔찌',
      grade: '태초',
      option: '+15 강화',
      desc: '물리 공격력 +5%',
    ),
    EquipmentItem(
      category: '반지',
      imagePath: 'assets/images/sample_weapon.png',
      name: '멸룡의 반지',
      grade: '태초',
      option: '+15 강화',
      desc: '마법 공격력 +5%',
    ),
    EquipmentItem(
      category: '보조장비',
      imagePath: 'assets/images/sample_weapon.png',
      name: '멸룡의 부적',
      grade: '태초',
      option: '+10 강화',
      desc: '크리티컬 +3%',
    ),
    EquipmentItem(
      category: '마법석',
      imagePath: 'assets/images/sample_weapon.png',
      name: '멸룡의 마석',
      grade: '태초',
      option: '+15 강화',
      desc: '속성 피해 +7%',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: CustomContainerDivided(
        header: const Text(
          '장착장비',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: AppColors.primaryText,
          ),
        ),
        children: equipmentList.map((item) {
          final gradeColor = _getGradeColor(item.grade);

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
                    width: 55,
                    child: Text(
                      item.category,
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
                    item.imagePath,
                    width: 36,
                    height: 36,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(width: 8),

                  // 장비명 및 세부정보
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                item.name,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                  color: gradeColor, // 등급 색 → 이름에 적용
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              item.grade,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFFFD700), // 등급 라벨은 고정 색
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              item.option,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.orange, // 옵션 색도 프론트에서 고정
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item.desc,
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppColors.secondaryText,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
