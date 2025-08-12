import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class RoleSpecificSectionWidget extends StatelessWidget {
  final String userRole;
  final VoidCallback? onUserManagement;
  final VoidCallback? onChurchSettings;
  final VoidCallback? onTransactionPreferences;
  final VoidCallback? onReportSettings;

  const RoleSpecificSectionWidget({
    Key? key,
    required this.userRole,
    this.onUserManagement,
    this.onChurchSettings,
    this.onTransactionPreferences,
    this.onReportSettings,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isLight = Theme.of(context).brightness == Brightness.light;
    final List<Widget> roleOptions =
        _buildRoleSpecificOptions(context, isLight);

    if (roleOptions.isEmpty) {
      return SizedBox.shrink();
    }

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
            'Options spécifiques au rôle',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: isLight
                      ? AppTheme.textPrimaryLight
                      : AppTheme.textPrimaryDark,
                ),
          ),
          SizedBox(height: 2.h),
          ...roleOptions,
        ],
      ),
    );
  }

  List<Widget> _buildRoleSpecificOptions(BuildContext context, bool isLight) {
    List<Widget> options = [];

    switch (userRole) {
      case 'Admin Church':
        if (onUserManagement != null) {
          options.add(_buildOptionItem(
            context,
            isLight,
            'people',
            'Gestion des utilisateurs',
            'Gérer les comptes et permissions',
            onUserManagement!,
          ));
          options.add(SizedBox(height: 2.h));
        }
        if (onChurchSettings != null) {
          options.add(_buildOptionItem(
            context,
            isLight,
            'church',
            'Paramètres de l\'église',
            'Configuration et informations de l\'église',
            onChurchSettings!,
          ));
        }
        break;

      case 'Treasurer':
        if (onTransactionPreferences != null) {
          options.add(_buildOptionItem(
            context,
            isLight,
            'account_balance_wallet',
            'Préférences de transaction',
            'Configurer les types de revenus et dépenses',
            onTransactionPreferences!,
          ));
        }
        break;

      case 'Observer':
        if (onReportSettings != null) {
          options.add(_buildOptionItem(
            context,
            isLight,
            'assessment',
            'Paramètres de rapport',
            'Configurer les préférences de rapport',
            onReportSettings!,
          ));
        }
        break;
    }

    return options;
  }

  Widget _buildOptionItem(
    BuildContext context,
    bool isLight,
    String iconName,
    String title,
    String subtitle,
    VoidCallback onTap,
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
