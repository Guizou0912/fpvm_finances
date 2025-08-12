import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class QuickActionsWidget extends StatelessWidget {
  final String userRole;

  const QuickActionsWidget({
    Key? key,
    required this.userRole,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 2.w),
            child: Text(
              'Actions Rapides',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(height: 2.h),
          SizedBox(
            height: 12.h,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 2.w),
              children: _buildActionChips(context),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildActionChips(BuildContext context) {
    List<Map<String, dynamic>> actions = [];

    switch (userRole) {
      case 'Admin Church':
        actions = [
          {
            'title': 'Ajouter Revenu',
            'icon': 'add_circle',
            'color': AppTheme.successLight,
            'onTap': () => _showAddIncomeDialog(context),
          },
          {
            'title': 'Enregistrer Dépense',
            'icon': 'remove_circle',
            'color': AppTheme.errorLight,
            'onTap': () => _showAddExpenseDialog(context),
          },
          {
            'title': 'Nouveau Projet',
            'icon': 'construction',
            'color': AppTheme.lightTheme.colorScheme.primary,
            'onTap': () => Navigator.pushNamed(context, '/project-management'),
          },
          {
            'title': 'Voir Rapports',
            'icon': 'assessment',
            'color': AppTheme.lightTheme.colorScheme.tertiary,
            'onTap': () => Navigator.pushNamed(context, '/financial-reports'),
          },
          {
            'title': 'Gérer Projets',
            'icon': 'engineering',
            'color': AppTheme.lightTheme.colorScheme.secondary,
            'onTap': () => Navigator.pushNamed(context, '/project-management'),
          },
        ];
        break;
      case 'Treasurer':
        actions = [
          {
            'title': 'Ajouter Revenu',
            'icon': 'add_circle',
            'color': AppTheme.successLight,
            'onTap': () => _showAddIncomeDialog(context),
          },
          {
            'title': 'Enregistrer Dépense',
            'icon': 'remove_circle',
            'color': AppTheme.errorLight,
            'onTap': () => _showAddExpenseDialog(context),
          },
          {
            'title': 'Historique',
            'icon': 'history',
            'color': AppTheme.lightTheme.colorScheme.primary,
            'onTap': () => Navigator.pushNamed(context, '/transaction-history'),
          },
          {
            'title': 'Rapports',
            'icon': 'assessment',
            'color': AppTheme.lightTheme.colorScheme.tertiary,
            'onTap': () => Navigator.pushNamed(context, '/financial-reports'),
          },
        ];
        break;
      case 'Observer':
        actions = [
          {
            'title': 'Générer Rapport',
            'icon': 'assessment',
            'color': AppTheme.lightTheme.colorScheme.primary,
            'onTap': () => Navigator.pushNamed(context, '/financial-reports'),
          },
          {
            'title': 'Voir Historique',
            'icon': 'history',
            'color': AppTheme.lightTheme.colorScheme.secondary,
            'onTap': () => Navigator.pushNamed(context, '/transaction-history'),
          },
          {
            'title': 'Projets',
            'icon': 'construction',
            'color': AppTheme.lightTheme.colorScheme.tertiary,
            'onTap': () => Navigator.pushNamed(context, '/project-management'),
          },
        ];
        break;
    }

    return actions.map((action) => _buildActionChip(action)).toList();
  }

  Widget _buildActionChip(Map<String, dynamic> action) {
    return Container(
      margin: EdgeInsets.only(right: 3.w),
      child: GestureDetector(
        onTap: action['onTap'],
        child: Container(
          width: 20.w,
          padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 2.w),
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 12.w,
                height: 12.w,
                decoration: BoxDecoration(
                  color: (action['color'] as Color).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: CustomIconWidget(
                    iconName: action['icon'],
                    color: action['color'],
                    size: 24,
                  ),
                ),
              ),
              SizedBox(height: 1.h),
              Text(
                action['title'],
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAddIncomeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Ajouter un Revenu'),
        content:
            Text('Fonctionnalité d\'ajout de revenu sera implémentée ici.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Fermer'),
          ),
        ],
      ),
    );
  }

  void _showAddExpenseDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Enregistrer une Dépense'),
        content:
            Text('Fonctionnalité d\'ajout de dépense sera implémentée ici.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Fermer'),
          ),
        ],
      ),
    );
  }
}
