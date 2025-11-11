import 'package:flutter/material.dart';
import '../../../ranking/presentation/pages/ranking_screen.dart';
import '../../../home/widgets/ranking_table_container.dart';
import '../widgets/character_search_input_full.dart';
import 'character_search_result.dart';
import 'character_detail_view.dart';

class CharacterSearchTab extends StatefulWidget {
  const CharacterSearchTab({super.key});

  @override
  State<CharacterSearchTab> createState() => _CharacterSearchTabState();
}

class _CharacterSearchTabState extends State<CharacterSearchTab>
    with AutomaticKeepAliveClientMixin {
  final TextEditingController _controller = TextEditingController();
  String _selectedServer = '전체';
  bool _isSearching = false;
  Map<String, dynamic>? _selectedCharacter; // 상세 캐릭터
  List<Map<String, dynamic>> _searchResults = [];

  @override
  bool get wantKeepAlive => false;

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

  final List<Map<String, dynamic>> _dummyRows = [
    {'rank': 1, 'name': '오지환', 'level': 300, 'job': '키네시스'},
    {'rank': 2, 'name': '버터', 'level': 300, 'job': '나이트로드'},
    {'rank': 3, 'name': '테룡이', 'level': 300, 'job': '카이저'},
    {'rank': 4, 'name': '솝상', 'level': 300, 'job': '비숍'},
    {'rank': 5, 'name': '보마노랑이', 'level': 300, 'job': '보우마스터'},
  ];

  void _searchCharacter() {
    final query = _controller.text.trim();
    if (query.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('캐릭터 이름을 입력하세요.')));
      return;
    }

    final results = _mockCharacters.where((c) {
      final matchesName = (c['name'] as String).toLowerCase().contains(
        query.toLowerCase(),
      );
      final matchesServer = _selectedServer == '전체'
          ? true
          : c['server'] == _selectedServer;
      return matchesName && matchesServer;
    }).toList();

    setState(() {
      _isSearching = true;
      _searchResults = results;
      _selectedCharacter = null;
    });
  }

  void _resetSearch() {
    setState(() {
      _isSearching = false;
      _selectedCharacter = null;
      _controller.clear();
      _selectedServer = '전체';
      _searchResults = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    // 🔹 1️⃣ 상세 보기 (같은 탭 내부에서 전환)
    if (_selectedCharacter != null) {
      return CharacterDetailView(character: _selectedCharacter!);
    }

    // 🔹 2️⃣ 검색 결과 화면
    if (_isSearching) {
      return CharacterSearchResult(
        query: _controller.text,
        results: _searchResults,
        onCharacterSelected: (character) {
          setState(() {
            _selectedCharacter = character;
          });
        },
      );
    }

    // 🔹 3️⃣ 기본 화면 (검색 + 랭킹)
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CharacterSearchInputFull(
              selectedServer: _selectedServer,
              servers: _servers,
              controller: _controller,
              onServerChanged: (value) =>
                  setState(() => _selectedServer = value),
              onSearch: _searchCharacter,
            ),
            const SizedBox(height: 24),
            RankingTableContainer(
              titleDate: '11월 9일',
              serverName: '전체 서버',
              rows: _dummyRows,
              onMoreTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const RankingScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
