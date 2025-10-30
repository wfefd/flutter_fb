import '../model/notice.dart';
import '../model/notice_category.dart';

/// 공지 레포지토리 인터페이스
abstract class NoticeRepository {
  /// 공지 목록 조회
  Future<List<Notice>> fetchNotices({
    NoticeCategory? category, // null이면 전체
    String query,             // 제목/내용 검색어(선택)
    bool onlyPinned = false,  // 상단 고정만
  });

  /// 단건 조회
  Future<Notice?> getNoticeById(int id);

  /// 생성
  Future<Notice> createNotice(Notice notice);

  /// 수정
  Future<Notice> updateNotice(Notice notice);

  /// 삭제
  Future<void> deleteNotice(int id);
}

/// 메모리 기반 더미 구현 (실서버 붙기 전 임시)
class InMemoryNoticeRepository implements NoticeRepository {
  final List<Notice> _notices = [
    Notice(
      id: 1,
      title: '업데이트 안내',
      content: '1. 신규 이벤트 시작!\n2. 버그 수정',
      author: '운영팀',
      createdAt: DateTime(2025, 10, 29),
      category: NoticeCategory.event,
      pinned: true,
      views: 320,
      commentCount: 5,
    ),
    Notice(
      id: 2,
      title: '서버 점검 공지',
      content: '10월 26일 오전 2시 ~ 6시 점검 예정',
      author: '운영팀',
      createdAt: DateTime(2025, 10, 25),
      category: NoticeCategory.maintenance,
      pinned: false,
      views: 510,
      commentCount: 8,
    ),
    Notice(
      id: 3,
      title: '할로윈 이벤트',
      content: '한정 코스튬을 획득하세요!',
      author: '운영팀',
      createdAt: DateTime(2025, 10, 20),
      category: NoticeCategory.event,
      pinned: false,
      views: 770,
      commentCount: 12,
    ),
  ];

  int _seq = 100;

  @override
  Future<List<Notice>> fetchNotices({
    NoticeCategory? category,
    String query = '',
    bool onlyPinned = false,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 120));

    Iterable<Notice> res = _notices;

    if (onlyPinned) {
      res = res.where((n) => n.pinned);
    }

    if (category != null) {
      res = res.where((n) => n.category == category);
    }

    if (query.trim().isNotEmpty) {
      final q = query.toLowerCase();
      res = res.where((n) =>
          n.title.toLowerCase().contains(q) ||
          n.content.toLowerCase().contains(q));
    }

    final list = res.toList()
      ..sort((a, b) {
        // 상단 고정 우선 → 최신순
        if (a.pinned != b.pinned) return (b.pinned ? 1 : 0) - (a.pinned ? 1 : 0);
        return b.createdAt.compareTo(a.createdAt);
      });

    return list;
  }

  @override
  Future<Notice?> getNoticeById(int id) async {
    await Future<void>.delayed(const Duration(milliseconds: 60));
    try {
      return _notices.firstWhere((n) => n.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<Notice> createNotice(Notice notice) async {
    await Future<void>.delayed(const Duration(milliseconds: 100));
    final created = notice.copyWith(id: _seq++);
    _notices.add(created);
    return created;
  }

  @override
  Future<Notice> updateNotice(Notice notice) async {
    await Future<void>.delayed(const Duration(milliseconds: 100));
    final idx = _notices.indexWhere((n) => n.id == notice.id);
    if (idx >= 0) {
      _notices[idx] = notice;
      return notice;
    }
    throw StateError('Notice not found: ${notice.id}');
  }

  @override
  Future<void> deleteNotice(int id) async {
    await Future<void>.delayed(const Duration(milliseconds: 80));
    _notices.removeWhere((n) => n.id == id);
  }
}
