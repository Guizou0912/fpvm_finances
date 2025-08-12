import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class TransactionCard extends StatelessWidget {
  final Map<String, dynamic> transaction;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onDuplicate;
  final VoidCallback? onViewDetails;
  final VoidCallback? onShare;
  final VoidCallback? onExport;
  final VoidCallback? onAddToProject;
  final String userRole;

  const TransactionCard({
    Key? key,
    required this.transaction,
    this.onTap,
    this.onEdit,
    this.onDelete,
    this.onDuplicate,
    this.onViewDetails,
    this.onShare,
    this.onExport,
    this.onAddToProject,
    required this.userRole,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isIncome =
        (transaction['type'] as String).toLowerCase() == 'income';
    final String amount = transaction['amount'] as String;
    final String category = transaction['category'] as String;
    final String date = transaction['date'] as String;
    final String description = transaction['description'] as String;
    final String? receiptUrl = transaction['receiptUrl'] as String?;

    return Dismissible(
      key: Key('transaction_${transaction['id']}'),
      background: _buildSwipeBackground(isLeftSwipe: false),
      secondaryBackground: _buildSwipeBackground(isLeftSwipe: true),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          // Right swipe - Edit/Delete for Admin/Treasurer
          if (userRole == 'Admin' || userRole == 'Treasurer') {
            _showEditDeleteOptions(context);
          }
        } else {
          // Left swipe - Duplicate for Admin/Treasurer, View Details for Observer
          if (userRole == 'Observer') {
            onViewDetails?.call();
          } else {
            onDuplicate?.call();
          }
        }
        return false; // Don't actually dismiss
      },
      child: GestureDetector(
        onTap: onTap,
        onLongPress: () => _showContextMenu(context),
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppTheme.lightTheme.colorScheme.outline
                  .withValues(alpha: 0.2),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.all(4.w),
            child: Row(
              children: [
                // Amount and type indicator
                Container(
                  width: 20.w,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 2.w, vertical: 0.5.h),
                        decoration: BoxDecoration(
                          color: isIncome
                              ? AppTheme.lightTheme.colorScheme.tertiary
                                  .withValues(alpha: 0.1)
                              : AppTheme.lightTheme.colorScheme.error
                                  .withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CustomIconWidget(
                              iconName:
                                  isIncome ? 'arrow_downward' : 'arrow_upward',
                              color: isIncome
                                  ? AppTheme.lightTheme.colorScheme.tertiary
                                  : AppTheme.lightTheme.colorScheme.error,
                              size: 12.sp,
                            ),
                            SizedBox(width: 1.w),
                            Text(
                              isIncome ? 'IN' : 'OUT',
                              style: AppTheme.lightTheme.textTheme.labelSmall
                                  ?.copyWith(
                                color: isIncome
                                    ? AppTheme.lightTheme.colorScheme.tertiary
                                    : AppTheme.lightTheme.colorScheme.error,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 1.h),
                      Text(
                        amount,
                        style:
                            AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                          color: isIncome
                              ? AppTheme.lightTheme.colorScheme.tertiary
                              : AppTheme.lightTheme.colorScheme.error,
                          fontWeight: FontWeight.w700,
                          fontSize: 16.sp,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),

                SizedBox(width: 4.w),

                // Transaction details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              category,
                              style: AppTheme.lightTheme.textTheme.titleMedium
                                  ?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            date,
                            style: AppTheme.lightTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 0.5.h),
                      Text(
                        description,
                        style:
                            AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),

                // Receipt thumbnail
                if (receiptUrl != null) ...[
                  SizedBox(width: 3.w),
                  Container(
                    width: 12.w,
                    height: 12.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: AppTheme.lightTheme.colorScheme.outline
                            .withValues(alpha: 0.3),
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(7),
                      child: CustomImageWidget(
                        imageUrl: receiptUrl,
                        width: 12.w,
                        height: 12.w,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],

                SizedBox(width: 2.w),

                // More options indicator
                CustomIconWidget(
                  iconName: 'more_vert',
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  size: 18.sp,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSwipeBackground({required bool isLeftSwipe}) {
    if (isLeftSwipe) {
      // Left swipe - Duplicate or View Details
      final bool isObserver = userRole == 'Observer';
      return Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 6.w),
        margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
        decoration: BoxDecoration(
          color: isObserver
              ? AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1)
              : AppTheme.lightTheme.colorScheme.tertiary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: isObserver ? 'visibility' : 'content_copy',
              color: isObserver
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.lightTheme.colorScheme.tertiary,
              size: 24.sp,
            ),
            SizedBox(height: 0.5.h),
            Text(
              isObserver ? 'Voir' : 'Dupliquer',
              style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                color: isObserver
                    ? AppTheme.lightTheme.colorScheme.primary
                    : AppTheme.lightTheme.colorScheme.tertiary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      );
    } else {
      // Right swipe - Edit/Delete for Admin/Treasurer only
      if (userRole == 'Observer') return Container();

      return Container(
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.only(left: 6.w),
        margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.error.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'edit',
              color: AppTheme.lightTheme.colorScheme.error,
              size: 24.sp,
            ),
            SizedBox(height: 0.5.h),
            Text(
              'Modifier',
              style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.error,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      );
    }
  }

  void _showEditDeleteOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.lightTheme.colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(6.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 3.h),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'edit',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24.sp,
              ),
              title: Text(
                'Modifier la transaction',
                style: AppTheme.lightTheme.textTheme.titleMedium,
              ),
              onTap: () {
                Navigator.pop(context);
                onEdit?.call();
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'delete',
                color: AppTheme.lightTheme.colorScheme.error,
                size: 24.sp,
              ),
              title: Text(
                'Supprimer la transaction',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.error,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                onDelete?.call();
              },
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  void _showContextMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.lightTheme.colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(6.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 3.h),
            if (userRole != 'Observer') ...[
              ListTile(
                leading: CustomIconWidget(
                  iconName: 'edit',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 24.sp,
                ),
                title: Text(
                  'Modifier',
                  style: AppTheme.lightTheme.textTheme.titleMedium,
                ),
                onTap: () {
                  Navigator.pop(context);
                  onEdit?.call();
                },
              ),
              ListTile(
                leading: CustomIconWidget(
                  iconName: 'content_copy',
                  color: AppTheme.lightTheme.colorScheme.tertiary,
                  size: 24.sp,
                ),
                title: Text(
                  'Dupliquer',
                  style: AppTheme.lightTheme.textTheme.titleMedium,
                ),
                onTap: () {
                  Navigator.pop(context);
                  onDuplicate?.call();
                },
              ),
            ],
            ListTile(
              leading: CustomIconWidget(
                iconName: 'visibility',
                color: AppTheme.lightTheme.colorScheme.secondary,
                size: 24.sp,
              ),
              title: Text(
                'Voir les détails',
                style: AppTheme.lightTheme.textTheme.titleMedium,
              ),
              onTap: () {
                Navigator.pop(context);
                onViewDetails?.call();
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'share',
                color: AppTheme.lightTheme.colorScheme.secondary,
                size: 24.sp,
              ),
              title: Text(
                'Partager',
                style: AppTheme.lightTheme.textTheme.titleMedium,
              ),
              onTap: () {
                Navigator.pop(context);
                onShare?.call();
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'file_download',
                color: AppTheme.lightTheme.colorScheme.secondary,
                size: 24.sp,
              ),
              title: Text(
                'Exporter',
                style: AppTheme.lightTheme.textTheme.titleMedium,
              ),
              onTap: () {
                Navigator.pop(context);
                onExport?.call();
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'add_box',
                color: AppTheme.lightTheme.colorScheme.tertiary,
                size: 24.sp,
              ),
              title: Text(
                'Ajouter au projet',
                style: AppTheme.lightTheme.textTheme.titleMedium,
              ),
              onTap: () {
                Navigator.pop(context);
                onAddToProject?.call();
              },
            ),
            if (userRole != 'Observer') ...[
              Divider(height: 3.h),
              ListTile(
                leading: CustomIconWidget(
                  iconName: 'delete',
                  color: AppTheme.lightTheme.colorScheme.error,
                  size: 24.sp,
                ),
                title: Text(
                  'Supprimer',
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.error,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  onDelete?.call();
                },
              ),
            ],
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }
}
