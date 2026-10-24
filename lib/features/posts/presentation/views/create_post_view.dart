import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/utils/snackbar_helper.dart';
import '../../../../core/widgets/fullscreen_video_player.dart';
import '../../../../core/widgets/video_thumbnail_widget.dart';
import '../../domain/entities/post.dart';
import '../bloc/create_post/create_post_bloc.dart';
import '../bloc/create_post/create_post_event.dart';
import '../bloc/create_post/create_post_state.dart';

class CreatePostView extends StatelessWidget {
  const CreatePostView({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<CreatePostBloc>(),
      child: const _CreatePostViewBody(),
    );
  }
}

class _CreatePostViewBody extends StatefulWidget {
  const _CreatePostViewBody();
  @override
  State<_CreatePostViewBody> createState() => _CreatePostViewBodyState();
}

class _CreatePostViewBodyState extends State<_CreatePostViewBody> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _imagePicker = ImagePicker();
  final ValueNotifier<bool> _hasTextContent = ValueNotifier<bool>(false);
  @override
  void initState() {
    super.initState();
    _titleController.addListener(_updateContentStatus);
    _contentController.addListener(_updateContentStatus);
  }

  void _updateContentStatus() {
    final hasText =
        _titleController.text.trim().isNotEmpty ||
        _contentController.text.trim().isNotEmpty;
    if (_hasTextContent.value != hasText) {
      _hasTextContent.value = hasText;
    }
  }

  @override
  void dispose() {
    _titleController.removeListener(_updateContentStatus);
    _contentController.removeListener(_updateContentStatus);
    _titleController.dispose();
    _contentController.dispose();
    _hasTextContent.dispose();
    super.dispose();
  }

  bool _hasUnsavedChanges(CreatePostState state) {
    final hasText =
        _titleController.text.trim().isNotEmpty ||
        _contentController.text.trim().isNotEmpty;
    final hasMedia =
        state.mediaPath != null && state.mediaType != PostMediaType.none;
    return hasText || hasMedia;
  }

  Future<bool> _showDiscardConfirmationDialog(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          AppStrings.discardPostTitle,
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 18,
            color: AppColors.textPrimary,
          ),
        ),
        content: const Text(
          AppStrings.discardPostMessage,
          style: TextStyle(
            fontSize: 14,
            color: AppColors.textSecondary,
            height: 1.4,
          ),
        ),
        actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx, false),
            child: const Text(
              AppStrings.keepEditing,
              style: TextStyle(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () => Navigator.pop(dialogCtx, true),
            child: const Text(
              AppStrings.discard,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  void _handleBackNavigation(
    BuildContext context,
    CreatePostState state,
  ) async {
    if (_hasUnsavedChanges(state)) {
      final shouldDiscard = await _showDiscardConfirmationDialog(context);
      if (shouldDiscard && context.mounted) {
        context.pop();
      }
    } else {
      context.pop();
    }
  }

  Future<void> _pickImage() async {
    final XFile? image = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (image != null && mounted) {
      context.read<CreatePostBloc>().add(
        MediaSelected(filePath: image.path, mediaType: PostMediaType.image),
      );
    }
  }

  Future<void> _pickVideo() async {
    final XFile? video = await _imagePicker.pickVideo(
      source: ImageSource.gallery,
      maxDuration: const Duration(minutes: 3),
    );
    if (video != null && mounted) {
      context.read<CreatePostBloc>().add(
        MediaSelected(filePath: video.path, mediaType: PostMediaType.video),
      );
    }
  }

  void _showMediaPickerOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(
                  Icons.photo_library_outlined,
                  color: AppColors.primary,
                ),
                title: const Text(
                  AppStrings.uploadPhoto,
                  style: AppTextStyles.bodyMedium,
                ),
                onTap: () {
                  Navigator.pop(ctx);
                  _pickImage();
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.videocam_outlined,
                  color: AppColors.primary,
                ),
                title: const Text(
                  AppStrings.uploadVideo,
                  style: AppTextStyles.bodyMedium,
                ),
                onTap: () {
                  Navigator.pop(ctx);
                  _pickVideo();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _submit() {
    context.read<CreatePostBloc>().add(
      CreatePostSubmitted(
        title: _titleController.text,
        content: _contentController.text,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CreatePostBloc, CreatePostState>(
      listener: (context, state) {
        if (state.status == CreatePostStatus.success) {
          SnackbarHelper.showSuccess(context, AppStrings.postCreatedSuccess);
          context.pop(true);
        } else if (state.status == CreatePostStatus.error) {
          SnackbarHelper.showError(
            context,
            state.errorMessage ?? AppStrings.postPublishFailed,
          );
        }
      },
      builder: (context, state) {
        final isSubmitting = state.status == CreatePostStatus.submitting;
        return PopScope(
          canPop: !_hasUnsavedChanges(state) && !isSubmitting,
          onPopInvokedWithResult: (didPop, result) async {
            if (didPop) return;
            if (isSubmitting) return;
            final shouldDiscard = await _showDiscardConfirmationDialog(context);
            if (shouldDiscard && context.mounted) {
              Navigator.of(context).pop();
            }
          },
          child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                backgroundColor: Colors.white,
                elevation: 0,
                leading: IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios_new,
                    color: AppColors.textPrimary,
                    size: 20,
                  ),
                  onPressed: isSubmitting
                      ? null
                      : () => _handleBackNavigation(context, state),
                ),
                title: const Text(
                  AppStrings.createAPost,
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                centerTitle: true,
                bottom: const PreferredSize(
                  preferredSize: Size.fromHeight(1),
                  child: Divider(height: 1, color: AppColors.border),
                ),
              ),
              body: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextField(
                                controller: _titleController,
                                style: AppTextStyles.body.copyWith(
                                  color: AppColors.textPrimary,
                                  fontWeight: FontWeight.w500,
                                ),
                                decoration: InputDecoration(
                                  hintText: "Title",
                                  hintStyle: AppTextStyles.body.copyWith(
                                    color: AppColors.textPrimary,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(
                                      color: AppColors.border,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(
                                      color: AppColors.border,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(
                                      color: AppColors.primary,
                                    ),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 16,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              TextField(
                                controller: _contentController,
                                style: AppTextStyles.body.copyWith(
                                  color: AppColors.textPrimary,
                                ),
                                maxLines: 7,
                                decoration: InputDecoration(
                                  hintText: "Description...",
                                  hintStyle: AppTextStyles.body.copyWith(
                                    color: AppColors.textPrimary,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(
                                      color: AppColors.border,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(
                                      color: AppColors.border,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(
                                      color: AppColors.primary,
                                    ),
                                  ),
                                  contentPadding: const EdgeInsets.all(16),
                                ),
                              ),
                              const SizedBox(height: 20),
                              if (state.mediaPath != null) ...[
                                Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child:
                                          state.mediaType == PostMediaType.image
                                          ? Image.file(
                                              File(state.mediaPath!),
                                              height: 200,
                                              width: double.infinity,
                                              fit: BoxFit.cover,
                                            )
                                          : GestureDetector(
                                              onTap: () {
                                                FullscreenVideoPlayer.open(
                                                  context,
                                                  videoUrl: state.mediaPath!,
                                                  isFile: true,
                                                );
                                              },
                                              child: VideoThumbnailWidget(
                                                videoUrl: state.mediaPath!,
                                                isFile: true,
                                                height: 200,
                                              ),
                                            ),
                                    ),
                                    Positioned(
                                      top: 8,
                                      right: 8,
                                      child: GestureDetector(
                                        onTap: () {
                                          context.read<CreatePostBloc>().add(
                                            MediaRemoved(),
                                          );
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.all(4),
                                          decoration: const BoxDecoration(
                                            color: Colors.black54,
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(
                                            Icons.close,
                                            color: Colors.white,
                                            size: 18,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                              ],
                              InkWell(
                                onTap: _showMediaPickerOptions,
                                borderRadius: BorderRadius.circular(12),
                                child: CustomPaint(
                                  painter: _DashedRRectPainter(
                                    color: AppColors.primary,
                                    strokeWidth: 1.2,
                                    dashPattern: const [6, 4],
                                    radius: const Radius.circular(12),
                                  ),
                                  child: Container(
                                    width: double.infinity,
                                    height: 52,
                                    alignment: Alignment.center,
                                    child: const Text(
                                      "+ Add photos and videos",
                                      style: TextStyle(
                                        color: AppColors.primary,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 16, bottom: 8),
                        child: ValueListenableBuilder<bool>(
                          valueListenable: _hasTextContent,
                          builder: (context, hasText, _) {
                            final hasMedia =
                                state.mediaPath != null &&
                                state.mediaType != PostMediaType.none;
                            final canPost =
                                (hasText || hasMedia) && !isSubmitting;
                            return SizedBox(
                              width: double.infinity,
                              height: 52,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: canPost
                                      ? AppColors.primary
                                      : const Color(0xFFE2E8F0),
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                onPressed: canPost ? _submit : null,
                                child: isSubmitting
                                    ? const Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            width: 20,
                                            height: 20,
                                            child: CircularProgressIndicator(
                                              color: Colors.white,
                                              strokeWidth: 2,
                                            ),
                                          ),
                                          SizedBox(width: 12),
                                          Text(
                                            AppStrings.uploadingPost,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      )
                                    : Text(
                                        AppStrings.post,
                                        style: TextStyle(
                                          color: canPost
                                              ? Colors.white
                                              : AppColors.textMuted,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _DashedRRectPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final List<double> dashPattern;
  final Radius radius;
  _DashedRRectPainter({
    required this.color,
    required this.strokeWidth,
    required this.dashPattern,
    required this.radius,
  });
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;
    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      radius,
    );
    final path = Path()..addRRect(rrect);
    final dashedPath = _createDashedPath(path, dashPattern);
    canvas.drawPath(dashedPath, paint);
  }

  Path _createDashedPath(Path source, List<double> pattern) {
    final dest = Path();
    for (final metric in source.computeMetrics()) {
      double distance = 0.0;
      int patternIndex = 0;
      bool draw = true;
      while (distance < metric.length) {
        final length = pattern[patternIndex % pattern.length];
        if (draw) {
          dest.addPath(
            metric.extractPath(distance, distance + length),
            Offset.zero,
          );
        }
        distance += length;
        draw = !draw;
        patternIndex++;
      }
    }
    return dest;
  }

  @override
  bool shouldRepaint(covariant _DashedRRectPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.radius != radius;
  }
}
