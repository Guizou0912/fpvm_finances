import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class QuickStatsWidget extends StatelessWidget {
  final double monthlyIncome;
  final double monthlyExpenses;
  final double incomeChange;
  final double expenseChange;
  final bool isLoading;

  const QuickStatsWidget({
    Key? key,
    required this.monthlyIncome,
    required this.monthlyExpenses,
    required this.incomeChange,
    required this.expenseChange,
    this.isLoading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Row(
        children: [
          Expanded(
            child: _buildStatCard(
              title: 'Revenus du Mois',
              amount: monthlyIncome,
              change: incomeChange,
              isPositive: incomeChange >= 0,
              icon: 'trending_up',
              color: AppTheme.successLight,
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: _buildStatCard(
              title: 'Dépenses du Mois',
              amount: monthlyExpenses,
              change: expenseChange,
              isPositive: expenseChange <= 0,
              icon: 'trending_down',
              color: AppTheme.errorLight,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required double amount,
    required double change,
    required bool isPositive,
    required String icon,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppTheme.lightTheme.colorScheme.shadow,
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  title,
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              CustomIconWidget(
                iconName: icon,
                color: color,
                size: 20,
              ),
            ],
          ),
          SizedBox(height: 1.h),
          isLoading
              ? Container(
                  height: 2.5.h,
                  width: 20.w,
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.outline
                        .withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                )
              : Text(
                  '${amount.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]} ')} MGA',
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    color: color,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
          SizedBox(height: 0.5.h),
          Row(
            children: [
              CustomIconWidget(
                iconName: isPositive ? 'arrow_upward' : 'arrow_downward',
                color: isPositive ? AppTheme.successLight : AppTheme.errorLight,
                size: 16,
              ),
              SizedBox(width: 1.w),
              Flexible(
                child: Text(
                  '${change.abs().toStringAsFixed(1)}%',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: isPositive
                        ? AppTheme.successLight
                        : AppTheme.errorLight,
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
