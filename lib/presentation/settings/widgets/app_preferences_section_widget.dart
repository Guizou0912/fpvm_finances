import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AppPreferencesSectionWidget extends StatelessWidget {
  final String currencyFormat;
  final String dateFormat;
  final String language;
  final Function(String) onCurrencyFormatChange;
  final Function(String) onDateFormatChange;
  final Function(String) onLanguageChange;

  const AppPreferencesSectionWidget({
    Key? key,
    required this.currencyFormat,
    required this.dateFormat,
    required this.language,
    required this.onCurrencyFormatChange,
    required this.onDateFormatChange,
    required this.onLanguageChange,
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
            'Préférences de l\'application',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: isLight
                      ? AppTheme.textPrimaryLight
                      : AppTheme.textPrimaryDark,
                ),
          ),
          SizedBox(height: 2.h),
          _buildPreferenceItem(
            context,
            isLight,
            'attach_money',
            'Format de devise',
            currencyFormat,
            () => _showCurrencyFormatPicker(context, isLight),
          ),
          SizedBox(height: 2.h),
          _buildPreferenceItem(
            context,
            isLight,
            'calendar_today',
            'Format de date',
            dateFormat,
            () => _showDateFormatPicker(context, isLight),
          ),
          SizedBox(height: 2.h),
          _buildPreferenceItem(
            context,
            isLight,
            'language',
            'Langue',
            language,
            () => _showLanguagePicker(context, isLight),
          ),
        ],
      ),
    );
  }

  Widget _buildPreferenceItem(
    BuildContext context,
    bool isLight,
    String iconName,
    String title,
    String value,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          CustomIconWidget(
            iconName: iconName,
            color: isLight ? AppTheme.primaryLight : AppTheme.primaryDark,
            size: 6.w,
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: isLight
                            ? AppTheme.textPrimaryLight
                            : AppTheme.textPrimaryDark,
                      ),
                ),
                Text(
                  value,
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
    );
  }

  void _showCurrencyFormatPicker(BuildContext context, bool isLight) {
    final List<Map<String, String>> currencyOptions = [
      {'value': 'MGA', 'display': 'MGA (Ariary Malagasy)'},
      {'value': 'Ar', 'display': 'Ar (Ariary)'},
      {'value': '₳', 'display': '₳ (Symbole Ariary)'},
    ];

    _showOptionPicker(
      context,
      isLight,
      'Format de devise',
      currencyOptions,
      currencyFormat,
      onCurrencyFormatChange,
    );
  }

  void _showDateFormatPicker(BuildContext context, bool isLight) {
    final List<Map<String, String>> dateOptions = [
      {'value': 'DD/MM/YYYY', 'display': 'DD/MM/YYYY (12/08/2025)'},
      {'value': 'MM/DD/YYYY', 'display': 'MM/DD/YYYY (08/12/2025)'},
      {'value': 'YYYY-MM-DD', 'display': 'YYYY-MM-DD (2025-08-12)'},
      {'value': 'DD MMM YYYY', 'display': 'DD MMM YYYY (12 Août 2025)'},
    ];

    _showOptionPicker(
      context,
      isLight,
      'Format de date',
      dateOptions,
      dateFormat,
      onDateFormatChange,
    );
  }

  void _showLanguagePicker(BuildContext context, bool isLight) {
    final List<Map<String, String>> languageOptions = [
      {'value': 'Français', 'display': 'Français'},
      {'value': 'Malagasy', 'display': 'Malagasy'},
      {'value': 'English', 'display': 'English'},
    ];

    _showOptionPicker(
      context,
      isLight,
      'Langue',
      languageOptions,
      language,
      onLanguageChange,
    );
  }

  void _showOptionPicker(
    BuildContext context,
    bool isLight,
    String title,
    List<Map<String, String>> options,
    String currentValue,
    Function(String) onChanged,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: isLight
          ? AppTheme.lightTheme.colorScheme.surface
          : AppTheme.darkTheme.colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Container(
        height: 40.h,
        padding: EdgeInsets.all(4.w),
        child: Column(
          children: [
            Container(
              width: 12.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: isLight
                    ? AppTheme.textSecondaryLight
                    : AppTheme.textSecondaryDark,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: isLight
                        ? AppTheme.textPrimaryLight
                        : AppTheme.textPrimaryDark,
                  ),
            ),
            SizedBox(height: 2.h),
            Expanded(
              child: ListView.builder(
                itemCount: options.length,
                itemBuilder: (context, index) {
                  final option = options[index];
                  final isSelected = option['value'] == currentValue;

                  return ListTile(
                    title: Text(
                      option['display']!,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: isSelected
                                ? (isLight
                                    ? AppTheme.primaryLight
                                    : AppTheme.primaryDark)
                                : (isLight
                                    ? AppTheme.textPrimaryLight
                                    : AppTheme.textPrimaryDark),
                            fontWeight:
                                isSelected ? FontWeight.w600 : FontWeight.w400,
                          ),
                    ),
                    trailing: isSelected
                        ? CustomIconWidget(
                            iconName: 'check',
                            color: isLight
                                ? AppTheme.primaryLight
                                : AppTheme.primaryDark,
                            size: 5.w,
                          )
                        : null,
                    onTap: () {
                      onChanged(option['value']!);
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
