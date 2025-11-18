import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/custom_container_divided.dart';
import '../../models/basic_stat.dart';

class StatTab extends StatelessWidget {
  const StatTab({super.key});

  // ✅ 더 이상 Map이 아니라 BasicStat 리스트
  List<BasicStat> get _stats => const [
    BasicStat(
      iconPath: 'assets/images/stat/defense.png',
      name: '물리방어율',
      value: '47.3',
    ),
    BasicStat(
      iconPath: 'assets/images/stat/mdefense.png',
      name: '마법방어율',
      value: '48.7',
    ),
    BasicStat(iconPath: 'assets/images/stat/str.png', name: '힘', value: '8144'),
    BasicStat(
      iconPath: 'assets/images/stat/int.png',
      name: '지능',
      value: '4524',
    ),
    BasicStat(
      iconPath: 'assets/images/stat/vit.png',
      name: '체력',
      value: '4481',
    ),
    BasicStat(
      iconPath: 'assets/images/stat/spi.png',
      name: '정신력',
      value: '4341',
    ),
    BasicStat(
      iconPath: 'assets/images/stat/patk.png',
      name: '물리공격',
      value: '5887',
    ),
    BasicStat(
      iconPath: 'assets/images/stat/matk.png',
      name: '마법공격',
      value: '5276',
    ),
    BasicStat(
      iconPath: 'assets/images/stat/pcrit.png',
      name: '물크',
      value: '82.5 (122.5%)',
    ),
    BasicStat(
      iconPath: 'assets/images/stat/mcrit.png',
      name: '마크',
      value: '72.5 (112.5%)',
    ),
    BasicStat(
      iconPath: 'assets/images/stat/independent.png',
      name: '독립공격',
      value: '3381',
    ),
    BasicStat(
      iconPath: 'assets/images/stat/adventurer.png',
      name: '모험가명성',
      value: '82370',
    ),
    BasicStat(
      iconPath: 'assets/images/stat/aspd.png',
      name: '공격속도',
      value: '94.5',
    ),
    BasicStat(
      iconPath: 'assets/images/stat/cspd.png',
      name: '캐스팅속도',
      value: '89.5',
    ),
    BasicStat(
      iconPath: 'assets/images/stat/fire.png',
      name: '화속성강화',
      value: '301 (431)',
    ),
    BasicStat(
      iconPath: 'assets/images/stat/water.png',
      name: '수속성강화',
      value: '301 (431)',
    ),
    BasicStat(
      iconPath: 'assets/images/stat/light.png',
      name: '명속성강화',
      value: '311 (441)',
    ),
    BasicStat(
      iconPath: 'assets/images/stat/dark.png',
      name: '암속성강화',
      value: '301 (431)',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final stats = _stats;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: CustomContainerDivided(
        header: const Text(
          '스탯',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: AppColors.primaryText,
          ),
        ),
        children: List.generate((stats.length / 2).ceil(), (index) {
          final left = stats[index * 2];
          final right = index * 2 + 1 < stats.length
              ? stats[index * 2 + 1]
              : null;

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              children: [
                Expanded(child: _buildStatBox(left)),
                const SizedBox(width: 8),
                Expanded(
                  child: right != null
                      ? _buildStatBox(right)
                      : const SizedBox(), // 홀수일 때 빈 공간
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildStatBox(BasicStat stat) {
    return Container(
      height: 42,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border, width: 1),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Image.asset(
                stat.iconPath,
                width: 18,
                height: 18,
                errorBuilder: (_, __, ___) =>
                    const Icon(Icons.circle, size: 12),
              ),
              const SizedBox(width: 6),
              Text(
                stat.name,
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.primaryText,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          Text(
            stat.value,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.primaryText,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
