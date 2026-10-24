import 'package:equatable/equatable.dart';

import '../../domain/entities/user_profile.dart';

abstract class AuthState extends Equatable {
  const AuthState();
  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class Authenticated extends AuthState {
  final UserProfile profile;
  const Authenticated(this.profile);
  @override
  List<Object?> get props => [profile];
}

class NeedsOnboarding extends AuthState {
  final String userId;
  final String email;
  const NeedsOnboarding({required this.userId, required this.email});
  @override
  List<Object?> get props => [userId, email];
}

class EmailVerificationPending extends AuthState {
  final String email;
  const EmailVerificationPending(this.email);
  @override
  List<Object?> get props => [email];
}

class Unauthenticated extends AuthState {}

class AuthFailureState extends AuthState {
  final String message;
  const AuthFailureState(this.message);
  @override
  List<Object?> get props => [message];
}
