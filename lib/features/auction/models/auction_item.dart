class AuctionItem {
  final int id;
  final String name;
  final int price;
  final String seller;

  // ✅ 썸네일(자산) 경로 추가
  final String? imagePath;

  const AuctionItem({
    required this.id,
    required this.name,
    required this.price,
    required this.seller,
    this.imagePath,
  });

  AuctionItem copyWith({
    int? id,
    String? name,
    int? price,
    String? seller,
    String? imagePath,
  }) {
    return AuctionItem(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      seller: seller ?? this.seller,
      imagePath: imagePath ?? this.imagePath,
    );
  }

  factory AuctionItem.fromJson(Map<String, dynamic> j) => AuctionItem(
        id: j['id'] as int,
        name: j['name'] as String,
        price: j['price'] as int,
        seller: j['seller'] as String? ?? '—',
        imagePath: j['imagePath'] as String?,     // ✅
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'price': price,
        'seller': seller,
        'imagePath': imagePath,                   // ✅
      };
}
