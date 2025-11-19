// lib/features/character/models/basic_stat.dart
class BasicStat {
  final String iconPath; // 프론트 image/assets에서 사용 (또는 url)
  final String name;
  final String value; // UI용 문자열

  const BasicStat({
    required this.iconPath,
    required this.name,
    required this.value,
  });

  factory BasicStat.fromJson(Map<String, dynamic> json) {
    return BasicStat(
      iconPath: json['iconPath'] as String? ?? '',
      name: json['name'] as String? ?? '',
      value: json['value'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'iconPath': iconPath, 'name': name, 'value': value};
  }
}
