import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/chart_section_widget.dart';
import './widgets/custom_report_builder_widget.dart';
import './widgets/metrics_card_widget.dart';
import './widgets/period_selector_widget.dart';
import './widgets/report_template_widget.dart';

class FinancialReports extends StatefulWidget {
  const FinancialReports({Key? key}) : super(key: key);

  @override
  State<FinancialReports> createState() => _FinancialReportsState();
}

class _FinancialReportsState extends State<FinancialReports>
    with TickerProviderStateMixin {
  late TabController _tabController;
  String _selectedPeriod = 'Mensuel';
  int _currentBottomNavIndex = 3; // Financial Reports tab

  // Mock financial data
  final List<Map<String, dynamic>> _financialMetrics = [
    {
      "title": "Revenus Totaux",
      "amount": "18 500 000 Ar",
      "trend": "+12.5%",
      "isPositive": true,
    },
    {
      "title": "Dépenses Totales",
      "amount": "12 800 000 Ar",
      "trend": "+8.3%",
      "isPositive": false,
    },
    {
      "title": "Solde Net",
      "amount": "5 700 000 Ar",
      "trend": "+24.1%",
      "isPositive": true,
    },
    {
      "title": "Transactions",
      "amount": "247",
      "trend": "+15.2%",
      "isPositive": true,
    },
  ];

  final List<Map<String, dynamic>> _reportTemplates = [
    {
      "title": "Résumé Financier",
      "description": "Vue d'ensemble complète des finances de l'église",
      "iconName": "assessment",
    },
    {
      "title": "Analyse des Revenus",
      "description": "Détail des dîmes, offrandes et dons reçus",
      "iconName": "trending_up",
    },
    {
      "title": "Répartition des Dépenses",
      "description": "Analyse détaillée de toutes les dépenses",
      "iconName": "pie_chart",
    },
    {
      "title": "Rapports de Projets",
      "description": "Suivi financier des projets en cours",
      "iconName": "construction",
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 1, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: _buildAppBar(),
      body: _buildBody(),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppTheme.lightTheme.colorScheme.surface,
      elevation: 2,
      shadowColor: Colors.black.withValues(alpha: 0.1),
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: CustomIconWidget(
          iconName: 'arrow_back',
          color: AppTheme.lightTheme.colorScheme.onSurface,
          size: 24,
        ),
      ),
      title: Text(
        'Rapports Financiers',
        style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w600,
          color: AppTheme.lightTheme.colorScheme.onSurface,
        ),
      ),
      actions: [
        IconButton(
          onPressed: _showFilterOptions,
          icon: CustomIconWidget(
            iconName: 'filter_list',
            color: AppTheme.lightTheme.colorScheme.onSurface,
            size: 24,
          ),
        ),
        IconButton(
          onPressed: _refreshData,
          icon: CustomIconWidget(
            iconName: 'refresh',
            color: AppTheme.lightTheme.colorScheme.onSurface,
            size: 24,
          ),
        ),
      ],
      bottom: TabBar(
        controller: _tabController,
        labelColor: AppTheme.lightTheme.colorScheme.primary,
        unselectedLabelColor: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
        indicatorColor: AppTheme.lightTheme.colorScheme.primary,
        tabs: const [
          Tab(text: 'Rapports'),
        ],
      ),
    );
  }

  Widget _buildBody() {
    return TabBarView(
      controller: _tabController,
      children: [
        _buildReportsTab(),
      ],
    );
  }

  Widget _buildReportsTab() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 2.h),
          PeriodSelectorWidget(
            selectedPeriod: _selectedPeriod,
            onPeriodChanged: (period) {
              setState(() {
                _selectedPeriod = period;
              });
              _showToast('Période changée: $_selectedPeriod');
            },
          ),
          SizedBox(height: 2.h),
          _buildMetricsSection(),
          SizedBox(height: 3.h),
          ChartSectionWidget(selectedPeriod: _selectedPeriod),
          SizedBox(height: 3.h),
          _buildReportTemplatesSection(),
          SizedBox(height: 2.h),
          CustomReportBuilderWidget(
            onGenerateReport: _generateCustomReport,
          ),
          SizedBox(height: 4.h),
        ],
      ),
    );
  }

  Widget _buildMetricsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Text(
            'Indicateurs Clés',
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppTheme.lightTheme.colorScheme.onSurface,
            ),
          ),
        ),
        SizedBox(height: 2.h),
        SizedBox(
          height: 20.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            itemCount: _financialMetrics.length,
            itemBuilder: (context, index) {
              final metric = _financialMetrics[index];
              return Padding(
                padding: EdgeInsets.only(right: 3.w),
                child: MetricsCardWidget(
                  title: metric["title"] as String,
                  amount: metric["amount"] as String,
                  trend: metric["trend"] as String,
                  isPositive: metric["isPositive"] as bool,
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildReportTemplatesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Text(
            'Modèles de Rapports',
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppTheme.lightTheme.colorScheme.onSurface,
            ),
          ),
        ),
        SizedBox(height: 2.h),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _reportTemplates.length,
          itemBuilder: (context, index) {
            final template = _reportTemplates[index];
            return ReportTemplateWidget(
              title: template["title"] as String,
              description: template["description"] as String,
              iconName: template["iconName"] as String,
              onGeneratePdf: () =>
                  _generatePdfReport(template["title"] as String),
              onExportExcel: () =>
                  _exportExcelReport(template["title"] as String),
            );
          },
        ),
      ],
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: _currentBottomNavIndex,
      onTap: _onBottomNavTap,
      type: BottomNavigationBarType.fixed,
      backgroundColor: AppTheme.lightTheme.colorScheme.surface,
      selectedItemColor: AppTheme.lightTheme.colorScheme.primary,
      unselectedItemColor: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
      elevation: 8,
      items: [
        BottomNavigationBarItem(
          icon: CustomIconWidget(
            iconName: 'dashboard',
            color: _currentBottomNavIndex == 0
                ? AppTheme.lightTheme.colorScheme.primary
                : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 24,
          ),
          label: 'Tableau de Bord',
        ),
        BottomNavigationBarItem(
          icon: CustomIconWidget(
            iconName: 'history',
            color: _currentBottomNavIndex == 1
                ? AppTheme.lightTheme.colorScheme.primary
                : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 24,
          ),
          label: 'Historique',
        ),
        BottomNavigationBarItem(
          icon: CustomIconWidget(
            iconName: 'construction',
            color: _currentBottomNavIndex == 2
                ? AppTheme.lightTheme.colorScheme.primary
                : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 24,
          ),
          label: 'Projets',
        ),
        BottomNavigationBarItem(
          icon: CustomIconWidget(
            iconName: 'assessment',
            color: _currentBottomNavIndex == 3
                ? AppTheme.lightTheme.colorScheme.primary
                : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 24,
          ),
          label: 'Rapports',
        ),
        BottomNavigationBarItem(
          icon: CustomIconWidget(
            iconName: 'settings',
            color: _currentBottomNavIndex == 4
                ? AppTheme.lightTheme.colorScheme.primary
                : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 24,
          ),
          label: 'Paramètres',
        ),
      ],
    );
  }

  void _onBottomNavTap(int index) {
    if (index == _currentBottomNavIndex) return;

    setState(() {
      _currentBottomNavIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/dashboard');
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/transaction-history');
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/project-management');
        break;
      case 3:
        // Current screen - do nothing
        break;
      case 4:
        Navigator.pushReplacementNamed(context, '/settings');
        break;
    }
  }

  void _showFilterOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.lightTheme.colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(4.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Options de Filtrage',
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 2.h),
              ListTile(
                leading: CustomIconWidget(
                  iconName: 'date_range',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 24,
                ),
                title: const Text('Filtrer par Date'),
                onTap: () {
                  Navigator.pop(context);
                  _showToast('Filtre par date sélectionné');
                },
              ),
              ListTile(
                leading: CustomIconWidget(
                  iconName: 'category',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 24,
                ),
                title: const Text('Filtrer par Catégorie'),
                onTap: () {
                  Navigator.pop(context);
                  _showToast('Filtre par catégorie sélectionné');
                },
              ),
              ListTile(
                leading: CustomIconWidget(
                  iconName: 'account_balance',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 24,
                ),
                title: const Text('Filtrer par Montant'),
                onTap: () {
                  Navigator.pop(context);
                  _showToast('Filtre par montant sélectionné');
                },
              ),
              SizedBox(height: 2.h),
            ],
          ),
        );
      },
    );
  }

  void _refreshData() {
    _showToast('Actualisation des données...');
    // Simulate data refresh
    Future.delayed(const Duration(seconds: 1), () {
      _showToast('Données actualisées avec succès');
    });
  }

  void _generatePdfReport(String reportType) {
    _showToast('Génération du rapport PDF: $reportType');
    // Simulate PDF generation
    Future.delayed(const Duration(seconds: 2), () {
      _showToast('Rapport PDF généré avec succès');
    });
  }

  void _exportExcelReport(String reportType) {
    _showToast('Export Excel en cours: $reportType');
    // Simulate Excel export
    Future.delayed(const Duration(seconds: 2), () {
      _showToast('Rapport Excel exporté avec succès');
    });
  }

  void _generateCustomReport(Map<String, dynamic> reportConfig) {
    final startDate = reportConfig['startDate'] as DateTime;
    final endDate = reportConfig['endDate'] as DateTime;
    final categories = reportConfig['categories'] as List<String>;
    final format = reportConfig['format'] as String;

    _showToast('Génération du rapport personnalisé en format $format');

    // Simulate custom report generation
    Future.delayed(const Duration(seconds: 3), () {
      _showToast('Rapport personnalisé généré avec succès');
    });
  }

  void _showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: AppTheme.lightTheme.colorScheme.surface,
      textColor: AppTheme.lightTheme.colorScheme.onSurface,
      fontSize: 14.sp,
    );
  }
}
