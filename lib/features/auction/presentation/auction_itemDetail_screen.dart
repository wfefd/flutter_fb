import 'package:flutter/material.dart';

import '../models/auction_item.dart';
// 원본 무기 상세(레벨/공격력/옵션 등)를 보여주기 위해 우리가 만든 데이터 참조
import '../data/auction_item_data.dart' as src;

class AuctionItemDetailScreen extends StatelessWidget {
  const AuctionItemDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> j =
        (ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?) ??
            {};
    final item = AuctionItem.fromJson(j);

    // 이름으로 상세 데이터(레벨/공격/옵션 등) 매칭
    final srcItem = src.kAuctionItems
        .cast<src.AuctionItem?>()
        .firstWhere((e) => e?.name == item.name, orElse: () => null);

    return Scaffold(
      appBar: AppBar(title: Text(item.name)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
          children: [
            // ── 상단: 좌측 이미지 + 우측 기본 정보
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _thumb(item.imagePath),
                const SizedBox(width: 14),
                Expanded(
                  child: _BasicInfo(
                    name: item.name,
                    price: item.price,
                    seller: item.seller,
                    rarityLabel: srcItem?.rarity, // 있으면 표시
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),
            Divider(
              height: 28,
              thickness: 1,
              color: Theme.of(context).dividerColor.withOpacity(0.6),
            ),

            // ── 하단: 세부 내용(있으면 상세, 없으면 간단 안내)
            if (srcItem != null) ...[
              _SectionTitle('세부 정보'),
              const SizedBox(height: 8),
              _KeyValueCard(entries: [
                if (srcItem.type.isNotEmpty) ('종류', '${srcItem.type} / ${srcItem.subType}'),
                ('등급', srcItem.rarity),
                ('요구 레벨', '${srcItem.levelLimit}'),
                ('지능', '${srcItem.intelligence}'),
                ('전투력', '${srcItem.combatPower}'),
                if (srcItem.weightKg != null) ('무게(kg)', '${srcItem.weightKg}'),
                if (srcItem.durability != null) ('내구도', srcItem.durability!),
              ]),

              const SizedBox(height: 14),
              _SectionTitle('공격력'),
              const SizedBox(height: 8),
              _KeyValueCard(entries: [
                ('물리', '${srcItem.attack.physical}'),
                ('마법', '${srcItem.attack.magical}'),
                ('독립', '${srcItem.attack.independent}'),
              ]),

              if (srcItem.options.isNotEmpty) ...[
                const SizedBox(height: 14),
                _SectionTitle('옵션'),
                const SizedBox(height: 8),
                _OptionList(options: srcItem.options),
              ],
            ] else ...[
              _SectionTitle('세부 정보'),
              const SizedBox(height: 8),
              Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    '추가 상세 데이터가 없어 기본 정보만 표시합니다.\n'
                    '이름: ${item.name}\n가격: ${item.price} G\n판매자: ${item.seller}',
                    style: const TextStyle(height: 1.6),
                  ),
                ),
              ),
            ],
          ],
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

class _BasicInfo extends StatelessWidget {
  final String name;
  final int price;
  final String seller;
  final String? rarityLabel;

  const _BasicInfo({
    required this.name,
    required this.price,
    required this.seller,
    this.rarityLabel,
  });

  @override
  Widget build(BuildContext context) {
    final chip = rarityLabel == null
        ? null
        : Chip(
            label: Text(rarityLabel!),
            avatar: const Icon(Icons.grade, size: 16),
            visualDensity: VisualDensity.compact,
          );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          name,
          style: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Text('판매자: $seller', style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(width: 10),
            if (chip != null) chip,
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            const Icon(Icons.payments_outlined, size: 18),
            const SizedBox(width: 6),
            Text(
              '$price G',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style:
          Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
    );
  }
}

class _KeyValueCard extends StatelessWidget {
  final List<(String, String)> entries;
  const _KeyValueCard({required this.entries});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
        child: Column(
          children: entries
              .map((e) => _OneRow(label: e.$1, value: e.$2))
              .toList(growable: false),
        ),
      ),
    );
  }
}

class _OneRow extends StatelessWidget {
  final String label;
  final String value;
  const _OneRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          SizedBox(
            width: 92,
            child: Text(
              label,
              style: TextStyle(
                color: Theme.of(context).hintColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}

class _OptionList extends StatelessWidget {
  final List<String> options;
  const _OptionList({required this.options});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 10, 14, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: options
              .map(
                (o) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('•  '),
                      Expanded(child: Text(o)),
                    ],
                  ),
                ),
              )
              .toList(growable: false),
        ),
      ),
    );
  }
}
