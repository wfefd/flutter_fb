class ItemPrice {
  final String name;   // 아이템명 (매칭 키)
  final int avgPrice;  // 평균 시세 (G)
  final String trend;  // "+2.1%" 형태

  const ItemPrice({
    required this.name,
    required this.avgPrice,
    required this.trend,
  });

  factory ItemPrice.fromJson(Map<String, dynamic> json) {
    return ItemPrice(
      name: json['name'] as String,
      avgPrice: json['avgPrice'] as int,
      trend: json['trend'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'avgPrice': avgPrice,
        'trend': trend,
      };
}
