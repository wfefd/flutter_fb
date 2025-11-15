import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/custom_container_divided.dart';
import '../../models/auction_item.dart'; // 화면용 AuctionItem (id, price, seller…)
import '../../data/auction_item_data.dart'
    as src; // 상세용 하드코딩 데이터(kAuctionItems)

class AuctionSearchContent extends StatefulWidget {
  final String query;

  const AuctionSearchContent({super.key, required this.query});

  @override
  State<AuctionSearchContent> createState() => _AuctionSearchContentState();
}

class _AuctionSearchContentState extends State<AuctionSearchContent> {
  // 🔹 실제 아이템 데이터 소스: kAuctionItems
  final List<src.AuctionItem> _allItems = src.kAuctionItems;

  // 🔹 찜 상태 (이름 기준으로 관리)
  final Set<String> _favoriteNames = {};

  void _toggleFavorite(String name) {
    setState(() {
      if (_favoriteNames.contains(name)) {
        _favoriteNames.remove(name);
      } else {
        _favoriteNames.add(name);
      }
    });
  }

  // 🔹 현재가(골드) 추출: 7일 시세(d7) 마지막 값 사용
  int _currentPrice(src.AuctionItem item) {
    final series = src.fullSeriesOf(item, src.PriceRange.d7);
    if (series.isEmpty) return 0;
    return series.last.toInt();
  }

  // 🔹 디테일 화면으로 이동
  void _openDetail(src.AuctionItem srcItem) {
    final price = _currentPrice(srcItem);

    // id는 그냥 리스트 인덱스로 부여 (디테일에서 눈에 띄게 쓰지도 않으니까)
    final id = _allItems.indexWhere((e) => e.name == srcItem.name);
    final safeId = id >= 0 ? id + 1 : 0;

    // 화면용 AuctionItem으로 변환
    final auctionItem = AuctionItem(
      id: safeId,
      name: srcItem.name,
      price: price,
      seller: '경매장 상인', // 임시 판매자
      imagePath: srcItem.imagePath,
    );

    Navigator.pushNamed(
      context,
      '/auction_item_detail',
      arguments: auctionItem.toJson(),
    );
  }

  @override
  Widget build(BuildContext context) {
    // 🔍 이름 포함 검색
    final filtered = _allItems.where((item) {
      return item.name.contains(widget.query);
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 제목: 'xx' 검색결과
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          child: Text(
            '\'${widget.query}\' 검색결과',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.primaryText,
            ),
          ),
        ),
        const SizedBox(height: 4),

        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            child: CustomContainerDivided(
              header: const Text(
                '아이템 리스트',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: AppColors.primaryText,
                ),
              ),
              children: filtered.map((item) {
                final name = item.name;
                final isFav = _favoriteNames.contains(name);
                final gold = _currentPrice(item);

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 3),
                  child: InkWell(
                    onTap: () => _openDetail(item), // ✅ 클릭 시 detail 이동
                    child: Container(
                      height: 52,
                      padding: const EdgeInsets.symmetric(
                        vertical: 6,
                        horizontal: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.border, width: 1),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // 이미지
                          Image.asset(
                            item.imagePath,
                            width: 32,
                            height: 32,
                            fit: BoxFit.cover,
                          ),
                          const SizedBox(width: 8),

                          // 아이템 이름
                          Expanded(
                            child: Text(
                              name,
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 13,
                                color: AppColors.primaryText,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),

                          const SizedBox(width: 8),

                          // 골드 + 하트 (골드 먼저, 그 다음 하트)
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '${gold}G',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primaryText,
                                ),
                              ),
                              const SizedBox(width: 4),
                              GestureDetector(
                                onTap: () => _toggleFavorite(name),
                                child: Icon(
                                  isFav
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  size: 18,
                                  color: isFav ? Colors.red : Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}
