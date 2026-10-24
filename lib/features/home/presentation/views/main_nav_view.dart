import 'package:dreamcatchers/features/auth/domain/entities/user_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../posts/presentation/views/feed_view.dart';
import '../../../profile/presentation/views/user_profile_view.dart';

class MainNavView extends StatefulWidget {
  final UserProfile userProfile;
  const MainNavView({super.key, required this.userProfile});
  @override
  State<MainNavView> createState() => _MainNavViewState();
}

class _MainNavViewState extends State<MainNavView> {
  final ValueNotifier<int> _currentIndex = ValueNotifier<int>(0);
  late final List<Widget> _pages;
  @override
  void initState() {
    super.initState();
    _pages = [
      FeedView(userProfile: widget.userProfile),
      UserProfileView(profile: widget.userProfile),
    ];
  }

  @override
  void dispose() {
    _currentIndex.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: _currentIndex,
      builder: (context, activeIndex, _) {
        return Scaffold(
          body: IndexedStack(index: activeIndex, children: _pages),
          bottomNavigationBar: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(color: AppColors.border, width: 0.8),
              ),
            ),
            child: BottomNavigationBar(
              currentIndex: activeIndex,
              onTap: (index) => _currentIndex.value = index,
              type: BottomNavigationBarType.fixed,
              backgroundColor: Colors.white,
              selectedItemColor: AppColors.primary,
              unselectedItemColor: AppColors.textSecondary,
              selectedFontSize: 12,
              unselectedFontSize: 12,
              elevation: 0,
              items: [
                BottomNavigationBarItem(
                  icon: SvgPicture.asset(
                    'assets/Home.svg',
                    width: 22,
                    height: 22,
                    colorFilter: const ColorFilter.mode(
                      AppColors.textSecondary,
                      BlendMode.srcIn,
                    ),
                  ),
                  activeIcon: SvgPicture.asset(
                    'assets/Home.svg',
                    width: 22,
                    height: 22,
                    colorFilter: const ColorFilter.mode(
                      AppColors.primary,
                      BlendMode.srcIn,
                    ),
                  ),
                  label: "Home",
                ),
                BottomNavigationBarItem(
                  icon: SvgPicture.asset(
                    'assets/profile.svg',
                    width: 22,
                    height: 22,
                    colorFilter: const ColorFilter.mode(
                      AppColors.textSecondary,
                      BlendMode.srcIn,
                    ),
                  ),
                  activeIcon: SvgPicture.asset(
                    'assets/profile.svg',
                    width: 22,
                    height: 22,
                    colorFilter: const ColorFilter.mode(
                      AppColors.primary,
                      BlendMode.srcIn,
                    ),
                  ),
                  label: "Profile",
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
