import 'package:flutter/material.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_strings.dart';
import '../../../../../core/constants/app_text_styles.dart';
import '../../../../../core/widgets/custom_button.dart';
import '../../bloc/onboarding_state.dart';

class OnboardingBottomBar extends StatelessWidget {
  final OnboardingState state;
  final VoidCallback onContinue;
  final VoidCallback onSkip;
  const OnboardingBottomBar({
    super.key,
    required this.state,
    required this.onContinue,
    required this.onSkip,
  });
  bool get _isSkippable =>
      state.currentStep == 4 ||
      state.currentStep == 5 ||
      state.currentStep == 6;
  @override
  Widget build(BuildContext context) {
    final isSubmitting = state.status == OnboardingStatus.submitting;
    final isValidating = state.status == OnboardingStatus.validating;
    final canContinue =
        state.isCurrentStepValid && !isSubmitting && !isValidating;
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildDisclaimer(state.currentStep),
          CustomButton(
            text: AppStrings.continueText,
            isLoading: isSubmitting || isValidating,
            onPressed: canContinue ? onContinue : null,
          ),
          if (_isSkippable) ...[
            const SizedBox(height: 8),
            TextButton(
              onPressed: onSkip,
              child: const Text(
                AppStrings.skip,
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDisclaimer(int step) {
    switch (step) {
      case 0:
        return Padding(
          padding: const EdgeInsets.only(bottom: 14),
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: AppTextStyles.bodySecondary.copyWith(fontSize: 12),
              children: const [
                TextSpan(text: AppStrings.usernameDisclaimerPrefix),
                TextSpan(
                  text: AppStrings.usernameCannotChange,
                  style: TextStyle(
                    color: AppColors.error,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        );
      case 2:
        return Padding(
          padding: const EdgeInsets.only(bottom: 14),
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: AppTextStyles.bodySecondary.copyWith(
                fontSize: 12,
                height: 1.4,
              ),
              children: const [
                TextSpan(text: AppStrings.birthdayDisclaimerPrefix),
                TextSpan(
                  text: AppStrings.birthdayCannotChange,
                  style: TextStyle(
                    color: AppColors.error,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        );
      case 4:
        return _plainDisclaimer(AppStrings.personalityDisclaimer);
      case 5:
        return _plainDisclaimer(AppStrings.relationshipDisclaimer);
      case 6:
        return _plainDisclaimer(AppStrings.educationDisclaimer);
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _plainDisclaimer(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: AppTextStyles.bodySecondary.copyWith(fontSize: 13, height: 1.4),
      ),
    );
  }
}
