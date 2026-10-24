import 'package:equatable/equatable.dart';

import '../../../auth/domain/entities/user_profile.dart';

enum OnboardingStatus {
  initial,
  validating,
  inProgress,
  submitting,
  success,
  failure,
}

class OnboardingState extends Equatable {
  final int currentStep;
  final String userId;
  final String email;
  final String username;
  final bool? isUsernameAvailable;
  final String? usernameError;
  final String? gender;
  final String? sexualOrientation;
  final DateTime? birthday;
  final String? ethnicity;
  final String personalityIorE;
  final String personalitySorN;
  final String personalityForT;
  final String personalityPorJ;
  final String? personalityTypeSelected;
  final String? relationshipStatus;
  final String? educationLevel;
  final OnboardingStatus status;
  final String? errorMessage;
  final UserProfile? createdProfile;
  const OnboardingState({
    this.currentStep = 0,
    this.userId = '',
    this.email = '',
    this.username = '',
    this.isUsernameAvailable,
    this.usernameError,
    this.gender,
    this.sexualOrientation,
    this.birthday,
    this.ethnicity,
    this.personalityIorE = 'E',
    this.personalitySorN = 'N',
    this.personalityForT = 'T',
    this.personalityPorJ = 'J',
    this.personalityTypeSelected = 'I/E',
    this.relationshipStatus,
    this.educationLevel,
    this.status = OnboardingStatus.initial,
    this.errorMessage,
    this.createdProfile,
  });
  String get personalityType =>
      personalityTypeSelected ??
      '$personalityIorE$personalitySorN$personalityForT$personalityPorJ';
  int? get calculatedAge {
    if (birthday == null) return null;
    final now = DateTime.now();
    int age = now.year - birthday!.year;
    if (now.month < birthday!.month ||
        (now.month == birthday!.month && now.day < birthday!.day)) {
      age--;
    }
    return age;
  }

  bool get isCurrentStepValid {
    switch (currentStep) {
      case 0:
        return username.trim().length >= 3;
      case 1:
        return gender != null && gender!.isNotEmpty;
      case 2:
        return birthday != null;
      case 3:
        return ethnicity != null && ethnicity!.isNotEmpty;
      case 4:
        return true;
      case 5:
        return relationshipStatus != null && relationshipStatus!.isNotEmpty;
      case 6:
        return educationLevel != null && educationLevel!.isNotEmpty;
      default:
        return false;
    }
  }

  OnboardingState copyWith({
    int? currentStep,
    String? userId,
    String? email,
    String? username,
    bool? isUsernameAvailable,
    String? usernameError,
    String? gender,
    String? sexualOrientation,
    DateTime? birthday,
    String? ethnicity,
    String? personalityIorE,
    String? personalitySorN,
    String? personalityForT,
    String? personalityPorJ,
    String? personalityTypeSelected,
    String? relationshipStatus,
    String? educationLevel,
    OnboardingStatus? status,
    String? errorMessage,
    UserProfile? createdProfile,
  }) {
    return OnboardingState(
      currentStep: currentStep ?? this.currentStep,
      userId: userId ?? this.userId,
      email: email ?? this.email,
      username: username ?? this.username,
      isUsernameAvailable: isUsernameAvailable ?? this.isUsernameAvailable,
      usernameError: usernameError,
      gender: gender ?? this.gender,
      sexualOrientation: sexualOrientation ?? this.sexualOrientation,
      birthday: birthday ?? this.birthday,
      ethnicity: ethnicity ?? this.ethnicity,
      personalityIorE: personalityIorE ?? this.personalityIorE,
      personalitySorN: personalitySorN ?? this.personalitySorN,
      personalityForT: personalityForT ?? this.personalityForT,
      personalityPorJ: personalityPorJ ?? this.personalityPorJ,
      personalityTypeSelected:
          personalityTypeSelected ?? this.personalityTypeSelected,
      relationshipStatus: relationshipStatus ?? this.relationshipStatus,
      educationLevel: educationLevel ?? this.educationLevel,
      status: status ?? this.status,
      errorMessage: errorMessage,
      createdProfile: createdProfile ?? this.createdProfile,
    );
  }

  @override
  List<Object?> get props => [
    currentStep,
    userId,
    email,
    username,
    isUsernameAvailable,
    usernameError,
    gender,
    sexualOrientation,
    birthday,
    ethnicity,
    personalityIorE,
    personalitySorN,
    personalityForT,
    personalityPorJ,
    personalityTypeSelected,
    relationshipStatus,
    educationLevel,
    status,
    errorMessage,
    createdProfile,
  ];
}
