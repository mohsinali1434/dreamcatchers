import 'package:equatable/equatable.dart';

abstract class CommentEvent extends Equatable {
  const CommentEvent();
  @override
  List<Object?> get props => [];
}

class LoadComments extends CommentEvent {
  final String postId;
  final bool isRefresh;
  const LoadComments({required this.postId, this.isRefresh = false});
  @override
  List<Object?> get props => [postId, isRefresh];
}

class LoadMoreComments extends CommentEvent {
  final String postId;
  const LoadMoreComments(this.postId);
  @override
  List<Object?> get props => [postId];
}

class AddCommentSubmitted extends CommentEvent {
  final String postId;
  final String content;
  const AddCommentSubmitted({required this.postId, required this.content});
  @override
  List<Object?> get props => [postId, content];
}
