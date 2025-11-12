import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_fb/core/theme/app_colors.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../models/auction_item.dart';
import '../models/item_price.dart';
import '../repository/auction_repository.dart';
import '../presentation/auction_item_list_tab.dart';

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

  // 🔍 디바운스 검색
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
      length: 2,
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
            labelColor: AppColors.secondaryText,
            indicatorColor: AppColors.secondaryText,
            tabs: [
              Tab(text: '경매장 아이템'),
              Tab(text: '아이템 시세'),
            ],
          ),
          const SizedBox(height: 4),

          Expanded(
            child: TabBarView(
              children: [
                // 🧩 경매장 아이템 탭 (찜 목록 + 전체 아이템)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_favorites.isNotEmpty) ...[
                      Expanded(
                        flex: 1,
                        child: AuctionItemListTab(
                          headerTitle: '찜 목록', // ✅ 헤더 변경
                          items: _favorites,
                          favoriteIds: _favorites.map((e) => e.id).toSet(),
                          onFavToggle: _toggleFavorite,
                          onItemTap: (item) {
                            Navigator.pushNamed(
                              context,
                              '/auction_item_detail',
                              arguments: item.toJson(),
                            );
                          },
                        ),
                      ),
                    ],
                    const SizedBox(height: 8),
                    Expanded(
                      flex: 2,
                      child: _loading
                          ? const Center(child: CircularProgressIndicator())
                          : AuctionItemListTab(
                              headerTitle: '경매장 아이템', // ✅ 기본 헤더
                              items: _items,
                              favoriteIds: _favorites.map((e) => e.id).toSet(),
                              onFavToggle: _toggleFavorite,
                              onItemTap: (item) {
                                Navigator.pushNamed(
                                  context,
                                  '/auction_item_detail',
                                  arguments: item.toJson(),
                                );
                              },
                            ),
                    ),
                  ],
                ),

                // 💰 아이템 시세 탭
                _buildPriceList(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
