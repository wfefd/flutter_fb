// lib/features/character/models/avatar_slot.dart
import '../domain/avatar_item.dart';

/// 고정 아바타/크리쳐 슬롯 카테고리
/// Firestore에 저장되는 category 값이랑 이 문자열을 맞춰야 한다.
const List<String> kAvatarCategories = [
  '모자 아바타',
  '머리 아바타',
  '얼굴 아바타',
  '상의 아바타',
  '하의 아바타',
  '신발 아바타',
  '목가슴 아바타',
  '허리 아바타',
  '스킨 아바타',
  '오라 아바타',
  '무기 아바타',
  '오라 스킨 아바타',
  '크리쳐',
];

/// 화면에서 사용할 "아바타/크리쳐 슬롯" 단위
class AvatarSlot {
  final String category; // ex) 머리, 모자, 크리쳐 ...
  final AvatarItem? item; // 해당 슬롯에 장착된 아바타/크리쳐 (없으면 null)

  const AvatarSlot({required this.category, this.item});

  bool get isEmpty => item == null;
}

/// Firestore에서 받아온 아바타/크리쳐 리스트를
/// 고정 슬롯 기준으로 매핑한다.
List<AvatarSlot> buildAvatarSlotsFromItems(List<AvatarItem> items) {
  // category → AvatarItem 매핑
  final mapByCategory = <String, AvatarItem>{};
  for (final item in items) {
    mapByCategory[item.category] = item; // 같은 카테고리 여러 개면 마지막 것이 덮어씀
  }

  // 고정 카테고리 순서대로 슬롯 생성
  return kAvatarCategories.map((category) {
    return AvatarSlot(
      category: category,
      item: mapByCategory[category], // 없으면 null
    );
  }).toList();
}
