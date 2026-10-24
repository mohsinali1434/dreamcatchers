import '../../domain/entities/post.dart';
import '../../domain/repositories/post_repository.dart';
import '../datasources/post_remote_data_source.dart';

class PostRepositoryImpl implements PostRepository {
  final PostRemoteDataSource remoteDataSource;
  PostRepositoryImpl({required this.remoteDataSource});
  @override
  Future<List<Post>> fetchPosts({
    required int offset,
    required int limit,
  }) async {
    return await remoteDataSource.getPostsFeed(offset: offset, limit: limit);
  }

  @override
  Future<List<Post>> fetchTrendingPosts({
    required int offset,
    required int limit,
  }) async {
    return await remoteDataSource.getTrendingPosts(
      offset: offset,
      limit: limit,
    );
  }

  @override
  Future<List<Post>> fetchMyPosts() async {
    return await remoteDataSource.getMyPosts();
  }

  @override
  Future<Post> createPost({
    String? title,
    String? content,
    String? mediaFilePath,
    required PostMediaType mediaType,
  }) async {
    return await remoteDataSource.createPost(
      title: title,
      content: content,
      mediaFilePath: mediaFilePath,
      mediaType: mediaType,
    );
  }

  @override
  Future<Post> updatePost({
    required String postId,
    String? title,
    String? content,
  }) async {
    return await remoteDataSource.updatePost(
      postId: postId,
      title: title,
      content: content,
    );
  }

  @override
  Future<void> deletePost(String postId) async {
    await remoteDataSource.deletePost(postId);
  }

  @override
  Future<bool> toggleLikePost(String postId) async {
    return await remoteDataSource.toggleLike(postId);
  }

  @override
  Future<int> incrementShareCount(String postId) async {
    return await remoteDataSource.incrementShare(postId);
  }
}
