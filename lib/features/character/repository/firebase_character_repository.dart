// lib/features/character/repository/firebase_character_repository.dart
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/domain/character.dart';
import '../models/domain/ranking_row.dart';
import '../models/ui/character_detail.dart'; // ★ NEW
import 'character_repository.dart';

class FirebaseCharacterRepository implements CharacterRepository {
  final FirebaseFirestore _db;

  FirebaseCharacterRepository({FirebaseFirestore? db})
    : _db = db ?? FirebaseFirestore.instance;

  // ---------------------------------------------------------------------------
  // 1) 랭킹 미리보기
  // ---------------------------------------------------------------------------
  @override
  Future<List<RankingRow>> fetchRankingPreview({String? server}) async {
    Query<Map<String, dynamic>> q = _db
        .collection('character_ranking')
        .orderBy('rank');

    if (server != null) {
      q = q.where('serverCode', isEqualTo: serverCodeFromLabel(server));
    }

    final snap = await q.limit(20).get();

    return snap.docs.map((doc) => RankingRow.fromJson(doc.data())).toList();
  }

  // ---------------------------------------------------------------------------
  // 2) 캐릭터 검색
  // ---------------------------------------------------------------------------
  @override
  Future<List<Character>> searchCharacters({
    required String name,
    String? server,
  }) async {
    Query<Map<String, dynamic>> q = _db.collection('characters');

    if (server != null) {
      q = q.where('serverCode', isEqualTo: serverCodeFromLabel(server));
    }

    // 일단 완전 일치 검색 기준
    q = q.where('name', isEqualTo: name);

    final snap = await q.limit(50).get();

    // doc.id를 id 필드로 같이 넣어주기
    return snap.docs.map((doc) {
      final data = doc.data();
      return Character.fromJson({
        'id': doc.id, // ★ doc.id를 id로 사용
        ...data,
      });
    }).toList();
  }

  // ---------------------------------------------------------------------------
  // 3) 캐릭터 기본 정보 조회 (리스트/카드용)
  // ---------------------------------------------------------------------------
  @override
  Future<Character?> getCharacterById(String id) async {
    final doc = await _db.collection('characters').doc(id).get();

    if (!doc.exists) return null;

    final data = doc.data()!;
    return Character.fromJson({
      'id': doc.id, // ★ 동일하게 id 추가
      ...data,
    });
  }

  // ---------------------------------------------------------------------------
  // 4) 캐릭터 상세 조회 (장비/스탯/버프/아바타 포함)
  // ---------------------------------------------------------------------------
  @override
  Future<CharacterDetail?> getCharacterDetailById(String id) async {
    // ★ NEW
    final doc = await _db.collection('characters').doc(id).get();

    if (!doc.exists) return null;

    final data = doc.data()!;

    // CharacterDetail.fromJson이 전체 JSON을 받아서
    // summary + stats + detailStats + avatars + buffItems + equipments 등을
    // 내부에서 각 모델로 나눠서 만든다고 가정.
    return CharacterDetail.fromJson({
      'id': doc.id, // 요약 Character용
      ...data,
    });
  }

  // ---------------------------------------------------------------------------
  // 서버 라벨(카인/시로코..) → 코드(kain/siroco..) 변환
  // Character.fromJson에서는 반대로 code → label로 바꾸고 있지.
  // ---------------------------------------------------------------------------
  String serverCodeFromLabel(String label) {
    switch (label) {
      case '카인':
        return 'kain';
      case '시로코':
        return 'siroco';
      // TODO: 나머지 서버도 여기 추가
      default:
        return label;
    }
  }
}
