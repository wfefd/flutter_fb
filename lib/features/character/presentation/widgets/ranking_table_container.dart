import 'package:flutter/material.dart';
import 'package:flutter_fb/core/theme/app_colors.dart';
import 'package:flutter_fb/core/theme/app_text_styles.dart';

class RankingTableContainer extends StatelessWidget {
  final String titleDate;
  final String serverName;
  final List<Map<String, dynamic>> rows;
  final VoidCallback? onMoreTap; // ✅ 콜백 추가

  const RankingTableContainer({
    super.key,
    required this.titleDate,
    required this.serverName,
    required this.rows,
    this.onMoreTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppColors.border,
          width: 1,
          strokeAlign: BorderSide.strokeAlignInside,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ✅ 제목 영역
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RichText(
                  text: TextSpan(
                    style: AppTextStyles.body1,
                    children: [
                      TextSpan(text: '$titleDate '),
                      TextSpan(
                        text: serverName,
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                      const TextSpan(text: ' 랭킹'),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: onMoreTap,
                  child: Row(
                    children: [
                      Text(
                        '더 보기',
                        style: AppTextStyles.body1.copyWith(
                          color: AppColors.secondaryText,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 14,
                        color: AppColors.secondaryText,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ✅ 헤더 행
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            color: const Color(0xFFF7F7F7),
            child: Row(
              children: const [
                SizedBox(
                  width: 24,
                  child: Text(
                    '#',
                    textAlign: TextAlign.center,
                    style: _headerStyle,
                  ),
                ),
                Expanded(flex: 4, child: Text('캐릭터', style: _headerStyle)),
                Expanded(flex: 2, child: Text('명성', style: _headerStyle)),
                Expanded(
                  flex: 3,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text('직업', style: _headerStyle),
                  ),
                ),
              ],
            ),
          ),

          const Divider(height: 1, color: Color(0xFFEAEAEA)),

          // ✅ 데이터 리스트
          Column(
            children: rows.map((e) {
              final rank = e['rank'] as int;
              final name = e['name'] as String;
              final level = e['level'] as int;
              final job = e['job'] as String;

              return Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 6,
                      horizontal: 16,
                    ),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 20,
                          height: 24,
                          child: _RankBadge(rank: rank),
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          flex: 4,
                          child: Text(
                            name,
                            style: AppTextStyles.body2.copyWith(
                              color: AppColors.primaryText,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            '$level',
                            style: AppTextStyles.body2.copyWith(
                              color: AppColors.secondaryText,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              job,
                              style: AppTextStyles.body2.copyWith(
                                color: AppColors.secondaryText,
                              ),
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
    Color color = rank <= 3 ? AppColors.secondaryText : Colors.white;
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
          fontSize: 11,
          color: rank <= 3 ? Colors.white : AppColors.secondaryText,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

const _headerStyle = TextStyle(
  fontSize: 13,
  fontWeight: FontWeight.w500,
  color: AppColors.primaryText,
);
