import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/utils/snackbar_helper.dart';
import '../../../../core/routing/app_router.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});
  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final ValueNotifier<bool> _obscurePassword = ValueNotifier<bool>(true);
  final ValueNotifier<bool> _obscureConfirm = ValueNotifier<bool>(true);
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _obscurePassword.dispose();
    _obscureConfirm.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthBloc>().add(
        SignUpSubmitted(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is EmailVerificationPending) {
          context.pushReplacement(
            AppRoutes.emailVerification,
            extra: state.email,
          );
        } else if (state is AuthFailureState) {
          SnackbarHelper.showError(context, state.message);
        }
      },
      builder: (context, state) {
        final isLoading = state is AuthLoading;
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new,
                color: AppColors.textPrimary,
                size: 20,
              ),
              onPressed: () => context.pop(),
            ),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      AppStrings.createAccount,
                      style: AppTextStyles.heading1,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      AppStrings.signUpSubtitle,
                      style: AppTextStyles.bodySecondary,
                    ),
                    const SizedBox(height: 32),
                    CustomTextField(
                      controller: _emailController,
                      labelText: AppStrings.emailLabel,
                      hintText: AppStrings.emailHint,
                      keyboardType: TextInputType.emailAddress,
                      prefixIcon: const Icon(
                        Icons.email_outlined,
                        color: AppColors.textSecondary,
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return AppStrings.emailRequired;
                        }
                        if (!value.contains('@') || !value.contains('.')) {
                          return AppStrings.emailInvalid;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    ValueListenableBuilder<bool>(
                      valueListenable: _obscurePassword,
                      builder: (context, isObscure, _) {
                        return CustomTextField(
                          controller: _passwordController,
                          labelText: AppStrings.passwordLabel,
                          hintText: AppStrings.passwordCreateHint,
                          obscureText: isObscure,
                          prefixIcon: const Icon(
                            Icons.lock_outline,
                            color: AppColors.textSecondary,
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              isObscure
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              color: AppColors.textSecondary,
                            ),
                            onPressed: () => _obscurePassword.value =
                                !_obscurePassword.value,
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return AppStrings.passwordCreateRequired;
                            }
                            if (value.length < 6) {
                              return AppStrings.passwordMinLength;
                            }
                            return null;
                          },
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    ValueListenableBuilder<bool>(
                      valueListenable: _obscureConfirm,
                      builder: (context, isObscure, _) {
                        return CustomTextField(
                          controller: _confirmPasswordController,
                          labelText: AppStrings.confirmPasswordLabel,
                          hintText: AppStrings.confirmPasswordHint,
                          obscureText: isObscure,
                          prefixIcon: const Icon(
                            Icons.lock_reset_outlined,
                            color: AppColors.textSecondary,
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              isObscure
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              color: AppColors.textSecondary,
                            ),
                            onPressed: () =>
                                _obscureConfirm.value = !_obscureConfirm.value,
                          ),
                          validator: (value) {
                            if (value != _passwordController.text) {
                              return AppStrings.passwordsDoNotMatch;
                            }
                            return null;
                          },
                        );
                      },
                    ),
                    const SizedBox(height: 36),
                    CustomButton(
                      text: AppStrings.continueText,
                      isLoading: isLoading,
                      onPressed: _submit,
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          AppStrings.alreadyHaveAccount,
                          style: AppTextStyles.bodySecondary,
                        ),
                        GestureDetector(
                          onTap: () =>
                              context.pushReplacement(AppRoutes.signIn),
                          child: Text(
                            AppStrings.signIn,
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
