import '../../domain/entities/post.dart';

class PostModel extends Post {
  const PostModel({
    required super.id,
    required super.userId,
    super.title,
    super.content,
    super.mediaUrl,
    super.mediaType = PostMediaType.none,
    super.likesCount = 0,
    super.commentsCount = 0,
    super.sharesCount = 0,
    required super.createdAt,
    required super.updatedAt,
    super.authorUsername,
    super.authorAvatarUrl,
    super.authorPersonalityType,
    super.authorGender,
    super.authorAge,
    super.authorEducation,
    super.isLikedByMe = false,
  });
  factory PostModel.fromJson(Map<String, dynamic> json) {
    PostMediaType parseMediaType(String? val) {
      if (val == 'image') return PostMediaType.image;
      if (val == 'video') return PostMediaType.video;
      return PostMediaType.none;
    }

    final profile = json['profiles'] as Map<String, dynamic>?;
    return PostModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      title: json['title'] as String?,
      content: json['content'] as String?,
      mediaUrl: json['media_url'] as String?,
      mediaType: parseMediaType(json['media_type'] as String?),
      likesCount: (json['likes_count'] as num?)?.toInt() ?? 0,
      commentsCount: (json['comments_count'] as num?)?.toInt() ?? 0,
      sharesCount: (json['shares_count'] as num?)?.toInt() ?? 0,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : DateTime.now(),
      authorUsername:
          json['author_username'] as String? ?? profile?['username'],
      authorAvatarUrl:
          json['author_avatar_url'] as String? ?? profile?['avatar_url'],
      authorPersonalityType:
          json['author_personality_type'] as String? ??
          profile?['personality_type'],
      authorGender: json['author_gender'] as String? ?? profile?['gender'],
      authorAge: (json['author_age'] as num?)?.toInt(),
      authorEducation:
          json['author_education'] as String? ??
          profile?['highest_education_level'],
      isLikedByMe: (json['is_liked_by_me'] as bool?) ?? false,
    );
  }
  Map<String, dynamic> toJson() {
    String mediaTypeString() {
      switch (mediaType) {
        case PostMediaType.image:
          return 'image';
        case PostMediaType.video:
          return 'video';
        case PostMediaType.none:
          return 'none';
      }
    }

    return {
      'id': id,
      'user_id': userId,
      'title': title,
      'content': content,
      'media_url': mediaUrl,
      'media_type': mediaTypeString(),
      'likes_count': likesCount,
      'comments_count': commentsCount,
      'shares_count': sharesCount,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
