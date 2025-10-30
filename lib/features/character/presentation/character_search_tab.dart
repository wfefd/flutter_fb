import 'package:flutter/material.dart';
import 'widgets/character_detail_view.dart';
import 'widgets/character_search_result.dart';
import 'widgets/character_search_input.dart';

class CharacterSearchTab extends StatefulWidget {
  const CharacterSearchTab({super.key});

  @override
  State<CharacterSearchTab> createState() => _CharacterSearchTabState();
}

class _CharacterSearchTabState extends State<CharacterSearchTab> {
  final TextEditingController _controller = TextEditingController();
  bool _isSearching = false;
  String _selectedServer = '전체';
  Map<String, dynamic>? _selectedCharacter;
  List<Map<String, dynamic>> _results = [];

  final List<String> _servers = [
    '전체',
    '카인',
    '디레지에',
    '시로코',
    '프레이',
    '카시야스',
    '힐더',
    '안톤',
    '바칼',
  ];

  final List<Map<String, dynamic>> _mockCharacters = [
    {
      'name': '전사A',
      'class': '런처',
      'level': 115,
      'server': '카인',
      'image': 'assets/images/character1.png',
      'power': '74,689',
    },
    {
      'name': '도적B',
      'class': '어쌔신',
      'level': 110,
      'server': '시로코',
      'image': 'assets/images/character1.png',
      'power': '68,234',
    },
    {
      'name': '마법사C',
      'class': '엘레멘탈리스트',
      'level': 113,
      'server': '바칼',
      'image': 'assets/images/character1.png',
      'power': '72,430',
    },
  ];

  void _searchCharacter() {
    final query = _controller.text.trim();
    if (query.isEmpty) return;

    setState(() {
      _isSearching = true;
      _selectedCharacter = null;
      _results = _mockCharacters.where((c) {
        final matchesName = c['name']!.toLowerCase().contains(
          query.toLowerCase(),
        );
        final matchesServer = _selectedServer == '전체'
            ? true
            : c['server'] == _selectedServer;
        return matchesName && matchesServer;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_selectedCharacter != null) {
      return CharacterDetailView(character: _selectedCharacter!);
    }

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: _isSearching
            ? CharacterSearchResult(
                query: _controller.text,
                results: _results,
                onCharacterSelected: (c) {
                  setState(() => _selectedCharacter = c);
                },
              )
            : CharacterSearchInput(
                selectedServer: _selectedServer,
                servers: _servers,
                controller: _controller,
                onServerChanged: (value) =>
                    setState(() => _selectedServer = value),
                onSearch: _searchCharacter,
              ),
      ),
    );
  }
}
