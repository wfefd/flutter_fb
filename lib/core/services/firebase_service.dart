// lib/core/services/firebase_service.dart
// import 'dart:convert'; // 디버그용 로그 안 쓰면 이건 지워도 됨

import 'package:cloud_firestore/cloud_firestore.dart';

import 'firestore_mappers.dart';

// board
import '../../features/board/model/notice.dart';
import '../../features/board/model/notice_category.dart';

// community
import '../../features/community/model/community_post.dart';
import '../../features/community/model/post_category.dart';
import '../../features/community/model/community_comment.dart';

// auth user
import '../../features/auth/model/app_user.dart';

class FirestoreService {
  FirestoreService._(); // 생성 막기 (정적 유틸 클래스처럼 사용)

  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  // ─────────────────────────────────────────────
  // 1) Notice(공지사항) READ
  // ─────────────────────────────────────────────

  /// 카테고리, pinned 여부로 공지 검색 (최신순)
  static Future<List<Notice>> fetchNotices({
    NoticeCategory? category,
    bool? pinned,
    int limit = 20,
  }) async {
    Query<Map<String, dynamic>> q =
        _db.collection('notices').orderBy('created_at', descending: true);

    if (category != null) {
      q = q.where('notice_type', isEqualTo: noticeCategoryToString(category));
    }
    if (pinned != null) {
      q = q.where('pinned', isEqualTo: pinned);
    }

    final snap = await q.limit(limit).get();
    return noticesFromQuerySnapshot(snap);
  }

  /// 제목 완전 일치 검색
  static Future<List<Notice>> searchNoticesByExactTitle(
    String title, {
    int limit = 20,
  }) async {
    final snap = await _db
        .collection('notices')
        .where('title', isEqualTo: title)
        .limit(limit)
        .get();

    return noticesFromQuerySnapshot(snap);
  }

  /// 필터 없이 전체 공지 가져오기 (최신순)
  static Future<List<Notice>> fetchAllNotices({int limit = 50}) async {
    final snap = await _db
        .collection('notices')
        .orderBy('created_at', descending: true)
        .limit(limit)
        .get();

    return noticesFromQuerySnapshot(snap);
  }

  /// notice_no(숫자 id) 로 공지 한 개 가져오기
  static Future<Notice?> getNoticeByNo(int noticeNo) async {
    final snap = await _db
        .collection('notices')
        .where('notice_no', isEqualTo: noticeNo)
        .limit(1)
        .get();

    if (snap.docs.isEmpty) return null;
    return noticeFromFirestoreDoc(snap.docs.first);
  }

  // ─────────────────────────────────────────────
  // 1-1) Notice(공지사항) CREATE / UPDATE / DELETE
  // ─────────────────────────────────────────────

  /// 공지 생성 (자동 docId 반환)
  /// - Notice.id(notice_no)는 이미 채워져 있다고 가정
  static Future<String> createNotice(Notice notice) async {
    final data = noticeToFirestoreMap(notice);
    final ref = await _db.collection('notices').add(data);
    return ref.id;
  }

  /// 공지 수정 (docId 기준)
  static Future<void> updateNotice(String docId, Notice notice) async {
    final data = noticeToFirestoreMap(notice);
    await _db.collection('notices').doc(docId).update(data);
  }

  /// 공지 삭제 (docId 기준)
  static Future<void> deleteNotice(String docId) async {
    await _db.collection('notices').doc(docId).delete();
  }

  // ─────────────────────────────────────────────
  // 2) CommunityPost(boards 컬렉션) READ
  // ─────────────────────────────────────────────

  static Future<List<CommunityPost>> fetchCommunityPosts({
    PostCategory? category,
    String? authorUid,
    int limit = 20,
  }) async {
    Query<Map<String, dynamic>> q =
        _db.collection('boards').orderBy('created_at', descending: true);

    if (category != null) {
      q = q.where('category', isEqualTo: categoryToString(category));
    }
    if (authorUid != null) {
      q = q.where('author_uid', isEqualTo: authorUid);
    }

    final snap = await q.limit(limit).get();
    return communityPostsFromQuerySnapshot(snap);
  }

  static Future<List<CommunityPost>> searchPostsByExactTitle(
    String title, {
    int limit = 20,
  }) async {
    final snap = await _db
        .collection('boards')
        .where('title', isEqualTo: title)
        .limit(limit)
        .get();

    return communityPostsFromQuerySnapshot(snap);
  }

  static Future<List<CommunityPost>> fetchAllCommunityPosts({
    int limit = 50,
  }) async {
    try {
      final snap = await _db
          .collection('boards')
          .orderBy('created_at', descending: true)
          .limit(limit)
          .get();

      return communityPostsFromQuerySnapshot(snap);
    } on FirebaseException catch (e, st) {
      print(
          '[fetchAllCommunityPosts] FirebaseException: ${e.code} / ${e.message}');
      print(st);
      rethrow;
    }
  }

