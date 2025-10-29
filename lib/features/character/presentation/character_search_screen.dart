// lib/features/character/presentation/character_search_screen.dart
import 'package:flutter/material.dart';

class CharacterSearchScreen extends StatelessWidget {
  final String query;
  const CharacterSearchScreen({super.key, required this.query});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> allCharacters = [
      {'name': '전사A', 'class': '전사', 'level': 45},
      {'name': '마법사B', 'class': '마법사', 'level': 38},
      {'name': '도적C', 'class': '도적', 'level': 52},
    ];

    final results = allCharacters
        .where((c) => c['name'].toString().contains(query))
        .toList();

    return Scaffold(
      appBar: AppBar(title: Text('검색 결과: $query')),
      body: results.isEmpty
          ? const Center(child: Text('검색 결과가 없습니다.'))
          : ListView.builder(
              itemCount: results.length,
              itemBuilder: (context, index) {
                final c = results[index];
                return ListTile(
                  leading: const CircleAvatar(child: Icon(Icons.person)),
                  title: Text(c['name']),
                  subtitle: Text('${c['class']} · Lv.${c['level']}'),
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/character_detail',
                      arguments: c,
                    );
                  },
                );
              },
            ),
    );
  }
}
