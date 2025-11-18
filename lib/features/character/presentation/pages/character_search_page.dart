import 'package:flutter/material.dart';

import '../../models/character.dart';
import '../../models/ranking_row.dart';

import '../widgets/page_ranking_row.dart'; // 여기 안에서 RankingTableContainer 있다고 가정
import '../widgets/page_character_search_input.dart';
import 'character_search_result.dart';
import 'character_detail_view.dart';

class CharacterSearchTab extends StatefulWidget {
  final void Function(int)? onTabChange; // 탭 이동 콜백

  const CharacterSearchTab({super.key, this.onTabChange});

  @override
  State<CharacterSearchTab> createState() => _CharacterSearchTabState();
}

class _CharacterSearchTabState extends State<CharacterSearchTab>
    with AutomaticKeepAliveClientMixin {
  final TextEditingController _controller = TextEditingController();
  String _selectedServer = '전체';
  bool _isSearching = false;

  // 선택된 캐릭터는 여기서 안 들고, 상세는 push로 이동
  List<Character> _searchResults = [];

  TabController? _tabController; // 탭 이동 감지용

  @override
  bool get wantKeepAlive => false; // 어차피 직접 리셋할 거라 false 유지

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

  // Mock 캐릭터 데이터 (id 포함)
  final List<Character> _mockCharacters = const [
    Character(
      id: 'char_1',
      name: '전사A',
      job: '런처',
      level: 115,
      server: '카인',
      imagePath: 'assets/images/character1.png',
      fame: '74,689',
    ),
    Character(
      id: 'char_2',
      name: '도적B',
      job: '어쌔신',
      level: 110,
      server: '시로코',
      imagePath: 'assets/images/character1.png',
      fame: '68,234',
    ),
    Character(
      id: 'char_3',
      name: '마법사C',
      job: '엘레멘탈리스트',
      level: 113,
      server: '바칼',
      imagePath: 'assets/images/character1.png',
      fame: '72,430',
    ),
  ];

  // 랭킹 더미 데이터
  final List<RankingRow> _dummyRows = const [
    RankingRow(
      rank: 1,
      characterId: 'char_1',
      name: '오지환',
      fame: 30000,
      job: '키네시스',
    ),
    RankingRow(
      rank: 2,
      characterId: 'char_2',
      name: '버터',
      fame: 29500,
      job: '나이트로드',
    ),
    RankingRow(
      rank: 3,
      characterId: 'char_3',
      name: '테룡이',
      fame: 29000,
      job: '카이저',
    ),
    RankingRow(
      rank: 4,
      characterId: 'char_4',
      name: '솝상',
      fame: 28800,
      job: '비숍',
    ),
    RankingRow(
      rank: 5,
      characterId: 'char_5',
      name: '보마노랑이',
      fame: 28500,
      job: '보우마스터',
    ),
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // 상위의 DefaultTabController 가져와서 탭 변경 감지
    final controller = DefaultTabController.of(context);
    if (controller != null && controller != _tabController) {
      _tabController?.removeListener(_onTabChanged);
      _tabController = controller;
      _tabController!.addListener(_onTabChanged);
    }
  }

  void _onTabChanged() {
    // 이 위젯이 0번 탭이라고 가정 (캐릭터 검색 탭이 첫 번째)
    const myIndex = 0;

    if (_tabController == null) return;

    // 이 탭에서 다른 탭으로 이동하는 순간
    if (_tabController!.index != myIndex) {
      if (mounted) {
        setState(() {
          _isSearching = false;
          _searchResults = [];
          _controller.clear();
        });
      }
    }
  }

  void _searchCharacter() {
    final query = _controller.text.trim();
    if (query.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('캐릭터 이름을 입력하세요.')));
      return;
    }

    final results = _mockCharacters.where((c) {
      final matchesName = c.name.toLowerCase().contains(query.toLowerCase());
      final matchesServer = _selectedServer == '전체'
          ? true
          : c.server == _selectedServer;
      return matchesName && matchesServer;
    }).toList();

    setState(() {
      _isSearching = true;
      _searchResults = results;
    });
  }

  @override
  void dispose() {
    _tabController?.removeListener(_onTabChanged);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    // 🔹 1) 검색 결과 화면 (패딩 16 적용)
    if (_isSearching) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: CharacterSearchResult(
                query: _controller.text,
                results: _searchResults,
                onCharacterSelected: (character) {
                  // ✅ 여기서만 상세 페이지로 push → detail은 padding 없음
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CharacterDetailView(character: character),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      );
    }

    // 🔹 2) 기본 검색 + 랭킹 미리보기 화면 (패딩 16 적용)
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
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
                  widget.onTabChange?.call(1);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
