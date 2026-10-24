import 'dart:io';

import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseErrorHandler {
  SupabaseErrorHandler._();
  static String toFriendlyMessage(Object error) {
    if (error is SocketException) {
      return 'No internet connection. Please check your network and try again.';
    }
    if (error is AuthException) {
      return _mapAuthError(error);
    }
    if (error is PostgrestException) {
      return _mapPostgrestError(error);
    }
    final raw = error.toString().toLowerCase();
    if (raw.contains('failed host lookup') ||
        raw.contains('network is unreachable') ||
        raw.contains('connection refused') ||
        raw.contains('clientexception')) {
      return 'Unable to connect to the server. Please check your internet connection.';
    }
    if (raw.contains('timeout')) {
      return 'Connection timed out. Please try again.';
    }
    final clean = error.toString().replaceAll('Exception: ', '').trim();
    if (clean.isNotEmpty && !clean.contains('instance of')) {
      return clean;
    }
    return 'Something went wrong. Please try again later.';
  }

  static String _mapAuthError(AuthException error) {
    final msg = error.message.toLowerCase();
    final code = error.statusCode?.toString() ?? '';
    if (msg.contains('invalid login credentials') ||
        msg.contains('invalid email or password')) {
      return 'Incorrect email or password. Please try again.';
    }
    if (msg.contains('user already registered') ||
        msg.contains('already exists')) {
      return 'An account with this email already exists. Please sign in instead.';
    }
    if (msg.contains('email not confirmed')) {
      return 'Please verify your email address before signing in.';
    }
    if (msg.contains('password should be at least')) {
      return 'Password must be at least 6 characters.';
    }
    if (msg.contains('rate limit') ||
        msg.contains('too many requests') ||
        code == '429') {
      return 'Too many requests. Please wait a moment and try again.';
    }
    if (msg.contains('signup disabled')) {
      return 'New registrations are currently closed. Please contact support.';
    }
    if (error.message.isNotEmpty) {
      return error.message;
    }
    return 'Authentication failed. Please check your details and try again.';
  }

  static String _mapPostgrestError(PostgrestException error) {
    final code = error.code ?? '';
    final msg = error.message.toLowerCase();
    if (code == '23505' || msg.contains('duplicate key')) {
      if (msg.contains('username') ||
          error.details?.toString().contains('username') == true) {
        return 'This username is already taken. Please choose another one.';
      }
      return 'This record already exists.';
    }
    if (code == '23503') {
      return 'Unable to complete action due to missing user or post reference.';
    }
    if (code == '42501' || msg.contains('permission denied')) {
      return 'You do not have permission to perform this action.';
    }
    if (error.message.isNotEmpty) {
      return error.message;
    }
    return 'Database operation failed. Please try again.';
  }
}
