import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/error/supabase_error_handler.dart';
import '../../../domain/repositories/post_repository.dart';
import 'post_feed_event.dart';
import 'post_feed_state.dart';

class PostFeedBloc extends Bloc<PostFeedEvent, PostFeedState> {
  final PostRepository postRepository;
  static const int _pageLimit = 10;
  PostFeedBloc({required this.postRepository}) : super(const PostFeedState()) {
    on<LoadFeed>(_onLoadFeed);
    on<LoadMorePosts>(_onLoadMorePosts);
    on<TogglePostLike>(_onTogglePostLike);
    on<SharePostRequested>(_onSharePostRequested);
  }
  Future<void> _onLoadFeed(LoadFeed event, Emitter<PostFeedState> emit) async {
    emit(
      state.copyWith(
        status: event.isRefresh ? state.status : FeedStatus.loading,
        isTrending: event.isTrending,
      ),
    );
    try {
      final posts = event.isTrending
          ? await postRepository.fetchTrendingPosts(
              offset: 0,
              limit: _pageLimit,
            )
          : await postRepository.fetchPosts(offset: 0, limit: _pageLimit);
      emit(
        state.copyWith(
          status: FeedStatus.loaded,
          posts: posts,
          hasReachedMax: posts.length < _pageLimit,
          isTrending: event.isTrending,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: FeedStatus.error,
          errorMessage: SupabaseErrorHandler.toFriendlyMessage(e),
        ),
      );
    }
  }

  Future<void> _onLoadMorePosts(
    LoadMorePosts event,
    Emitter<PostFeedState> emit,
  ) async {
    if (state.hasReachedMax || state.status == FeedStatus.loadingMore) return;
    emit(state.copyWith(status: FeedStatus.loadingMore));
    try {
      final offset = state.posts.length;
      final newPosts = state.isTrending
          ? await postRepository.fetchTrendingPosts(
              offset: offset,
              limit: _pageLimit,
            )
          : await postRepository.fetchPosts(offset: offset, limit: _pageLimit);
      emit(
        state.copyWith(
          status: FeedStatus.loaded,
          posts: List.of(state.posts)..addAll(newPosts),
          hasReachedMax: newPosts.length < _pageLimit,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: FeedStatus.loaded,
          errorMessage: 'Failed to load more posts',
        ),
      );
    }
  }

  Future<void> _onTogglePostLike(
    TogglePostLike event,
    Emitter<PostFeedState> emit,
  ) async {
    final updatedPosts = state.posts.map((post) {
      if (post.id == event.postId) {
        final newIsLiked = !post.isLikedByMe;
        final newLikesCount = newIsLiked
            ? post.likesCount + 1
            : (post.likesCount > 0 ? post.likesCount - 1 : 0);
        return post.copyWith(
          isLikedByMe: newIsLiked,
          likesCount: newLikesCount,
        );
      }
      return post;
    }).toList();
    emit(state.copyWith(posts: updatedPosts));
    try {
      await postRepository.toggleLikePost(event.postId);
    } catch (_) {
      // Ignore
    }
  }

  Future<void> _onSharePostRequested(
    SharePostRequested event,
    Emitter<PostFeedState> emit,
  ) async {
    final updatedPosts = state.posts.map((post) {
      if (post.id == event.postId) {
        return post.copyWith(sharesCount: post.sharesCount + 1);
      }
      return post;
    }).toList();
    emit(state.copyWith(posts: updatedPosts));
    try {
      final newCount = await postRepository.incrementShareCount(event.postId);
      final syncedPosts = state.posts.map((post) {
        if (post.id == event.postId) {
          return post.copyWith(sharesCount: newCount);
        }
        return post;
      }).toList();
      emit(state.copyWith(posts: syncedPosts));
    } catch (_) {
      // Ignore
    }
  }
}
