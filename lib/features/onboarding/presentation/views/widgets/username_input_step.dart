import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_strings.dart';
import '../../../../../core/constants/app_text_styles.dart';
import '../../../../../core/widgets/custom_text_field.dart';
import '../../bloc/onboarding_bloc.dart';
import '../../bloc/onboarding_event.dart';
import '../../bloc/onboarding_state.dart';

class UsernameInputStep extends StatelessWidget {
  final TextEditingController controller;
  final OnboardingState state;
  const UsernameInputStep({
    super.key,
    required this.controller,
    required this.state,
  });
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        const Text(AppStrings.usernameTitle, style: AppTextStyles.heading2),
        const SizedBox(height: 8),
        Text(AppStrings.usernameSubtitle, style: AppTextStyles.bodySecondary),
        const SizedBox(height: 28),
        CustomTextField(
          controller: controller,
          hintText: "Enter username",
          onChanged: (val) {
            context.read<OnboardingBloc>().add(UsernameChanged(val));
          },
        ),
        if (state.usernameError != null) ...[
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(Icons.cancel, color: AppColors.error, size: 18),
              const SizedBox(width: 6),
              Text(
                state.usernameError!,
                style: const TextStyle(
                  color: AppColors.error,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}
