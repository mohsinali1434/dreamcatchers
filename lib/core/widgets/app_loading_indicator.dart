import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

class AppLoadingIndicator extends StatelessWidget {
  final double size;
  final Color color;
  const AppLoadingIndicator({
    super.key,
    this.size = 28.0,
    this.color = AppColors.primary,
  });
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: size,
        height: size,
        child: CircularProgressIndicator(
          strokeWidth: 2.8,
          valueColor: AlwaysStoppedAnimation<Color>(color),
        ),
      ),
    );
  }
}
