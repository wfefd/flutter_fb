class Character {
  final String id;
  final String name;
  final String job;
  final int level;
  final String server; // 여전히 '카인' 처럼 표시용
  final String imagePath;
  final String fame;

  const Character({
    required this.id,
    required this.name,
    required this.job,
    required this.level,
    required this.server,
    required this.imagePath,
    required this.fame,
  });

  factory Character.fromJson(Map<String, dynamic> json) {
    final serverCode = json['serverCode'] as String;
    return Character(
      id: json['id'] as String,
      name: json['name'] as String,
      job: json['job'] as String,
      level: json['level'] as int,
      server: _mapServerCodeToLabel(serverCode), // 👈 여기서 한 번 변환
      imagePath: json['imageUrl'] as String,
      fame: json['fame'].toString(),
    );
  }
}

String _mapServerCodeToLabel(String code) {
  switch (code) {
    case 'kain':
      return '카인';
    case 'siroco':
      return '시로코';
    // ...
    default:
      return code;
  }
}
