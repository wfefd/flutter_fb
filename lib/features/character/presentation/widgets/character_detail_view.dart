import 'package:flutter/material.dart';

class CharacterDetailView extends StatefulWidget {
  final Map<String, dynamic> character;
  final bool fromRanking; // 🔹 랭킹에서 진입 여부

  const CharacterDetailView({
    super.key,
    required this.character,
    this.fromRanking = false,
  });

  @override
  State<CharacterDetailView> createState() => _CharacterDetailViewState();
}

class _CharacterDetailViewState extends State<CharacterDetailView>
    with AutomaticKeepAliveClientMixin {
  int _selectedTabIndex = 0;

  final List<String> tabs = const [
    '장착장비',
    '스탯',
    '세부스탯',
    '아바타&크리쳐',
    '버프강화',
    '스킬개화',
    '딜표',
    '스킬정보',
  ];

  final Map<int, Future<String>> _tabDataCache = {};

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final c = widget.character;

    return Scaffold(
      backgroundColor: Colors.white,

      // 🔹 랭킹에서 진입했을 때만 AppBar 보이게
      appBar: widget.fromRanking
          ? AppBar(
              title: Text(
                c['name'] ?? '캐릭터 정보',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              backgroundColor: const Color(0xFF7BC57B),
              foregroundColor: Colors.white,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new),
                onPressed: () => Navigator.pop(context),
              ),
              elevation: 2,
            )
          : null,

      body: Column(
        children: [
          _buildCharacterInfo(c),
          const Divider(height: 1),
          _buildTabSelector(),
          const Divider(height: 1),
          Expanded(child: _buildTabContent()),
        ],
      ),
    );
  }

  /// 🔹 캐릭터 기본 정보
  Widget _buildCharacterInfo(Map<String, dynamic> c) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              c['image'] ?? 'assets/images/no_image.png',
              width: 120,
              height: 120,
              fit: BoxFit.cover,
              cacheWidth: 240,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  c['name'] ?? 'Unknown',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${c['class'] ?? ''} | ${c['server'] ?? ''}',
                  style: const TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 6),
                Text('Lv.${c['level'] ?? 0}'),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(
                      Icons.workspace_premium,
                      color: Colors.amber,
                      size: 22,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      c['power'] ?? '0',
                      style: const TextStyle(
                        color: Colors.amber,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 🔹 탭 선택 바
  Widget _buildTabSelector() {
    return Wrap(
      spacing: 1,
      runSpacing: 1,
      children: List.generate(tabs.length, (index) {
        final isSelected = _selectedTabIndex == index;
        return SizedBox(
          width: MediaQuery.of(context).size.width / 4 - 1,
          height: 40,
          child: InkWell(
            onTap: () => setState(() => _selectedTabIndex = index),
            child: Container(
              color: isSelected ? const Color(0xFF7BC57B) : Colors.white,
              alignment: Alignment.center,
              child: Text(
                tabs[index],
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.black87,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  fontSize: 13,
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  /// 🔹 탭 내용 (IndexedStack + Lazy Loading)
  Widget _buildTabContent() {
    return IndexedStack(
      index: _selectedTabIndex,
      children: List.generate(tabs.length, (i) {
        _tabDataCache[i] ??= _loadTabData(i);

        return FutureBuilder<String>(
          future: _tabDataCache[i],
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return const Center(child: Text('데이터 로드 실패'));
            }
            return Center(
              child: Text(snapshot.data!, style: const TextStyle(fontSize: 16)),
            );
          },
        );
      }),
    );
  }

  /// 🔹 탭별 비동기 데이터 로딩 (예시)
  Future<String> _loadTabData(int index) async {
    await Future.delayed(const Duration(milliseconds: 600)); // 로딩 시뮬레이션
    switch (index) {
      case 0:
        return '장착장비 데이터 로드 완료';
      case 1:
        return '스탯 정보 로드 완료';
      case 2:
        return '세부스탯 데이터 로드 완료';
      case 3:
        return '아바타 & 크리쳐 정보 로드 완료';
      case 4:
        return '버프 강화 데이터 로드 완료';
      case 5:
        return '스킬 개화 정보 로드 완료';
      case 6:
        return '딜표 데이터 로드 완료';
      case 7:
        return '스킬 정보 로드 완료';
      default:
        return '데이터 없음';
    }
  }

  @override
  bool get wantKeepAlive => true;
}
