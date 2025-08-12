import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class BottomNavigationWidget extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavigationWidget({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isLight = Theme.of(context).brightness == Brightness.light;

    return Container(
      decoration: BoxDecoration(
        color: isLight
            ? AppTheme.lightTheme.colorScheme.surface
            : AppTheme.darkTheme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: isLight ? AppTheme.shadowLight : AppTheme.shadowDark,
            blurRadius: 8,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Container(
          height: 8.h,
          padding: EdgeInsets.symmetric(horizontal: 2.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                context,
                isLight,
                0,
                'dashboard',
                'Tableau de bord',
                '/dashboard',
              ),
              _buildNavItem(
                context,
                isLight,
                1,
                'history',
                'Historique',
                '/transaction-history',
              ),
              _buildNavItem(
                context,
                isLight,
                2,
                'work',
                'Projets',
                '/project-management',
              ),
              _buildNavItem(
                context,
                isLight,
                3,
                'assessment',
                'Rapports',
                '/financial-reports',
              ),
              _buildNavItem(
                context,
                isLight,
                4,
                'settings',
                'Paramètres',
                '/settings',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context,
    bool isLight,
    int index,
    String iconName,
    String label,
    String route,
  ) {
    final bool isSelected = currentIndex == index;
    final Color selectedColor =
        isLight ? AppTheme.primaryLight : AppTheme.primaryDark;
    final Color unselectedColor =
        isLight ? AppTheme.textSecondaryLight : AppTheme.textSecondaryDark;

    return GestureDetector(
      onTap: () {
        if (!isSelected) {
          onTap(index);
          Navigator.pushNamed(context, route);
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 1.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomIconWidget(
              iconName: iconName,
              color: isSelected ? selectedColor : unselectedColor,
              size: isSelected ? 6.w : 5.5.w,
            ),
            SizedBox(height: 0.5.h),
            Text(
              label,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: isSelected ? selectedColor : unselectedColor,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    fontSize: isSelected ? 10.sp : 9.sp,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
