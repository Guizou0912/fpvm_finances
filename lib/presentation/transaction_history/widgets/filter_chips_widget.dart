import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class FilterChipsWidget extends StatelessWidget {
  final Map<String, dynamic> activeFilters;
  final Function(String) onFilterRemoved;
  final VoidCallback onClearAll;

  const FilterChipsWidget({
    Key? key,
    required this.activeFilters,
    required this.onFilterRemoved,
    required this.onClearAll,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (activeFilters.isEmpty) return const SizedBox.shrink();

    final List<Widget> chips = [];

    // Date range chip
    if (activeFilters['dateRange'] != null) {
      final DateTimeRange dateRange =
          activeFilters['dateRange'] as DateTimeRange;
      chips.add(_buildFilterChip(
        context,
        'dateRange',
        '${_formatDate(dateRange.start)} - ${_formatDate(dateRange.end)}',
        CustomIconWidget(
          iconName: 'date_range',
          color: AppTheme.lightTheme.colorScheme.primary,
          size: 16.sp,
        ),
      ));
    }

    // Transaction types chip
    if (activeFilters['transactionTypes'] != null) {
      final List<String> types =
          activeFilters['transactionTypes'] as List<String>;
      if (types.length == 1) {
        chips.add(_buildFilterChip(
          context,
          'transactionTypes',
          types.first == 'income' ? 'Revenus' : 'Dépenses',
          CustomIconWidget(
            iconName:
                types.first == 'income' ? 'arrow_downward' : 'arrow_upward',
            color: types.first == 'income'
                ? AppTheme.lightTheme.colorScheme.tertiary
                : AppTheme.lightTheme.colorScheme.error,
            size: 16.sp,
          ),
        ));
      }
    }

    // Categories chips
    if (activeFilters['categories'] != null) {
      final List<String> categories =
          activeFilters['categories'] as List<String>;
      if (categories.length <= 3) {
        for (String category in categories) {
          chips.add(_buildFilterChip(
            context,
            'category_$category',
            category,
            CustomIconWidget(
              iconName: 'category',
              color: AppTheme.lightTheme.colorScheme.secondary,
              size: 16.sp,
            ),
          ));
        }
      } else {
        chips.add(_buildFilterChip(
          context,
          'categories',
          '${categories.length} catégories',
          CustomIconWidget(
            iconName: 'category',
            color: AppTheme.lightTheme.colorScheme.secondary,
            size: 16.sp,
          ),
        ));
      }
    }

    // Amount range chip
    if (activeFilters['amountRange'] != null) {
      final RangeValues amountRange =
          activeFilters['amountRange'] as RangeValues;
      chips.add(_buildFilterChip(
        context,
        'amountRange',
        '${_formatAmount(amountRange.start)} - ${_formatAmount(amountRange.end)}',
        CustomIconWidget(
          iconName: 'attach_money',
          color: AppTheme.lightTheme.colorScheme.tertiary,
          size: 16.sp,
        ),
      ));
    }

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Filtres actifs (${_getTotalFiltersCount()})',
                style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: onClearAll,
                style: TextButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  'Tout effacer',
                  style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.error,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          Wrap(
            spacing: 2.w,
            runSpacing: 1.h,
            children: chips,
          ),
          SizedBox(height: 2.h),
        ],
      ),
    );
  }

  Widget _buildFilterChip(
    BuildContext context,
    String filterKey,
    String label,
    Widget icon,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.3),
        ),
      ),
      child: IntrinsicWidth(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 3.w, top: 1.h, bottom: 1.h),
              child: icon,
            ),
            SizedBox(width: 2.w),
            Flexible(
              child: Padding(
                padding: EdgeInsets.only(top: 1.h, bottom: 1.h),
                child: Text(
                  label,
                  style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            GestureDetector(
              onTap: () => onFilterRemoved(filterKey),
              child: Padding(
                padding: EdgeInsets.all(2.w),
                child: CustomIconWidget(
                  iconName: 'close',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 16.sp,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  String _formatAmount(double amount) {
    return '${amount.toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]} ')} MGA';
  }

  int _getTotalFiltersCount() {
    int count = 0;

    if (activeFilters['dateRange'] != null) count++;
    if (activeFilters['transactionTypes'] != null) count++;
    if (activeFilters['categories'] != null) {
      final List<String> categories =
          activeFilters['categories'] as List<String>;
      count += categories.length;
    }
    if (activeFilters['amountRange'] != null) count++;

    return count;
  }
}
