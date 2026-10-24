import '../entities/post.dart';

abstract class PostRepository {
  Future<List<Post>> fetchPosts({required int offset, required int limit});
  Future<List<Post>> fetchTrendingPosts({
    required int offset,
    required int limit,
  });
  Future<List<Post>> fetchMyPosts();
  Future<Post> createPost({
    String? title,
    String? content,
    String? mediaFilePath,
    required PostMediaType mediaType,
  });
  Future<Post> updatePost({
    required String postId,
    String? title,
    String? content,
  });
  Future<void> deletePost(String postId);
  Future<bool> toggleLikePost(String postId);
  Future<int> incrementShareCount(String postId);
}
