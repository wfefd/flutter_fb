// lib/features/character/models/character_stats.dart
class CharacterStats {
  final double physicalDefenseRate;
  final double magicDefenseRate;
  final int str;
  final int intStat;
  final int vit;
  final int spi;
  final int physicalAttack;
  final int magicAttack;
  final double physicalCrit;
  final double magicCrit;
  final int independentAttack;
  final int adventureFame;
  final double attackSpeed;
  final double castSpeed;
  final int fireElement;
  final int waterElement;
  final int lightElement;
  final int darkElement;

  const CharacterStats({
    required this.physicalDefenseRate,
    required this.magicDefenseRate,
    required this.str,
    required this.intStat,
    required this.vit,
    required this.spi,
    required this.physicalAttack,
    required this.magicAttack,
    required this.physicalCrit,
    required this.magicCrit,
    required this.independentAttack,
    required this.adventureFame,
    required this.attackSpeed,
    required this.castSpeed,
    required this.fireElement,
    required this.waterElement,
    required this.lightElement,
    required this.darkElement,
  });

  factory CharacterStats.fromJson(Map<String, dynamic> json) {
    double _d(dynamic v) => (v ?? 0).toDouble();
    int _i(dynamic v) => (v ?? 0).toInt();

    return CharacterStats(
      physicalDefenseRate: _d(json['physicalDefenseRate']),
      magicDefenseRate: _d(json['magicDefenseRate']),
      str: _i(json['str']),
      intStat: _i(json['int']),
      vit: _i(json['vit']),
      spi: _i(json['spi']),
      physicalAttack: _i(json['physicalAttack']),
      magicAttack: _i(json['magicAttack']),
      physicalCrit: _d(json['physicalCrit']),
      magicCrit: _d(json['magicCrit']),
      independentAttack: _i(json['independentAttack']),
      adventureFame: _i(json['adventureFame']),
      attackSpeed: _d(json['attackSpeed']),
      castSpeed: _d(json['castSpeed']),
      fireElement: _i(json['fireElement']),
      waterElement: _i(json['waterElement']),
      lightElement: _i(json['lightElement']),
      darkElement: _i(json['darkElement']),
    );
  }
}
