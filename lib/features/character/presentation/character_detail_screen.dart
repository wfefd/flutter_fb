// features/character/presentation/character_detail_screen.dart
import 'package:flutter/material.dart';

class CharacterDetailScreen extends StatelessWidget {
  final Map<String, dynamic> character;        // ← 추가

  const CharacterDetailScreen({
    super.key,
    required this.character,                   // ← 추가
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(character['name'] as String)),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Icon(Icons.person, size: 100),
            const SizedBox(height: 20),
            Text('직업: ${character['class']}', style: const TextStyle(fontSize: 18)),
            Text('레벨: ${character['level']}', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('뒤로가기'),
            )
          ],
        ),
      ),
    );
  }
}
