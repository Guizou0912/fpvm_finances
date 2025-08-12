import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class EmptyStateWidget extends StatelessWidget {
  final String userRole;
  final bool hasActiveFilters;
  final VoidCallback? onAddTransaction;
  final VoidCallback? onClearFilters;

  const EmptyStateWidget({
    Key? key,
    required this.userRole,
    required this.hasActiveFilters,
    this.onAddTransaction,
    this.onClearFilters,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (hasActiveFilters) {
      return _buildNoResultsState(context);
    } else {
      return _buildEmptyTransactionsState(context);
    }
  }

  Widget _buildNoResultsState(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(8.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Illustration
            Container(
              width: 40.w,
              height: 40.w,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.primary
                    .withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: CustomIconWidget(
                  iconName: 'search_off',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 60.sp,
                ),
              ),
            ),

            SizedBox(height: 4.h),

            // Title
            Text(
              'Aucun résultat trouvé',
              style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppTheme.lightTheme.colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 2.h),

            // Description
            Text(
              'Aucune transaction ne correspond à vos critères de recherche. Essayez de modifier vos filtres ou votre recherche.',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 4.h),

            // Action buttons
            Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: onClearFilters,
                    icon: CustomIconWidget(
                      iconName: 'clear_all',
                      color: Colors.white,
                      size: 20.sp,
                    ),
                    label: Text('Effacer les filtres'),
                  ),
                ),
                if (userRole != 'Observer') ...[
                  SizedBox(height: 2.h),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: onAddTransaction,
                      icon: CustomIconWidget(
                        iconName: 'add',
                        color: AppTheme.lightTheme.colorScheme.primary,
                        size: 20.sp,
                      ),
                      label: Text('Ajouter une transaction'),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyTransactionsState(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(8.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Illustration
            Container(
              width: 50.w,
              height: 50.w,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.primary
                    .withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: CustomIconWidget(
                  iconName: 'receipt_long',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 80.sp,
                ),
              ),
            ),

            SizedBox(height: 4.h),

            // Title
            Text(
              userRole == 'Observer'
                  ? 'Aucune transaction disponible'
                  : 'Commencez à enregistrer',
              style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppTheme.lightTheme.colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 2.h),

            // Description
            Text(
              userRole == 'Observer'
                  ? 'Il n\'y a pas encore de transactions enregistrées dans le système. Les transactions apparaîtront ici une fois qu\'elles seront ajoutées par les administrateurs.'
                  : 'Vous n\'avez pas encore de transactions enregistrées. Commencez par ajouter vos premiers revenus et dépenses pour suivre les finances de votre église.',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 4.h),

            // Action button for non-observers
            if (userRole != 'Observer')
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: onAddTransaction,
                  icon: CustomIconWidget(
                    iconName: 'add',
                    color: Colors.white,
                    size: 24.sp,
                  ),
                  label: Text('Ajouter ma première transaction'),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 2.h),
                  ),
                ),
              ),

            // Tips section
            SizedBox(height: 6.h),
            Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.tertiary
                    .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppTheme.lightTheme.colorScheme.tertiary
                      .withValues(alpha: 0.3),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'lightbulb',
                        color: AppTheme.lightTheme.colorScheme.tertiary,
                        size: 20.sp,
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        'Conseils pour commencer',
                        style:
                            AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.tertiary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 2.h),
                  _buildTip(
                      'Enregistrez d\'abord vos revenus réguliers (dîmes, offrandes)'),
                  _buildTip('Ajoutez vos dépenses avec des photos de reçus'),
                  _buildTip(
                      'Utilisez des catégories claires pour faciliter le suivi'),
                  _buildTip('Synchronisez régulièrement avec le cloud'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTip(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 1.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(top: 0.5.h),
            width: 1.w,
            height: 1.w,
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.tertiary,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Text(
              text,
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
