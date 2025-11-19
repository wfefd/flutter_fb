// lib/features/character/models/character_detail.dart
import '../domain/character.dart';
import '../domain/character_stats.dart';
import '../domain/character_detail_stats.dart';
import '../domain/avatar_item.dart';
import '../domain/buff_item.dart';
import '../domain/equipment_item.dart';
import 'basic_stat.dart';
import 'detail_stat.dart';

class CharacterDetail {
  final Character summary; // 상단 기본 정보
  final CharacterStats stats; // 기본 스탯
  final CharacterDetailStats detailStats; // 세부 스탯
  final List<AvatarItem> avatars; // 아바타/크리쳐
  final List<BuffItem> buffItems; // 버프 강화 장비
  final List<EquipmentItem> equipments; // 장착 장비
  final List<BasicStat> basicStats; // 스탯 탭
  final List<DetailStat> extraDetailStats; // 추가 세부 스탯

  const CharacterDetail({
    required this.summary,
    required this.stats,
    required this.detailStats,
    required this.avatars,
    required this.buffItems,
    required this.equipments,
    required this.basicStats,
    required this.extraDetailStats,
  });

  factory CharacterDetail.fromJson(Map<String, dynamic> json) {
    // summary용 Character (리스트/카드에서 쓰는 그 모델 재사용)
    final summary = Character.fromJson({
      'id': json['id'],
      'name': json['name'],
      'job': json['job'],
      'level': json['level'],
      'serverCode': json['serverCode'],
      'imageUrl': json['imageUrl'],
      'fame': json['fame'],
    });

    List<T> _list<T>(dynamic v, T Function(Map<String, dynamic>) mapper) {
      if (v == null) return const [];
      return (v as List<dynamic>)
          .map((e) => mapper(e as Map<String, dynamic>))
          .toList();
    }

    return CharacterDetail(
      summary: summary,
      stats: CharacterStats.fromJson(
        (json['stats'] as Map<String, dynamic>? ?? const {}),
      ),
      detailStats: CharacterDetailStats.fromJson(
        (json['detailStats'] as Map<String, dynamic>? ?? const {}),
      ),
      avatars: _list(json['avatars'], AvatarItem.fromJson),
      buffItems: _list(json['buffItems'], BuffItem.fromJson),
      equipments: _list(json['equipments'], EquipmentItem.fromJson),
      basicStats: _list(json['basicStats'], BasicStat.fromJson),
      extraDetailStats: _list(json['extraDetailStats'], DetailStat.fromJson),
    );
  }
}