  // ─────────────────────────────────────────────
  // 2-1) CommunityPost CREATE / UPDATE / DELETE
  // ─────────────────────────────────────────────

  /// 게시글 생성 (boards 컬렉션, docId 반환)
  static Future<String> createCommunityPost(CommunityPost post) async {
    final data = communityPostToFirestoreMap(post);
    final ref = await _db.collection('boards').add(data);
    return ref.id;
  }

  /// 게시글 수정 (docId 기준)
  static Future<void> updateCommunityPost(
    String docId,
    CommunityPost post,
  ) async {
    final data = communityPostToFirestoreMap(post);
    await _db.collection('boards').doc(docId).update(data);
  }

  /// 게시글 삭제 (docId 기준)
  /// ※ 하위 comments 서브컬렉션까지 같이 지우고 싶으면
  ///    여기에 추가 로직 또는 Cloud Function 사용하는 걸 추천
  static Future<void> deleteCommunityPost(String docId) async {
    await _db.collection('boards').doc(docId).delete();
  }

  // ─────────────────────────────────────────────
  // 2-2) CommunityComment(boards/{post}/comments) READ
  // ─────────────────────────────────────────────

  static Future<List<CommunityComment>> fetchCommentsForPost(
    String postDocId, {
    int limit = 100,
  }) async {
    final snap = await _db
        .collection('boards')
        .doc(postDocId)
        .collection('comments')
        .orderBy('created_at', descending: true)
        .limit(limit)
        .get();

    return commentsFromQuerySnapshot(snap);
  }

  static Future<CommunityComment?> getCommentById(
    String postDocId,
    String commentDocId,
  ) async {
    final doc = await _db
        .collection('boards')
        .doc(postDocId)
        .collection('comments')
        .doc(commentDocId)
        .get();

    if (!doc.exists) return null;
    return commentFromFirestoreDoc(doc);
  }

  // ─────────────────────────────────────────────
  // 2-3) CommunityComment CREATE / UPDATE / DELETE
  // ─────────────────────────────────────────────

  /// 댓글 생성 (해당 게시글의 comments 서브컬렉션, docId 반환)
  static Future<String> createCommentForPost(
    String postDocId,
    CommunityComment comment,
  ) async {
    final data = communityCommentToFirestoreMap(comment);
    final ref = await _db
        .collection('boards')
        .doc(postDocId)
        .collection('comments')
        .add(data);
    return ref.id;
  }

  /// 댓글 수정
  static Future<void> updateCommentForPost(
    String postDocId,
    String commentDocId,
    CommunityComment comment,
  ) async {
    final data = communityCommentToFirestoreMap(comment);
    await _db
        .collection('boards')
        .doc(postDocId)
        .collection('comments')
        .doc(commentDocId)
        .update(data);
  }

  /// 댓글 삭제
  static Future<void> deleteCommentForPost(
    String postDocId,
    String commentDocId,
  ) async {
    await _db
        .collection('boards')
        .doc(postDocId)
        .collection('comments')
        .doc(commentDocId)
        .delete();
  }

  // ─────────────────────────────────────────────
  // 3) AppUser(유저) READ
  // ─────────────────────────────────────────────

  static Future<AppUser?> getUserByUid(String uid) async {
    final doc = await _db.collection('users').doc(uid).get();
    if (!doc.exists) return null;
    return appUserFromFirestoreDoc(doc);
  }

  static Future<List<AppUser>> searchUsersByDisplayName(
    String displayName, {
    int limit = 20,
  }) async {
    final snap = await _db
        .collection('users')
        .where('display_name', isEqualTo: displayName)
        .limit(limit)
        .get();

    return appUsersFromQuerySnapshot(snap);
  }

  static Future<List<AppUser>> searchUsersByEmail(
    String email, {
    int limit = 20,
  }) async {
    final snap = await _db
        .collection('users')
        .where('email', isEqualTo: email)
        .limit(limit)
        .get();

    return appUsersFromQuerySnapshot(snap);
  }

  // ─────────────────────────────────────────────
  // 3-1) AppUser CREATE / UPDATE / DELETE
  // ─────────────────────────────────────────────

  /// uid를 doc id로 사용해서 유저 생성
  static Future<void> createUser(AppUser user) async {
    final data = appUserToFirestoreMap(user);
    await _db.collection('users').doc(user.uid).set(data);
  }

  /// 유저 정보 수정
  static Future<void> updateUser(AppUser user) async {
    final data = appUserToFirestoreMap(user);
    await _db.collection('users').doc(user.uid).update(data);
  }

  /// 유저 삭제
  static Future<void> deleteUser(String uid) async {
    await _db.collection('users').doc(uid).delete();
  }
}
