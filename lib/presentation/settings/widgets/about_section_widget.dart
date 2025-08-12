import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AboutSectionWidget extends StatelessWidget {
  final String appVersion;
  final VoidCallback onPrivacyPolicy;
  final VoidCallback onTermsOfService;
  final VoidCallback onContactSupport;

  const AboutSectionWidget({
    Key? key,
    required this.appVersion,
    required this.onPrivacyPolicy,
    required this.onTermsOfService,
    required this.onContactSupport,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isLight = Theme.of(context).brightness == Brightness.light;

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
            'À propos',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: isLight
                      ? AppTheme.textPrimaryLight
                      : AppTheme.textPrimaryDark,
                ),
          ),
          SizedBox(height: 2.h),
          _buildAboutItem(
            context,
            isLight,
            'info',
            'Version de l\'application',
            appVersion,
            null,
          ),
          SizedBox(height: 2.h),
          _buildAboutItem(
            context,
            isLight,
            'privacy_tip',
            'Politique de confidentialité',
            'Consulter notre politique de confidentialité',
            onPrivacyPolicy,
          ),
          SizedBox(height: 2.h),
          _buildAboutItem(
            context,
            isLight,
            'description',
            'Conditions d\'utilisation',
            'Lire les conditions d\'utilisation',
            onTermsOfService,
          ),
          SizedBox(height: 2.h),
          _buildAboutItem(
            context,
            isLight,
            'support_agent',
            'Contacter le support',
            'Obtenir de l\'aide et du support technique',
            onContactSupport,
          ),
        ],
      ),
    );
  }

  Widget _buildAboutItem(
    BuildContext context,
    bool isLight,
    String iconName,
    String title,
    String subtitle,
    VoidCallback? onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          CustomIconWidget(
            iconName: iconName,
            color: isLight ? AppTheme.primaryLight : AppTheme.primaryDark,
            size: 6.w,
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: isLight
                            ? AppTheme.textPrimaryLight
                            : AppTheme.textPrimaryDark,
                      ),
                ),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: isLight
                            ? AppTheme.textSecondaryLight
                            : AppTheme.textSecondaryDark,
                      ),
                ),
              ],
            ),
          ),
          if (onTap != null)
            CustomIconWidget(
              iconName: 'chevron_right',
              color: isLight
                  ? AppTheme.textSecondaryLight
                  : AppTheme.textSecondaryDark,
              size: 5.w,
            ),
        ],
      ),
    );
  }
}
