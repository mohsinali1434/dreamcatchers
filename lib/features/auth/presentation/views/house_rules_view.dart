import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/routing/app_router.dart';
import '../../../../core/widgets/custom_button.dart';

class HouseRulesView extends StatelessWidget {
  final String userId;
  final String email;
  const HouseRulesView({super.key, required this.userId, required this.email});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: const TextSpan(
                  children: [
                    TextSpan(
                      text: "Welcome to ",
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    TextSpan(
                      text: "Ask Asap",
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Please follow these House Rules.",
                style: AppTextStyles.bodySecondary.copyWith(fontSize: 15),
              ),
              const SizedBox(height: 32),
              _buildRuleItem(
                title: "Be honest.",
                description: "Answer Ask Asap's questions honestly to ensure higher accuracy in matching.",
              ),
              _buildRuleItem(
                title: "Be open-minded.",
                description: "Respect others' opinions, values, and perspectives with dignity and care.",
              ),
              _buildRuleItem(
                title: "Be proactive.",
                description: "Answer Ask Asap's questions honestly to ensure higher accuracy in matching.",
              ),
              const SizedBox(height: 12),
              Text(
                "More on community guidelines.",
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textSecondary,
                  decoration: TextDecoration.underline,
                ),
              ),
              const Spacer(),
              CustomButton(
                text: "I Agree",
                onPressed: () {
                  context.go(
                    AppRoutes.onboarding,
                    extra: {'userId': userId, 'email': email},
                  );
                },
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRuleItem({required String title, required String description}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.heading3.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            description,
            style: AppTextStyles.bodySecondary.copyWith(
              color: AppColors.textSecondary,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
