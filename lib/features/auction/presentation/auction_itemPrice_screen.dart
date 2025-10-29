import 'package:flutter/material.dart';

class ItemPriceScreen extends StatelessWidget {
  final Map<String, dynamic> item;

  const ItemPriceScreen({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${item['name']} 시세 정보'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // 🔹 상단: 이미지 + 기본 정보
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 아이템 이미지 (임시 placeholder)
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.image, size: 60, color: Colors.white),
                ),
                const SizedBox(width: 16),

                // 아이템 기본 정보
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item['name'].toString(),
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text('판매자: ${item['seller']}'),
                      Text('현재가: ${item['price']} G'),
                      Text('아이템 ID: ${item['id']}'),
                      const SizedBox(height: 8),
                      ElevatedButton.icon(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('시세 알림 설정 기능 (추후 구현 예정)'),
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

            const SizedBox(height: 24),

            // 🔹 하단: 아이템 시세 그래프
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: const Center(
                  child: Text(
                    '📊 아이템 시세 그래프 (추후 구현 예정)\n'
                    '예: 날짜별 평균가 라인 차트 표시',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
