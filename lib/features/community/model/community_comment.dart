class CommunityComment {
  final int id;
  final int postId;
  final String author;
  final String content;
  final DateTime createdAt;
  final int likes;

  CommunityComment({
    required this.id,
    required this.postId,
    required this.author,
    required this.content,
    required this.createdAt,
    this.likes = 0,
  });

  CommunityComment copyWith({
    int? id,
    int? postId,
    String? author,
    String? content,
    DateTime? createdAt,
    int? likes,
  }) {
    return CommunityComment(
      id: id ?? this.id,
      postId: postId ?? this.postId,
      author: author ?? this.author,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      likes: likes ?? this.likes,
    );
  }

  factory CommunityComment.fromJson(Map<String, dynamic> j) => CommunityComment(
        id: j['id'] as int,
        postId: j['postId'] as int,
        author: j['author'] as String? ?? '익명',
        content: j['content'] as String,
        createdAt: DateTime.parse(j['createdAt'] as String),
        likes: j['likes'] as int? ?? 0,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'postId': postId,
        'author': author,
        'content': content,
        'createdAt': createdAt.toIso8601String(),
        'likes': likes,
      };
}
