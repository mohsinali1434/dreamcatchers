import 'package:equatable/equatable.dart';

abstract class OnboardingEvent extends Equatable {
  const OnboardingEvent();
  @override
  List<Object?> get props => [];
}

class InitOnboarding extends OnboardingEvent {
  final String userId;
  final String email;
  const InitOnboarding({required this.userId, required this.email});
  @override
  List<Object?> get props => [userId, email];
}

class UsernameChanged extends OnboardingEvent {
  final String username;
  const UsernameChanged(this.username);
  @override
  List<Object?> get props => [username];
}

class ValidateUsernameRequested extends OnboardingEvent {}

class GenderSelected extends OnboardingEvent {
  final String gender;
  const GenderSelected(this.gender);
  @override
  List<Object?> get props => [gender];
}

class SexualOrientationSelected extends OnboardingEvent {
  final String sexualOrientation;
  const SexualOrientationSelected(this.sexualOrientation);
  @override
  List<Object?> get props => [sexualOrientation];
}

class BirthdaySelected extends OnboardingEvent {
  final DateTime birthday;
  const BirthdaySelected(this.birthday);
  @override
  List<Object?> get props => [birthday];
}

class EthnicitySelected extends OnboardingEvent {
  final String ethnicity;
  const EthnicitySelected(this.ethnicity);
  @override
  List<Object?> get props => [ethnicity];
}

class PersonalityDimensionToggled extends OnboardingEvent {
  final int dimensionIndex;
  final String value;
  const PersonalityDimensionToggled({
    required this.dimensionIndex,
    required this.value,
  });
  @override
  List<Object?> get props => [dimensionIndex, value];
}

class PersonalityTypeSelected extends OnboardingEvent {
  final String personalityType;
  const PersonalityTypeSelected(this.personalityType);
  @override
  List<Object?> get props => [personalityType];
}

class RelationshipStatusSelected extends OnboardingEvent {
  final String relationshipStatus;
  const RelationshipStatusSelected(this.relationshipStatus);
  @override
  List<Object?> get props => [relationshipStatus];
}

class EducationLevelSelected extends OnboardingEvent {
  final String educationLevel;
  const EducationLevelSelected(this.educationLevel);
  @override
  List<Object?> get props => [educationLevel];
}

class NextStepRequested extends OnboardingEvent {}

class PreviousStepRequested extends OnboardingEvent {}

class CompleteOnboardingSubmitted extends OnboardingEvent {}
