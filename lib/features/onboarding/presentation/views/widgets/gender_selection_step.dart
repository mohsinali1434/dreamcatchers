import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_strings.dart';
import '../../../../../core/constants/app_text_styles.dart';
import '../../../../../core/utils/app_helpers.dart';
import '../../bloc/onboarding_bloc.dart';
import '../../bloc/onboarding_event.dart';
import '../../bloc/onboarding_state.dart';
import '../../constants/onboarding_constants.dart';
import 'selectable_option_card.dart';

class GenderSelectionStep extends StatelessWidget {
  final OnboardingState state;
  const GenderSelectionStep({super.key, required this.state});
  @override
  Widget build(BuildContext context) {
    final isOtherSelected =
        state.gender != null &&
        !OnboardingConstants.mainGenders.contains(state.gender);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        const Text(AppStrings.genderTitle, style: AppTextStyles.heading2),
        const SizedBox(height: 28),
        ...OnboardingConstants.mainGenders.map((gender) {
          final isSelected = state.gender == gender;
          return SelectableOptionCard(
            title: gender,
            isSelected: isSelected,
            onTap: () {
              context.read<OnboardingBloc>().add(GenderSelected(gender));
            },
          );
        }),
        SelectableOptionCard(
          title: "Others",
          isSelected: isOtherSelected,
          subtitle: isOtherSelected ? state.gender : null,
          trailing: const Icon(
            Icons.chevron_right,
            color: AppColors.textSecondary,
          ),
          onTap: () {
            AppHelpers.showOptionPicker(
              context: context,
              title: "Select Gender",
              options: OnboardingConstants.otherGenders,
              onSelected: (selected) {
                context.read<OnboardingBloc>().add(GenderSelected(selected));
              },
            );
          },
        ),
      ],
    );
  }
}
