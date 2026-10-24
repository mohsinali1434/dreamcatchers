import '../entities/comment.dart';

abstract class CommentRepository {
  Future<List<Comment>> fetchComments({
    required String postId,
    required int offset,
    required int limit,
  });
  Future<Comment> addComment({required String postId, required String content});
}
