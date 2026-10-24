import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';
import '../models/user_profile_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  AuthRepositoryImpl({required this.remoteDataSource});
  @override
  bool get isAuthenticated => remoteDataSource.currentUser != null;
  @override
  String? get currentUserId => remoteDataSource.currentUser?.id;
  @override
  String? get currentUserEmail => remoteDataSource.currentUser?.email;
  @override
  Future<UserProfile?> getCurrentUserProfile() async {
    return await remoteDataSource.getCurrentProfile();
  }

  @override
  Future<void> signInWithPassword({
    required String email,
    required String password,
  }) async {
    await remoteDataSource.signInWithPassword(email: email, password: password);
  }

  @override
  Future<void> signUpWithPassword({
    required String email,
    required String password,
  }) async {
    await remoteDataSource.signUpWithPassword(email: email, password: password);
  }

  @override
  Future<void> resendVerificationEmail(String email) async {
    await remoteDataSource.resendVerificationEmail(email);
  }

  @override
  Future<bool> checkUsernameAvailable(String username) async {
    return await remoteDataSource.checkUsernameAvailable(username);
  }

  @override
  Future<UserProfile> saveUserProfile(UserProfile profile) async {
    final model = UserProfileModel.fromEntity(profile);
    return await remoteDataSource.saveProfile(model);
  }

  @override
  Future<UserProfile?> fetchUserProfileById(String userId) async {
    return await remoteDataSource.getProfileById(userId);
  }

  @override
  Future<void> signOut() async {
    await remoteDataSource.signOut();
  }
}
