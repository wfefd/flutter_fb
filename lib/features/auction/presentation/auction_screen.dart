import 'dart:async';
import 'package:flutter/material.dart';

// 👉 현재 프로젝트 구조에 맞춘 import
import 'models/auction_item.dart';
import 'models/item_price.dart';
import 'repository/auction_repository.dart'; // InMemoryAuctionRepository 포함

class AuctionScreen extends StatefulWidget {
  const AuctionScreen({super.key});

  @override
  State<AuctionScreen> createState() => _AuctionScreenState();
}

class _AuctionScreenState extends State<AuctionScreen> {
  final TextEditingController _searchController = TextEditingController();

  // ✅ 레포지토리(메모리 더미)
  late final InMemoryAuctionRepository _repo;

  // ✅ 화면 상태
  List<AuctionItem> _items = [];
  List<AuctionItem> _favorites = [];

  // 가격 시세는 서버호출 없이 로컬 필터링할 수 있도록 전체/필터 분리
  List<ItemPrice> _allPrices = [];
  List<ItemPrice> _prices = [];

  String _searchQuery = '';
  bool _loading = true;

  // 디바운서
  Timer? _debounce;
  static const _debounceMs = 250;

  @override
  void initState() {
    super.initState();
    _repo = InMemoryAuctionRepository();
    _loadInitial();

    // 🔎 입력 변경 시 실시간 검색(디바운스)
    _searchController.addListener(_onSearchTextChanged);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadInitial() async {
    setState(() => _loading = true);
    final items = await _repo.fetchItems();
    final prices = await _repo.fetchPrices(); // 전체 시세
    final favs = await _repo.fetchFavorites();
    setState(() {
      _items = items;
      _allPrices = prices;
      _prices = prices; // 초기엔 전체 노출
      _favorites = favs;
      _loading = false;
    });
  }

  // ─────────────────────────────────────────────
  // 🔎 디바운스 핸들러
  void _onSearchTextChanged() {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: _debounceMs), () {
      _runSearch(); // 입력 잠깐 멈추면 실행
    });
  }

  // 🔎 검색 실행 (아이템: 레포지토리 호출, 시세: 로컬 필터)
  Future<void> _runSearch() async {
    final q = _searchController.text.trim();
    _searchQuery = q;

    // 시세는 로컬 필터 (이름 포함)
    final filteredPrices = _allPrices.where((p) {
      if (q.isEmpty) return true;
      return p.name.toLowerCase().contains(q.toLowerCase());
    }).toList();

    setState(() {
      _prices = filteredPrices;
      _loading = true; // 아이템 검색 동안만 로딩 표시
    });

    // 아이템은 서버/레포지토리 검색
    final items = await _repo.fetchItems(query: q);
    final favs = await _repo.fetchFavorites();
    if (!mounted) return;
    setState(() {
      _items = items;
      _favorites = favs;
      _loading = false;
    });
  }

  Future<void> _toggleFavorite(int itemId) async {
    await _repo.toggleFavorite(itemId);
    final favs = await _repo.fetchFavorites();
    if (!mounted) return;
    setState(() {
      _favorites = favs;
    });
  }

  bool _isFav(int itemId) => _favorites.any((e) => e.id == itemId);

  // ---------------- UI Builders ----------------

  Widget _buildItemCard(AuctionItem item) {
    final isFav = _isFav(item.id);
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      color: isFav ? Colors.pink.shade50 : null,
      child: ListTile(
        leading: const Icon(Icons.shopping_bag),
        title: Text(item.name),
        subtitle: Text('판매자: ${item.seller}'),
        onTap: () {
          Navigator.pushNamed(
            context,
            '/auction_item_detail',
            arguments: item.toJson(), // 라우터가 Map 기대
          );
        },
        trailing: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 8,
          children: [
            Text('${item.price} G'),
            IconButton(
              icon: Icon(
                isFav ? Icons.favorite : Icons.favorite_border,
                color: isFav ? Colors.pink : Colors.grey,
              ),
              onPressed: () => _toggleFavorite(item.id),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFavoriteList() {
    if (_favorites.isEmpty) return const SizedBox.shrink();
    return Expanded(
      flex: 1,
      child: ListView.builder(
        itemCount: _favorites.length,
        itemBuilder: (context, index) => _buildItemCard(_favorites[index]),
      ),
    );
  }

  Widget _buildAuctionList() {
    return Expanded(
      flex: 2,
      child: ListView.builder(
        itemCount: _items.length,
        itemBuilder: (context, index) => _buildItemCard(_items[index]),
      ),
    );
  }

  Widget _buildPriceList() {
    return ListView.builder(
      itemCount: _prices.length,
      itemBuilder: (context, index) {
        final p = _prices[index];
        final trend = p.trend;

        // 시세 아이템 이름으로 매칭되는 경매 아이템 찾아 전달 (현재 검색 결과 기준)
        final matched = _items.cast<AuctionItem?>().firstWhere(
              (e) => e?.name == p.name,
              orElse: () => null,
            );

        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: const Icon(Icons.trending_up),
            title: Text(p.name),
            subtitle: Text('평균 시세: ${p.avgPrice} G'),
            trailing: Text(
              trend,
              style: TextStyle(
                color: trend.startsWith('+') ? Colors.green : Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: () {
              final arg = matched != null
                  ? matched.toJson()
                  : {
                      'name': p.name,
                      'price': p.avgPrice,
                      'seller': '정보 없음',
                      'id': -1,
                    };
              Navigator.pushNamed(context, '/item_price', arguments: arg);
            },
          ),
        );
      },
    );
  }

  // ---------------- Build ----------------

  @override
  Widget build(BuildContext context) {
    if (_loading && _items.isEmpty) {
      // 최초 로딩만 전체 스피너
      return const Center(child: CircularProgressIndicator());
    }

    return DefaultTabController(
      length: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔍 검색창 (실시간 반영 + 클리어 버튼)
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: '아이템 이름을 검색하세요',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchQuery.isEmpty
                    ? null
                    : IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _runSearch();
                        },
                      ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                isDense: true,
              ),
              textInputAction: TextInputAction.search,
              onSubmitted: (_) => _runSearch(), // 엔터 시 즉시
            ),
            const SizedBox(height: 10),

            // 🧭 탭바
            const TabBar(
              labelColor: Colors.deepPurple,
              indicatorColor: Colors.deepPurple,
              tabs: [
                Tab(text: '경매장 아이템 목록'),
                Tab(text: '아이템 시세 목록'),
              ],
            ),
            const SizedBox(height: 10),

            // 📦 탭별 콘텐츠
            Expanded(
              child: TabBarView(
                children: [
                  // 🛒 경매장 탭
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (_favorites.isNotEmpty) ...[
                        const Text(
                          '찜 아이템 목록',
                          style:
                              TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        _buildFavoriteList(),
                        const SizedBox(height: 10),
                      ],
                      const Text(
                        '경매장 아이템 목록',
                        style:
                            TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      if (_loading)
                        const Expanded(
                          child: Center(child: CircularProgressIndicator()),
                        )
                      else
                        _buildAuctionList(),
                    ],
                  ),

                  // 💰 시세 탭 (항상 즉시 필터 반영)
                  _buildPriceList(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
