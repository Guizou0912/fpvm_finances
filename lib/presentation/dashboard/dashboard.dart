import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/active_projects_widget.dart';
import './widgets/balance_card_widget.dart';
import './widgets/quick_actions_widget.dart';
import './widgets/quick_stats_widget.dart';
import './widgets/recent_transactions_widget.dart';
import './widgets/sync_status_widget.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> with TickerProviderStateMixin {
  int _currentIndex = 0;
  bool _isLoading = false;
  bool _isOnline = true;
  bool _isSyncing = false;
  DateTime? _lastSyncTime = DateTime.now().subtract(const Duration(minutes: 5));

  // Mock user data
  final String _churchName = "FPVM Antananarivo Centre";
  final String _userRole =
      "Admin Church"; // Can be: Admin Church, Treasurer, Observer
  final String _userName = "Jean Baptiste Rakoto";

  // Mock financial data
  double _currentBalance = 15750000.0;
  double _monthlyIncome = 3250000.0;
  double _monthlyExpenses = 1890000.0;
  double _incomeChange = 12.5;
  double _expenseChange = -8.3;

  // Mock transactions data
  final List<Map<String, dynamic>> _recentTransactions = [
    {
      "id": 1,
      "type": "income",
      "description": "Dîmes du dimanche",
      "amount": 450000.0,
      "date": "12/08/2025",
      "category": "Dîmes"
    },
    {
      "id": 2,
      "type": "expense",
      "description": "Achat matériel sonorisation",
      "amount": 125000.0,
      "date": "11/08/2025",
      "category": "Équipement"
    },
    {
      "id": 3,
      "type": "income",
      "description": "Offrandes spéciales",
      "amount": 280000.0,
      "date": "11/08/2025",
      "category": "Offrandes"
    },
    {
      "id": 4,
      "type": "expense",
      "description": "Frais électricité",
      "amount": 75000.0,
      "date": "10/08/2025",
      "category": "Utilités"
    },
    {
      "id": 5,
      "type": "income",
      "description": "Vente produits église",
      "amount": 95000.0,
      "date": "09/08/2025",
      "category": "Ventes"
    }
  ];

  // Mock projects data
  final List<Map<String, dynamic>> _activeProjects = [
    {
      "id": 1,
      "name": "Rénovation Sanctuaire",
      "progress": 0.65,
      "budget": 5000000.0,
      "spent": 3250000.0,
      "status": "En cours"
    },
    {
      "id": 2,
      "name": "Nouveau Système Audio",
      "progress": 0.30,
      "budget": 1500000.0,
      "spent": 450000.0,
      "status": "En cours"
    },
    {
      "id": 3,
      "name": "Extension Parking",
      "progress": 0.85,
      "budget": 2800000.0,
      "spent": 2380000.0,
      "status": "Presque terminé"
    }
  ];

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }

  Future<void> _loadDashboardData() async {
    setState(() => _isLoading = true);

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    setState(() => _isLoading = false);
  }

  Future<void> _refreshData() async {
    setState(() => _isSyncing = true);

    // Simulate refresh
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _isSyncing = false;
      _lastSyncTime = DateTime.now();
    });
  }

  void _onBottomNavTap(int index) {
    setState(() => _currentIndex = index);

    switch (index) {
      case 0:
        // Already on dashboard
        break;
      case 1:
        Navigator.pushNamed(context, '/transaction-history');
        break;
      case 2:
        Navigator.pushNamed(context, '/project-management');
        break;
      case 3:
        Navigator.pushNamed(context, '/financial-reports');
        break;
      case 4:
        Navigator.pushNamed(context, '/settings');
        break;
    }
  }

  void _onTransactionEdit(Map<String, dynamic> transaction) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Modifier Transaction'),
        content: Text('Modification de: ${transaction['description']}'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Modifier'),
          ),
        ],
      ),
    );
  }

  void _showBalanceDetails() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: 50.h,
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: EdgeInsets.all(5.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 12.w,
                height: 0.5.h,
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.outline,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            SizedBox(height: 3.h),
            Text(
              'Détails du Solde',
              style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 3.h),
            _buildBalanceDetailItem('Solde Total', _currentBalance,
                AppTheme.lightTheme.colorScheme.primary),
            _buildBalanceDetailItem(
                'Revenus ce mois', _monthlyIncome, AppTheme.successLight),
            _buildBalanceDetailItem(
                'Dépenses ce mois', _monthlyExpenses, AppTheme.errorLight),
            _buildBalanceDetailItem(
                'Solde disponible',
                _currentBalance - (_monthlyExpenses * 0.1),
                AppTheme.lightTheme.colorScheme.secondary),
            SizedBox(height: 3.h),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Fermer'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBalanceDetailItem(String label, double amount, Color color) {
    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            '${amount.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]} ')} MGA',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  void _onFloatingActionButtonPressed() {
    if (_userRole == 'Admin Church') {
      _showAdminActionMenu();
    } else if (_userRole == 'Treasurer') {
      _showAddTransactionDialog();
    } else {
      Navigator.pushNamed(context, '/financial-reports');
    }
  }

  void _showAdminActionMenu() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: EdgeInsets.all(5.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Container(
                width: 12.w,
                height: 0.5.h,
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.outline,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            SizedBox(height: 3.h),
            Text(
              'Actions Administrateur',
              style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 3.h),
            _buildActionMenuItem(
                'Ajouter Revenu', 'add_circle', AppTheme.successLight, () {
              Navigator.pop(context);
              _showAddIncomeDialog();
            }),
            _buildActionMenuItem(
                'Enregistrer Dépense', 'remove_circle', AppTheme.errorLight,
                () {
              Navigator.pop(context);
              _showAddExpenseDialog();
            }),
            _buildActionMenuItem('Nouveau Projet', 'construction',
                AppTheme.lightTheme.colorScheme.primary, () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/project-management');
            }),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  Widget _buildActionMenuItem(
      String title, String icon, Color color, VoidCallback onTap) {
    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      child: ListTile(
        leading: Container(
          width: 12.w,
          height: 12.w,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: CustomIconWidget(
              iconName: icon,
              color: color,
              size: 24,
            ),
          ),
        ),
        title: Text(
          title,
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        onTap: onTap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  void _showAddTransactionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Ajouter Transaction'),
        content:
            Text('Interface d\'ajout de transaction sera implémentée ici.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Ajouter'),
          ),
        ],
      ),
    );
  }

  void _showAddIncomeDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Ajouter un Revenu'),
        content: Text('Interface d\'ajout de revenu sera implémentée ici.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Ajouter'),
          ),
        ],
      ),
    );
  }

  void _showAddExpenseDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Enregistrer une Dépense'),
        content: Text('Interface d\'ajout de dépense sera implémentée ici.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Enregistrer'),
          ),
        ],
      ),
    );
  }

  List<BottomNavigationBarItem> _getBottomNavItems() {
    List<BottomNavigationBarItem> items = [
      const BottomNavigationBarItem(
        icon: Icon(Icons.dashboard),
        label: 'Tableau de Bord',
      ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.receipt_long),
        label: 'Transactions',
      ),
    ];

    if (_userRole != 'Observer') {
      items.add(const BottomNavigationBarItem(
        icon: Icon(Icons.construction),
        label: 'Projets',
      ));
    }

    items.addAll([
      const BottomNavigationBarItem(
        icon: Icon(Icons.assessment),
        label: 'Rapports',
      ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.settings),
        label: 'Paramètres',
      ),
    ]);

    return items;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Bonjour, $_userName',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              _churchName,
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 4.w),
            child: Row(
              children: [
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.primary
                        .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _userRole,
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                SizedBox(width: 2.w),
                SyncStatusWidget(
                  isOnline: _isOnline,
                  lastSyncTime: _lastSyncTime,
                  isSyncing: _isSyncing,
                ),
              ],
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        color: AppTheme.lightTheme.colorScheme.primary,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 2.h),
              BalanceCardWidget(
                currentBalance: _currentBalance,
                onLongPress: _showBalanceDetails,
                isLoading: _isLoading,
              ),
              SizedBox(height: 2.h),
              QuickStatsWidget(
                monthlyIncome: _monthlyIncome,
                monthlyExpenses: _monthlyExpenses,
                incomeChange: _incomeChange,
                expenseChange: _expenseChange,
                isLoading: _isLoading,
              ),
              SizedBox(height: 2.h),
              QuickActionsWidget(userRole: _userRole),
              SizedBox(height: 2.h),
              RecentTransactionsWidget(
                transactions: _recentTransactions,
                userRole: _userRole,
                isLoading: _isLoading,
                onTransactionEdit: _onTransactionEdit,
              ),
              SizedBox(height: 2.h),
              ActiveProjectsWidget(
                projects: _activeProjects,
                isLoading: _isLoading,
              ),
              SizedBox(height: 10.h),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onBottomNavTap,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppTheme.lightTheme.colorScheme.primary,
        unselectedItemColor: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
        backgroundColor: AppTheme.lightTheme.colorScheme.surface,
        elevation: 8,
        items: _getBottomNavItems(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _onFloatingActionButtonPressed,
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
        foregroundColor: Colors.white,
        child: CustomIconWidget(
          iconName: _userRole == 'Admin Church'
              ? 'add'
              : _userRole == 'Treasurer'
                  ? 'add_circle'
                  : 'assessment',
          color: Colors.white,
          size: 28,
        ),
      ),
    );
  }
}
