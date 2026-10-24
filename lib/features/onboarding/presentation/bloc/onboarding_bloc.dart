import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/supabase_error_handler.dart';
import '../../../auth/domain/entities/personality_type.dart';
import '../../../auth/domain/entities/user_profile.dart';
import '../../../auth/domain/repositories/auth_repository.dart';
import 'onboarding_event.dart';
import 'onboarding_state.dart';

class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  final AuthRepository authRepository;
  String? _verifiedUsername;
  OnboardingBloc({required this.authRepository})
    : super(const OnboardingState()) {
    on<InitOnboarding>(_onInitOnboarding);
    on<UsernameChanged>(_onUsernameChanged);
    on<ValidateUsernameRequested>(_onValidateUsernameRequested);
    on<GenderSelected>(_onGenderSelected);
    on<SexualOrientationSelected>(_onSexualOrientationSelected);
    on<BirthdaySelected>(_onBirthdaySelected);
    on<EthnicitySelected>(_onEthnicitySelected);
    on<PersonalityDimensionToggled>(_onPersonalityDimensionToggled);
    on<PersonalityTypeSelected>(_onPersonalityTypeSelected);
    on<RelationshipStatusSelected>(_onRelationshipStatusSelected);
    on<EducationLevelSelected>(_onEducationLevelSelected);
    on<NextStepRequested>(_onNextStepRequested);
    on<PreviousStepRequested>(_onPreviousStepRequested);
    on<CompleteOnboardingSubmitted>(_onCompleteOnboardingSubmitted);
  }
  void _onInitOnboarding(InitOnboarding event, Emitter<OnboardingState> emit) {
    emit(
      state.copyWith(
        userId: event.userId,
        email: event.email,
        status: OnboardingStatus.inProgress,
      ),
    );
  }

  void _onUsernameChanged(
    UsernameChanged event,
    Emitter<OnboardingState> emit,
  ) {
    emit(
      state.copyWith(
        username: event.username,
        isUsernameAvailable: null,
        usernameError: null,
      ),
    );
  }

  Future<void> _onValidateUsernameRequested(
    ValidateUsernameRequested event,
    Emitter<OnboardingState> emit,
  ) async {
    final username = state.username.trim();
    if (username.length < 3) {
      emit(
        state.copyWith(
          isUsernameAvailable: false,
          usernameError: 'Username must be at least 3 characters',
        ),
      );
      return;
    }
    emit(state.copyWith(status: OnboardingStatus.validating));
    try {
      final isAvailable = await authRepository.checkUsernameAvailable(username);
      emit(
        state.copyWith(
          status: OnboardingStatus.inProgress,
          isUsernameAvailable: isAvailable,
          usernameError: isAvailable ? null : 'Username is already taken',
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: OnboardingStatus.inProgress,
          isUsernameAvailable: false,
          usernameError: 'Error checking username',
        ),
      );
    }
  }

  void _onGenderSelected(GenderSelected event, Emitter<OnboardingState> emit) {
    emit(state.copyWith(gender: event.gender));
  }

  void _onSexualOrientationSelected(
    SexualOrientationSelected event,
    Emitter<OnboardingState> emit,
  ) {
    emit(state.copyWith(sexualOrientation: event.sexualOrientation));
  }

  void _onBirthdaySelected(
    BirthdaySelected event,
    Emitter<OnboardingState> emit,
  ) {
    emit(state.copyWith(birthday: event.birthday));
  }

  void _onEthnicitySelected(
    EthnicitySelected event,
    Emitter<OnboardingState> emit,
  ) {
    emit(state.copyWith(ethnicity: event.ethnicity));
  }

  void _onPersonalityDimensionToggled(
    PersonalityDimensionToggled event,
    Emitter<OnboardingState> emit,
  ) {
    switch (event.dimensionIndex) {
      case 0:
        emit(state.copyWith(personalityIorE: event.value));
        break;
      case 1:
        emit(state.copyWith(personalitySorN: event.value));
        break;
      case 2:
        emit(state.copyWith(personalityForT: event.value));
        break;
      case 3:
        emit(state.copyWith(personalityPorJ: event.value));
        break;
    }
  }

  void _onPersonalityTypeSelected(
    PersonalityTypeSelected event,
    Emitter<OnboardingState> emit,
  ) {
    emit(state.copyWith(personalityTypeSelected: event.personalityType));
  }

  void _onRelationshipStatusSelected(
    RelationshipStatusSelected event,
    Emitter<OnboardingState> emit,
  ) {
    emit(state.copyWith(relationshipStatus: event.relationshipStatus));
  }

  void _onEducationLevelSelected(
    EducationLevelSelected event,
    Emitter<OnboardingState> emit,
  ) {
    emit(state.copyWith(educationLevel: event.educationLevel));
  }

  Future<void> _onNextStepRequested(
    NextStepRequested event,
    Emitter<OnboardingState> emit,
  ) async {
    if (state.currentStep == 0) {
      final username = state.username.trim();
      if (username.length < 3) {
        emit(
          state.copyWith(
            isUsernameAvailable: false,
            usernameError: 'Username must be at least 3 characters',
          ),
        );
        return;
      }
      if (state.isUsernameAvailable == true && _verifiedUsername == username) {
        emit(state.copyWith(currentStep: 1));
        return;
      }
      emit(state.copyWith(status: OnboardingStatus.validating));
      try {
        final isAvailable = await authRepository.checkUsernameAvailable(
          username,
        );
        if (isAvailable) {
          _verifiedUsername = username;
          emit(
            state.copyWith(
              status: OnboardingStatus.inProgress,
              isUsernameAvailable: true,
              usernameError: null,
              currentStep: 1,
            ),
          );
        } else {
          emit(
            state.copyWith(
              status: OnboardingStatus.inProgress,
              isUsernameAvailable: false,
              usernameError: 'Username is already taken',
            ),
          );
        }
      } catch (e) {
        emit(
          state.copyWith(
            status: OnboardingStatus.inProgress,
            isUsernameAvailable: false,
            usernameError: 'Error checking username availability',
          ),
        );
      }
      return;
    }
    if (state.currentStep < 6) {
      emit(state.copyWith(currentStep: state.currentStep + 1));
    }
  }

  void _onPreviousStepRequested(
    PreviousStepRequested event,
    Emitter<OnboardingState> emit,
  ) {
    if (state.currentStep > 0) {
      emit(state.copyWith(currentStep: state.currentStep - 1));
    }
  }

  Future<void> _onCompleteOnboardingSubmitted(
    CompleteOnboardingSubmitted event,
    Emitter<OnboardingState> emit,
  ) async {
    emit(state.copyWith(status: OnboardingStatus.submitting));
    try {
      final profile = UserProfile(
        id: state.userId,
        username: state.username.trim(),
        email: state.email.trim(),
        gender: state.gender,
        sexualOrientation: state.sexualOrientation,
        birthday: state.birthday,
        ethnicity: state.ethnicity,
        personalityType: PersonalityType.fromCode(state.personalityType),
        relationshipStatus: state.relationshipStatus,
        highestEducationLevel: state.educationLevel,
        createdAt: DateTime.now(),
      );
      final saved = await authRepository.saveUserProfile(profile);
      emit(
        state.copyWith(status: OnboardingStatus.success, createdProfile: saved),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: OnboardingStatus.failure,
          errorMessage: SupabaseErrorHandler.toFriendlyMessage(e),
        ),
      );
    }
  }
}
