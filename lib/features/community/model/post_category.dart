enum PostCategory {
  general,      // 전체/일반
  event,        // 이벤트
  maintenance,  // 점검
}

PostCategory categoryFromString(String s) {
  switch (s) {
    case 'event':
      return PostCategory.event;
    case 'maintenance':
      return PostCategory.maintenance;
    default:
      return PostCategory.general;
  }
}

String categoryToString(PostCategory c) {
  switch (c) {
    case PostCategory.event:
      return 'event';
    case PostCategory.maintenance:
      return 'maintenance';
    case PostCategory.general:
      return 'general';
  }
}
