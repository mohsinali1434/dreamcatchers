import '../../domain/entities/personality_type.dart';
import '../../domain/entities/user_profile.dart';

class UserProfileModel extends UserProfile {
  const UserProfileModel({
    required super.id,
    required super.username,
    required super.email,
    super.gender,
    super.sexualOrientation,
    super.birthday,
    super.ethnicity,
    super.personalityType,
    super.relationshipStatus,
    super.highestEducationLevel,
    super.avatarUrl,
    required super.createdAt,
  });
  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      id: json['id'] as String,
      username: (json['username'] as String?) ?? '',
      email: (json['email'] as String?) ?? '',
      gender: json['gender'] as String?,
      sexualOrientation: json['sexual_orientation'] as String?,
      birthday: json['birthday'] != null
          ? DateTime.tryParse(json['birthday'] as String)
          : null,
      ethnicity: json['ethnicity'] as String?,
      personalityType: PersonalityType.fromCode(
        json['personality_type'] as String?,
      ),
      relationshipStatus: json['relationship_status'] as String?,
      highestEducationLevel: json['highest_education_level'] as String?,
      avatarUrl: json['avatar_url'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'gender': gender,
      'birthday': birthday != null
          ? "${birthday!.year.toString().padLeft(4, '0')}-${birthday!.month.toString().padLeft(2, '0')}-${birthday!.day.toString().padLeft(2, '0')}"
          : null,
      'ethnicity': ethnicity,
      'personality_type': personalityType?.code,
      'relationship_status': relationshipStatus,
      'highest_education_level': highestEducationLevel,
      'avatar_url': avatarUrl,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory UserProfileModel.fromEntity(UserProfile entity) {
    return UserProfileModel(
      id: entity.id,
      username: entity.username,
      email: entity.email,
      gender: entity.gender,
      sexualOrientation: entity.sexualOrientation,
      birthday: entity.birthday,
      ethnicity: entity.ethnicity,
      personalityType: entity.personalityType,
      relationshipStatus: entity.relationshipStatus,
      highestEducationLevel: entity.highestEducationLevel,
      avatarUrl: entity.avatarUrl,
      createdAt: entity.createdAt,
    );
  }
}
