// 결과 영역
import 'package:flutter/material.dart';
import 'character_card.dart';

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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text.rich(
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
        ),
        const SizedBox(height: 8),
        Expanded(
          child: results.isEmpty
              ? const Center(
                  child: Text(
                    '검색 결과가 없습니다.',
                    style: TextStyle(color: Colors.grey),
                  ),
                )
              : GridView.builder(
                  padding: const EdgeInsets.all(8),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
    );
  }
}
