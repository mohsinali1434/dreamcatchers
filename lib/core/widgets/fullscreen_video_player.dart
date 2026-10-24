import 'dart:io';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

enum VideoPlayerStatus { loading, ready, error }

class FullscreenVideoPlayer extends StatefulWidget {
  final String videoUrl;
  final bool isFile;
  const FullscreenVideoPlayer({
    super.key,
    required this.videoUrl,
    this.isFile = false,
  });
  static void open(
    BuildContext context, {
    required String videoUrl,
    bool isFile = false,
  }) {
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        barrierDismissible: true,
        pageBuilder: (context, animation, secondaryAnimation) =>
            FullscreenVideoPlayer(videoUrl: videoUrl, isFile: isFile),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  @override
  State<FullscreenVideoPlayer> createState() => _FullscreenVideoPlayerState();
}

class _FullscreenVideoPlayerState extends State<FullscreenVideoPlayer> {
  late VideoPlayerController _controller;
  final ValueNotifier<VideoPlayerStatus> _playerStatus =
      ValueNotifier<VideoPlayerStatus>(VideoPlayerStatus.loading);
  final ValueNotifier<bool> _showControls = ValueNotifier<bool>(true);
  @override
  void initState() {
    super.initState();
    _initVideo();
  }

  Future<void> _initVideo() async {
    try {
      if (widget.isFile) {
        _controller = VideoPlayerController.file(File(widget.videoUrl));
      } else {
        _controller = VideoPlayerController.networkUrl(
          Uri.parse(widget.videoUrl),
        );
      }
      await _controller.initialize();
      _controller.setLooping(true);
      await _controller.play();
      _playerStatus.value = VideoPlayerStatus.ready;
    } catch (_) {
      _playerStatus.value = VideoPlayerStatus.error;
    }
  }

  @override
  void dispose() {
    _showControls.dispose();
    _playerStatus.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _togglePlayPause() {
    if (_playerStatus.value != VideoPlayerStatus.ready) return;
    if (_controller.value.isPlaying) {
      _controller.pause();
    } else {
      _controller.play();
    }
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          _showControls.value = !_showControls.value;
        },
        child: Stack(
          alignment: Alignment.center,
          children: [
            ValueListenableBuilder<VideoPlayerStatus>(
              valueListenable: _playerStatus,
              builder: (context, status, _) {
                switch (status) {
                  case VideoPlayerStatus.error:
                    return const Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.error_outline_rounded,
                            color: Colors.white70,
                            size: 48,
                          ),
                          SizedBox(height: 8),
                          Text(
                            "Unable to play video",
                            style: TextStyle(color: Colors.white70),
                          ),
                        ],
                      ),
                    );
                  case VideoPlayerStatus.ready:
                    return Center(
                      child: AspectRatio(
                        aspectRatio: _controller.value.aspectRatio,
                        child: VideoPlayer(_controller),
                      ),
                    );
                  case VideoPlayerStatus.loading:
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    );
                }
              },
            ),
            ValueListenableBuilder<bool>(
              valueListenable: _showControls,
              builder: (context, show, child) {
                return AnimatedOpacity(
                  opacity: show ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 200),
                  child: IgnorePointer(
                    ignoring: !show,
                    child: Stack(
                      children: [
                        SafeArea(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.black.withValues(alpha: 0.5),
                                  shape: BoxShape.circle,
                                ),
                                child: IconButton(
                                  icon: const Icon(
                                    Icons.close_rounded,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                  onPressed: () => Navigator.of(context).pop(),
                                ),
                              ),
                            ),
                          ),
                        ),
                        ValueListenableBuilder<VideoPlayerStatus>(
                          valueListenable: _playerStatus,
                          builder: (context, status, _) {
                            if (status != VideoPlayerStatus.ready) {
                              return const SizedBox.shrink();
                            }
                            return ValueListenableBuilder<VideoPlayerValue>(
                              valueListenable: _controller,
                              builder: (context, val, _) {
                                return Center(
                                  child: GestureDetector(
                                    onTap: _togglePlayPause,
                                    child: Container(
                                      padding: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        color: Colors.black.withValues(
                                          alpha: 0.5,
                                        ),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        val.isPlaying
                                            ? Icons.pause_rounded
                                            : Icons.play_arrow_rounded,
                                        color: Colors.white,
                                        size: 48,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                        ValueListenableBuilder<VideoPlayerStatus>(
                          valueListenable: _playerStatus,
                          builder: (context, status, _) {
                            if (status != VideoPlayerStatus.ready) {
                              return const SizedBox.shrink();
                            }
                            return Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: SafeArea(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.bottomCenter,
                                      end: Alignment.topCenter,
                                      colors: [
                                        Colors.black.withValues(alpha: 0.8),
                                        Colors.transparent,
                                      ],
                                    ),
                                  ),
                                  child: ValueListenableBuilder<VideoPlayerValue>(
                                    valueListenable: _controller,
                                    builder:
                                        (context, VideoPlayerValue value, _) {
                                          return Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              VideoProgressIndicator(
                                                _controller,
                                                allowScrubbing: true,
                                                colors:
                                                    const VideoProgressColors(
                                                      playedColor: Colors.white,
                                                      bufferedColor:
                                                          Colors.white24,
                                                      backgroundColor:
                                                          Colors.white10,
                                                    ),
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      vertical: 8,
                                                    ),
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    _formatDuration(
                                                      value.position,
                                                    ),
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                  Text(
                                                    _formatDuration(
                                                      value.duration,
                                                    ),
                                                    style: const TextStyle(
                                                      color: Colors.white70,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          );
                                        },
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
