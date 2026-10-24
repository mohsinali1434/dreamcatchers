import 'dart:io';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../constants/app_colors.dart';

enum VideoThumbnailStatus { loading, ready, error }

class VideoThumbnailWidget extends StatefulWidget {
  final String videoUrl;
  final bool isFile;
  final double height;
  final double? width;
  final BoxFit fit;
  const VideoThumbnailWidget({
    super.key,
    required this.videoUrl,
    this.isFile = false,
    this.height = 200,
    this.width = double.infinity,
    this.fit = BoxFit.cover,
  });
  @override
  State<VideoThumbnailWidget> createState() => _VideoThumbnailWidgetState();
}

class _VideoThumbnailWidgetState extends State<VideoThumbnailWidget>
    with AutomaticKeepAliveClientMixin<VideoThumbnailWidget> {
  VideoPlayerController? _controller;
  final ValueNotifier<VideoThumbnailStatus> _status =
      ValueNotifier<VideoThumbnailStatus>(VideoThumbnailStatus.loading);
  @override
  bool get wantKeepAlive => true;
  @override
  void initState() {
    super.initState();
    _initThumbnail();
  }

  @override
  void didUpdateWidget(covariant VideoThumbnailWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.videoUrl != widget.videoUrl ||
        oldWidget.isFile != widget.isFile) {
      _controller?.dispose();
      _controller = null;
      _status.value = VideoThumbnailStatus.loading;
      _initThumbnail();
    }
  }

  Future<void> _initThumbnail() async {
    try {
      final controller = widget.isFile
          ? VideoPlayerController.file(File(widget.videoUrl))
          : VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl));
      _controller = controller;
      await controller.initialize();
      await controller.setVolume(0.0);
      await controller.pause();
      _status.value = VideoThumbnailStatus.ready;
    } catch (_) {
      _status.value = VideoThumbnailStatus.error;
    }
  }

  @override
  void dispose() {
    _status.dispose();
    _controller?.dispose();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      width: widget.width,
      height: widget.height,
      color: Colors.black,
      child: Stack(
        fit: StackFit.expand,
        alignment: Alignment.center,
        children: [
          ValueListenableBuilder<VideoThumbnailStatus>(
            valueListenable: _status,
            builder: (context, status, _) {
              switch (status) {
                case VideoThumbnailStatus.ready:
                  if (_controller == null) return const SizedBox.shrink();
                  return FittedBox(
                    fit: widget.fit,
                    clipBehavior: Clip.hardEdge,
                    child: SizedBox(
                      width: _controller!.value.size.width,
                      height: _controller!.value.size.height,
                      child: VideoPlayer(_controller!),
                    ),
                  );
                case VideoThumbnailStatus.error:
                  return Container(
                    color: Colors.black87,
                    child: const Center(
                      child: Icon(
                        Icons.videocam_off_rounded,
                        color: Colors.white54,
                        size: 36,
                      ),
                    ),
                  );
                case VideoThumbnailStatus.loading:
                  return Container(
                    color: AppColors.inputBackground,
                    child: const Center(
                      child: SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    ),
                  );
              }
            },
          ),
          Container(color: Colors.black.withValues(alpha: 0.25)),
          Center(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.55),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.play_arrow_rounded,
                size: 36,
                color: Colors.white,
              ),
            ),
          ),
          Positioned(
            bottom: 8,
            right: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.65),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.videocam, color: Colors.white, size: 13),
                  const SizedBox(width: 4),
                  ValueListenableBuilder<VideoThumbnailStatus>(
                    valueListenable: _status,
                    builder: (context, status, _) {
                      final hasDuration =
                          status == VideoThumbnailStatus.ready &&
                          _controller != null;
                      return Text(
                        hasDuration
                            ? _formatDuration(_controller!.value.duration)
                            : "Video",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
