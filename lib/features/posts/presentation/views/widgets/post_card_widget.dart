import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:dreamcatchers/core/utils/app_helpers.dart';
import 'package:dreamcatchers/core/constants/app_colors.dart';
import 'package:dreamcatchers/core/constants/app_text_styles.dart';
import 'package:dreamcatchers/core/widgets/fullscreen_image_viewer.dart';
import 'package:dreamcatchers/core/widgets/fullscreen_video_player.dart';
import 'package:dreamcatchers/core/widgets/video_thumbnail_widget.dart';

import '../../../domain/entities/post.dart';

class PostCardWidget extends StatelessWidget {
  final Post post;
  final VoidCallback onLike;
  final VoidCallback onComment;
  final VoidCallback onShare;
  final VoidCallback? onAuthorTap;
  const PostCardWidget({
    super.key,
    required this.post,
    required this.onLike,
    required this.onComment,
    required this.onShare,
    this.onAuthorTap,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: AppColors.border.withValues(alpha: 0.6)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: onAuthorTap,
                child: CircleAvatar(
                  radius: 20,
                  backgroundColor: AppColors.primaryLight,
                  backgroundImage: post.authorAvatarUrl != null
                      ? CachedNetworkImageProvider(post.authorAvatarUrl!)
                      : null,
                  child: post.authorAvatarUrl == null
                      ? Text(
                          (post.authorUsername?.isNotEmpty ?? false)
                              ? post.authorUsername![0].toUpperCase()
                              : "U",
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w700,
                          ),
                        )
                      : null,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: GestureDetector(
                  onTap: onAuthorTap,
                  child: Row(
                    children: [
                      Flexible(
                        child: Text(
                          post.authorUsername ?? "Anonymous",
                          style: AppTextStyles.bodyMedium.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text("•", style: AppTextStyles.caption),
                      const SizedBox(width: 4),
                      Text(
                        AppHelpers.formatTimeAgo(post.createdAt),
                        style: AppTextStyles.caption,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          if (post.title != null && post.title!.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              post.title!,
              style: AppTextStyles.heading3.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
          if (post.content != null && post.content!.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              post.content!,
              style: AppTextStyles.body.copyWith(
                color: AppColors.textPrimary,
                height: 1.45,
              ),
            ),
          ],
          if (post.mediaUrl != null &&
              post.mediaType != PostMediaType.none) ...[
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: post.mediaType == PostMediaType.image
                  ? GestureDetector(
                      onTap: () {
                        FullscreenImageViewer.open(
                          context,
                          imageUrl: post.mediaUrl!,
                          heroTag: 'post-image-${post.id}',
                        );
                      },
                      child: Hero(
                        tag: 'post-image-${post.id}',
                        child: CachedNetworkImage(
                          imageUrl: post.mediaUrl!,
                          width: double.infinity,
                          height: 220,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            height: 220,
                            color: AppColors.inputBackground,
                            child: const Center(
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          ),
                          errorWidget: (context, url, error) => Container(
                            height: 220,
                            color: AppColors.inputBackground,
                            child: const Icon(
                              Icons.broken_image,
                              color: AppColors.textMuted,
                            ),
                          ),
                        ),
                      ),
                    )
                  : GestureDetector(
                      onTap: () {
                        FullscreenVideoPlayer.open(
                          context,
                          videoUrl: post.mediaUrl!,
                        );
                      },
                      child: VideoThumbnailWidget(
                        videoUrl: post.mediaUrl!,
                        height: 220,
                      ),
                    ),
            ),
          ],
          const SizedBox(height: 16),
          const Divider(height: 1, color: AppColors.border),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _AnimatedLikeButton(
                isLiked: post.isLikedByMe,
                likesCount: post.likesCount,
                onLike: onLike,
              ),
              InkWell(
                onTap: onComment,
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 6,
                  ),
                  child: Row(
                    children: [
                      _actionIcon(
                        'assets/message-text.svg',
                        AppColors.textSecondary,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        '${post.commentsCount}',
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w500,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: onShare,
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 6,
                  ),
                  child: Row(
                    children: [
                      _actionIcon('assets/export.svg', AppColors.textSecondary),
                      const SizedBox(width: 5),
                      Text(
                        '${post.sharesCount}',
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w500,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _actionIcon(String asset, Color color) {
    return SvgPicture.asset(
      asset,
      width: 19,
      height: 19,
      colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
    );
  }
}

class _AnimatedLikeButton extends StatefulWidget {
  final bool isLiked;
  final int likesCount;
  final VoidCallback onLike;
  const _AnimatedLikeButton({
    required this.isLiked,
    required this.likesCount,
    required this.onLike,
  });
  @override
  State<_AnimatedLikeButton> createState() => _AnimatedLikeButtonState();
}

class _AnimatedLikeButtonState extends State<_AnimatedLikeButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.3), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 1.3, end: 1.0), weight: 50),
    ]).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void didUpdateWidget(covariant _AnimatedLikeButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!oldWidget.isLiked && widget.isLiked) {
      _controller.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (!widget.isLiked) {
          _controller.forward(from: 0.0);
        }
        widget.onLike();
      },
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
        child: Row(
          children: [
            ScaleTransition(
              scale: _scaleAnimation,
              child: SvgPicture.asset(
                'assets/like.svg',
                width: 19,
                height: 19,
                colorFilter: ColorFilter.mode(
                  widget.isLiked ? AppColors.primary : AppColors.textSecondary,
                  BlendMode.srcIn,
                ),
              ),
            ),
            const SizedBox(width: 5),
            Text(
              '${widget.likesCount}',
              style: TextStyle(
                color: widget.isLiked
                    ? AppColors.primary
                    : AppColors.textSecondary,
                fontWeight: widget.isLiked ? FontWeight.w700 : FontWeight.w500,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
