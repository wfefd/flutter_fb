// lib/features/character/presentation/widgets/detail_buff_tab.dart

import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/custom_container_divided.dart';
import '../../models/domain/buff_item.dart';
import '../../models/ui/buff_slot.dart';

class BuffTab extends StatelessWidget {
  /// 이제는 "BuffItem 리스트"가 아니라 "BuffSlot 리스트"를 받는다.
  final List<BuffSlot> slots;

  const BuffTab({super.key, required this.slots});

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

  // URL/asset 둘 다 처리
  Widget _buildImage(String path) {
    const double size = 36;

    if (path.isEmpty) {
      return Image.asset(
        'assets/images/no_image.png',
        width: size,
        height: size,
        fit: BoxFit.cover,
      );
    }

    if (path.startsWith('http')) {
      return Image.network(
        path,
        width: size,
        height: size,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) {
          return Image.asset(
            'assets/images/no_image.png',
            width: size,
            height: size,
            fit: BoxFit.cover,
          );
        },
      );
    }

    return Image.asset(path, width: size, height: size, fit: BoxFit.cover);
  }

  // 카테고리에 따라 옵션 색 적당히 나눔
  Color _getOptionColor(BuffItem item) {
    // 대충 규칙:
    // - 아바타: 주황
    // - 그 외(장비/크리쳐): 보라
    final cat = item.category;
    if (cat.contains('아바타')) {
      return Colors.orange;
    }
    return Colors.purple;
  }

  @override
  Widget build(BuildContext context) {
    // 슬롯조차 없으면 구조 문제
    if (slots.isEmpty) {
      return const Center(
        child: Text(
          '버프 슬롯 정보를 불러오지 못했습니다.',
          style: TextStyle(color: AppColors.secondaryText),
        ),
      );
    }

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
        children: slots.map((slot) {
          final BuffItem? item = slot.item;

          // 1) 해당 슬롯에 버프 장비가 없는 경우
          if (item == null) {
            return _buildEmptyBuffSlot(slot.category);
          }

          // 2) 실제 버프 장비가 있는 경우
          final optionColor = _getOptionColor(item);
          return _buildBuffBox(
            category: slot.category,
            item: item,
            optionColor: optionColor,
          );
        }).toList(),
      ),
    );
  }

  /// 버프 장비가 없는 슬롯 UI
  Widget _buildEmptyBuffSlot(String category) {
    return Container(
      height: 70,
      margin: const EdgeInsets.symmetric(vertical: 4),
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
              category,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                color: AppColors.primaryText,
              ),
            ),
          ),
          const SizedBox(width: 4),

          const Icon(
            Icons.remove_circle_outline,
            size: 20,
            color: AppColors.secondaryText,
          ),
          const SizedBox(width: 8),

          const Expanded(
            child: Text(
              '장착된 버프 장비 없음',
              style: TextStyle(fontSize: 12, color: AppColors.secondaryText),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  /// 실제 버프 장비 카드
  Widget _buildBuffBox({
    required String category,
    required BuffItem item,
    Color optionColor = Colors.purple,
  }) {
    final nameColor = _getGradeColor(item.grade);

    return Container(
      height: 80,
      margin: const EdgeInsets.symmetric(vertical: 4),
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
              category,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                color: AppColors.primaryText,
              ),
            ),
          ),
          const SizedBox(width: 4),

          // 이미지
          _buildImage(item.imagePath),
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
                    color: nameColor, // 등급에 따른 이름 색
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
    );
  }
}
