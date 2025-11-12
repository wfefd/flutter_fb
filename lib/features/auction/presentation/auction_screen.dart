import 'dart:async';
import 'package:flutter/material.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../models/auction_item.dart';
import '../models/item_price.dart';
import '../repository/auction_repository.dart';
import '../presentation/widgets/auction_item_list_tab.dart'; // ✅ 새 장비형 리스트 탭 import

class AuctionScreen extends StatefulWidget {
  const AuctionScreen({super.key});

  @override
  State<AuctionScreen> createState() => _AuctionScreenState();
}

class _AuctionScreenState extends State<AuctionScreen> {
  final TextEditingController _searchController = TextEditingController();
  late final InMemoryAuctionRepository _repo;

  List<AuctionItem> _items = [];
  List<AuctionItem> _favorites = [];
  List<ItemPrice> _allPrices = [];
  List<ItemPrice> _prices = [];

  String _searchQuery = '';
  bool _loading = true;
  Timer? _debounce;
  static const _debounceMs = 250;

  @override
  void initState() {
    super.initState();
    _repo = InMemoryAuctionRepository();
    _loadInitial();
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
    final prices = await _repo.fetchPrices();
    final favs = await _repo.fetchFavorites();
    if (!mounted) return;
    setState(() {
      _items = items;
      _allPrices = prices;
      _prices = prices;
      _favorites = favs;
      _loading = false;
    });
  }

  // 🔎 디바운스 검색
  void _onSearchTextChanged() {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: _debounceMs), _runSearch);
  }

  Future<void> _runSearch() async {
    final q = _searchController.text.trim();
    _searchQuery = q;

    final filteredPrices = _allPrices.where((p) {
      if (q.isEmpty) return true;
      return p.name.toLowerCase().contains(q.toLowerCase());
    }).toList();

    if (!mounted) return;
    setState(() {
      _prices = filteredPrices;
      _loading = true;
    });

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

  Widget _buildItemCard(AuctionItem item) {
    final isFav = _isFav(item.id);
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      color: isFav ? Colors.pink.shade50 : null,
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: Image.asset(
            item.imagePath ?? 'assets/images/no_image.png',
            width: 44,
            height: 44,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => const Icon(Icons.image_not_supported),
          ),
        ),
        title: Text(item.name),
        subtitle: Text('판매자: ${item.seller}'),
        onTap: () {
          Navigator.pushNamed(
            context,
            '/auction_item_detail',
            arguments: item.toJson(),
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

  @override
  Widget build(BuildContext context) {
    if (_loading && _items.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    return DefaultTabController(
      length: 3, // 🧭 탭 3개
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: CustomTextField(
              hintText: '아이템 이름을 검색하세요',
              controller: _searchController,
            ),
          ),
          const SizedBox(height: 4),

          const TabBar(
            labelColor: Colors.deepPurple,
            indicatorColor: Colors.deepPurple,
            tabs: [
              Tab(text: '경매장 아이템'),
              Tab(text: '아이템 시세'),
              Tab(text: '카드형 보기'),
            ],
          ),
          const SizedBox(height: 4),

          Expanded(
            child: TabBarView(
              children: [
                // 🛒 경매장 리스트
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_favorites.isNotEmpty) ...[
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                          '찜 아이템 목록',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      _buildFavoriteList(),
                    ],
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        '경매장 아이템 목록',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    if (_loading)
                      const Expanded(
                        child: Center(child: CircularProgressIndicator()),
                      )
                    else
                      _buildAuctionList(),
                  ],
                ),

                // 💰 시세 탭
                _buildPriceList(),

                // 🧩 카드형 장비탭 스타일 보기
                AuctionItemListTab(
                  items: _items,
                  favoriteIds: _favorites.map((e) => e.id).toSet(),
                  onFavToggle: _toggleFavorite,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
