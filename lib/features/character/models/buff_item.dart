class BuffItem {
  final String category; // 상의 아바타, 크리쳐, 무기 ...
  final String imagePath; // 아이콘 경로
  final String name; // 아이템 이름
  final String grade; // 등급: 레어, 에픽, 레전더리 등
  final String option; // 옵션 텍스트, 없으면 "" (빈 문자열)

  const BuffItem({
    required this.category,
    required this.imagePath,
    required this.name,
    required this.grade,
    required this.option,
  });
}
