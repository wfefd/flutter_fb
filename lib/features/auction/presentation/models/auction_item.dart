class AuctionItem {
  final int id;
  final String name;
  final int price;     // 현재가 (G)
  final String seller; // 판매자

  const AuctionItem({
    required this.id,
    required this.name,
    required this.price,
    required this.seller,
  });

  AuctionItem copyWith({
    int? id,
    String? name,
    int? price,
    String? seller,
  }) {
    return AuctionItem(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      seller: seller ?? this.seller,
    );
  }

  factory AuctionItem.fromJson(Map<String, dynamic> json) {
    return AuctionItem(
      id: json['id'] as int,
      name: json['name'] as String,
      price: json['price'] as int,
      seller: json['seller'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'price': price,
        'seller': seller,
      };
}
