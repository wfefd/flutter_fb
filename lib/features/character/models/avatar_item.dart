class AvatarItem {
  final String category; // 모자 아바타, 크리쳐 등
  final List<String> images; // 아바타/크리쳐 이미지들
  final String name; // 아바타/크리쳐 이름
  final String option; // 옵션 (없으면 "" 로 내려옴)
  final String desc; // 엠블렘 설명 등

  const AvatarItem({
    required this.category,
    required this.images,
    required this.name,
    required this.option,
    required this.desc,
  });
}
