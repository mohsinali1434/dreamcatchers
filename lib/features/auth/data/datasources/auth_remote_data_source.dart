import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/user_profile_model.dart';

abstract class AuthRemoteDataSource {
  User? get currentUser;
  Future<UserProfileModel?> getCurrentProfile();
  Future<void> signInWithPassword({
    required String email,
    required String password,
  });
  Future<AuthResponse> signUpWithPassword({
    required String email,
    required String password,
  });
  Future<void> resendVerificationEmail(String email);
  Future<bool> checkUsernameAvailable(String username);
  Future<UserProfileModel> saveProfile(UserProfileModel profile);
  Future<UserProfileModel?> getProfileById(String userId);
  Future<void> signOut();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final SupabaseClient supabaseClient;
  AuthRemoteDataSourceImpl({required this.supabaseClient});
  @override
  User? get currentUser => supabaseClient.auth.currentUser;
  @override
  Future<UserProfileModel?> getCurrentProfile() async {
    final user = currentUser;
    if (user == null) return null;
    return getProfileById(user.id);
  }

  @override
  Future<void> signInWithPassword({
    required String email,
    required String password,
  }) async {
    await supabaseClient.auth.signInWithPassword(
      email: email.trim(),
      password: password,
    );
  }

  @override
  Future<AuthResponse> signUpWithPassword({
    required String email,
    required String password,
  }) async {
    return await supabaseClient.auth.signUp(
      email: email.trim(),
      password: password,
    );
  }

  @override
  Future<void> resendVerificationEmail(String email) async {
    await supabaseClient.auth.resend(type: OtpType.signup, email: email.trim());
  }

  @override
  Future<bool> checkUsernameAvailable(String username) async {
    final trimmed = username.trim();
    if (trimmed.isEmpty) return false;
    final response = await supabaseClient
        .from('profiles')
        .select('id')
        .eq('username', trimmed)
        .maybeSingle();
    return response == null;
  }

  @override
  Future<UserProfileModel> saveProfile(UserProfileModel profile) async {
    final data = profile.toJson();
    await supabaseClient.from('profiles').upsert(data);
    return profile;
  }

  @override
  Future<UserProfileModel?> getProfileById(String userId) async {
    final response = await supabaseClient
        .from('profiles')
        .select()
        .eq('id', userId)
        .maybeSingle();
    if (response == null) return null;
    return UserProfileModel.fromJson(response);
  }

  @override
  Future<void> signOut() async {
    await supabaseClient.auth.signOut();
  }
}
