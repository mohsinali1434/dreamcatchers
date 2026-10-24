import 'package:equatable/equatable.dart';

import '../../domain/entities/comment.dart';

enum CommentStatus {
  initial,
  loading,
  loaded,
  loadingMore,
  posting,
  postSuccess,
  error,
}

class CommentState extends Equatable {
  final CommentStatus status;
  final List<Comment> comments;
  final bool hasReachedMax;
  final String? errorMessage;
  const CommentState({
    this.status = CommentStatus.initial,
    this.comments = const [],
    this.hasReachedMax = false,
    this.errorMessage,
  });
  CommentState copyWith({
    CommentStatus? status,
    List<Comment>? comments,
    bool? hasReachedMax,
    String? errorMessage,
  }) {
    return CommentState(
      status: status ?? this.status,
      comments: comments ?? this.comments,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, comments, hasReachedMax, errorMessage];
}
