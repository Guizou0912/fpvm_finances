import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class NotificationSectionWidget extends StatelessWidget {
  final Map<String, bool> notificationSettings;
  final Function(String, bool) onNotificationToggle;

  const NotificationSectionWidget({
    Key? key,
    required this.notificationSettings,
    required this.onNotificationToggle,
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
            'Notifications',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: isLight
                      ? AppTheme.textPrimaryLight
                      : AppTheme.textPrimaryDark,
                ),
          ),
          SizedBox(height: 2.h),
          _buildNotificationItem(
            context,
            isLight,
            'notifications',
            'Alertes de transaction',
            'Recevoir des notifications pour les nouvelles transactions',
            'transactionAlerts',
          ),
          SizedBox(height: 2.h),
          _buildNotificationItem(
            context,
            isLight,
            'assignment_turned_in',
            'Rapports terminés',
            'Notification quand un rapport est généré',
            'reportCompletion',
          ),
          SizedBox(height: 2.h),
          _buildNotificationItem(
            context,
            isLight,
            'warning',
            'Alertes budgétaires',
            'Avertissements de dépassement de budget',
            'budgetWarnings',
          ),
          SizedBox(height: 2.h),
          _buildNotificationItem(
            context,
            isLight,
            'sync',
            'État de synchronisation',
            'Notifications de synchronisation des données',
            'syncStatus',
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationItem(
    BuildContext context,
    bool isLight,
    String iconName,
    String title,
    String subtitle,
    String settingKey,
  ) {
    final bool isEnabled = notificationSettings[settingKey] ?? false;

    return Row(
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
        Switch(
          value: isEnabled,
          onChanged: (value) => onNotificationToggle(settingKey, value),
          activeColor: isLight ? AppTheme.primaryLight : AppTheme.primaryDark,
        ),
      ],
    );
  }
}
