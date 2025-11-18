import 'dart:math';

import '../model/community_post.dart';
import '../model/post_category.dart';
import '../model/community_comment.dart';
import '../../../core/services/firebase_service.dart';
abstract class CommunityRepository {
  Future<List<CommunityPost>> fetchPosts({String? query, PostCategory? category});
  Future<CommunityPost?> getPostById(int id);
  Future<CommunityPost> createPost(CommunityPost post);
  Future<CommunityPost> updatePost(CommunityPost post);
  Future<void> deletePost(int id);

  Future<List<CommunityComment>> fetchComments(int postId);
  Future<CommunityComment> addComment(int postId, String author, String content);
  Future<void> deleteComment(int postId, int commentId);

  Future<CommunityPost?> incrementViews(int postId);
  Future<CommunityComment?> likeComment(int postId, int commentId, {bool increment = true});
  Future<CommunityComment?> updateComment(CommunityComment comment);
}

class InMemoryCommunityRepository implements CommunityRepository {
  int _postAutoId = 0;
  int _cmtAutoId = 0;

  final List<CommunityPost> _posts = [];
  final Map<int, List<CommunityComment>> _comments = {};

  // 🔥 Firestore → 메모리로 한번 싹 가져오는 초기화 함수
  Future<void> loadFromFirestore() async {
    // 1) 게시글 전부 가져오기 (mapper까지 끝난 상태로 들어옴)
    final remotePosts = await FirestoreService.fetchAllCommunityPosts(limit: 100);

    // 2) 필요하면 댓글도 Firestore에서 가져와서 넣을 수 있음
    //    지금은 예시로 "댓글은 아직 안쓴다" 가정하고 빈 리스트.
    //    나중에 FirestoreService에 fetchAllComments() 같은 거 만들면 여기서 같이 호출하면 됨.
    final List<CommunityComment> remoteComments = const [];

    _replaceWithRemoteData(
      posts: remotePosts,
      comments: remoteComments,
    );
  }

  /// 내부 캐시 교체 함수 (외부에서는 loadFromFirestore만 쓰면 됨)
  void _replaceWithRemoteData({
    required List<CommunityPost> posts,
    required List<CommunityComment> comments,
  }) {
    // posts 세팅
    _posts
      ..clear()
      ..addAll(posts);

    if (_posts.isEmpty) {
      _postAutoId = 0;
    } else {
      _postAutoId = _posts.map((p) => p.id).reduce(max);
    }

    // comments 세팅 (postId 기준으로 그룹)
    _comments.clear();
    for (final c in comments) {
      final list = _comments.putIfAbsent(c.postId, () => <CommunityComment>[]);
      list.add(c);
    }

    if (comments.isEmpty) {
      _cmtAutoId = 0;
    } else {
      _cmtAutoId = comments.map((c) => c.id).reduce(max);
    }
  }

  // ───────── 이하 기존 메서드들은 그대로 ─────────

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

    final before = list.length;
    list.removeWhere((e) => e.id == commentId);
    final removed = before - list.length;

    if (removed > 0) {
      final idx = _posts.indexWhere((p) => p.id == postId);
      if (idx >= 0) {
        final cur = _posts[idx];
        final newCount = cur.commentCount - removed;
        _posts[idx] = cur.copyWith(
          commentCount: newCount < 0 ? 0 : newCount,
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
    final nextLikes = increment ? cur.likes + 1 : cur.likes - 1;
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