import 'package:equatable/equatable.dart';

enum PostMediaType { none, image, video }

class Post extends Equatable {
  final String id;
  final String userId;
  final String? title;
  final String? content;
  final String? mediaUrl;
  final PostMediaType mediaType;
  final int likesCount;
  final int commentsCount;
  final int sharesCount;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? authorUsername;
  final String? authorAvatarUrl;
  final String? authorPersonalityType;
  final String? authorGender;
  final int? authorAge;
  final String? authorEducation;
  final bool isLikedByMe;
  const Post({
    required this.id,
    required this.userId,
    this.title,
    this.content,
    this.mediaUrl,
    this.mediaType = PostMediaType.none,
    this.likesCount = 0,
    this.commentsCount = 0,
    this.sharesCount = 0,
    required this.createdAt,
    required this.updatedAt,
    this.authorUsername,
    this.authorAvatarUrl,
    this.authorPersonalityType,
    this.authorGender,
    this.authorAge,
    this.authorEducation,
    this.isLikedByMe = false,
  });
  Post copyWith({
    String? id,
    String? userId,
    String? title,
    String? content,
    String? mediaUrl,
    PostMediaType? mediaType,
    int? likesCount,
    int? commentsCount,
    int? sharesCount,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? authorUsername,
    String? authorAvatarUrl,
    String? authorPersonalityType,
    String? authorGender,
    int? authorAge,
    String? authorEducation,
    bool? isLikedByMe,
  }) {
    return Post(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      content: content ?? this.content,
      mediaUrl: mediaUrl ?? this.mediaUrl,
      mediaType: mediaType ?? this.mediaType,
      likesCount: likesCount ?? this.likesCount,
      commentsCount: commentsCount ?? this.commentsCount,
      sharesCount: sharesCount ?? this.sharesCount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      authorUsername: authorUsername ?? this.authorUsername,
      authorAvatarUrl: authorAvatarUrl ?? this.authorAvatarUrl,
      authorPersonalityType:
          authorPersonalityType ?? this.authorPersonalityType,
      authorGender: authorGender ?? this.authorGender,
      authorAge: authorAge ?? this.authorAge,
      authorEducation: authorEducation ?? this.authorEducation,
      isLikedByMe: isLikedByMe ?? this.isLikedByMe,
    );
  }

  @override
  List<Object?> get props => [
    id,
    userId,
    title,
    content,
    mediaUrl,
    mediaType,
    likesCount,
    commentsCount,
    sharesCount,
    createdAt,
    updatedAt,
    authorUsername,
    authorAvatarUrl,
    authorPersonalityType,
    authorGender,
    authorAge,
    authorEducation,
    isLikedByMe,
  ];
}
