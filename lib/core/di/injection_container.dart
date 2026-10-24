import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../features/auth/data/datasources/auth_remote_data_source.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/onboarding/presentation/bloc/onboarding_bloc.dart';
import '../../features/posts/data/datasources/post_remote_data_source.dart';
import '../../features/posts/data/repositories/post_repository_impl.dart';
import '../../features/posts/domain/repositories/post_repository.dart';
import '../../features/posts/presentation/bloc/create_post/create_post_bloc.dart';
import '../../features/posts/presentation/bloc/feed/post_feed_bloc.dart';
import '../../features/comments/data/datasources/comment_remote_data_source.dart';
import '../../features/comments/data/repositories/comment_repository_impl.dart';
import '../../features/comments/domain/repositories/comment_repository.dart';
import '../../features/comments/presentation/bloc/comment_bloc.dart';

final sl = GetIt.instance;
Future<void> initDependencies() async {
  sl.registerLazySingleton<SupabaseClient>(() => Supabase.instance.client);
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(supabaseClient: sl()),
  );
  sl.registerLazySingleton<PostRemoteDataSource>(
    () => PostRemoteDataSourceImpl(supabaseClient: sl()),
  );
  sl.registerLazySingleton<CommentRemoteDataSource>(
    () => CommentRemoteDataSourceImpl(supabaseClient: sl()),
  );
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<PostRepository>(
    () => PostRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<CommentRepository>(
    () => CommentRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerFactory(() => AuthBloc(authRepository: sl()));
  sl.registerFactory(() => OnboardingBloc(authRepository: sl()));
  sl.registerFactory(() => PostFeedBloc(postRepository: sl()));
  sl.registerFactory(() => CreatePostBloc(postRepository: sl()));
  sl.registerFactory(() => CommentBloc(commentRepository: sl()));
}
