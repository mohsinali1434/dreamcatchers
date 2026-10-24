import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/supabase_error_handler.dart';
import '../../domain/repositories/auth_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;
  AuthBloc({required this.authRepository}) : super(AuthInitial()) {
    on<CheckAuthStatus>(_onCheckAuthStatus);
    on<SignInSubmitted>(_onSignInSubmitted);
    on<SignUpSubmitted>(_onSignUpSubmitted);
    on<ResendEmailVerification>(_onResendEmailVerification);
    on<SignOutRequested>(_onSignOutRequested);
  }
  Future<void> _onCheckAuthStatus(
    CheckAuthStatus event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      if (!authRepository.isAuthenticated) {
        emit(Unauthenticated());
        return;
      }
      final profile = await authRepository.getCurrentUserProfile();
      if (profile != null && profile.username.isNotEmpty) {
        emit(Authenticated(profile));
      } else {
        final userId = authRepository.currentUserId ?? '';
        final email = authRepository.currentUserEmail ?? '';
        emit(NeedsOnboarding(userId: userId, email: email));
      }
    } catch (_) {
      emit(Unauthenticated());
    }
  }

  Future<void> _onSignInSubmitted(
    SignInSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      await authRepository.signInWithPassword(
        email: event.email,
        password: event.password,
      );
      final profile = await authRepository.getCurrentUserProfile();
      if (profile != null && profile.username.isNotEmpty) {
        emit(Authenticated(profile));
      } else {
        final userId = authRepository.currentUserId ?? '';
        final email = authRepository.currentUserEmail ?? event.email;
        emit(NeedsOnboarding(userId: userId, email: email));
      }
    } catch (e) {
      emit(AuthFailureState(SupabaseErrorHandler.toFriendlyMessage(e)));
    }
  }

  Future<void> _onSignUpSubmitted(
    SignUpSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      await authRepository.signUpWithPassword(
        email: event.email,
        password: event.password,
      );
      emit(EmailVerificationPending(event.email));
    } catch (e) {
      emit(AuthFailureState(SupabaseErrorHandler.toFriendlyMessage(e)));
    }
  }

  Future<void> _onResendEmailVerification(
    ResendEmailVerification event,
    Emitter<AuthState> emit,
  ) async {
    try {
      await authRepository.resendVerificationEmail(event.email);
    } catch (e) {
      emit(AuthFailureState(SupabaseErrorHandler.toFriendlyMessage(e)));
    }
  }

  Future<void> _onSignOutRequested(
    SignOutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      await authRepository.signOut();
      emit(Unauthenticated());
    } catch (e) {
      emit(AuthFailureState(e.toString()));
    }
  }
}
