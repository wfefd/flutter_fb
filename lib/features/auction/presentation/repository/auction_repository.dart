import '../models/auction_item.dart';
import '../models/item_price.dart';

/// 레포지토리 인터페이스
abstract class AuctionRepository {
  Future<List<AuctionItem>> fetchItems({String query});
  Future<AuctionItem?> getItemById(int id);

  Future<List<ItemPrice>> fetchPrices();

  Future<void> toggleFavorite(int itemId);
  Future<List<AuctionItem>> fetchFavorites();
  Future<bool> isFavorite(int itemId);
}

/// 메모리 기반 더미 구현체
class InMemoryAuctionRepository implements AuctionRepository {
  final List<AuctionItem> _items = const [
    AuctionItem(id: 1, name: '용사의 검',   price: 12000, seller: 'Player01'),
    AuctionItem(id: 2, name: '빛나는 활',   price: 9800,  seller: 'Player02'),
    AuctionItem(id: 3, name: '마법사의 로브', price: 7600,  seller: 'Player03'),
  ];

  final List<ItemPrice> _prices = const [
    ItemPrice(name: '용사의 검',   avgPrice: 11800, trend: '+2.1%'),
    ItemPrice(name: '빛나는 활',   avgPrice: 9700,  trend: '-0.8%'),
    ItemPrice(name: '마법사의 로브', avgPrice: 7500,  trend: '+1.3%'),
  ];

  final Set<int> _favorites = {};

  @override
  Future<List<AuctionItem>> fetchItems({String query = ''}) async {
    await Future<void>.delayed(const Duration(milliseconds: 120));
    if (query.trim().isEmpty) return List<AuctionItem>.from(_items);
    final q = query.toLowerCase();
    return _items.where((e) => e.name.toLowerCase().contains(q)).toList();
  }

  @override
  Future<AuctionItem?> getItemById(int id) async {
    await Future<void>.delayed(const Duration(milliseconds: 60));
    try {
      return _items.firstWhere((e) => e.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<List<ItemPrice>> fetchPrices() async {
    await Future<void>.delayed(const Duration(milliseconds: 100));
    return List<ItemPrice>.from(_prices);
  }

  @override
  Future<void> toggleFavorite(int itemId) async {
    await Future<void>.delayed(const Duration(milliseconds: 30));
    if (_favorites.contains(itemId)) {
      _favorites.remove(itemId);
    } else {
      _favorites.add(itemId);
    }
  }

  @override
  Future<List<AuctionItem>> fetchFavorites() async {
    await Future<void>.delayed(const Duration(milliseconds: 80));
    return _items.where((e) => _favorites.contains(e.id)).toList();
  }

  @override
  Future<bool> isFavorite(int itemId) async {
    await Future<void>.delayed(const Duration(milliseconds: 20));
    return _favorites.contains(itemId);
  }
}
