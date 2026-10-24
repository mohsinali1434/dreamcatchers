import '../../domain/entities/comment.dart';
import '../../domain/repositories/comment_repository.dart';
import '../datasources/comment_remote_data_source.dart';

class CommentRepositoryImpl implements CommentRepository {
  final CommentRemoteDataSource remoteDataSource;
  CommentRepositoryImpl({required this.remoteDataSource});
  @override
  Future<List<Comment>> fetchComments({
    required String postId,
    required int offset,
    required int limit,
  }) async {
    return await remoteDataSource.getComments(
      postId: postId,
      offset: offset,
      limit: limit,
    );
  }

  @override
  Future<Comment> addComment({
    required String postId,
    required String content,
  }) async {
    return await remoteDataSource.insertComment(
      postId: postId,
      content: content,
    );
  }
}
