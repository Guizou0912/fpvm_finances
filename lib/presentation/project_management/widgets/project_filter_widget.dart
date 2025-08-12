import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class ProjectFilterWidget extends StatefulWidget {
  final Function(Map<String, dynamic>) onFiltersChanged;
  final Map<String, dynamic> currentFilters;

  const ProjectFilterWidget({
    Key? key,
    required this.onFiltersChanged,
    required this.currentFilters,
  }) : super(key: key);

  @override
  State<ProjectFilterWidget> createState() => _ProjectFilterWidgetState();
}

class _ProjectFilterWidgetState extends State<ProjectFilterWidget> {
  late Map<String, dynamic> _filters;
  final TextEditingController _minBudgetController = TextEditingController();
  final TextEditingController _maxBudgetController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _filters = Map<String, dynamic>.from(widget.currentFilters);
    _minBudgetController.text =
        (_filters['minBudget'] as double?)?.toStringAsFixed(0) ?? '';
    _maxBudgetController.text =
        (_filters['maxBudget'] as double?)?.toStringAsFixed(0) ?? '';
  }

  @override
  void dispose() {
    _minBudgetController.dispose();
    _maxBudgetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 12.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: AppTheme.borderLight,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          SizedBox(height: 2.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Filtres',
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              TextButton(
                onPressed: _clearFilters,
                child: Text(
                  'Effacer tout',
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.lightTheme.primaryColor,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          _buildStatusFilter(),
          SizedBox(height: 3.h),
          _buildTypeFilter(),
          SizedBox(height: 3.h),
          _buildDateRangeFilter(),
          SizedBox(height: 3.h),
          _buildBudgetRangeFilter(),
          SizedBox(height: 4.h),
          Row(
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
          SizedBox(height: 2.h),
        ],
      ),
    );
  }

  Widget _buildStatusFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Statut',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 1.h),
        Wrap(
          spacing: 2.w,
          runSpacing: 1.h,
          children: [
            _buildFilterChip('Tous', 'all', 'status'),
            _buildFilterChip('Actif', 'active', 'status'),
            _buildFilterChip('Terminé', 'completed', 'status'),
            _buildFilterChip('Dépassé', 'over-budget', 'status'),
            _buildFilterChip('En attente', 'on-hold', 'status'),
          ],
        ),
      ],
    );
  }

  Widget _buildTypeFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Type de projet',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 1.h),
        Wrap(
          spacing: 2.w,
          runSpacing: 1.h,
          children: [
            _buildFilterChip('Tous', 'all', 'type'),
            _buildFilterChip('Construction', 'construction', 'type'),
            _buildFilterChip('Rénovation', 'renovation', 'type'),
            _buildFilterChip('Équipement', 'equipment', 'type'),
          ],
        ),
      ],
    );
  }

  Widget _buildDateRangeFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Période',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 1.h),
        Wrap(
          spacing: 2.w,
          runSpacing: 1.h,
          children: [
            _buildFilterChip('Toutes', 'all', 'dateRange'),
            _buildFilterChip('Ce mois', 'thisMonth', 'dateRange'),
            _buildFilterChip('3 derniers mois', 'last3Months', 'dateRange'),
            _buildFilterChip('Cette année', 'thisYear', 'dateRange'),
          ],
        ),
      ],
    );
  }

  Widget _buildBudgetRangeFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Budget (MGA)',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 1.h),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _minBudgetController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Minimum',
                  hintText: '0',
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.5.h),
                ),
                onChanged: (value) {
                  _filters['minBudget'] = double.tryParse(value) ?? 0.0;
                },
              ),
            ),
            SizedBox(width: 4.w),
            Expanded(
              child: TextFormField(
                controller: _maxBudgetController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Maximum',
                  hintText: '1000000',
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.5.h),
                ),
                onChanged: (value) {
                  _filters['maxBudget'] =
                      double.tryParse(value) ?? double.infinity;
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFilterChip(String label, String value, String filterType) {
    final bool isSelected = _filters[filterType] == value;

    return FilterChip(
      label: Text(
        label,
        style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
          color: isSelected ? Colors.white : AppTheme.textPrimaryLight,
          fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
        ),
      ),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _filters[filterType] = selected ? value : 'all';
        });
      },
      backgroundColor: AppTheme.lightTheme.colorScheme.surface,
      selectedColor: AppTheme.lightTheme.primaryColor,
      checkmarkColor: Colors.white,
      side: BorderSide(
        color: isSelected
            ? AppTheme.lightTheme.primaryColor
            : AppTheme.borderLight,
      ),
    );
  }

  void _clearFilters() {
    setState(() {
      _filters = {
        'status': 'all',
        'type': 'all',
        'dateRange': 'all',
        'minBudget': 0.0,
        'maxBudget': double.infinity,
      };
      _minBudgetController.clear();
      _maxBudgetController.clear();
    });
  }

  void _applyFilters() {
    widget.onFiltersChanged(_filters);
    Navigator.pop(context);
  }
}
