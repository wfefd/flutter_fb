// lib/features/auction/presentation/auction_itemPrice_screen.dart
import 'package:flutter/material.dart';

// ✅ 차트 (각 분기의 첫 값만 그리는 위젯)
import 'widgets/price_line_chart.dart';

// ✅ 더미 레포
import '../repository/auction_repository.dart';

// ✅ data의 PriceRange enum 사용
import '../data/auction_item_data.dart' as data;

class ItemPriceScreen extends StatefulWidget {
  final Map<String, dynamic> item; // {name, price, seller, id, imagePath?}

  const ItemPriceScreen({super.key, required this.item});

  @override
  State<ItemPriceScreen> createState() => _ItemPriceScreenState();
}

class _ItemPriceScreenState extends State<ItemPriceScreen> {
  late final InMemoryAuctionRepository _repo;

  // 차트 로딩 상태 & 데이터
  bool _loadingChart = true;
  Map<data.PriceRange, List<double>> _history = const {};

  @override
  void initState() {
    super.initState();
    _repo = InMemoryAuctionRepository();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    final String name = widget.item['name'] as String;

    // 5개 분기 순서 고정
    final ranges = <data.PriceRange>[
      data.PriceRange.d7,
      data.PriceRange.d14,
      data.PriceRange.d30,
      data.PriceRange.d90,
      data.PriceRange.d365,
    ];

    // 병렬로 각 분기 시리즈 가져오기
    final results = await Future.wait(
      ranges.map((r) => _repo.fetchPriceSeries(name, range: r)),
    );

    // 맵 구성
    final map = <data.PriceRange, List<double>>{};
    for (int i = 0; i < ranges.length; i++) {
      map[ranges[i]] = results[i];
    }

    if (!mounted) return;
    setState(() {
      _history = map;
      _loadingChart = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final String? imagePath = widget.item['imagePath'] as String?;

    return Scaffold(
      appBar: AppBar(title: Text('${widget.item['name']} 시세 정보')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // ── 상단: 좌측 이미지 + 우측 기본 텍스트
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _thumb(imagePath),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.item['name'].toString(),
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(fontWeight: FontWeight.w800),
                        ),
                        const SizedBox(height: 6),
                        Text('판매자: ${widget.item['seller']}'),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            const Icon(Icons.payments_outlined, size: 18),
                            const SizedBox(width: 6),
                            Text(
                              '${widget.item['price']} G',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                        if (widget.item['id'] != null) ...[
                          const SizedBox(height: 6),
                          Text('아이템 ID: ${widget.item['id']}'),
                        ],
                        const SizedBox(height: 10),
                        ElevatedButton.icon(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('시세 알림 기능 (추후 구현 예정)'),
                                duration: Duration(seconds: 1),
                              ),
                            );
                          },
                          icon: const Icon(Icons.notifications),
                          label: const Text('시세 알림'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // ── 하단: 5분기 첫 값 차트
              Expanded(
                child: _loadingChart
                    ? const Center(child: CircularProgressIndicator())
                    : PriceLineChartFirst5(history: _history),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _thumb(String? path) {
    if (path == null || path.isEmpty) {
      return Container(
        width: 96,
        height: 96,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.grey.withOpacity(0.15),
        ),
        child: const Icon(Icons.image_not_supported, size: 28),
      );
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.asset(
        path,
        width: 96,
        height: 96,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Container(
          width: 96,
          height: 96,
          alignment: Alignment.center,
          color: Colors.grey.withOpacity(0.15),
          child: const Icon(Icons.broken_image_outlined),
        ),
      ),
    );
  }
}
