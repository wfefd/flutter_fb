class EquipmentItem {
  final String category; // 상의, 무기, 세트, 반지 등
  final String imagePath; // 아이콘 경로 / URL
  final String name; // 장비 이름
  final String grade; // 레전더리, 에픽, rare 등
  final String option; // +15 강화, +2 버프레벨
  final String desc; // 설명

  const EquipmentItem({
    required this.category,
    required this.imagePath,
    required this.name,
    required this.grade,
    required this.option,
    required this.desc,
  });
}
