// lib/features/character/presentation/widgets/detail_avatar_creature_tab.dart

import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/custom_container_divided.dart';
import '../../models/domain/avatar_item.dart';
import '../../models/ui/avatar_creature_slot.dart';

class AvatarCreatureTab extends StatelessWidget {
  /// 이제는 "아바타 리스트"가 아니라 "슬롯 리스트"를 받는다.
  final List<AvatarSlot> slots;

  const AvatarCreatureTab({super.key, required this.slots});

  // URL/asset 둘 다 처리하는 이미지 헬퍼
  Widget _buildImage(String path, double size) {
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

    // 나머지는 asset 경로로 취급
    return Image.asset(path, width: size, height: size, fit: BoxFit.cover);
  }

  @override
  Widget build(BuildContext context) {
    // 슬롯 리스트조차 비어 있으면 구조 자체 문제
    if (slots.isEmpty) {
      return const Center(
        child: Text(
          '아바타 / 크리쳐 슬롯 정보를 불러오지 못했습니다.',
          style: TextStyle(color: AppColors.secondaryText),
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: CustomContainerDivided(
        header: const Text(
          '아바타 / 크리쳐',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: AppColors.primaryText,
          ),
        ),
        children: slots.map((slot) {
          final AvatarItem? item = slot.item;
          final bool isCreature = slot.category == '크리쳐';

          // 1) 해당 슬롯에 아무것도 없는 경우
          if (item == null) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Container(
                height: 70,
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
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
                      width: 75,
                      child: Text(
                        slot.category,
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

                    Expanded(
                      child: Text(
                        isCreature ? '장착된 크리쳐 없음' : '장착된 아바타 없음',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.secondaryText,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          // 2) 실제 아이템이 있는 경우
          final images = item.images;

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Container(
              height: 90,
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
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
                    width: 75,
                    child: Text(
                      slot.category,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        color: AppColors.primaryText,
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),

                  // 이미지들
                  SizedBox(
                    width: isCreature ? 120 : 60,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: List.generate(images.length, (i) {
                        final img = images[i];
                        double size;
                        if (isCreature) {
                          size = i == 0 ? 30 : 18; // 크리쳐: 메인 큼, 나머지 작게
                        } else {
                          size = 24; // 일반 아바타
                        }

                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 2),
                          child: _buildImage(img, size),
                        );
                      }),
                    ),
                  ),
                  const SizedBox(width: 8),

                  // 이름, 옵션, 설명
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          item.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            color: AppColors.primaryText,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        if (item.option.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 2),
                            child: Text(
                              item.option,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.purple,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        const SizedBox(height: 2),
                        Text(
                          item.desc,
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppColors.secondaryText,
                            height: 1.2,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
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
