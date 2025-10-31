import '../model/community_post.dart';
import '../model/post_category.dart';
import '../model/community_comment.dart';

abstract class CommunityRepository {
  Future<List<CommunityPost>> fetchPosts({String? query, PostCategory? category});
  Future<CommunityPost?> getPostById(int id);
  Future<CommunityPost> createPost(CommunityPost post);
  Future<CommunityPost> updatePost(CommunityPost post);
  Future<void> deletePost(int id);

  Future<List<CommunityComment>> fetchComments(int postId);
  Future<CommunityComment> addComment(int postId, String author, String content);
  Future<void> deleteComment(int postId, int commentId);

// ▼▼▼ 여기부터 추가 ▼▼▼
  /// 상세 진입 시 조회수 +1 하고 갱신된 포스트 반환
  Future<CommunityPost?> incrementViews(int postId);

  /// 댓글 좋아요 수 증감 (increment=true면 +1, false면 -1 최소 0 보장)
  Future<CommunityComment?> likeComment(int postId, int commentId, {bool increment = true});

  /// 댓글 내용/작성자 수정 (id로 찾아 업데이트)
  Future<CommunityComment?> updateComment(CommunityComment comment);
  // ▲▲▲ 여기까지 추가 ▲▲▲
  
}

class InMemoryCommunityRepository implements CommunityRepository {
  int _postAutoId = 3;
  int _cmtAutoId = 3;

  final List<CommunityPost> _posts = [
    CommunityPost(
      id: 1,
      title: '업데이트 안내',
      content: '신규 이벤트 시작! 버그 수정.',
      author: '운영팀',
      createdAt: DateTime(2025, 10, 29),
      category: PostCategory.event,
      views: 321,
      commentCount: 2,
    ),
    CommunityPost(
      id: 2,
      title: '서버 점검 공지',
      content: '10/26(토) 02:00~06:00 점검 예정.',
      author: '운영팀',
      createdAt: DateTime(2025, 10, 25),
      category: PostCategory.maintenance,
      views: 210,
      commentCount: 1,
    ),
    CommunityPost(
      id: 3,
      title: '자유게시판 이용 안내',
      content: '욕설/비방 금지, 매너 댓글 부탁드립니다.',
      author: '운영팀',
      createdAt: DateTime(2025, 10, 20),
      category: PostCategory.general,
      views: 120,
      commentCount: 0,
    ),
  ];

  // postId -> comments
  final Map<int, List<CommunityComment>> _comments = {
    1: [
      CommunityComment(
        id: 1, postId: 1, author: '유저A',
        content: '기대됩니다!', createdAt: DateTime(2025, 10, 29, 10, 0)),
      CommunityComment(
        id: 2, postId: 1, author: '유저B',
        content: '수고하세요~', createdAt: DateTime(2025, 10, 29, 10, 5)),
    ],
    2: [
      CommunityComment(
        id: 3, postId: 2, author: '유저C',
        content: '점검 길지 않길..', createdAt: DateTime(2025, 10, 25, 9, 0)),
    ],
  };

  @override
  Future<List<CommunityPost>> fetchPosts({String? query, PostCategory? category}) async {
    await Future.delayed(const Duration(milliseconds: 150));
    Iterable<CommunityPost> it = _posts;
    if (category != null) {
      it = it.where((p) => p.category == category);
    }
    if (query != null && query.trim().isNotEmpty) {
      final q = query.toLowerCase().trim();
      it = it.where((p) =>
          p.title.toLowerCase().contains(q) ||
          p.content.toLowerCase().contains(q));
    }
    // 최신순
    final list = it.toList()..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return list;
  }

  @override
  Future<CommunityPost?> getPostById(int id) async {
    await Future.delayed(const Duration(milliseconds: 80));
    try {
      return _posts.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<CommunityPost> createPost(CommunityPost post) async {
    await Future.delayed(const Duration(milliseconds: 80));
    final newPost = post.copyWith(id: ++_postAutoId, views: 0, commentCount: 0);
    _posts.add(newPost);
    return newPost;
  }

  @override
  Future<CommunityPost> updatePost(CommunityPost post) async {
    await Future.delayed(const Duration(milliseconds: 80));
    final idx = _posts.indexWhere((p) => p.id == post.id);
    if (idx >= 0) _posts[idx] = post;
    return post;
  }

  @override
  Future<void> deletePost(int id) async {
    await Future.delayed(const Duration(milliseconds: 80));
    _posts.removeWhere((p) => p.id == id);
    _comments.remove(id);
  }

  @override
  Future<List<CommunityComment>> fetchComments(int postId) async {
    await Future.delayed(const Duration(milliseconds: 120));
    return List<CommunityComment>.from(_comments[postId] ?? const []);
  }

  @override
  Future<CommunityComment> addComment(int postId, String author, String content) async {
    await Future.delayed(const Duration(milliseconds: 120));
    final c = CommunityComment(
      id: ++_cmtAutoId,
      postId: postId,
      author: author.isEmpty ? '익명' : author,
      content: content,
      createdAt: DateTime.now(),
    );
    _comments.putIfAbsent(postId, () => []).add(c);

    // 댓글 수 반영
    final idx = _posts.indexWhere((p) => p.id == postId);
    if (idx >= 0) {
      final cur = _posts[idx];
      _posts[idx] = cur.copyWith(commentCount: cur.commentCount + 1);
    }
    return c;
  }

  @override
  Future<void> deleteComment(int postId, int commentId) async {
    await Future.delayed(const Duration(milliseconds: 80));
    final list = _comments[postId];
    if (list == null) return;

    // 삭제 전/후 길이 차이로 removed 계산
    final before = list.length;
    list.removeWhere((e) => e.id == commentId);
    final removed = before - list.length;

    if (removed > 0) {
      final idx = _posts.indexWhere((p) => p.id == postId);
      if (idx >= 0) {
        final cur = _posts[idx];
        final newCount = cur.commentCount - removed;
        _posts[idx] = cur.copyWith(
          commentCount: newCount < 0 ? 0 : newCount, // 음수 방지
        );
      }
    }
  }

  @override
  Future<CommunityPost?> incrementViews(int postId) async {
    await Future.delayed(const Duration(milliseconds: 60));
    final idx = _posts.indexWhere((p) => p.id == postId);
    if (idx < 0) return null;
    final cur = _posts[idx];
    final updated = cur.copyWith(views: cur.views + 1);
    _posts[idx] = updated;
    return updated;
  }

  @override
  Future<CommunityComment?> likeComment(int postId, int commentId, {bool increment = true}) async {
    await Future.delayed(const Duration(milliseconds: 60));
    final list = _comments[postId];
    if (list == null) return null;
    final idx = list.indexWhere((e) => e.id == commentId);
    if (idx < 0) return null;

    final cur = list[idx];
    final nextLikes = (increment ? cur.likes + 1 : cur.likes - 1);
    final updated = cur.copyWith(likes: nextLikes < 0 ? 0 : nextLikes);
    list[idx] = updated;
    return updated;
  }

  @override
  Future<CommunityComment?> updateComment(CommunityComment comment) async {
    await Future.delayed(const Duration(milliseconds: 80));
    final list = _comments[comment.postId];
    if (list == null) return null;
    final idx = list.indexWhere((e) => e.id == comment.id);
    if (idx < 0) return null;

    list[idx] = comment;
    return comment;
  }

}