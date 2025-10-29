import 'package:flutter/material.dart';

class AuctionScreen extends StatefulWidget {
  const AuctionScreen({super.key});

  @override
  State<AuctionScreen> createState() => _AuctionScreenState();
}

class _AuctionScreenState extends State<AuctionScreen> {
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, dynamic>> _auctionItems = [
    {'id': 1, 'name': '용사의 검', 'price': 12000, 'seller': 'Player01'},
    {'id': 2, 'name': '빛나는 활', 'price': 9800, 'seller': 'Player02'},
    {'id': 3, 'name': '마법사의 로브', 'price': 7600, 'seller': 'Player03'},
  ];

  final List<Map<String, dynamic>> _priceList = [
    {'name': '용사의 검', 'avgPrice': 11800, 'trend': '+2.1%'},
    {'name': '빛나는 활', 'avgPrice': 9700, 'trend': '-0.8%'},
    {'name': '마법사의 로브', 'avgPrice': 7500, 'trend': '+1.3%'},
  ];

  final Set<int> _favorites = {};
  String _searchQuery = '';

  // ✅ 공통 카드 생성 함수
  Widget _buildItemCard(Map<String, dynamic> item, bool isFav) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      color: isFav ? Colors.pink.shade50 : null,
      child: ListTile(
        leading: const Icon(Icons.shopping_bag),
        title: Text(item['name'].toString()),
        subtitle: Text('판매자: ${item['seller']}'),
        onTap: () {
          Navigator.pushNamed(
            context,
            '/auction_item_detail',
            arguments: item,
          );
        },
        trailing: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 8,
          children: [
            Text('${item['price']} G'),
            IconButton(
              icon: Icon(
                isFav ? Icons.favorite : Icons.favorite_border,
                color: isFav ? Colors.pink : Colors.grey,
              ),
              onPressed: () {
                setState(() {
                  if (isFav) {
                    _favorites.remove(item['id']);
                  } else {
                    _favorites.add(item['id']);
                  }
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  // ✅ 찜 목록 빌더
  Widget _buildFavoriteList(List<Map<String, dynamic>> favoriteItems) {
    if (favoriteItems.isEmpty) return const SizedBox.shrink();
    return Expanded(
      flex: 1,
      child: ListView.builder(
        itemCount: favoriteItems.length,
        itemBuilder: (context, index) {
          final item = favoriteItems[index];
          return _buildItemCard(item, true);
        },
      ),
    );
  }

  // ✅ 경매 목록 빌더
  Widget _buildAuctionList(List<Map<String, dynamic>> filteredItems) {
    return Expanded(
      flex: 2,
      child: ListView.builder(
        itemCount: filteredItems.length,
        itemBuilder: (context, index) {
          final item = filteredItems[index];
          final isFav = _favorites.contains(item['id']);
          return _buildItemCard(item, isFav);
        },
      ),
    );
  }

 Widget _buildPriceList(List<Map<String, dynamic>> priceList) {
  return ListView.builder(
    itemCount: priceList.length,
    itemBuilder: (context, index) {
      final p = priceList[index];
      final trend = p['trend'].toString();

      // 🔍 시세 목록의 이름과 같은 경매 아이템을 찾아서 전달
      final matchedItem = _auctionItems.firstWhere(
        (item) => item['name'] == p['name'],
        orElse: () => {'name': p['name'], 'price': p['avgPrice']},
      );

      return Card(
        margin: const EdgeInsets.only(bottom: 8),
        child: ListTile(
          leading: const Icon(Icons.trending_up),
          title: Text(p['name'].toString()),
          subtitle: Text('평균 시세: ${p['avgPrice']} G'),
          trailing: Text(
            trend,
            style: TextStyle(
              color: trend.startsWith('+') ? Colors.green : Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),

          // ✅ onTap 추가
          onTap: () {
            Navigator.pushNamed(
              context,
              '/item_price', // 라우터에 등록된 시세 상세 화면 경로
              arguments: matchedItem,
            );
          },
        ),
      );
    },
  );
}

  @override
  Widget build(BuildContext context) {
    final filteredItems = _auctionItems
        .where((item) =>
            item['name'].toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
    final favoriteItems =
        _auctionItems.where((item) => _favorites.contains(item['id'])).toList();

    return DefaultTabController(
      length: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔍 검색창
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: '아이템 이름을 검색하세요',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    setState(() {
                      _searchQuery = _searchController.text;
                    });
                  },
                ),
              ),
              onSubmitted: (_) {
                setState(() {
                  _searchQuery = _searchController.text;
                });
              },
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
                      if (favoriteItems.isNotEmpty) ...[
                        const Text(
                          '찜 아이템 목록',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        _buildFavoriteList(favoriteItems),
                        const SizedBox(height: 10),
                      ],
                      const Text(
                        '경매장 아이템 목록',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      _buildAuctionList(filteredItems),
                    ],
                  ),

                  // 💰 시세 탭
                  _buildPriceList(_priceList),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
