import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/custom_container_divided.dart';

class AuctionSearchScreen extends StatefulWidget {
  final String query;

  const AuctionSearchScreen({super.key, required this.query});

  @override
  State<AuctionSearchScreen> createState() => _AuctionSearchScreenState();
}

class _AuctionSearchScreenState extends State<AuctionSearchScreen> {
  // TODO: 나중에 실제 서버/레포에서 가져오면 됨.
  // 일단은 EquipmentTab에서 쓰던 더미 데이터 재사용
  final List<Map<String, dynamic>> _equipmentList = [
    {
      'category': '세트',
      'image': 'assets/images/sample_weapon.png',
      'name': '멸룡 세트',
      'grade': '레전더리',
      'option': '+3 세트효과',
      'optionColor': Colors.blue,
      'desc': '모속강 +20, 피해 증가 +10%',
    },
    {
      'category': '무기',
      'image': 'assets/images/sample_weapon.png',
      'name': '멸룡검 발몽',
      'grade': '일반',
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
    // ... 나머지 네가 쓰던 리스트 그대로 추가
  ];

  late List<Map<String, dynamic>> _filteredList;

  @override
  void initState() {
    super.initState();
    _filteredList = _filterByQuery(widget.query);
  }

  List<Map<String, dynamic>> _filterByQuery(String q) {
    final query = q.trim();
    if (query.isEmpty) return List.from(_equipmentList);

    return _equipmentList.where((item) {
      final name = (item['name'] ?? '') as String;
      return name.contains(query);
    }).toList();
  }

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
        return const Color(0xFFFFD700);
      case 'primeval':
      default:
        return AppColors.primaryText;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.primaryText,
        title: Text(
          '\'${widget.query}\' 검색결과',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.primaryText,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        child: CustomContainerDivided(
          header: const Text(
            '아이템 리스트',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: AppColors.primaryText,
            ),
          ),
          children: _filteredList.map((item) {
            final gradeColor = _getGradeColor(item['grade'] ?? '');

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
                                  item['name'],
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                    color: gradeColor,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                item['grade'],
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFFFFD700),
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                item['option'],
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: item['optionColor'] as Color,
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
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
