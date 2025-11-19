class RankingRow {
  final int rank;
  final String characterId;
  final String name;
  final int fame;
  final String job;

  const RankingRow({
    required this.rank,
    required this.characterId,
    required this.name,
    required this.fame,
    required this.job,
  });

  factory RankingRow.fromJson(Map<String, dynamic> json) {
    return RankingRow(
      rank: json['rank'] as int,
      characterId: json['characterId'] as String,
      name: json['name'] as String,
      fame: json['fame'] as int,
      job: json['job'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'rank': rank,
      'characterId': characterId,
      'name': name,
      'fame': fame,
      'job': job,
    };
  }
}
