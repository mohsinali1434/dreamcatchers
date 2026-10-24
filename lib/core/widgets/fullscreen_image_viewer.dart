import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class FullscreenImageViewer extends StatelessWidget {
  final String imageUrl;
  final String? heroTag;
  const FullscreenImageViewer({
    super.key,
    required this.imageUrl,
    this.heroTag,
  });
  static void open(
    BuildContext context, {
    required String imageUrl,
    String? heroTag,
  }) {
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        barrierDismissible: true,
        pageBuilder: (context, animation, secondaryAnimation) =>
            FullscreenImageViewer(imageUrl: imageUrl, heroTag: heroTag),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget imageWidget = CachedNetworkImage(
      imageUrl: imageUrl,
      fit: BoxFit.contain,
      placeholder: (context, url) => const Center(
        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
      ),
      errorWidget: (context, url, error) => const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.broken_image, color: Colors.white70, size: 48),
            SizedBox(height: 8),
            Text(
              "Failed to load image",
              style: TextStyle(color: Colors.white70),
            ),
          ],
        ),
      ),
    );
    if (heroTag != null) {
      imageWidget = Hero(tag: heroTag!, child: imageWidget);
    }
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Center(
            child: InteractiveViewer(
              minScale: 0.8,
              maxScale: 4.0,
              clipBehavior: Clip.none,
              child: imageWidget,
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
        ],
      ),
    );
  }
}
