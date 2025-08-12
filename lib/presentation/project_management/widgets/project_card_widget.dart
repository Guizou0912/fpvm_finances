import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ProjectCardWidget extends StatelessWidget {
  final Map<String, dynamic> project;
  final VoidCallback onTap;
  final VoidCallback onAddExpense;
  final VoidCallback onUpdateProgress;
  final VoidCallback onViewPhotos;
  final VoidCallback onEdit;
  final VoidCallback onArchive;
  final VoidCallback onGenerateReport;
  final VoidCallback onShare;

  const ProjectCardWidget({
    Key? key,
    required this.project,
    required this.onTap,
    required this.onAddExpense,
    required this.onUpdateProgress,
    required this.onViewPhotos,
    required this.onEdit,
    required this.onArchive,
    required this.onGenerateReport,
    required this.onShare,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String status = (project['status'] as String?) ?? 'active';
    final double progress = ((project['progress'] as num?) ?? 0).toDouble();
    final double budget = ((project['budget'] as num?) ?? 0).toDouble();
    final double spent = ((project['spent'] as num?) ?? 0).toDouble();
    final String projectType = (project['type'] as String?) ?? 'construction';

    Color statusColor = _getStatusColor(status);
    Color progressColor =
        spent > budget ? AppTheme.errorLight : AppTheme.successLight;

    return Dismissible(
      key: Key('project_${project['id']}'),
      direction: DismissDirection.endToStart,
      background: Container(
        margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.primaryColor,
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 4.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'add',
              color: Colors.white,
              size: 24,
            ),
            SizedBox(height: 0.5.h),
            Text(
              'Add Expense',
              style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
      onDismissed: (direction) => onAddExpense(),
      child: GestureDetector(
        onTap: onTap,
        onLongPress: () => _showContextMenu(context),
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: AppTheme.shadowLight,
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
            border: Border(
              left: BorderSide(
                color: statusColor,
                width: 4,
              ),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(4.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(2.w),
                      decoration: BoxDecoration(
                        color: statusColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: CustomIconWidget(
                        iconName: _getProjectIcon(projectType),
                        color: statusColor,
                        size: 20,
                      ),
                    ),
                    SizedBox(width: 3.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            (project['name'] as String?) ?? 'Unnamed Project',
                            style: AppTheme.lightTheme.textTheme.titleMedium
                                ?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 0.5.h),
                          Text(
                            _getProjectTypeLabel(projectType),
                            style: AppTheme.lightTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: AppTheme.textSecondaryLight,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 2.w, vertical: 0.5.h),
                      decoration: BoxDecoration(
                        color: statusColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        _getStatusLabel(status),
                        style:
                            AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                          color: statusColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 3.h),
                Row(
                  children: [
                    Text(
                      'Progress',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.textSecondaryLight,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '${progress.toInt()}%',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: progressColor,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 1.h),
                LinearProgressIndicator(
                  value: progress / 100,
                  backgroundColor: AppTheme.borderLight,
                  valueColor: AlwaysStoppedAnimation<Color>(progressColor),
                  minHeight: 6,
                ),
                SizedBox(height: 2.h),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Budget',
                            style: AppTheme.lightTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: AppTheme.textSecondaryLight,
                            ),
                          ),
                          SizedBox(height: 0.5.h),
                          Text(
                            '${budget.toStringAsFixed(0)} MGA',
                            style: AppTheme.lightTheme.textTheme.bodyMedium
                                ?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Spent',
                            style: AppTheme.lightTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: AppTheme.textSecondaryLight,
                            ),
                          ),
                          SizedBox(height: 0.5.h),
                          Text(
                            '${spent.toStringAsFixed(0)} MGA',
                            style: AppTheme.lightTheme.textTheme.bodyMedium
                                ?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: spent > budget
                                  ? AppTheme.errorLight
                                  : AppTheme.textPrimaryLight,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Remaining',
                            style: AppTheme.lightTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: AppTheme.textSecondaryLight,
                            ),
                          ),
                          SizedBox(height: 0.5.h),
                          Text(
                            '${(budget - spent).toStringAsFixed(0)} MGA',
                            style: AppTheme.lightTheme.textTheme.bodyMedium
                                ?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: (budget - spent) < 0
                                  ? AppTheme.errorLight
                                  : AppTheme.successLight,
                            ),
                          ),
                        ],
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
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return AppTheme.successLight;
      case 'over-budget':
        return AppTheme.warningLight;
      case 'on-hold':
        return AppTheme.errorLight;
      default:
        return AppTheme.lightTheme.primaryColor;
    }
  }

  String _getProjectIcon(String type) {
    switch (type.toLowerCase()) {
      case 'construction':
        return 'construction';
      case 'renovation':
        return 'home_repair_service';
      case 'equipment':
        return 'build';
      default:
        return 'work';
    }
  }

  String _getProjectTypeLabel(String type) {
    switch (type.toLowerCase()) {
      case 'construction':
        return 'Construction';
      case 'renovation':
        return 'Rénovation';
      case 'equipment':
        return 'Équipement';
      default:
        return 'Projet';
    }
  }

  String _getStatusLabel(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return 'Actif';
      case 'completed':
        return 'Terminé';
      case 'over-budget':
        return 'Dépassé';
      case 'on-hold':
        return 'En attente';
      default:
        return 'Actif';
    }
  }

  void _showContextMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.lightTheme.colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: AppTheme.borderLight,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              'Actions du projet',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 2.h),
            _buildContextMenuItem(
              context,
              'Modifier',
              'edit',
              onEdit,
            ),
            _buildContextMenuItem(
              context,
              'Archiver',
              'archive',
              onArchive,
            ),
            _buildContextMenuItem(
              context,
              'Générer un rapport',
              'assessment',
              onGenerateReport,
            ),
            _buildContextMenuItem(
              context,
              'Partager les mises à jour',
              'share',
              onShare,
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  Widget _buildContextMenuItem(
    BuildContext context,
    String title,
    String iconName,
    VoidCallback onTap,
  ) {
    return ListTile(
      leading: CustomIconWidget(
        iconName: iconName,
        color: AppTheme.textSecondaryLight,
        size: 20,
      ),
      title: Text(
        title,
        style: AppTheme.lightTheme.textTheme.bodyMedium,
      ),
      onTap: () {
        Navigator.pop(context);
        onTap();
      },
    );
  }
}
