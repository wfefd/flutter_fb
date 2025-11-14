import 'dart:async';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../models/auction_item.dart';
import '../repository/auction_repository.dart';
import '../presentation/auction_item_list_tab.dart';

class AuctionScreen extends StatefulWidget {
  const AuctionScreen({super.key});

  @override
  State<AuctionScreen> createState() => _AuctionScreenState();
}

class _AuctionScreenState extends State<AuctionScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  late final InMemoryAuctionRepository _repo;
  late TabController _innerTabController;

  List<AuctionItem> _items = [];
  List<AuctionItem> _favorites = [];
  bool _loading = true;
  Timer? _debounce;
  static const _debounceMs = 250;

  @override
  void initState() {
    super.initState();
    _repo = InMemoryAuctionRepository();
    _innerTabController = TabController(length: 2, vsync: this);
    _loadInitial();
    _searchController.addListener(_onSearchTextChanged);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    _innerTabController.dispose();
    super.dispose();
  }

  Future<void> _loadInitial() async {
    setState(() => _loading = true);
    final items = await _repo.fetchItems();
    final favs = await _repo.fetchFavorites();
    if (!mounted) return;
    setState(() {
      _items = items;
      _favorites = favs;
      _loading = false;
    });
  }

  void _onSearchTextChanged() {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: _debounceMs), _runSearch);
  }

  Future<void> _runSearch() async {
    final q = _searchController.text.trim();
    setState(() => _loading = true);

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

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ✅ 내부 탭바
        Container(
          width: double.infinity,
          color: AppColors.surface, // 위 스샷의 연한 회색 영역
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          child: TabBar(
            controller: _innerTabController,
            isScrollable: true,

            // 🚫 밑줄 / 배경 모두 제거
            indicatorColor: Colors.transparent,
            indicator: const BoxDecoration(),
            splashFactory: NoSplash.splashFactory,
            overlayColor: MaterialStatePropertyAll(Colors.transparent),

            // 글자 스타일
            labelColor: AppColors.primaryText, // 선택된 탭 (경매장아이템)
            unselectedLabelColor: AppColors.secondaryText.withOpacity(0.6),

            labelStyle: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
            unselectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 13,
            ),
            labelPadding: const EdgeInsets.only(right: 24),

            tabs: const [
              Tab(text: '경매장아이템'),
              Tab(text: '찜목록'),
            ],
          ),
        ),

        // 🔍 검색창
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
          child: CustomTextField(
            hintText: '아이템 이름을 검색하세요',
            controller: _searchController,
          ),
        ),

        // 이하 그대로
        Expanded(
          child: TabBarView(
            controller: _innerTabController,
            children: [
              _loading
                  ? const Center(child: CircularProgressIndicator())
                  : AuctionItemListTab(
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
              AuctionItemListTab(
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
            ],
          ),
        ),
      ],
    );
  }
}
