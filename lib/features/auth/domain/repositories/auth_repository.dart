import '../entities/user_profile.dart';

abstract class AuthRepository {
  Future<UserProfile?> getCurrentUserProfile();
  bool get isAuthenticated;
  String? get currentUserId;
  String? get currentUserEmail;
  Future<void> signInWithPassword({
    required String email,
    required String password,
  });
  Future<void> signUpWithPassword({
    required String email,
    required String password,
  });
  Future<void> resendVerificationEmail(String email);
  Future<bool> checkUsernameAvailable(String username);
  Future<UserProfile> saveUserProfile(UserProfile profile);
  Future<UserProfile?> fetchUserProfileById(String userId);
  Future<void> signOut();
}
