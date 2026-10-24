import 'package:equatable/equatable.dart';

import '../../../domain/entities/post.dart';

abstract class CreatePostEvent extends Equatable {
  const CreatePostEvent();
  @override
  List<Object?> get props => [];
}

class MediaSelected extends CreatePostEvent {
  final String filePath;
  final PostMediaType mediaType;
  const MediaSelected({required this.filePath, required this.mediaType});
  @override
  List<Object?> get props => [filePath, mediaType];
}

class MediaRemoved extends CreatePostEvent {}

class CreatePostSubmitted extends CreatePostEvent {
  final String? title;
  final String? content;
  const CreatePostSubmitted({this.title, this.content});
  @override
  List<Object?> get props => [title, content];
}
