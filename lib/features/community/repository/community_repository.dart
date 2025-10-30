import '../model/community_post.dart';
import '../model/post_category.dart';

/// 인터페이스
abstract class CommunityRepository {
  Future<List<CommunityPost>> fetchPosts({
    PostCategory? category, // null이면 전체
    String query,           // 제목 검색
  });

  Future<CommunityPost?> getPostById(int id);

  Future<CommunityPost> createPost(CommunityPost post);

  Future<CommunityPost> updatePost(CommunityPost post);

  Future<void> deletePost(int id);
}

/// 메모리 기반 더미 구현체
class InMemoryCommunityRepository implements CommunityRepository {
  final List<CommunityPost> _posts = [
    CommunityPost(
      id: 1,
      title: '업데이트 안내',
      content: '1. 신규 이벤트 시작!\n2. 버그 수정',
      author: '운영팀',
      createdAt: DateTime(2025, 10, 29),
      category: PostCategory.event,
      views: 321,
      commentCount: 5,
    ),
    CommunityPost(
      id: 2,
      title: '서버 점검 공지',
      content: '10월 26일 오전 2시 ~ 6시 점검 예정',
      author: '운영팀',
      createdAt: DateTime(2025, 10, 25),
      category: PostCategory.maintenance,
      views: 514,
      commentCount: 8,
    ),
    CommunityPost(
      id: 3,
      title: '할로윈 이벤트',
      content: '한정 코스튬을 획득하세요!',
      author: '운영팀',
      createdAt: DateTime(2025, 10, 20),
      category: PostCategory.event,
      views: 777,
      commentCount: 12,
    ),
  ];

  int _seq = 100;

  @override
  Future<List<CommunityPost>> fetchPosts({
    PostCategory? category,
    String query = '',
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 120));
    Iterable<CommunityPost> res = _posts;
    if (category != null) {
      res = res.where((p) => p.category == category);
    }
    if (query.trim().isNotEmpty) {
      final q = query.toLowerCase();
      res = res.where((p) => p.title.toLowerCase().contains(q));
    }
    final list = res.toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt)); // 최신순
    return list;
  }

  @override
  Future<CommunityPost?> getPostById(int id) async {
    await Future<void>.delayed(const Duration(milliseconds: 60));
    try {
      return _posts.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<CommunityPost> createPost(CommunityPost post) async {
    await Future<void>.delayed(const Duration(milliseconds: 100));
    final created = post.copyWith(id: _seq++);
    _posts.add(created);
    return created;
  }

  @override
  Future<CommunityPost> updatePost(CommunityPost post) async {
    await Future<void>.delayed(const Duration(milliseconds: 100));
    final idx = _posts.indexWhere((p) => p.id == post.id);
    if (idx >= 0) {
      _posts[idx] = post;
      return post;
    }
    throw StateError('Post not found: ${post.id}');
  }

  @override
  Future<void> deletePost(int id) async {
    await Future<void>.delayed(const Duration(milliseconds: 80));
    _posts.removeWhere((p) => p.id == id);
  }
}
