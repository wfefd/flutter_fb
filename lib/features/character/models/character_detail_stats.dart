class CharacterDetailStats {
  final double attackIncreaseFlat;
  final double attackIncreasePercent;
  final int buffPower;
  final double buffPowerPercent;
  final double finalDamagePercent;
  final double elementStackPercent;
  final double cooldownReductionPercent;
  final double cooldownRecoveryPercent;
  final double totalCooldownReductionPercent;

  const CharacterDetailStats({
    required this.attackIncreaseFlat,
    required this.attackIncreasePercent,
    required this.buffPower,
    required this.buffPowerPercent,
    required this.finalDamagePercent,
    required this.elementStackPercent,
    required this.cooldownReductionPercent,
    required this.cooldownRecoveryPercent,
    required this.totalCooldownReductionPercent,
  });

  factory CharacterDetailStats.fromJson(Map<String, dynamic> json) {
    double _d(dynamic v) => (v ?? 0).toDouble();
    int _i(dynamic v) => (v ?? 0).toInt();

    return CharacterDetailStats(
      attackIncreaseFlat: _d(json['attackIncreaseFlat']),
      attackIncreasePercent: _d(json['attackIncreasePercent']),
      buffPower: _i(json['buffPower']),
      buffPowerPercent: _d(json['buffPowerPercent']),
      finalDamagePercent: _d(json['finalDamagePercent']),
      elementStackPercent: _d(json['elementStackPercent']),
      cooldownReductionPercent: _d(json['cooldownReductionPercent']),
      cooldownRecoveryPercent: _d(json['cooldownRecoveryPercent']),
      totalCooldownReductionPercent: _d(json['totalCooldownReductionPercent']),
    );
  }
}
