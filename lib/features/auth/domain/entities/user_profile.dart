import 'package:equatable/equatable.dart';

import 'personality_type.dart';

class UserProfile extends Equatable {
  final String id;
  final String username;
  final String email;
  final String? gender;
  final String? sexualOrientation;
  final DateTime? birthday;
  final String? ethnicity;
  final PersonalityType? personalityType;
  final String? relationshipStatus;
  final String? highestEducationLevel;
  final String? avatarUrl;
  final DateTime createdAt;
  const UserProfile({
    required this.id,
    required this.username,
    required this.email,
    this.gender,
    this.sexualOrientation,
    this.birthday,
    this.ethnicity,
    this.personalityType,
    this.relationshipStatus,
    this.highestEducationLevel,
    this.avatarUrl,
    required this.createdAt,
  });
  String? get personalityTypeCode => personalityType?.code;
  int? get age {
    if (birthday == null) return null;
    final now = DateTime.now();
    int age = now.year - birthday!.year;
    if (now.month < birthday!.month ||
        (now.month == birthday!.month && now.day < birthday!.day)) {
      age--;
    }
    return age;
  }

  @override
  List<Object?> get props => [
    id,
    username,
    email,
    gender,
    sexualOrientation,
    birthday,
    ethnicity,
    personalityType,
    relationshipStatus,
    highestEducationLevel,
    avatarUrl,
    createdAt,
  ];
}
