import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();
  @override
  List<Object?> get props => [];
}

class CheckAuthStatus extends AuthEvent {}

class SignInSubmitted extends AuthEvent {
  final String email;
  final String password;
  const SignInSubmitted({required this.email, required this.password});
  @override
  List<Object?> get props => [email, password];
}

class SignUpSubmitted extends AuthEvent {
  final String email;
  final String password;
  const SignUpSubmitted({required this.email, required this.password});
  @override
  List<Object?> get props => [email, password];
}

class ResendEmailVerification extends AuthEvent {
  final String email;
  const ResendEmailVerification(this.email);
  @override
  List<Object?> get props => [email];
}

class SignOutRequested extends AuthEvent {}
