import 'package:flutter/material.dart';

class CharacterCard extends StatelessWidget {
  final Map<String, dynamic> character;
  final VoidCallback onTap;

  const CharacterCard({
    super.key,
    required this.character,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final c = character;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white, // ✅ 카드 배경 흰색
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1), // ✅ Figma: 10% 투명도
              blurRadius: 4, // ✅ blur 4
              offset: const Offset(0, 2), // ✅ x:0, y:2
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // ✅ 이미지 (여백 최소화 + 중앙 정렬)
            const SizedBox(height: 12),

            // ✅ 직업 태그
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                c['class'] ?? '',
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            const SizedBox(height: 6),

            // ✅ 서버명
            Text(
              c['server'] ?? '',
              style: const TextStyle(
                fontSize: 13,
                color: Colors.grey,
                fontWeight: FontWeight.w400,
              ),
            ),

            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
              child: Image.asset(
                c['image'] ?? 'assets/images/no_image.png',
                height: 160,
                width: double.infinity,
                fit: BoxFit.cover, // ✅ 여백 최소화
                alignment: Alignment.center, // ✅ 중앙 정렬
              ),
            ),
            const SizedBox(height: 8),

            // ✅ 닉네임
            Text(
              c['name'] ?? '',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),

            const SizedBox(height: 4),

            // ✅ 전투력 표시
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.workspace_premium,
                  color: Colors.amber,
                  size: 18,
                ),
                const SizedBox(width: 4),
                Text(
                  c['power'] ?? '0',
                  style: const TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                    fontSize: 13,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}
