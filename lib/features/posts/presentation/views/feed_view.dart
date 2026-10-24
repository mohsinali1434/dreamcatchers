import 'package:dreamcatchers/core/utils/snackbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/widgets/app_loading_indicator.dart';
import '../../../auth/domain/entities/user_profile.dart';
import '../../../comments/presentation/views/comments_bottom_sheet.dart';
import '../bloc/feed/post_feed_bloc.dart';
import '../bloc/feed/post_feed_event.dart';
import '../bloc/feed/post_feed_state.dart';

import 'package:go_router/go_router.dart';

import '../../../../core/routing/app_router.dart';

import 'package:share_plus/share_plus.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'widgets/post_card_widget.dart';

class FeedView extends StatelessWidget {
  final UserProfile? userProfile;
  const FeedView({super.key, this.userProfile});
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<PostFeedBloc>()..add(const LoadFeed(isTrending: false)),
      child: _FeedViewBody(userProfile: userProfile),
    );
  }
}

class _FeedViewBody extends StatefulWidget {
  final UserProfile? userProfile;
  const _FeedViewBody({this.userProfile});
  @override
  State<_FeedViewBody> createState() => _FeedViewBodyState();
}

class _FeedViewBodyState extends State<_FeedViewBody> {
  final _scrollController = ScrollController();
  final ValueNotifier<bool> _isTrendingSelected = ValueNotifier<bool>(false);
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _isTrendingSelected.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<PostFeedBloc>().add(LoadMorePosts());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Home",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
      ),
      body: Column(
        children: [
          ValueListenableBuilder<bool>(
            valueListenable: _isTrendingSelected,
            builder: (context, isTrending, _) {
              return Container(
                color: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Row(
                  children: [
                    _buildTabChip(
                      label: "Latest",
                      icon: Icons.access_time_rounded,
                      isSelected: !isTrending,
                      onTap: () {
                        if (isTrending) {
                          _isTrendingSelected.value = false;
                          context.read<PostFeedBloc>().add(
                            const LoadFeed(isTrending: false),
                          );
                        }
                      },
                    ),
                    const SizedBox(width: 12),
                    _buildTabChip(
                      label: "Trending",
                      icon: Icons.local_fire_department_rounded,
                      isSelected: isTrending,
                      onTap: () {
                        if (!isTrending) {
                          _isTrendingSelected.value = true;
                          context.read<PostFeedBloc>().add(
                            const LoadFeed(isTrending: true),
                          );
                        }
                      },
                    ),
                  ],
                ),
              );
            },
          ),
          const Divider(height: 1, color: AppColors.border),
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: InkWell(
              onTap: () async {
                final created = await context.push<bool>(AppRoutes.createPost);
                if (!context.mounted) return;
                if (created == true) {
                  context.read<PostFeedBloc>().add(
                    LoadFeed(
                      isTrending: _isTrendingSelected.value,
                      isRefresh: true,
                    ),
                  );
                }
              },
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: AppColors.inputBackground,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  children: [
                    SvgPicture.asset('assets/add.svg', width: 22, height: 22),
                    const SizedBox(width: 10),
                    const Text(
                      "Write something...",
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: BlocConsumer<PostFeedBloc, PostFeedState>(
              listener: (context, state) {
                if (state.status == FeedStatus.error &&
                    state.errorMessage != null) {
                  SnackbarHelper.showError(context, state.errorMessage!);
                }
              },
              builder: (context, state) {
                if (state.status == FeedStatus.loading ||
                    state.status == FeedStatus.initial) {
                  return const Center(child: AppLoadingIndicator());
                }
                if (state.posts.isEmpty) {
                  return RefreshIndicator(
                    onRefresh: () async {
                      context.read<PostFeedBloc>().add(
                        LoadFeed(
                          isTrending: _isTrendingSelected.value,
                          isRefresh: true,
                        ),
                      );
                    },
                    child: ListView(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.45,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.article_outlined,
                                  size: 56,
                                  color: AppColors.textMuted,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  _isTrendingSelected.value
                                      ? "No trending posts yet"
                                      : "No posts found",
                                  style: AppTextStyles.heading3.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  "Be the first to share something!",
                                  style: AppTextStyles.caption,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return RefreshIndicator(
                  color: AppColors.primary,
                  onRefresh: () async {
                    context.read<PostFeedBloc>().add(
                      LoadFeed(
                        isTrending: _isTrendingSelected.value,
                        isRefresh: true,
                      ),
                    );
                  },
                  child: ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount:
                        state.posts.length +
                        (state.status == FeedStatus.loadingMore ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index >= state.posts.length) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: Center(
                            child: SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          ),
                        );
                      }
                      final post = state.posts[index];
                      return PostCardWidget(
                        post: post,
                        onLike: () {
                          context.read<PostFeedBloc>().add(
                            TogglePostLike(post.id),
                          );
                        },
                        onComment: () {
                          CommentsBottomSheet.show(context, post.id);
                        },
                        onShare: () {
                          context.read<PostFeedBloc>().add(
                            SharePostRequested(post.id),
                          );
                          final shareText =
                              post.content != null && post.content!.isNotEmpty
                              ? post.content!
                              : (post.mediaUrl ??
                                    "Check out this post on Dreamcatchers!");
                          SharePlus.instance.share(
                            ShareParams(
                              text: shareText,
                              subject:
                                  'Dreamcatchers Post by @${post.authorUsername ?? "user"}',
                            ),
                          );
                        },
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabChip({
    required String label,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.inputBackground,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: isSelected ? Colors.white : AppColors.textSecondary,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : AppColors.textSecondary,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
