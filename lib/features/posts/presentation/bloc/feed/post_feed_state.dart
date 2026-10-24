import 'package:equatable/equatable.dart';

import '../../../domain/entities/post.dart';

enum FeedStatus { initial, loading, loaded, loadingMore, error }

class PostFeedState extends Equatable {
  final FeedStatus status;
  final List<Post> posts;
  final bool hasReachedMax;
  final bool isTrending;
  final String? errorMessage;
  const PostFeedState({
    this.status = FeedStatus.initial,
    this.posts = const [],
    this.hasReachedMax = false,
    this.isTrending = false,
    this.errorMessage,
  });
  PostFeedState copyWith({
    FeedStatus? status,
    List<Post>? posts,
    bool? hasReachedMax,
    bool? isTrending,
    String? errorMessage,
  }) {
    return PostFeedState(
      status: status ?? this.status,
      posts: posts ?? this.posts,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      isTrending: isTrending ?? this.isTrending,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    posts,
    hasReachedMax,
    isTrending,
    errorMessage,
  ];
}
