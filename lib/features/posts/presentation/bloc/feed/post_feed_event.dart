import 'package:equatable/equatable.dart';

abstract class PostFeedEvent extends Equatable {
  const PostFeedEvent();
  @override
  List<Object?> get props => [];
}

class LoadFeed extends PostFeedEvent {
  final bool isTrending;
  final bool isRefresh;
  const LoadFeed({this.isTrending = false, this.isRefresh = false});
  @override
  List<Object?> get props => [isTrending, isRefresh];
}

class LoadMorePosts extends PostFeedEvent {
  const LoadMorePosts();
}

class TogglePostLike extends PostFeedEvent {
  final String postId;
  const TogglePostLike(this.postId);
  @override
  List<Object?> get props => [postId];
}

class SharePostRequested extends PostFeedEvent {
  final String postId;
  const SharePostRequested(this.postId);
  @override
  List<Object?> get props => [postId];
}
