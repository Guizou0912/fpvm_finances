import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ProfileSectionWidget extends StatelessWidget {
  final Map<String, dynamic> userProfile;
  final VoidCallback? onEditProfile;

  const ProfileSectionWidget({
    Key? key,
    required this.userProfile,
    this.onEditProfile,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isLight = Theme.of(context).brightness == Brightness.light;
    final String userRole = (userProfile['role'] as String?) ?? 'Observer';
    final bool canEdit = userRole == 'Admin Church';

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: isLight
            ? AppTheme.lightTheme.colorScheme.surface
            : AppTheme.darkTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isLight
              ? AppTheme.lightTheme.colorScheme.outline
              : AppTheme.darkTheme.colorScheme.outline,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Profil',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: isLight
                      ? AppTheme.textPrimaryLight
                      : AppTheme.textPrimaryDark,
                ),
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              Container(
                width: 15.w,
                height: 15.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isLight
                      ? AppTheme.primaryLight.withValues(alpha: 0.1)
                      : AppTheme.primaryDark.withValues(alpha: 0.1),
                ),
                child: userProfile['avatar'] != null &&
                        (userProfile['avatar'] as String).isNotEmpty
                    ? ClipOval(
                        child: CustomImageWidget(
                          imageUrl: userProfile['avatar'] as String,
                          width: 15.w,
                          height: 15.w,
                          fit: BoxFit.cover,
                        ),
                      )
                    : Center(
                        child: CustomIconWidget(
                          iconName: 'person',
                          color: isLight
                              ? AppTheme.primaryLight
                              : AppTheme.primaryDark,
                          size: 8.w,
                        ),
                      ),
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      (userProfile['name'] as String?) ?? 'Utilisateur',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: isLight
                                ? AppTheme.textPrimaryLight
                                : AppTheme.textPrimaryDark,
                          ),
                    ),
                    SizedBox(height: 0.5.h),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 2.w, vertical: 0.5.h),
                      decoration: BoxDecoration(
                        color: _getRoleColor(userRole, isLight)
                            .withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        userRole,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: _getRoleColor(userRole, isLight),
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      (userProfile['church'] as String?) ?? 'FPVM Église',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: isLight
                                ? AppTheme.textSecondaryLight
                                : AppTheme.textSecondaryDark,
                          ),
                    ),
                  ],
                ),
              ),
              if (canEdit && onEditProfile != null)
                GestureDetector(
                  onTap: onEditProfile,
                  child: Container(
                    padding: EdgeInsets.all(2.w),
                    decoration: BoxDecoration(
                      color: isLight
                          ? AppTheme.lightTheme.colorScheme.surface
                          : AppTheme.darkTheme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isLight
                            ? AppTheme.lightTheme.colorScheme.outline
                            : AppTheme.darkTheme.colorScheme.outline,
                      ),
                    ),
                    child: CustomIconWidget(
                      iconName: 'edit',
                      color: isLight
                          ? AppTheme.primaryLight
                          : AppTheme.primaryDark,
                      size: 5.w,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getRoleColor(String role, bool isLight) {
    switch (role) {
      case 'Admin Church':
        return isLight ? AppTheme.primaryLight : AppTheme.primaryDark;
      case 'Treasurer':
        return isLight ? AppTheme.accentLight : AppTheme.accentDark;
      case 'Observer':
        return isLight ? AppTheme.secondaryLight : AppTheme.secondaryDark;
      default:
        return isLight
            ? AppTheme.textSecondaryLight
            : AppTheme.textSecondaryDark;
    }
  }
}
