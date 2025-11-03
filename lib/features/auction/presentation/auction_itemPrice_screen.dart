// lib/features/auction/presentation/auction_itemPrice_screen.dart
import 'dart:math'; // max 함수 사용을 위해 import
import 'package:flutter/material.dart';
// import 'package:intl/intl.dart'; // ⛔️ 날짜 포맷팅 제거

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
    final String itemName = widget.item['name'].toString();

    // ✅ 그래프와 표의 배경색 통일
    const Color cardBackgroundColor = Color(0xff2a3a4c); // 기존보다 살짝 밝게

    // 최근 판매가 데이터 (로딩 중이 아닐 때만 계산)
    final List<double> recentPrices = _loadingChart
        ? []
        : (_history[data.PriceRange.d7]?.sublist(max(0, _history[data.PriceRange.d7]!.length - 4))
                .reversed
                .toList() ??
            []);

    return Scaffold(
      appBar: AppBar(title: Text('$itemName 시세 정보')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── 상단: 좌측 이미지 + 우측 기본 텍스트
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _thumb(imagePath), // 고정 높이 100
                  const SizedBox(width: 14),
                  Expanded(
                    // ✅ 1. 버튼 위치 조정을 위해 SizedBox와 Column 구조 변경
                    child: SizedBox(
                      height: 100, // 이미지와 높이를 맞춤
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween, // 위아래로 밀착
                        children: [
                          Text(
                            itemName,
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(fontWeight: FontWeight.w800),
                            maxLines: 2, // 이름이 길 경우 2줄까지
                            overflow: TextOverflow.ellipsis,
                          ),
                          
                          // ✅ 버튼을 Column의 맨 아래로 이동
                          OutlinedButton.icon( 
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('시세 알림 기능 (추후 구현 예정)'),
                                  duration: Duration(seconds: 1),
                                ),
                              );
                            },
                            icon: const Icon(Icons.notifications_active_outlined), 
                            label: const Text('시세 알림 설정'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Theme.of(context).colorScheme.primary, 
                              side: BorderSide(color: Theme.of(context).colorScheme.primary),
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24), 

              // ── 그래프 섹션
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text(
                  '시세 그래프',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration( 
                    color: cardBackgroundColor, 
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white.withOpacity(0.15)),
                  ),
                  child: _loadingChart
                      ? const Center(child: CircularProgressIndicator())
                      : PriceLineChartFirst5(history: _history, backgroundColor: cardBackgroundColor), 
                ),
              ),

              const SizedBox(height: 24), 

              // ── 최근 판매가 표 섹션
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text(
                  '최근 판매가', 
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
              _buildRecentPricesTable(recentPrices, _loadingChart, cardBackgroundColor),
            ],
          ),
        ),
      ),
    );
  }

  /// ✅ 최근 판매가 목록을 "표" 형태로 그리는 위젯 (날짜 제거됨)
  Widget _buildRecentPricesTable(List<double> prices, bool isLoading, Color backgroundColor) {
    if (isLoading) {
      return Container(
        height: 150, 
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withOpacity(0.15)),
        ),
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    if (prices.isEmpty) {
      return Container(
        height: 150, 
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withOpacity(0.15)),
        ),
        child: const Center(
          child: Text(
            '최근 판매 기록이 없습니다.',
            style: TextStyle(color: Colors.grey),
          ),
        ),
      );
    }

    // ⛔️ 날짜 포맷터 제거
    // final DateFormat formatter = DateFormat('yy/MM/dd');
    // final DateTime now = DateTime.now();

    return Container(
      decoration: BoxDecoration(
        color: backgroundColor, 
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.15)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          // 표 헤더
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05), 
              border: Border(
                bottom: BorderSide(color: Colors.white.withOpacity(0.15), width: 1),
              ),
            ),
            child: Row(
              children: [
                const SizedBox(width: 24), // 순번 공간
                Expanded(
                  // flex: 2, // ⛔️ 제거
                  child: Text(
                    '가격 (G)',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.white.withOpacity(0.8),
                        ),
                  ),
                ),
                // ⛔️ 날짜 헤더 제거
                // Expanded(
                //   flex: 1,
                //   child: Text('날짜', ...),
                // ),
              ],
            ),
          ),
          // 데이터 행
          for (int i = 0; i < prices.length; i++) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  SizedBox(
                    width: 24, // 순번 고정 너비
                    child: Text(
                      '${i + 1}.',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w500,
                            color: Colors.white.withOpacity(0.7),
                          ),
                    ),
                  ),
                  Expanded(
                    // flex: 2, // ⛔️ 제거
                    child: Text(
                      prices[i].toStringAsFixed(0),
                      style: (i == 0)
                          ? Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: Colors.amber, 
                              )
                          : Theme.of(context).textTheme.bodyLarge?.copyWith(
                                fontWeight: FontWeight.w500,
                                color: Colors.amber.withOpacity(0.85),
                              ),
                    ),
                  ),
                  // ⛔️ 날짜 텍스트 제거
                  // Expanded(
                  //   flex: 1,
                  //   child: Text(formatter.format(now.subtract(Duration(days: i + 1))), ...),
                  // ),
                ],
              ),
            ),
            if (i < prices.length - 1)
              Divider(
                height: 1,
                thickness: 1,
                color: Colors.white.withOpacity(0.1),
                indent: 16,
                endIndent: 16,
              ),
          ],
        ],
      ),
    );
  }

  // 이 위젯은 현재 사용되지 않음 (참고용)
  Widget _buildInfoRow(IconData icon, String label, String value,
      {bool isPrice = false}) {
    // ... (내용 동일)
    return Row(
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Icon(icon, size: 18, color: Colors.grey[600]),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[600],
              ),
        ),
        Expanded(
          child: Text(
            value,
            style: isPrice
                ? Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context).colorScheme.secondary, 
                    )
                : Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _thumb(String? path) {
    if (path == null || path.isEmpty) {
      return Container(
        width: 100, 
        height: 100,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.grey.withOpacity(0.15),
        ),
        child: const Icon(Icons.image_not_supported, size: 36, color: Colors.grey), 
      );
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.asset(
        path,
        width: 100,
        height: 100,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Container(
          width: 100,
          height: 100,
          alignment: Alignment.center,
          color: Colors.grey.withOpacity(0.15),
          child: const Icon(Icons.broken_image_outlined, size: 36, color: Colors.grey), 
        ),
      ),
    );
  }
}