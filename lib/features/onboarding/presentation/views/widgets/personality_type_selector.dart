import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_strings.dart';
import '../../../../../core/constants/app_text_styles.dart';
import '../../bloc/onboarding_bloc.dart';
import '../../bloc/onboarding_event.dart';
import '../../bloc/onboarding_state.dart';
import '../../constants/onboarding_constants.dart';

class PersonalityTypeSelector extends StatelessWidget {
  final OnboardingState state;
  const PersonalityTypeSelector({super.key, required this.state});
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        const Text(AppStrings.personalityTitle, style: AppTextStyles.heading2),
        const SizedBox(height: 28),
        Row(
          children: OnboardingConstants.personalityTypes.map((option) {
            final isSelected = state.personalityType == option;
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: AspectRatio(
                  aspectRatio: 1.0,
                  child: InkWell(
                    onTap: () {
                      context.read<OnboardingBloc>().add(
                        PersonalityTypeSelected(option),
                      );
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.border,
                          width: isSelected ? 1.5 : 1.2,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        option,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: isSelected
                              ? AppColors.primary
                              : const Color(0xFFB0B7C3),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
