import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../models/auction_item.dart';
import '../repository/auction_repository.dart';
import '../presentation/widgets/auction_item_tile.dart';

class AuctionFavoriteTab extends StatefulWidget {
  const AuctionFavoriteTab({super.key});

  @override
  State<AuctionFavoriteTab> createState() => _AuctionFavoriteTabState();
}

class _AuctionFavoriteTabState extends State<AuctionFavoriteTab> {
  late final InMemoryAuctionRepository _repo;
  List<AuctionItem> _favorites = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _repo = InMemoryAuctionRepository();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    setState(() => _loading = true);
    final favs = await _repo.fetchFavorites();
    if (!mounted) return;
    setState(() {
      _favorites = favs;
      _loading = false;
    });
  }

  Future<void> _toggleFavorite(int itemId) async {
    await _repo.toggleFavorite(itemId);
    await _loadFavorites();
  }

  @override
  Widget build(BuildContext context) {
    return _loading
        ? const Center(child: CircularProgressIndicator())
        : _favorites.isEmpty
        ? const Center(
            child: Text(
              '찜한 아이템이 없습니다.',
              style: TextStyle(color: AppColors.secondaryText),
            ),
          )
        : ListView.builder(
            itemCount: _favorites.length,
            itemBuilder: (context, index) {
              final item = _favorites[index];
              return AuctionItemTile(
                item: item,
                isFavorite: true,
                onFavoriteToggle: () => _toggleFavorite(item.id),
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    '/auction_item_detail',
                    arguments: item.toJson(),
                  );
                },
              );
            },
          );
  }
}
