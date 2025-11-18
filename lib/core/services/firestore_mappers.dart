// lib/core/services/firestore_mappers.dart
import 'package:cloud_firestore/cloud_firestore.dart';

// ── board 쪽 공지 모델 ──
import '../../features/board/model/notice.dart';
import '../../features/board/model/notice_category.dart';

// ── community 쪽 게시글 모델 ──
import '../../features/community/model/community_post.dart';
import '../../features/community/model/post_category.dart';

// ── auth 쪽 유저 모델 ──
import '../../features/auth/model/app_user.dart';

import '../../features/community/model/community_comment.dart';


/// Map Firestore data for `notices` collection to Notice model.
Notice noticeFromFirestoreDoc(
  DocumentSnapshot<Map<String, dynamic>> doc,
) {
  final data = doc.data() ?? <String, dynamic>{};

  final int id = (data['notice_no'] ?? 0) as int;

  final String title = (data['title'] ?? '') as String;
  final String content = (data['content'] ?? '') as String;

  final String author =
      (data['author_name'] ?? data['author'] ?? '운영팀') as String;

  final Timestamp? tsCreated = data['created_at'] as Timestamp?;
  final DateTime createdAt =
      tsCreated != null ? tsCreated.toDate() : DateTime.now();

  final String rawCategory =
      (data['notice_type'] ?? data['category'] ?? 'general') as String;
  final NoticeCategory category = noticeCategoryFromString(rawCategory);

  final bool pinned =
      (data['pinned'] ?? data['is_pinned'] ?? false) as bool;

  final int views = (data['view_count'] ?? data['views'] ?? 0) as int;

  final int commentCount = (data['comment_count'] ?? 0) as int;

  return Notice(
    id: id,
    title: title,
    content: content,
    author: author,
    createdAt: createdAt,
    category: category,
    pinned: pinned,
    views: views,
    commentCount: commentCount,
  );
}

/// Map Firestore data for `boards` collection to CommunityPost model.
CommunityPost communityPostFromFirestoreDoc(
  DocumentSnapshot<Map<String, dynamic>> doc,
) {
  final data = doc.data() ?? <String, dynamic>{};

  final int id = (data['post_no'] ?? 0) as int;

  final String title = (data['title'] ?? '') as String;
  final String content = (data['content'] ?? '') as String;

  final String author =
      (data['author_name'] ?? data['author'] ?? '익명') as String;

  final Timestamp? tsCreated = data['created_at'] as Timestamp?;
  final DateTime createdAt =
      tsCreated != null ? tsCreated.toDate() : DateTime.now();

  final String rawCategory = (data['category'] ?? 'general') as String;
  final PostCategory category = categoryFromString(rawCategory);

  final int views = (data['view_count'] ?? data['views'] ?? 0) as int;
  final int commentCount = (data['comment_count'] ?? 0) as int;
  final int likes = (data['like_count'] ?? data['likes'] ?? 0) as int;

  return CommunityPost(
    id: id,
    title: title,
    content: content,
    author: author,
    createdAt: createdAt,
    category: category,
    views: views,
    commentCount: commentCount,
    likes: likes,
  );
}


CommunityComment commentFromFirestoreDoc(
  DocumentSnapshot<Map<String, dynamic>> doc,
) {
  final data = doc.data() ?? <String, dynamic>{};

  return CommunityComment(
    id: (data['id'] ?? 0) as int,
    postId: (data['post_id'] ?? 0) as int,
    author: (data['author'] ?? '익명') as String,
    content: (data['content'] ?? '') as String,
    createdAt: (data['created_at'] as Timestamp?)?.toDate() ?? DateTime.now(),
    likes: (data['likes'] ?? 0) as int,
  );
}


/// Map Firestore data for `users` collection to AppUser model.
AppUser appUserFromFirestoreDoc(
  DocumentSnapshot<Map<String, dynamic>> doc,
) {
  final data = doc.data() ?? <String, dynamic>{};

  final String uid = (data['uid'] ?? doc.id) as String;
  final String? email = data['email'] as String?;

  final String displayName =
      (data['display_name'] ?? data['displayName'] ?? 'User') as String;

  final String provider = (data['provider'] ?? 'unknown') as String;
  final String role = (data['role'] ?? 'user') as String;

  final Timestamp? tsCreated = data['created_at'] as Timestamp?;
  final Timestamp? tsLastLogin = data['last_login_at'] as Timestamp?;
  final Timestamp? tsLastAction = data['last_action_at'] as Timestamp?;

  final DateTime createdAt =
      tsCreated != null ? tsCreated.toDate() : DateTime.now();
  final DateTime? lastLoginAt = tsLastLogin?.toDate();
  final DateTime? lastActionAt = tsLastAction?.toDate();

  return AppUser(
    uid: uid,
    email: email,
    displayName: displayName,
    provider: provider,
    role: role,
    createdAt: createdAt,
    lastLoginAt: lastLoginAt,
    lastActionAt: lastActionAt,
  );
}

/// QuerySnapshot → List<Notice>
List<Notice> noticesFromQuerySnapshot(
  QuerySnapshot<Map<String, dynamic>> snap,
) {
  return snap.docs.map(noticeFromFirestoreDoc).toList();
}

/// QuerySnapshot → List<CommunityPost>
List<CommunityPost> communityPostsFromQuerySnapshot(
  QuerySnapshot<Map<String, dynamic>> snap,
) {
  return snap.docs.map(communityPostFromFirestoreDoc).toList();
}

List<CommunityComment> commentsFromQuerySnapshot(
  QuerySnapshot<Map<String, dynamic>> snap,
) {
  return snap.docs.map(commentFromFirestoreDoc).toList();
}

/// QuerySnapshot → List<AppUser>
List<AppUser> appUsersFromQuerySnapshot(
  QuerySnapshot<Map<String, dynamic>> snap,
) {
  return snap.docs.map(appUserFromFirestoreDoc).toList();
}


// ─────────────────────────────────────────────
// 🔽 모델 → Firestore Map (Create / Update 용)
// ─────────────────────────────────────────────

Map<String, dynamic> noticeToFirestoreMap(Notice n) {
  return {
    'notice_no': n.id,
    'title': n.title,
    'content': n.content,
    'author_name': n.author,
    'created_at': n.createdAt,
    'notice_type': noticeCategoryToString(n.category),
    'pinned': n.pinned,
    'view_count': n.views,
    'comment_count': n.commentCount,
  };
}

Map<String, dynamic> communityPostToFirestoreMap(CommunityPost p) {
  return {
    'post_no': p.id,
    'title': p.title,
    'content': p.content,
    'author_name': p.author,
    'created_at': p.createdAt,
    'category': categoryToString(p.category),
    'view_count': p.views,
    'comment_count': p.commentCount,
    'like_count': p.likes,
  };
}

Map<String, dynamic> communityCommentToFirestoreMap(CommunityComment c) {
  return {
    'id': c.id,
    'post_id': c.postId,
    'author': c.author,
    'content': c.content,
    'created_at': c.createdAt,
    'likes': c.likes,
  };
}

Map<String, dynamic> appUserToFirestoreMap(AppUser u) {
  return {
    'uid': u.uid,
    'email': u.email,
    'display_name': u.displayName,
    'provider': u.provider,
    'role': u.role,
    'created_at': u.createdAt,
    'last_login_at': u.lastLoginAt,
    'last_action_at': u.lastActionAt,
  };
}