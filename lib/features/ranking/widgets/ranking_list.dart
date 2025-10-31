// lib/features/ranking/widgets/ranking_list.dart
import 'package:flutter/material.dart';

class RankingList extends StatelessWidget {
  final String job;
  final String awakening;
  final List<Map<String, dynamic>> rankingData;
  final Function(Map<String, dynamic>)? onTapCharacter; // ✅ 클릭 콜백 추가

  const RankingList({
    super.key,
    required this.job,
    required this.awakening,
    required this.rankingData,
    this.onTapCharacter,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$job > $awakening 랭킹',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 8),
        ...rankingData.map((player) {
          final rank = player['rank'];
          final isTop3 = rank <= 3;
          return GestureDetector(
            onTap: () => onTapCharacter?.call(player), // ✅ 콜백 실행
            child: Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: isTop3
                    ? const Color(
                        0xFF7BC57B,
                      ).withOpacity(rank == 1 ? 0.25 : 0.15)
                    : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 3,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        '$rank',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isTop3
                              ? const Color(0xFF4CAF50)
                              : Colors.black87,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        player['name'],
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                  Text(
                    '명성 ${player['score']}',
                    style: const TextStyle(fontSize: 13, color: Colors.black54),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ],
    );
  }
}
