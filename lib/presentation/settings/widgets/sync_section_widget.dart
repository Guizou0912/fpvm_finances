import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SyncSectionWidget extends StatefulWidget {
  final DateTime? lastSyncTime;
  final bool isSyncing;
  final String connectionStatus;
  final VoidCallback onManualSync;

  const SyncSectionWidget({
    Key? key,
    this.lastSyncTime,
    required this.isSyncing,
    required this.connectionStatus,
    required this.onManualSync,
  }) : super(key: key);

  @override
  State<SyncSectionWidget> createState() => _SyncSectionWidgetState();
}

class _SyncSectionWidgetState extends State<SyncSectionWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    );

    if (widget.isSyncing) {
      _animationController.repeat();
    }
  }

  @override
  void didUpdateWidget(SyncSectionWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isSyncing && !oldWidget.isSyncing) {
      _animationController.repeat();
    } else if (!widget.isSyncing && oldWidget.isSyncing) {
      _animationController.stop();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

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
            'Synchronisation',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: isLight
                      ? AppTheme.textPrimaryLight
                      : AppTheme.textPrimaryDark,
                ),
          ),
          SizedBox(height: 2.h),
          _buildLastSyncInfo(context, isLight),
          SizedBox(height: 2.h),
          _buildManualSyncButton(context, isLight),
          SizedBox(height: 2.h),
          _buildConnectionStatus(context, isLight),
        ],
      ),
    );
  }

  Widget _buildLastSyncInfo(BuildContext context, bool isLight) {
    final String syncText = widget.lastSyncTime != null
        ? 'Dernière sync: ${_formatDate(widget.lastSyncTime!)}'
        : 'Aucune synchronisation récente';

    return Row(
      children: [
        CustomIconWidget(
          iconName: 'history',
          color: isLight ? AppTheme.primaryLight : AppTheme.primaryDark,
          size: 6.w,
        ),
        SizedBox(width: 3.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Historique de synchronisation',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: isLight
                          ? AppTheme.textPrimaryLight
                          : AppTheme.textPrimaryDark,
                    ),
              ),
              Text(
                syncText,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: isLight
                          ? AppTheme.textSecondaryLight
                          : AppTheme.textSecondaryDark,
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildManualSyncButton(BuildContext context, bool isLight) {
    return GestureDetector(
      onTap: widget.isSyncing ? null : widget.onManualSync,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
        decoration: BoxDecoration(
          color: widget.isSyncing
              ? (isLight
                  ? AppTheme.textSecondaryLight.withValues(alpha: 0.1)
                  : AppTheme.textSecondaryDark.withValues(alpha: 0.1))
              : (isLight
                  ? AppTheme.primaryLight.withValues(alpha: 0.1)
                  : AppTheme.primaryDark.withValues(alpha: 0.1)),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: widget.isSyncing
                ? (isLight
                    ? AppTheme.textSecondaryLight
                    : AppTheme.textSecondaryDark)
                : (isLight ? AppTheme.primaryLight : AppTheme.primaryDark),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (widget.isSyncing)
              RotationTransition(
                turns: _animationController,
                child: CustomIconWidget(
                  iconName: 'sync',
                  color: isLight
                      ? AppTheme.textSecondaryLight
                      : AppTheme.textSecondaryDark,
                  size: 5.w,
                ),
              )
            else
              CustomIconWidget(
                iconName: 'sync',
                color: isLight ? AppTheme.primaryLight : AppTheme.primaryDark,
                size: 5.w,
              ),
            SizedBox(width: 2.w),
            Text(
              widget.isSyncing
                  ? 'Synchronisation en cours...'
                  : 'Synchroniser maintenant',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: widget.isSyncing
                        ? (isLight
                            ? AppTheme.textSecondaryLight
                            : AppTheme.textSecondaryDark)
                        : (isLight
                            ? AppTheme.primaryLight
                            : AppTheme.primaryDark),
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConnectionStatus(BuildContext context, bool isLight) {
    Color statusColor;
    String statusIcon;

    switch (widget.connectionStatus.toLowerCase()) {
      case 'connecté':
        statusColor = isLight ? AppTheme.successLight : AppTheme.successDark;
        statusIcon = 'wifi';
        break;
      case 'déconnecté':
        statusColor = isLight ? AppTheme.errorLight : AppTheme.errorDark;
        statusIcon = 'wifi_off';
        break;
      case 'limité':
        statusColor = isLight ? AppTheme.warningLight : AppTheme.warningDark;
        statusIcon = 'signal_wifi_bad';
        break;
      default:
        statusColor =
            isLight ? AppTheme.textSecondaryLight : AppTheme.textSecondaryDark;
        statusIcon = 'help_outline';
    }

    return Row(
      children: [
        CustomIconWidget(
          iconName: statusIcon,
          color: statusColor,
          size: 6.w,
        ),
        SizedBox(width: 3.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'État de connexion',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: isLight
                          ? AppTheme.textPrimaryLight
                          : AppTheme.textPrimaryDark,
                    ),
              ),
              Text(
                widget.connectionStatus,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: isLight
                          ? AppTheme.textSecondaryLight
                          : AppTheme.textSecondaryDark,
                    ),
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
          decoration: BoxDecoration(
            color: statusColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            widget.connectionStatus,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: statusColor,
                  fontWeight: FontWeight.w500,
                ),
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year} à ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
}
