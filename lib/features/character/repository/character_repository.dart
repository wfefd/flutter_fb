// lib/features/character/repository/character_repository.dart
import '../models/domain/character.dart';
import '../models/domain/ranking_row.dart';
import '../models/ui/character_detail.dart'; // ★ NEW

abstract class CharacterRepository {
  /// 서버별 랭킹 미리보기 (상위 N개)
  Future<List<RankingRow>> fetchRankingPreview({String? server});

  /// 캐릭터 검색
  Future<List<Character>> searchCharacters({
    required String name,
    String? server, // null이면 전체 서버
  });

  /// 캐릭터 기본 정보 조회 (리스트/카드용)
  Future<Character?> getCharacterById(String id);

  /// 캐릭터 상세 조회 (장비/스탯/버프/아바타 전부 포함)
  Future<CharacterDetail?> getCharacterDetailById(String id); // ★ NEW
}
