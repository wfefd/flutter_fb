// lib/features/character/models/buff_slot.dart
import '../domain/buff_item.dart';

const List<String> kBuffCategories = [
  '상의 아바타',
  '하의 아바타',
  '크리쳐',
  '무기',
  '칭호',
  '상의',
  '머리어깨',
  '하의',
  '신발',
  '벨트',
  '목걸이',
  '팔찌',
  '반지',
  '보조장비',
  '마법석',
  '귀걸이',
];

class BuffSlot {
  final String category;
  final BuffItem? item;

  const BuffSlot({required this.category, this.item});

  bool get isEmpty => item == null;
}

List<BuffSlot> buildBuffSlotsFromItems(List<BuffItem> items) {
  final mapByCategory = <String, BuffItem>{
    for (final b in items) b.category: b,
  };

  return kBuffCategories.map((category) {
    return BuffSlot(category: category, item: mapByCategory[category]);
  }).toList();
}
