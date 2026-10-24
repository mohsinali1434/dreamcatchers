import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/constants/app_strings.dart';
import '../../../../../core/constants/app_text_styles.dart';
import '../../bloc/onboarding_bloc.dart';
import '../../bloc/onboarding_event.dart';
import '../../bloc/onboarding_state.dart';
import '../../constants/onboarding_constants.dart';
import 'selectable_option_card.dart';

class OnboardingOptionListStep extends StatelessWidget {
  final String title;
  final List<String> options;
  final String? selectedOption;
  final ValueChanged<String> onSelected;
  const OnboardingOptionListStep({
    super.key,
    required this.title,
    required this.options,
    required this.selectedOption,
    required this.onSelected,
  });
  factory OnboardingOptionListStep.ethnicity({
    Key? key,
    required BuildContext context,
    required OnboardingState state,
  }) {
    return OnboardingOptionListStep(
      key: key,
      title: AppStrings.ethnicityTitle,
      options: OnboardingConstants.ethnicities,
      selectedOption: state.ethnicity,
      onSelected: (item) {
        context.read<OnboardingBloc>().add(EthnicitySelected(item));
      },
    );
  }
  factory OnboardingOptionListStep.relationship({
    Key? key,
    required BuildContext context,
    required OnboardingState state,
  }) {
    return OnboardingOptionListStep(
      key: key,
      title: AppStrings.relationshipTitle,
      options: OnboardingConstants.relationshipStatuses,
      selectedOption: state.relationshipStatus,
      onSelected: (item) {
        context.read<OnboardingBloc>().add(RelationshipStatusSelected(item));
      },
    );
  }
  factory OnboardingOptionListStep.education({
    Key? key,
    required BuildContext context,
    required OnboardingState state,
  }) {
    return OnboardingOptionListStep(
      key: key,
      title: AppStrings.educationTitle,
      options: OnboardingConstants.educationLevels,
      selectedOption: state.educationLevel,
      onSelected: (item) {
        context.read<OnboardingBloc>().add(EducationLevelSelected(item));
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        Text(title, style: AppTextStyles.heading2),
        const SizedBox(height: 24),
        ...options.map((item) {
          final isSelected = selectedOption == item;
          return SelectableOptionCard(
            title: item,
            isSelected: isSelected,
            onTap: () => onSelected(item),
          );
        }),
      ],
    );
  }
}
