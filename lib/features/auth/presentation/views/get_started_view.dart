import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/routing/app_router.dart';
import '../../../../core/widgets/custom_button.dart';

class GetStartedView extends StatelessWidget {
  const GetStartedView({super.key});
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            ClipPath(
              clipper: ArchClipper(),
              child: Container(
                width: double.infinity,
                height: size.height * 0.55,
                decoration: const BoxDecoration(
                  gradient: AppColors.splashGradient,
                ),
                child: Center(
                  child: Image.asset(
                    'assets/logo.png',
                    width: 220,
                    fit: BoxFit.contain,
                    color: Colors.white,
                    colorBlendMode: BlendMode.srcIn,
                    errorBuilder: (context, error, stackTrace) => RichText(
                      textAlign: TextAlign.center,
                      text: const TextSpan(
                        children: [
                          TextSpan(
                            text: "Ask\n",
                            style: TextStyle(
                              fontSize: 48,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                              letterSpacing: -1,
                              height: 0.88,
                            ),
                          ),
                          TextSpan(
                            text: "Asap",
                            style: TextStyle(
                              fontSize: 48,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                              letterSpacing: -1,
                              height: 0.88,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const Spacer(),
            Text(
              "Anytime, Anywhere, Anyone",
              style: AppTextStyles.heading2.copyWith(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: CustomButton(
                text: "Sign up",
                onPressed: () => context.push(AppRoutes.signUp),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Already joined? ",
                  style: AppTextStyles.bodySecondary.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
                GestureDetector(
                  onTap: () => context.push(AppRoutes.signIn),
                  child: Text(
                    "Sign in",
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              child: Text(
                "Tapping “Sign up” Or “Sign in” means you understand and accept Ask Asap's Privacy Policy and Terms of Service.",
                textAlign: TextAlign.center,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.4,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ArchClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 60);
    final firstControlPoint = Offset(size.width / 2, size.height + 40);
    final firstEndPoint = Offset(size.width, size.height - 60);
    path.quadraticBezierTo(
      firstControlPoint.dx,
      firstControlPoint.dy,
      firstEndPoint.dx,
      firstEndPoint.dy,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
