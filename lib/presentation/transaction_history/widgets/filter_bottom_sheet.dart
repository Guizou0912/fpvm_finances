import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class FilterBottomSheet extends StatefulWidget {
  final Map<String, dynamic> currentFilters;
  final Function(Map<String, dynamic>) onFiltersApplied;

  const FilterBottomSheet({
    Key? key,
    required this.currentFilters,
    required this.onFiltersApplied,
  }) : super(key: key);

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  late Map<String, dynamic> _filters;
  DateTimeRange? _selectedDateRange;
  List<String> _selectedCategories = [];
  RangeValues _amountRange = const RangeValues(0, 10000000);
  Set<String> _selectedTransactionTypes = {'income', 'expense'};

  final List<String> _availableCategories = [
    'Dîmes',
    'Offrandes',
    'Dons',
    'Collections spéciales',
    'Ventes',
    'Salaires',
    'Électricité',
    'Eau',
    'Téléphone',
    'Internet',
    'Carburant',
    'Maintenance',
    'Fournitures',
    'Événements',
    'Formation',
    'Autres',
  ];

  @override
  void initState() {
    super.initState();
    _filters = Map<String, dynamic>.from(widget.currentFilters);
    _initializeFilters();
  }

  void _initializeFilters() {
    if (_filters['dateRange'] != null) {
      _selectedDateRange = _filters['dateRange'] as DateTimeRange;
    }

    if (_filters['categories'] != null) {
      _selectedCategories = List<String>.from(_filters['categories']);
    }

    if (_filters['amountRange'] != null) {
      _amountRange = _filters['amountRange'] as RangeValues;
    }

    if (_filters['transactionTypes'] != null) {
      _selectedTransactionTypes =
          Set<String>.from(_filters['transactionTypes']);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 85.h,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: EdgeInsets.only(top: 2.h),
            width: 12.w,
            height: 0.5.h,
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.outline
                  .withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: EdgeInsets.all(6.w),
            child: Row(
              children: [
                Text(
                  'Filtres',
                  style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: _clearAllFilters,
                  child: Text(
                    'Tout effacer',
                    style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.error,
                    ),
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 6.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Date Range Section
                  _buildSectionTitle('Période'),
                  SizedBox(height: 2.h),
                  _buildDateRangeSelector(),

                  SizedBox(height: 4.h),

                  // Transaction Types Section
                  _buildSectionTitle('Type de transaction'),
                  SizedBox(height: 2.h),
                  _buildTransactionTypeSelector(),

                  SizedBox(height: 4.h),

                  // Categories Section
                  _buildSectionTitle('Catégories'),
                  SizedBox(height: 2.h),
                  _buildCategorySelector(),

                  SizedBox(height: 4.h),

                  // Amount Range Section
                  _buildSectionTitle('Montant (MGA)'),
                  SizedBox(height: 2.h),
                  _buildAmountRangeSelector(),

                  SizedBox(height: 6.h),
                ],
              ),
            ),
          ),

          // Action buttons
          Container(
            padding: EdgeInsets.all(6.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surface,
              border: Border(
                top: BorderSide(
                  color: AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.2),
                ),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Annuler'),
                  ),
                ),
                SizedBox(width: 4.w),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _applyFilters,
                    child: Text('Appliquer'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildDateRangeSelector() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3),
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: CustomIconWidget(
          iconName: 'date_range',
          color: AppTheme.lightTheme.colorScheme.primary,
          size: 24.sp,
        ),
        title: Text(
          _selectedDateRange != null
              ? '${_formatDate(_selectedDateRange!.start)} - ${_formatDate(_selectedDateRange!.end)}'
              : 'Sélectionner une période',
          style: AppTheme.lightTheme.textTheme.bodyMedium,
        ),
        trailing: _selectedDateRange != null
            ? IconButton(
                onPressed: () {
                  setState(() {
                    _selectedDateRange = null;
                  });
                },
                icon: CustomIconWidget(
                  iconName: 'clear',
                  color: AppTheme.lightTheme.colorScheme.error,
                  size: 20.sp,
                ),
              )
            : null,
        onTap: _selectDateRange,
      ),
    );
  }

  Widget _buildTransactionTypeSelector() {
    return Wrap(
      spacing: 2.w,
      runSpacing: 1.h,
      children: [
        _buildTypeChip('income', 'Revenus', Colors.green),
        _buildTypeChip('expense', 'Dépenses', Colors.red),
      ],
    );
  }

  Widget _buildTypeChip(String type, String label, Color color) {
    final bool isSelected = _selectedTransactionTypes.contains(type);
    return FilterChip(
      selected: isSelected,
      label: Text(label),
      onSelected: (selected) {
        setState(() {
          if (selected) {
            _selectedTransactionTypes.add(type);
          } else {
            _selectedTransactionTypes.remove(type);
          }
        });
      },
      selectedColor: color.withValues(alpha: 0.2),
      checkmarkColor: color,
      labelStyle: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
        color: isSelected ? color : AppTheme.lightTheme.colorScheme.onSurface,
      ),
    );
  }

  Widget _buildCategorySelector() {
    return Container(
      constraints: BoxConstraints(maxHeight: 25.h),
      child: SingleChildScrollView(
        child: Wrap(
          spacing: 2.w,
          runSpacing: 1.h,
          children: _availableCategories.map((category) {
            final bool isSelected = _selectedCategories.contains(category);
            return FilterChip(
              selected: isSelected,
              label: Text(category),
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    _selectedCategories.add(category);
                  } else {
                    _selectedCategories.remove(category);
                  }
                });
              },
              selectedColor: AppTheme.lightTheme.colorScheme.primary
                  .withValues(alpha: 0.2),
              checkmarkColor: AppTheme.lightTheme.colorScheme.primary,
              labelStyle: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: isSelected
                    ? AppTheme.lightTheme.colorScheme.primary
                    : AppTheme.lightTheme.colorScheme.onSurface,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildAmountRangeSelector() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${_amountRange.start.toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]} ')} MGA',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              '${_amountRange.end.toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]} ')} MGA',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        SizedBox(height: 1.h),
        RangeSlider(
          values: _amountRange,
          min: 0,
          max: 10000000,
          divisions: 100,
          labels: RangeLabels(
            '${_amountRange.start.toInt()}',
            '${_amountRange.end.toInt()}',
          ),
          onChanged: (values) {
            setState(() {
              _amountRange = values;
            });
          },
        ),
      ],
    );
  }

  Future<void> _selectDateRange() async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: _selectedDateRange,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: AppTheme.lightTheme.colorScheme,
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedDateRange = picked;
      });
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  void _clearAllFilters() {
    setState(() {
      _selectedDateRange = null;
      _selectedCategories.clear();
      _amountRange = const RangeValues(0, 10000000);
      _selectedTransactionTypes = {'income', 'expense'};
    });
  }

  void _applyFilters() {
    final Map<String, dynamic> filters = {};

    if (_selectedDateRange != null) {
      filters['dateRange'] = _selectedDateRange;
    }

    if (_selectedCategories.isNotEmpty) {
      filters['categories'] = _selectedCategories;
    }

    if (_amountRange.start > 0 || _amountRange.end < 10000000) {
      filters['amountRange'] = _amountRange;
    }

    if (_selectedTransactionTypes.length == 1) {
      filters['transactionTypes'] = _selectedTransactionTypes.toList();
    }

    widget.onFiltersApplied(filters);
    Navigator.pop(context);
  }
}
