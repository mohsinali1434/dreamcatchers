import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/config/supabase_config.dart';
import '../../domain/entities/post.dart';
import '../models/post_model.dart';

List<PostModel> _parsePostsList(List<dynamic> list) {
  return list
      .map((item) => PostModel.fromJson(item as Map<String, dynamic>))
      .toList();
}

abstract class PostRemoteDataSource {
  Future<List<PostModel>> getPostsFeed({
    required int offset,
    required int limit,
  });
  Future<List<PostModel>> getTrendingPosts({
    required int offset,
    required int limit,
  });
  Future<List<PostModel>> getMyPosts();
  Future<PostModel> createPost({
    String? title,
    String? content,
    String? mediaFilePath,
    required PostMediaType mediaType,
  });
  Future<PostModel> updatePost({
    required String postId,
    String? title,
    String? content,
  });
  Future<void> deletePost(String postId);
  Future<bool> toggleLike(String postId);
  Future<int> incrementShare(String postId);
}

class PostRemoteDataSourceImpl implements PostRemoteDataSource {
  final SupabaseClient supabaseClient;
  PostRemoteDataSourceImpl({required this.supabaseClient});
  String? get currentUserId => supabaseClient.auth.currentUser?.id;
  @override
  Future<List<PostModel>> getPostsFeed({
    required int offset,
    required int limit,
  }) async {
    try {
      final response = await supabaseClient.rpc(
        'get_posts_feed',
        params: {
          'page_offset': offset,
          'page_limit': limit,
          'requesting_user_id': currentUserId,
        },
      );
      final List list = response as List;
      return await compute(_parsePostsList, list);
    } catch (e) {
      var query = supabaseClient
          .from('posts')
          .select(
            '*, profiles!posts_user_id_fkey(username, avatar_url, personality_type, gender, birthday, highest_education_level)',
          );
      final res = await query
          .order('created_at', ascending: false)
          .range(offset, offset + limit - 1);
      final List list = res as List;
      return await compute(_parsePostsList, list);
    }
  }

  @override
  Future<List<PostModel>> getTrendingPosts({
    required int offset,
    required int limit,
  }) async {
    try {
      final response = await supabaseClient.rpc(
        'get_trending_posts',
        params: {
          'page_offset': offset,
          'page_limit': limit,
          'requesting_user_id': currentUserId,
        },
      );
      final List list = response as List;
      return await compute(_parsePostsList, list);
    } catch (e) {
      return getPostsFeed(offset: offset, limit: limit);
    }
  }

  @override
  Future<List<PostModel>> getMyPosts() async {
    final userId = currentUserId;
    if (userId == null) return [];
    final response = await supabaseClient
        .from('posts')
        .select(
          '*, profiles!posts_user_id_fkey(username, avatar_url, personality_type, gender, birthday, highest_education_level)',
        )
        .eq('user_id', userId)
        .order('created_at', ascending: false);
    final List list = response as List;
    return await compute(_parsePostsList, list);
  }

  @override
  Future<PostModel> createPost({
    String? title,
    String? content,
    String? mediaFilePath,
    required PostMediaType mediaType,
  }) async {
    final userId = currentUserId;
    if (userId == null) throw Exception('User is not authenticated');
    String? uploadedMediaUrl;
    if (mediaFilePath != null && mediaType != PostMediaType.none) {
      final file = File(mediaFilePath);
      final extension = mediaFilePath.split('.').last;
      final fileName = '${userId}_${const Uuid().v4()}.$extension';
      await supabaseClient.storage
          .from(SupabaseConfig.postMediaBucket)
          .upload(fileName, file);
      uploadedMediaUrl = supabaseClient.storage
          .from(SupabaseConfig.postMediaBucket)
          .getPublicUrl(fileName);
    }
    String mediaTypeString = 'none';
    if (mediaType == PostMediaType.image) mediaTypeString = 'image';
    if (mediaType == PostMediaType.video) mediaTypeString = 'video';
    final insertData = {
      'user_id': userId,
      'title': title?.trim(),
      'content': content?.trim(),
      'media_url': uploadedMediaUrl,
      'media_type': mediaTypeString,
    };
    final response = await supabaseClient
        .from('posts')
        .insert(insertData)
        .select(
          '*, profiles!posts_user_id_fkey(username, avatar_url, personality_type, gender, birthday, highest_education_level)',
        )
        .single();
    return PostModel.fromJson(response);
  }

  @override
  Future<PostModel> updatePost({
    required String postId,
    String? title,
    String? content,
  }) async {
    final response = await supabaseClient
        .from('posts')
        .update({
          if (title != null) 'title': title.trim(),
          if (content != null) 'content': content.trim(),
        })
        .eq('id', postId)
        .select(
          '*, profiles!posts_user_id_fkey(username, avatar_url, personality_type, gender, birthday, highest_education_level)',
        )
        .single();
    return PostModel.fromJson(response);
  }

  @override
  Future<void> deletePost(String postId) async {
    await supabaseClient.from('posts').delete().eq('id', postId);
  }

  @override
  Future<bool> toggleLike(String postId) async {
    final userId = currentUserId;
    if (userId == null) throw Exception('Not authenticated');
    final existing = await supabaseClient
        .from('post_likes')
        .select()
        .eq('post_id', postId)
        .eq('user_id', userId)
        .maybeSingle();
    if (existing != null) {
      await supabaseClient
          .from('post_likes')
          .delete()
          .eq('post_id', postId)
          .eq('user_id', userId);
      return false;
    } else {
      await supabaseClient.from('post_likes').insert({
        'post_id': postId,
        'user_id': userId,
      });
      return true;
    }
  }

  @override
  Future<int> incrementShare(String postId) async {
    final response = await supabaseClient.rpc(
      'increment_share_count',
      params: {'target_post_id': postId},
    );
    return (response as num).toInt();
  }
}
