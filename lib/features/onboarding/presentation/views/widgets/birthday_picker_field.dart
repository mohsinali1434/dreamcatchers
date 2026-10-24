import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_strings.dart';
import '../../../../../core/constants/app_text_styles.dart';
import '../../../../../core/widgets/custom_button.dart';
import '../../bloc/onboarding_bloc.dart';
import '../../bloc/onboarding_event.dart';
import '../../bloc/onboarding_state.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

class BirthdayPickerField extends StatelessWidget {
  final OnboardingState state;
  const BirthdayPickerField({super.key, required this.state});
  void _showDatePickerBottomSheet(BuildContext context, OnboardingState state) {
    DateTime tempDate = state.birthday ?? DateTime(2000, 1, 1);
    final maxDate = DateTime.now().subtract(const Duration(days: 365 * 13));
    if (tempDate.isAfter(maxDate)) {
      tempDate = maxDate;
    }
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (bottomSheetContext) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 28),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Select Date",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 200,
                  child: CupertinoDatePicker(
                    mode: CupertinoDatePickerMode.date,
                    initialDateTime: tempDate,
                    maximumDate: maxDate,
                    minimumYear: 1940,
                    maximumYear: maxDate.year,
                    onDateTimeChanged: (DateTime newDate) {
                      tempDate = newDate;
                    },
                  ),
                ),
                const SizedBox(height: 20),
                CustomButton(
                  text: AppStrings.save,
                  onPressed: () {
                    context.read<OnboardingBloc>().add(
                      BirthdaySelected(tempDate),
                    );
                    Navigator.pop(bottomSheetContext);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final birthday = state.birthday;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        const Text(AppStrings.birthdayTitle, style: AppTextStyles.heading2),
        const SizedBox(height: 28),
        InkWell(
          onTap: () => _showDatePickerBottomSheet(context, state),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            width: double.infinity,
            height: 52,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: AppColors.inputBackground,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.calendar_today_outlined,
                  size: 20,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(width: 12),
                Text(
                  birthday != null
                      ? DateFormat('MMMM dd, yyyy').format(birthday)
                      : "December 23, 2023",
                  style: TextStyle(
                    fontSize: 15,
                    color: birthday != null
                        ? AppColors.textPrimary
                        : AppColors.textSecondary,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
