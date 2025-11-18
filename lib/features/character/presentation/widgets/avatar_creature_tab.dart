import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/custom_container_divided.dart';
import '../../models/avatar_item.dart';

class AvatarCreatureTab extends StatelessWidget {
  const AvatarCreatureTab({super.key});

  // ✅ 더 이상 Map이 아니라 AvatarItem 리스트
  static const List<AvatarItem> _avatarList = [
    AvatarItem(
      category: '모자 아바타',
      images: [
        'assets/images/sample_weapon.png',
        'assets/images/sample_weapon.png',
      ],
      name: '바니바니 아일랜드 [D타입]',
      option: '캐스팅 속도 14.0% 증가',
      desc: '찬란한 루비 엠블렘[이동속도]\n찬란한 루비 엠블렘[이동속도]',
    ),
    AvatarItem(
      category: '머리 아바타',
      images: [
        'assets/images/sample_weapon.png',
        'assets/images/sample_weapon.png',
      ],
      name: '바니바니 아일랜드 리프펌 헤어[D타입]',
      option: '캐스팅 속도 14.0% 증가',
      desc: '찬란한 루비 엠블렘[이동속도]\n찬란한 루비 엠블렘[이동속도]',
    ),
    AvatarItem(
      category: '얼굴 아바타',
      images: [
        'assets/images/sample_weapon.png',
        'assets/images/sample_weapon.png',
      ],
      name: '눈동자[D타입]',
      option: '공격 속도 6.0% 증가',
      desc: '찬란한 루비 엠블렘[공격속도]\n찬란한 루비 엠블렘[공격속도]',
    ),
    AvatarItem(
      category: '상의 아바타',
      images: [
        'assets/images/sample_weapon.png',
        'assets/images/sample_weapon.png',
      ],
      name: '플레임 에이시스 상의',
      option: '감정 스킬Lv +1',
      desc: '찬란한 루비 엠블렘[힘]\n찬란한 루비 엠블렘[힘]',
    ),
    AvatarItem(
      category: '하의 아바타',
      images: [
        'assets/images/sample_weapon.png',
        'assets/images/sample_weapon.png',
      ],
      name: '만월무사의 하의[C타입]',
      option: 'HP MAX 400 증가',
      desc: '찬란한 루비 엠블렘[체력]\n찬란한 루비 엠블렘[체력]',
    ),
    AvatarItem(
      category: '신발 아바타',
      images: [
        'assets/images/sample_weapon.png',
        'assets/images/sample_weapon.png',
      ],
      name: '만월무사의 신발[C타입]',
      option: '힘 55 증가',
      desc: '찬란한 루비 엠블렘[힘]\n찬란한 루비 엠블렘[힘]',
    ),
    AvatarItem(
      category: '목가슴 아바타',
      images: [
        'assets/images/sample_weapon.png',
        'assets/images/sample_weapon.png',
      ],
      name: '다크로드의 덫 장식[D타입]',
      option: '공격 속도 6.0% 증가',
      desc: '찬란한 루비 엠블렘[이동속도]\n찬란한 루비 엠블렘[이동속도]',
    ),
    AvatarItem(
      category: '허리 아바타',
      images: [
        'assets/images/sample_weapon.png',
        'assets/images/sample_weapon.png',
      ],
      name: '악귀나찰의 검과 가면[D타입]',
      option: '피해 감소 5.5% 증가',
      desc: '찬란한 루비 엠블렘[이동속도]\n찬란한 루비 엠블렘[이동속도]',
    ),
    AvatarItem(
      category: '스킨 아바타',
      images: ['assets/images/sample_weapon.png'],
      name: '진 웨펀마스터의 진짠듯한 피부[실버]',
      option: '물리 공격력 10 증가',
      desc: '찬란한 루비 엠블렘[힘]\n찬란한 루비 엠블렘[힘]',
    ),
    AvatarItem(
      category: '오라 아바타',
      images: ['assets/images/sample_weapon.png'],
      name: '루미너스 게이트',
      option: '',
      desc: '찬란한 루비 엠블렘[힘]\n찬란한 루비 엠블렘[힘]',
    ),
    AvatarItem(
      category: '무기 아바타',
      images: [
        'assets/images/sample_weapon.png',
        'assets/images/sample_weapon.png',
      ],
      name: '신검 강',
      option: '힘 55 증가',
      desc: '찬란한 루비 엠블렘[힘]\n찬란한 루비 엠블렘[힘]',
    ),
    AvatarItem(
      category: '오라 스킨 아바타',
      images: ['assets/images/sample_weapon.png'],
      name: '[M]어by프 패셔니스타',
      option: '',
      desc: '찬란한 루비 엠블렘[힘]\n찬란한 루비 엠블렘[힘]',
    ),
    AvatarItem(
      category: '크리쳐',
      images: [
        'assets/images/sample_weapon.png',
        'assets/images/sample_weapon.png',
        'assets/images/sample_weapon.png',
        'assets/images/sample_weapon.png',
      ],
      name: '손백의 울타리오',
      option: '',
      desc: '찬란한 루비 엠블렘[힘]\n찬란한 루비 엠블렘[힘]',
    ),
  ];

  @override
  Widget build(BuildContext context) {
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
        children: _avatarList.map((item) {
          final isCreature = item.category == '크리쳐';
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
                      item.category,
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
                          child: Image.asset(
                            img,
                            width: size,
                            height: size,
                            fit: BoxFit.cover,
                          ),
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
