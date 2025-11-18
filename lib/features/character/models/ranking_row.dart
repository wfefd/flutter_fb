class RankingRow {
  final int rank;
  final String characterId; // ✅ 캐릭터 연결용
  final String name;
  final String job;
  final int fame;

  const RankingRow({
    required this.rank,
    required this.characterId,
    required this.name,
    required this.job,
    required this.fame,
  });
}
