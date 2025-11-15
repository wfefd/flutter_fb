import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../models/auction_item.dart';
import '../repository/auction_repository.dart';
import 'widgets/auction_item_tile.dart';

/// 찜 목록 전체 화면
class AuctionFavoriteScreen extends StatefulWidget {
  const AuctionFavoriteScreen({super.key});

  @override
  State<AuctionFavoriteScreen> createState() => _AuctionFavoriteScreenState();
}

class _AuctionFavoriteScreenState extends State<AuctionFavoriteScreen> {
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
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.primaryText),
        title: Text(
          '찜 목록',
          style: AppTextStyles.body1.copyWith(
            fontWeight: FontWeight.w700,
            color: AppColors.primaryText,
          ),
        ),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_favorites.isEmpty) {
      return const Center(
        child: Text(
          '찜한 아이템이 없습니다.',
          style: TextStyle(color: AppColors.secondaryText),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      itemCount: _favorites.length,
      itemBuilder: (context, index) {
        final item = _favorites[index];

        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: AuctionItemTile(
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
          ),
        );
      },
    );
  }
}
