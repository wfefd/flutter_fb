// lib/features/character/presentation/character_search_result.dart
import 'package:flutter/material.dart';

import '../../models/domain/character.dart';
import '../widgets/result_character_card.dart';

class CharacterSearchResult extends StatelessWidget {
  final String query;
  final List<Character> results;
  final ValueChanged<Character> onCharacterSelected;

  const CharacterSearchResult({
    super.key,
    required this.query,
    required this.results,
    required this.onCharacterSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      // ★ CHANGED: Padding 제거
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
        const SizedBox(height: 12), // ★ NEW: 제목 아래 살짝 간격

        Expanded(
          child: results.isEmpty
              ? const Center(
                  child: Text(
                    '검색 결과가 없습니다.',
                    style: TextStyle(color: Colors.grey),
                  ),
                )
              : GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.6,
                  ),
                  itemCount: results.length,
                  itemBuilder: (context, index) {
                    final character = results[index]; // ✅ Character
                    return CharacterCard(
                      character: character,
                      onTap: () => onCharacterSelected(character),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
