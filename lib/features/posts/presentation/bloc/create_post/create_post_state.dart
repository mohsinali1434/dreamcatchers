import 'package:equatable/equatable.dart';

import '../../../domain/entities/post.dart';

enum CreatePostStatus { initial, mediaPicked, submitting, success, error }

class CreatePostState extends Equatable {
  final CreatePostStatus status;
  final String? mediaPath;
  final PostMediaType mediaType;
  final String? errorMessage;
  final Post? createdPost;
  const CreatePostState({
    this.status = CreatePostStatus.initial,
    this.mediaPath,
    this.mediaType = PostMediaType.none,
    this.errorMessage,
    this.createdPost,
  });
  CreatePostState copyWith({
    CreatePostStatus? status,
    String? mediaPath,
    bool clearMediaPath = false,
    PostMediaType? mediaType,
    String? errorMessage,
    Post? createdPost,
  }) {
    return CreatePostState(
      status: status ?? this.status,
      mediaPath: clearMediaPath ? null : (mediaPath ?? this.mediaPath),
      mediaType: mediaType ?? this.mediaType,
      errorMessage: errorMessage,
      createdPost: createdPost ?? this.createdPost,
    );
  }

  @override
  List<Object?> get props => [
    status,
    mediaPath,
    mediaType,
    errorMessage,
    createdPost,
  ];
}
