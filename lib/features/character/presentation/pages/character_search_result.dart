import 'package:flutter/material.dart';
import '../widgets/character_card.dart';

class CharacterSearchResult extends StatelessWidget {
  final String query;
  final List<Map<String, dynamic>> results;
  final ValueChanged<Map<String, dynamic>> onCharacterSelected;

  const CharacterSearchResult({
    super.key,
    required this.query,
    required this.results,
    required this.onCharacterSelected,
  });

  @override
  Widget build(BuildContext context) {
    return
    // 🔹 혹시 CharacterSearchTab에서 SafeArea 빼도 여기에 있어 안전
    Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: query.isEmpty ? "캐릭터" : query,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const TextSpan(
                  text: " 검색 결과",
                  style: TextStyle(fontSize: 16, color: Colors.black87),
                ),
              ],
            ),
          ),
          Expanded(
            // 🔹 여기가 핵심
            child: results.isEmpty
                ? const Center(
                    child: Text(
                      '검색 결과가 없습니다.',
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                : GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 0.6,
                        ),
                    itemCount: results.length,
                    itemBuilder: (context, index) {
                      final c = results[index];
                      return CharacterCard(
                        character: c,
                        onTap: () => onCharacterSelected(c),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
