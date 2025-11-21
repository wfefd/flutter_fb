// lib/core/services/firebase_service.dart
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

// auction
import '../../features/auction/models/auction_item.dart' as auction_simple;
import '../../features/auction/models/auction_item_data.dart' as auction_detail;
import 'package:flutter_fb/features/auction/models/item_price.dart';

class FirestoreService {
  FirestoreService._();

  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  // ---------------------------------------------------------------------------
  // 1) Notice
  // ---------------------------------------------------------------------------

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

  static Future<List<Notice>> fetchAllNotices({int limit = 50}) async {
    final snap = await _db
        .collection('notices')
        .orderBy('created_at', descending: true)
        .limit(limit)
        .get();

    return noticesFromQuerySnapshot(snap);
  }

  static Future<Notice?> getNoticeByNo(int noticeNo) async {
    final snap = await _db
        .collection('notices')
        .where('notice_no', isEqualTo: noticeNo)
        .limit(1)
        .get();

    if (snap.docs.isEmpty) return null;
    return noticeFromFirestoreDoc(snap.docs.first);
  }

  static Future<String> createNotice(Notice notice) async {
    final data = noticeToFirestoreMap(notice);
    final ref = await _db.collection('notices').add(data);
    return ref.id;
  }

  static Future<void> updateNotice(String docId, Notice notice) async {
    final data = noticeToFirestoreMap(notice);
    await _db.collection('notices').doc(docId).update(data);
  }

  static Future<void> deleteNotice(String docId) async {
    await _db.collection('notices').doc(docId).delete();
  }

  // ---------------------------------------------------------------------------
  // 2) CommunityPost / Comment
  // ---------------------------------------------------------------------------

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

  static Future<String> createCommunityPost(CommunityPost post) async {
    final data = communityPostToFirestoreMap(post);
    final ref = await _db.collection('boards').add(data);
    return ref.id;
  }

  static Future<void> updateCommunityPost(
    String docId,
    CommunityPost post,
  ) async {
    final data = communityPostToFirestoreMap(post);
    await _db.collection('boards').doc(docId).update(data);
  }

  static Future<void> deleteCommunityPost(String docId) async {
    await _db.collection('boards').doc(docId).delete();
  }

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

  // ---------------------------------------------------------------------------
  // 3) AppUser
  // ---------------------------------------------------------------------------

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

  static Future<void> createUser(AppUser user) async {
    final data = appUserToFirestoreMap(user);
    await _db.collection('users').doc(user.uid).set(data);
  }

  static Future<void> updateUser(AppUser user) async {
    final data = appUserToFirestoreMap(user);
    await _db.collection('users').doc(user.uid).update(data);
  }

  static Future<void> deleteUser(String uid) async {
    await _db.collection('users').doc(uid).delete();
  }

  // ---------------------------------------------------------------------------
  // 4) Auction: listings / item_prices
  // ---------------------------------------------------------------------------

  static Future<List<auction_simple.AuctionItem>>
      fetchAuctionListingsSimple(
    String itemId, {
    int limit = 50,
  }) async {
    final snap = await _db
        .collection('auction_items')
        .doc(itemId)
        .collection('listings')
        .orderBy('unitPrice')
        .limit(limit)
        .get();

    return auctionSimpleItemsFromQuerySnapshot(snap);
  }

  static Future<List<auction_detail.AuctionItem>>
      fetchAuctionListingsDetail(
    String itemId, {
    int limit = 50,
  }) async {
    final snap = await _db
        .collection('auction_items')
        .doc(itemId)
        .collection('listings')
        .orderBy('unitPrice')
        .limit(limit)
        .get();

    return auctionDetailItemsFromQuerySnapshot(snap);
  }

  static Future<ItemPrice?> getItemPriceByItemId(
    String itemId,
  ) async {
    final doc = await _db.collection('item_prices').doc(itemId).get();

    if (!doc.exists) return null;
    return itemPriceFromFirestoreDoc(doc);
  }

  static Future<List<ItemPrice>> searchItemPricesByName(
    String name, {
    int limit = 20,
  }) async {
    final snap = await _db
        .collection('item_prices')
        .where('itemName', isEqualTo: name)
        .limit(limit)
        .get();

    return itemPricesFromQuerySnapshot(snap);
  }

  // ---------------------------------------------------------------------------
  // 4-1) Auction: fetch all auction_items
  // ---------------------------------------------------------------------------

  /// All auction_items with simple listings mapped.
  /// Return: { itemId: List<AuctionItemSimple> }
  static Future<Map<String, List<auction_simple.AuctionItem>>>
      fetchAllAuctionListingsSimple({
    int perItemLimit = 50,
  }) async {
    final rootSnap = await _db.collection('auction_items').get();

    final Map<String, List<auction_simple.AuctionItem>> result = {};

    for (final doc in rootSnap.docs) {
      final listingsSnap = await doc.reference
          .collection('listings')
          .orderBy('unitPrice')
          .limit(perItemLimit)
          .get();

      result[doc.id] = auctionSimpleItemsFromQuerySnapshot(listingsSnap);
    }

    return result;
  }

  /// All auction_items with detail listings mapped.
  /// Return: { itemId: List<AuctionItemDetail> }
  static Future<Map<String, List<auction_detail.AuctionItem>>>
      fetchAllAuctionListingsDetail({
    int perItemLimit = 50,
  }) async {
    final rootSnap = await _db.collection('auction_items').get();

    final Map<String, List<auction_detail.AuctionItem>> result = {};

    for (final doc in rootSnap.docs) {
      final listingsSnap = await doc.reference
          .collection('listings')
          .orderBy('unitPrice')
          .limit(perItemLimit)
          .get();

      result[doc.id] = auctionDetailItemsFromQuerySnapshot(listingsSnap);
    }

    return result;
  }
}
