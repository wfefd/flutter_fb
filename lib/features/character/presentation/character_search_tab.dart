// lib/features/character/presentation/character_search_tab.dart
import 'package:flutter/material.dart';

class CharacterSearchTab extends StatefulWidget {
  const CharacterSearchTab({super.key});

  @override
  State<CharacterSearchTab> createState() => _CharacterSearchTabState();
}

class _CharacterSearchTabState extends State<CharacterSearchTab> {
  final TextEditingController _controller = TextEditingController();

  void _onSearch() {
    final query = _controller.text.trim();

    if (query.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('검색어를 입력하세요.')),
      );
      return;
    }

    // ✅ 라우팅 실행
    Navigator.pushNamed(context, '/character_search', arguments: query);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          TextField(
            controller: _controller,
            decoration: InputDecoration(
              hintText: '캐릭터 이름을 입력하세요',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              suffixIcon: IconButton(
                icon: const Icon(Icons.search),
                onPressed: _onSearch, // ✅ 클릭 시 검색 실행
              ),
            ),
            onSubmitted: (_) => _onSearch(), // 엔터 입력 시도 가능
          ),
          const SizedBox(height: 20),
          const Expanded(
            child: Center(child: Text('간이 순위표 (임시 자리)')),
          ),
        ],
      ),
    );
  }
}
