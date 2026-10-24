import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/domain/entities/user_profile.dart';
import '../../features/auth/presentation/views/email_verification_view.dart';
import '../../features/auth/presentation/views/get_started_view.dart';
import '../../features/auth/presentation/views/house_rules_view.dart';
import '../../features/auth/presentation/views/sign_in_view.dart';
import '../../features/auth/presentation/views/sign_up_view.dart';
import '../../features/auth/presentation/views/splash_view.dart';
import '../../features/home/presentation/views/main_nav_view.dart';
import '../../features/onboarding/presentation/views/onboarding_flow_view.dart';
import '../../features/posts/presentation/views/create_post_view.dart';
import '../../features/profile/presentation/views/personal_information_view.dart';

class AppRoutes {
  static const String splash = '/';
  static const String getStarted = '/get-started';
  static const String signIn = '/sign-in';
  static const String signUp = '/sign-up';
  static const String emailVerification = '/email-verification';
  static const String houseRules = '/house-rules';
  static const String onboarding = '/onboarding';
  static const String home = '/home';
  static const String createPost = '/create-post';
  static const String personalInformation = '/personal-information';
}

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();
final GoRouter appRouter = GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: AppRoutes.splash,
  routes: [
    GoRoute(
      path: AppRoutes.splash,
      name: 'splash',
      builder: (context, state) => const SplashView(),
    ),
    GoRoute(
      path: AppRoutes.getStarted,
      name: 'getStarted',
      builder: (context, state) => const GetStartedView(),
    ),
    GoRoute(
      path: AppRoutes.signIn,
      name: 'signIn',
      builder: (context, state) => const SignInView(),
    ),
    GoRoute(
      path: AppRoutes.signUp,
      name: 'signUp',
      builder: (context, state) => const SignUpView(),
    ),
    GoRoute(
      path: AppRoutes.emailVerification,
      name: 'emailVerification',
      builder: (context, state) {
        final email = state.extra as String? ?? '';
        return EmailVerificationView(email: email);
      },
    ),
    GoRoute(
      path: AppRoutes.houseRules,
      name: 'houseRules',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>? ?? {};
        final userId = extra['userId'] as String? ?? '';
        final email = extra['email'] as String? ?? '';
        return HouseRulesView(userId: userId, email: email);
      },
    ),
    GoRoute(
      path: AppRoutes.onboarding,
      name: 'onboarding',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>? ?? {};
        final userId = extra['userId'] as String? ?? '';
        final email = extra['email'] as String? ?? '';
        return OnboardingFlowView(userId: userId, email: email);
      },
    ),
    GoRoute(
      path: AppRoutes.home,
      name: 'home',
      builder: (context, state) {
        final profile = state.extra as UserProfile;
        return MainNavView(userProfile: profile);
      },
    ),
    GoRoute(
      path: AppRoutes.createPost,
      name: 'createPost',
      builder: (context, state) => const CreatePostView(),
    ),
    GoRoute(
      path: AppRoutes.personalInformation,
      name: 'personalInformation',
      builder: (context, state) =>
          PersonalInformationView(profile: state.extra as UserProfile),
    ),
  ],
);
