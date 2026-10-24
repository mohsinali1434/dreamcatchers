import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/routing/app_router.dart';
import '../../../../core/utils/snackbar_helper.dart';
import '../bloc/onboarding_bloc.dart';
import '../bloc/onboarding_event.dart';
import '../bloc/onboarding_state.dart';
import 'widgets/birthday_picker_field.dart';
import 'widgets/gender_selection_step.dart';
import 'widgets/onboarding_bottom_bar.dart';
import 'widgets/onboarding_option_list_step.dart';
import 'widgets/personality_type_selector.dart';
import 'widgets/username_input_step.dart';

class OnboardingFlowView extends StatelessWidget {
  final String userId;
  final String email;
  const OnboardingFlowView({
    super.key,
    required this.userId,
    required this.email,
  });
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          sl<OnboardingBloc>()
            ..add(InitOnboarding(userId: userId, email: email)),
      child: const _OnboardingFlowBody(),
    );
  }
}

class _OnboardingFlowBody extends StatefulWidget {
  const _OnboardingFlowBody();
  @override
  State<_OnboardingFlowBody> createState() => _OnboardingFlowBodyState();
}

class _OnboardingFlowBodyState extends State<_OnboardingFlowBody> {
  final _usernameController = TextEditingController();
  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  void _handleContinue(BuildContext context, OnboardingState state) {
    if (state.currentStep == 6) {
      context.read<OnboardingBloc>().add(CompleteOnboardingSubmitted());
    } else {
      context.read<OnboardingBloc>().add(NextStepRequested());
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OnboardingBloc, OnboardingState>(
      listener: (context, state) {
        if (state.status == OnboardingStatus.success &&
            state.createdProfile != null) {
          context.go(AppRoutes.home, extra: state.createdProfile!);
        } else if (state.status == OnboardingStatus.failure) {
          SnackbarHelper.showError(
            context,
            state.errorMessage ?? "An error occurred",
          );
        }
      },
      builder: (context, state) {
        final currentStep = state.currentStep;
        const totalSteps = 7;
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: currentStep > 0
                ? IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios_new,
                      color: AppColors.textPrimary,
                      size: 20,
                    ),
                    onPressed: () {
                      context.read<OnboardingBloc>().add(
                        PreviousStepRequested(),
                      );
                    },
                  )
                : null,
            title: const Text(
              AppStrings.signUp,
              style: TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
            centerTitle: true,
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(4),
              child: LinearProgressIndicator(
                value: (currentStep + 1) / totalSteps,
                backgroundColor: AppColors.border,
                valueColor: const AlwaysStoppedAnimation<Color>(
                  AppColors.primary,
                ),
                minHeight: 3,
              ),
            ),
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: _buildCurrentStep(context, state),
                    ),
                  ),
                  OnboardingBottomBar(
                    state: state,
                    onContinue: () => _handleContinue(context, state),
                    onSkip: () => _handleContinue(context, state),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCurrentStep(BuildContext context, OnboardingState state) {
    switch (state.currentStep) {
      case 0:
        return UsernameInputStep(controller: _usernameController, state: state);
      case 1:
        return GenderSelectionStep(state: state);
      case 2:
        return BirthdayPickerField(state: state);
      case 3:
        return OnboardingOptionListStep.ethnicity(
          context: context,
          state: state,
        );
      case 4:
        return PersonalityTypeSelector(state: state);
      case 5:
        return OnboardingOptionListStep.relationship(
          context: context,
          state: state,
        );
      case 6:
        return OnboardingOptionListStep.education(
          context: context,
          state: state,
        );
      default:
        return const SizedBox.shrink();
    }
  }
}
