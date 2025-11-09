import 'package:flutter/material.dart';
import 'package:flutter_fb/core/widgets/section_container.dart';
import 'package:flutter_fb/core/theme/app_colors.dart';
import 'package:flutter_fb/core/theme/app_text_styles.dart';

class WorldRankingBlock extends StatelessWidget {
  final List<Map<String, dynamic>> rows;
  const WorldRankingBlock({super.key, required this.rows});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 제목 영역
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // ✅ "일반 월드"만 bold 처리
                RichText(
                  text: TextSpan(
                    style: AppTextStyles.body1,
                    children: const [
                      TextSpan(text: '11월 9일 '),
                      TextSpan(
                        text: '전체 서버',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                      TextSpan(text: ' 랭킹'),
                    ],
                  ),
                ),
                Row(
                  children: [
                    Text('더 보기', style: AppTextStyles.body1.copyWith()),
                    const SizedBox(width: 4),
                    const Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 14,
                      color: AppColors.secondaryText,
                    ),
                  ],
                ),
              ],
            ),
          ),

          // ✅ 소제목 행
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            color: const Color(0xFFF7F7F7),
            child: Row(
              children: [
                SizedBox(
                  width: 14, // ✅ 순위 배지 영역과 맞춤 (22 + 여백 약간)
                  child: Text(
                    '#',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.body2.copyWith(
                      color: AppColors.primaryText,
                    ),
                  ),
                ),
                const SizedBox(width: 10), // ✅ 리스트의 배지-텍스트 간격과 동일하게 유지
                Expanded(
                  flex: 4,
                  child: Text(
                    '캐릭터',
                    style: AppTextStyles.body2.copyWith(
                      color: AppColors.primaryText,
                    ),
                  ),
                ),
                const SizedBox(width: 6), // ✅ 리스트의 배지-텍스트 간격과 동일하게 유지

                Expanded(
                  flex: 2,
                  child: Text(
                    '레벨',
                    style: AppTextStyles.body2.copyWith(
                      color: AppColors.primaryText,
                    ),
                  ),
                ),
                const SizedBox(width: 2), // ✅ 리스트의 배지-텍스트 간격과 동일하게 유지

                Expanded(
                  flex: 3,
                  child: Text(
                    '직업',
                    textAlign: TextAlign.end,
                    style: AppTextStyles.body2.copyWith(
                      color: AppColors.primaryText,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ✅ 순위 리스트
          Column(
            children: rows.map((e) {
              return Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 6, // 🔽 기존 12 → 6
                      horizontal: 10,
                    ),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 22, // 🔽 배지 크기 축소
                          height: 26,
                          child: _RankBadge(rank: e['rank'] as int),
                        ),
                        const SizedBox(width: 8), // 🔹 배지-텍스트 간 간격 추가
                        Expanded(
                          flex: 4,
                          child: Text(
                            e['name'],
                            style: AppTextStyles.body2.copyWith(
                              color: AppColors.primaryText,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            '${e['level']}',
                            style: AppTextStyles.body2.copyWith(
                              color: AppColors.secondaryText,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Text(
                            e['job'],
                            textAlign: TextAlign.end,
                            style: AppTextStyles.body2.copyWith(
                              color: AppColors.secondaryText,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(height: 1, color: Colors.grey.shade200),
                ],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class _RankBadge extends StatelessWidget {
  final int rank;
  const _RankBadge({required this.rank});

  @override
  Widget build(BuildContext context) {
    Color color;
    switch (rank) {
      case 1:
        color = AppColors.secondaryText; // gold
        break;
      case 2:
        color = AppColors.secondaryText; // gold
        // gold
        // silver
        break;
      case 3:
        color = AppColors.secondaryText; // gold
        // gold
        // bronze
        break;
      default:
        color = Colors.white;
    }

    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Text(
        '$rank',
        style: AppTextStyles.body2.copyWith(
          fontSize: 11, // 🔽 글자 크기 약간 축소
          color: rank <= 3 ? Colors.white : AppColors.secondaryText,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
