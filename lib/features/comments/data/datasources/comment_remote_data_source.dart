import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/comment_model.dart';

List<CommentModel> _parseCommentsList(List<dynamic> list) {
  return list
      .map((item) => CommentModel.fromJson(item as Map<String, dynamic>))
      .toList();
}

abstract class CommentRemoteDataSource {
  Future<List<CommentModel>> getComments({
    required String postId,
    required int offset,
    required int limit,
  });
  Future<CommentModel> insertComment({
    required String postId,
    required String content,
  });
}

class CommentRemoteDataSourceImpl implements CommentRemoteDataSource {
  final SupabaseClient supabaseClient;
  CommentRemoteDataSourceImpl({required this.supabaseClient});
  String? get currentUserId => supabaseClient.auth.currentUser?.id;
  @override
  Future<List<CommentModel>> getComments({
    required String postId,
    required int offset,
    required int limit,
  }) async {
    final response = await supabaseClient
        .from('comments')
        .select('*, profiles(username, avatar_url, personality_type)')
        .eq('post_id', postId)
        .order('created_at', ascending: true)
        .range(offset, offset + limit - 1);
    final List list = response as List;
    return await compute(_parseCommentsList, list);
  }

  @override
  Future<CommentModel> insertComment({
    required String postId,
    required String content,
  }) async {
    final userId = currentUserId;
    if (userId == null) throw Exception('Not authenticated');
    final response = await supabaseClient
        .from('comments')
        .insert({
          'post_id': postId,
          'user_id': userId,
          'content': content.trim(),
        })
        .select('*, profiles(username, avatar_url, personality_type)')
        .single();
    return CommentModel.fromJson(response);
  }
}
