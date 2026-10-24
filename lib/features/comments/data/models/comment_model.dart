import '../../domain/entities/comment.dart';

class CommentModel extends Comment {
  const CommentModel({
    required super.id,
    required super.postId,
    required super.userId,
    required super.content,
    required super.createdAt,
    super.authorUsername,
    super.authorAvatarUrl,
    super.authorPersonalityType,
  });
  factory CommentModel.fromJson(Map<String, dynamic> json) {
    final profile = json['profiles'] as Map<String, dynamic>?;
    return CommentModel(
      id: json['id'] as String,
      postId: json['post_id'] as String,
      userId: json['user_id'] as String,
      content: (json['content'] as String?) ?? '',
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
      authorUsername:
          json['author_username'] as String? ?? profile?['username'],
      authorAvatarUrl:
          json['author_avatar_url'] as String? ?? profile?['avatar_url'],
      authorPersonalityType:
          json['author_personality_type'] as String? ??
          profile?['personality_type'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'post_id': postId,
      'user_id': userId,
      'content': content,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
