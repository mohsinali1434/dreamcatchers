import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/error/supabase_error_handler.dart';
import '../../../domain/entities/post.dart';
import '../../../domain/repositories/post_repository.dart';
import 'create_post_event.dart';
import 'create_post_state.dart';

class CreatePostBloc extends Bloc<CreatePostEvent, CreatePostState> {
  final PostRepository postRepository;
  CreatePostBloc({required this.postRepository})
    : super(const CreatePostState()) {
    on<MediaSelected>(_onMediaSelected);
    on<MediaRemoved>(_onMediaRemoved);
    on<CreatePostSubmitted>(_onCreatePostSubmitted);
  }
  void _onMediaSelected(MediaSelected event, Emitter<CreatePostState> emit) {
    emit(
      state.copyWith(
        status: CreatePostStatus.mediaPicked,
        mediaPath: event.filePath,
        mediaType: event.mediaType,
        errorMessage: null,
      ),
    );
  }

  void _onMediaRemoved(MediaRemoved event, Emitter<CreatePostState> emit) {
    emit(
      state.copyWith(
        status: CreatePostStatus.initial,
        clearMediaPath: true,
        mediaType: PostMediaType.none,
        errorMessage: null,
      ),
    );
  }

  Future<void> _onCreatePostSubmitted(
    CreatePostSubmitted event,
    Emitter<CreatePostState> emit,
  ) async {
    final text = event.content?.trim();
    final hasMedia =
        state.mediaPath != null && state.mediaType != PostMediaType.none;
    if ((text == null || text.isEmpty) && !hasMedia) {
      emit(
        state.copyWith(
          status: CreatePostStatus.error,
          errorMessage: 'Please enter text or attach an image/video to post.',
        ),
      );
      return;
    }
    emit(state.copyWith(status: CreatePostStatus.submitting));
    try {
      final post = await postRepository.createPost(
        title: event.title?.trim(),
        content: text,
        mediaFilePath: state.mediaPath,
        mediaType: state.mediaType,
      );
      emit(state.copyWith(status: CreatePostStatus.success, createdPost: post));
    } catch (e) {
      emit(
        state.copyWith(
          status: CreatePostStatus.error,
          errorMessage: SupabaseErrorHandler.toFriendlyMessage(e),
        ),
      );
    }
  }
}
