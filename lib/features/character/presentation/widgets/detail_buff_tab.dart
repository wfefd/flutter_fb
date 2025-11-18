import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/custom_container_divided.dart';
import '../../models/buff_item.dart';

class BuffTab extends StatelessWidget {
  const BuffTab({super.key});

  // 등급에 따른 색 (장착장비랑 동일한 로직)
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
      default:
        return AppColors.primaryText;
    }
  }

  // 상/하의 아바타
  static const List<BuffItem> _avatarSection = [
    BuffItem(
      category: '상의 아바타',
      imagePath: 'assets/images/sample_weapon.png',
      name: '레어 상의 크론 아바타',
      grade: '레어',
      option: '오버드라이브 스킬 Lv +1', // 없으면 "" 로 내려오게 약속
    ),
    BuffItem(
      category: '하의 아바타',
      imagePath: 'assets/images/sample_weapon.png',
      name: '레어 하의 크론 아바타',
      grade: '레어',
      option: 'HP MAX +400 증가',
    ),
  ];

  // 크리쳐
  static const BuffItem _creature = BuffItem(
    category: '크리쳐',
    imagePath: 'assets/images/sample_weapon.png',
    name: 'SD 건실[단련된]',
    grade: '에픽',
    option: '', // 옵션 없으면 이렇게 빈 문자열
  );

  // 버프용 장비들
  static const List<BuffItem> _equipmentList = [
    BuffItem(
      category: '무기',
      imagePath: 'assets/images/sample_weapon.png',
      name: '짙은 심연의 편린 빌소드 : 오버드라이브',
      grade: '에픽',
      option: '+3 강화',
    ),
    BuffItem(
      category: '칭호',
      imagePath: 'assets/images/sample_weapon.png',
      name: '모험가의 엘지[빛]',
      grade: '에픽',
      option: '+2 강화',
    ),
    BuffItem(
      category: '상의',
      imagePath: 'assets/images/sample_weapon.png',
      name: '짙은 심연의 편린 상의 : 오버드라이브',
      grade: '에픽',
      option: '+3 강화',
    ),
    BuffItem(
      category: '머리어깨',
      imagePath: 'assets/images/sample_weapon.png',
      name: '짙은 심연의 편린 어깨 : 오버드라이브',
      grade: '에픽',
      option: '+3 강화',
    ),
    BuffItem(
      category: '하의',
      imagePath: 'assets/images/sample_weapon.png',
      name: '짙은 심연의 편린 하의 : 오버드라이브',
      grade: '에픽',
      option: '+3 강화',
    ),
    BuffItem(
      category: '신발',
      imagePath: 'assets/images/sample_weapon.png',
      name: '짙은 심연의 편린 신발 : 오버드라이브',
      grade: '에픽',
      option: '+3 강화',
    ),
    BuffItem(
      category: '벨트',
      imagePath: 'assets/images/sample_weapon.png',
      name: '짙은 심연의 편린 벨트 : 오버드라이브',
      grade: '에픽',
      option: '+3 강화',
    ),
    BuffItem(
      category: '목걸이',
      imagePath: 'assets/images/sample_weapon.png',
      name: '짙은 심연의 편린 목걸이 : 오버드라이브',
      grade: '에픽',
      option: '+3 강화',
    ),
    BuffItem(
      category: '팔찌',
      imagePath: 'assets/images/sample_weapon.png',
      name: '짙은 심연의 편린 팔찌 : 오버드라이브',
      grade: '에픽',
      option: '+3 강화',
    ),
    BuffItem(
      category: '반지',
      imagePath: 'assets/images/sample_weapon.png',
      name: '짙은 심연의 편린 반지 : 오버드라이브',
      grade: '에픽',
      option: '+3 강화',
    ),
    BuffItem(
      category: '보조장비',
      imagePath: 'assets/images/sample_weapon.png',
      name: '짙은 뒤틀린 심연의 현광 : 오버드라이브',
      grade: '에픽',
      option: '+3 강화',
    ),
    BuffItem(
      category: '마법석',
      imagePath: 'assets/images/sample_weapon.png',
      name: '짙은 뒤틀린 심연의 마법석 : 오버드라이브',
      grade: '에픽',
      option: '+3 강화',
    ),
    BuffItem(
      category: '귀걸이',
      imagePath: 'assets/images/sample_weapon.png',
      name: '짙은 뒤틀린 심연의 귀걸이 : 오버드라이브',
      grade: '에픽',
      option: '',
    ),
  ];

  @override
  Widget build(BuildContext context) {
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
          // 상/하의 아바타 (옵션 색: 주황)
          ..._avatarSection.map(
            (item) => _buildBuffBox(item, optionColor: Colors.orange),
          ),

          const SizedBox(height: 12),

          // 크리쳐 (옵션 거의 없으니 기본 색)
          _buildBuffBox(_creature, optionColor: Colors.purple),

          const SizedBox(height: 12),

          // 버프 장비들 (보라)
          ..._equipmentList.map(
            (item) => _buildBuffBox(item, optionColor: Colors.purple),
          ),
        ],
      ),
    );
  }

  Widget _buildBuffBox(BuffItem item, {Color optionColor = Colors.purple}) {
    final nameColor = _getGradeColor(item.grade);

    return Container(
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

            // 이름 + 옵션
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    item.name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: nameColor, // 👈 등급에 따른 이름 색
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),

                  // 옵션: 백에서 ""이면 안 보임
                  if (item.option.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 3),
                      child: Text(
                        item.option,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: optionColor,
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
