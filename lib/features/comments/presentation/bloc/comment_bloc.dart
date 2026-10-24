import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/supabase_error_handler.dart';
import '../../domain/repositories/comment_repository.dart';
import 'comment_event.dart';
import 'comment_state.dart';

class CommentBloc extends Bloc<CommentEvent, CommentState> {
  final CommentRepository commentRepository;
  static const int _pageLimit = 15;
  CommentBloc({required this.commentRepository}) : super(const CommentState()) {
    on<LoadComments>(_onLoadComments);
    on<LoadMoreComments>(_onLoadMoreComments);
    on<AddCommentSubmitted>(_onAddCommentSubmitted);
  }
  Future<void> _onLoadComments(
    LoadComments event,
    Emitter<CommentState> emit,
  ) async {
    emit(
      state.copyWith(
        status: event.isRefresh ? state.status : CommentStatus.loading,
      ),
    );
    try {
      final comments = await commentRepository.fetchComments(
        postId: event.postId,
        offset: 0,
        limit: _pageLimit,
      );
      emit(
        state.copyWith(
          status: CommentStatus.loaded,
          comments: comments,
          hasReachedMax: comments.length < _pageLimit,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: CommentStatus.error,
          errorMessage: SupabaseErrorHandler.toFriendlyMessage(e),
        ),
      );
    }
  }

  Future<void> _onLoadMoreComments(
    LoadMoreComments event,
    Emitter<CommentState> emit,
  ) async {
    if (state.hasReachedMax || state.status == CommentStatus.loadingMore) {
      return;
    }
    emit(state.copyWith(status: CommentStatus.loadingMore));
    try {
      final offset = state.comments.length;
      final newComments = await commentRepository.fetchComments(
        postId: event.postId,
        offset: offset,
        limit: _pageLimit,
      );
      emit(
        state.copyWith(
          status: CommentStatus.loaded,
          comments: List.of(state.comments)..addAll(newComments),
          hasReachedMax: newComments.length < _pageLimit,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: CommentStatus.loaded,
          errorMessage: 'Failed to load more comments',
        ),
      );
    }
  }

  Future<void> _onAddCommentSubmitted(
    AddCommentSubmitted event,
    Emitter<CommentState> emit,
  ) async {
    final text = event.content.trim();
    if (text.isEmpty) return;
    emit(state.copyWith(status: CommentStatus.posting));
    try {
      final newComment = await commentRepository.addComment(
        postId: event.postId,
        content: text,
      );
      final updatedList = List.of(state.comments)..add(newComment);
      emit(
        state.copyWith(
          status: CommentStatus.postSuccess,
          comments: updatedList,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: CommentStatus.error,
          errorMessage: SupabaseErrorHandler.toFriendlyMessage(e),
        ),
      );
    }
  }
}
