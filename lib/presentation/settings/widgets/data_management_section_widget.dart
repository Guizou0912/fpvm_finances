import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class DataManagementSectionWidget extends StatelessWidget {
  final VoidCallback onExportPDF;
  final VoidCallback onExportExcel;
  final DateTime? lastBackup;
  final String offlineDataSize;
  final VoidCallback onClearCache;

  const DataManagementSectionWidget({
    Key? key,
    required this.onExportPDF,
    required this.onExportExcel,
    this.lastBackup,
    required this.offlineDataSize,
    required this.onClearCache,
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
            'Gestion des données',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: isLight
                      ? AppTheme.textPrimaryLight
                      : AppTheme.textPrimaryDark,
                ),
          ),
          SizedBox(height: 2.h),
          _buildExportOptions(context, isLight),
          SizedBox(height: 2.h),
          _buildBackupStatus(context, isLight),
          SizedBox(height: 2.h),
          _buildCacheManagement(context, isLight),
        ],
      ),
    );
  }

  Widget _buildExportOptions(BuildContext context, bool isLight) {
    return Column(
      children: [
        GestureDetector(
          onTap: onExportPDF,
          child: Row(
            children: [
              CustomIconWidget(
                iconName: 'picture_as_pdf',
                color: isLight ? AppTheme.errorLight : AppTheme.errorDark,
                size: 6.w,
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Exporter en PDF',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                            color: isLight
                                ? AppTheme.textPrimaryLight
                                : AppTheme.textPrimaryDark,
                          ),
                    ),
                    Text(
                      'Télécharger les données au format PDF',
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
        ),
        SizedBox(height: 2.h),
        GestureDetector(
          onTap: onExportExcel,
          child: Row(
            children: [
              CustomIconWidget(
                iconName: 'table_chart',
                color: isLight ? AppTheme.successLight : AppTheme.successDark,
                size: 6.w,
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Exporter en Excel',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                            color: isLight
                                ? AppTheme.textPrimaryLight
                                : AppTheme.textPrimaryDark,
                          ),
                    ),
                    Text(
                      'Télécharger les données au format Excel',
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
        ),
      ],
    );
  }

  Widget _buildBackupStatus(BuildContext context, bool isLight) {
    final String backupText = lastBackup != null
        ? 'Dernière sauvegarde: ${_formatDate(lastBackup!)}'
        : 'Aucune sauvegarde récente';

    return Row(
      children: [
        CustomIconWidget(
          iconName: 'backup',
          color: isLight ? AppTheme.primaryLight : AppTheme.primaryDark,
          size: 6.w,
        ),
        SizedBox(width: 3.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'État de sauvegarde',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: isLight
                          ? AppTheme.textPrimaryLight
                          : AppTheme.textPrimaryDark,
                    ),
              ),
              Text(
                backupText,
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
            color: lastBackup != null
                ? (isLight
                    ? AppTheme.successLight.withValues(alpha: 0.1)
                    : AppTheme.successDark.withValues(alpha: 0.1))
                : (isLight
                    ? AppTheme.warningLight.withValues(alpha: 0.1)
                    : AppTheme.warningDark.withValues(alpha: 0.1)),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            lastBackup != null ? 'Actif' : 'Inactif',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: lastBackup != null
                      ? (isLight ? AppTheme.successLight : AppTheme.successDark)
                      : (isLight
                          ? AppTheme.warningLight
                          : AppTheme.warningDark),
                  fontWeight: FontWeight.w500,
                ),
          ),
        ),
      ],
    );
  }

  Widget _buildCacheManagement(BuildContext context, bool isLight) {
    return GestureDetector(
      onTap: onClearCache,
      child: Row(
        children: [
          CustomIconWidget(
            iconName: 'storage',
            color: isLight ? AppTheme.primaryLight : AppTheme.primaryDark,
            size: 6.w,
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Données hors ligne',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: isLight
                            ? AppTheme.textPrimaryLight
                            : AppTheme.textPrimaryDark,
                      ),
                ),
                Text(
                  'Taille: $offlineDataSize - Appuyez pour vider le cache',
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
            iconName: 'delete_outline',
            color: isLight ? AppTheme.errorLight : AppTheme.errorDark,
            size: 5.w,
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year} à ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
}
