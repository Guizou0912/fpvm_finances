import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SyncStatusWidget extends StatelessWidget {
  final bool isOnline;
  final DateTime? lastSyncTime;
  final bool isSyncing;

  const SyncStatusWidget({
    Key? key,
    required this.isOnline,
    this.lastSyncTime,
    this.isSyncing = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: _getStatusColor().withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: _getStatusColor().withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          isSyncing
              ? SizedBox(
                  width: 4.w,
                  height: 4.w,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor:
                        AlwaysStoppedAnimation<Color>(_getStatusColor()),
                  ),
                )
              : CustomIconWidget(
                  iconName: _getStatusIcon(),
                  color: _getStatusColor(),
                  size: 16,
                ),
          SizedBox(width: 2.w),
          Text(
            _getStatusText(),
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: _getStatusColor(),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor() {
    if (isSyncing) return AppTheme.lightTheme.colorScheme.primary;
    if (isOnline) return AppTheme.successLight;
    return AppTheme.warningLight;
  }

  String _getStatusIcon() {
    if (isOnline) return 'cloud_done';
    return 'cloud_off';
  }

  String _getStatusText() {
    if (isSyncing) return 'Synchronisation...';
    if (isOnline) {
      if (lastSyncTime != null) {
        final difference = DateTime.now().difference(lastSyncTime!);
        if (difference.inMinutes < 1) {
          return 'Synchronisé';
        } else if (difference.inHours < 1) {
          return 'Sync il y a ${difference.inMinutes}min';
        } else if (difference.inDays < 1) {
          return 'Sync il y a ${difference.inHours}h';
        } else {
          return 'Sync il y a ${difference.inDays}j';
        }
      }
      return 'En ligne';
    }
    return 'Hors ligne';
  }
}
