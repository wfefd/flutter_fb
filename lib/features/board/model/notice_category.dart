enum NoticeCategory {
  general,      // 일반
  event,        // 이벤트
  maintenance,  // 점검
}

NoticeCategory noticeCategoryFromString(String s) {
  switch (s) {
    case 'event':
      return NoticeCategory.event;
    case 'maintenance':
      return NoticeCategory.maintenance;
    default:
      return NoticeCategory.general;
  }
}

String noticeCategoryToString(NoticeCategory c) {
  switch (c) {
    case NoticeCategory.event:
      return 'event';
    case NoticeCategory.maintenance:
      return 'maintenance';
    case NoticeCategory.general:
      return 'general';
  }
}
