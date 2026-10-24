import 'package:equatable/equatable.dart';

class Comment extends Equatable {
  final String id;
  final String postId;
  final String userId;
  final String content;
  final DateTime createdAt;
  final String? authorUsername;
  final String? authorAvatarUrl;
  final String? authorPersonalityType;
  const Comment({
    required this.id,
    required this.postId,
    required this.userId,
    required this.content,
    required this.createdAt,
    this.authorUsername,
    this.authorAvatarUrl,
    this.authorPersonalityType,
  });
  @override
  List<Object?> get props => [
    id,
    postId,
    userId,
    content,
    createdAt,
    authorUsername,
    authorAvatarUrl,
    authorPersonalityType,
  ];
}
