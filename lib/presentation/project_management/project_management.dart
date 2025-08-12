import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/empty_state_widget.dart';
import './widgets/new_project_widget.dart';
import './widgets/project_card_widget.dart';
import './widgets/project_filter_widget.dart';

class ProjectManagement extends StatefulWidget {
  const ProjectManagement({Key? key}) : super(key: key);

  @override
  State<ProjectManagement> createState() => _ProjectManagementState();
}

class _ProjectManagementState extends State<ProjectManagement>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  List<Map<String, dynamic>> _allProjects = [];
  List<Map<String, dynamic>> _filteredProjects = [];
  Map<String, dynamic> _currentFilters = {
    'status': 'all',
    'type': 'all',
    'dateRange': 'all',
    'minBudget': 0.0,
    'maxBudget': double.infinity,
  };
  bool _isLoading = false;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _loadMockData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _loadMockData() {
    _allProjects = [
      {
        "id": 1,
        "name": "Construction Nouvelle Église",
        "description":
            "Construction d'un nouveau bâtiment principal pour l'église avec une capacité de 500 personnes",
        "type": "construction",
        "budget": 50000000.0,
        "spent": 32000000.0,
        "progress": 65.0,
        "status": "active",
        "startDate": DateTime(2024, 1, 15),
        "endDate": DateTime(2024, 12, 31),
        "createdAt": DateTime(2024, 1, 10),
      },
      {
        "id": 2,
        "name": "Rénovation Salle de Prière",
        "description":
            "Rénovation complète de la salle de prière principale avec nouveau système audio",
        "type": "renovation",
        "budget": 15000000.0,
        "spent": 15500000.0,
        "progress": 95.0,
        "status": "over-budget",
        "startDate": DateTime(2024, 3, 1),
        "endDate": DateTime(2024, 6, 30),
        "createdAt": DateTime(2024, 2, 20),
      },
      {
        "id": 3,
        "name": "Achat Équipement Sonore",
        "description":
            "Achat d'un nouveau système de sonorisation professionnel pour les services",
        "type": "equipment",
        "budget": 8000000.0,
        "spent": 8000000.0,
        "progress": 100.0,
        "status": "completed",
        "startDate": DateTime(2024, 2, 1),
        "endDate": DateTime(2024, 3, 15),
        "createdAt": DateTime(2024, 1, 25),
      },
      {
        "id": 4,
        "name": "Extension Parking",
        "description":
            "Extension du parking pour accueillir plus de véhicules les dimanches",
        "type": "construction",
        "budget": 12000000.0,
        "spent": 3000000.0,
        "progress": 25.0,
        "status": "active",
        "startDate": DateTime(2024, 4, 1),
        "endDate": DateTime(2024, 8, 31),
        "createdAt": DateTime(2024, 3, 15),
      },
      {
        "id": 5,
        "name": "Réparation Toiture",
        "description":
            "Réparation urgente de la toiture suite aux dégâts de la saison des pluies",
        "type": "renovation",
        "budget": 5000000.0,
        "spent": 1200000.0,
        "progress": 15.0,
        "status": "on-hold",
        "startDate": DateTime(2024, 5, 1),
        "endDate": DateTime(2024, 7, 15),
        "createdAt": DateTime(2024, 4, 20),
      },
    ];
    _applyFiltersAndSearch();
  }

  void _applyFiltersAndSearch() {
    setState(() {
      _filteredProjects = _allProjects.where((project) {
        // Search filter
        if (_searchQuery.isNotEmpty) {
          final name = (project['name'] as String).toLowerCase();
          final description = (project['description'] as String).toLowerCase();
          if (!name.contains(_searchQuery.toLowerCase()) &&
              !description.contains(_searchQuery.toLowerCase())) {
            return false;
          }
        }

        // Status filter
        if (_currentFilters['status'] != 'all' &&
            project['status'] != _currentFilters['status']) {
          return false;
        }

        // Type filter
        if (_currentFilters['type'] != 'all' &&
            project['type'] != _currentFilters['type']) {
          return false;
        }

        // Budget filter
        final budget = (project['budget'] as num).toDouble();
        if (budget < (_currentFilters['minBudget'] as double) ||
            budget > (_currentFilters['maxBudget'] as double)) {
          return false;
        }

        // Date range filter
        if (_currentFilters['dateRange'] != 'all') {
          final createdAt = project['createdAt'] as DateTime;
          final now = DateTime.now();

          switch (_currentFilters['dateRange']) {
            case 'thisMonth':
              if (createdAt.month != now.month || createdAt.year != now.year) {
                return false;
              }
              break;
            case 'last3Months':
              final threeMonthsAgo = now.subtract(Duration(days: 90));
              if (createdAt.isBefore(threeMonthsAgo)) {
                return false;
              }
              break;
            case 'thisYear':
              if (createdAt.year != now.year) {
                return false;
              }
              break;
          }
        }

        return true;
      }).toList();
    });
  }

  Future<void> _refreshProjects() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate network delay
    await Future.delayed(Duration(seconds: 1));

    _loadMockData();

    setState(() {
      _isLoading = false;
    });
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ProjectFilterWidget(
        currentFilters: _currentFilters,
        onFiltersChanged: (filters) {
          setState(() {
            _currentFilters = filters;
          });
          _applyFiltersAndSearch();
        },
      ),
    );
  }

  void _showNewProjectBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => NewProjectWidget(
        onProjectCreated: (project) {
          setState(() {
            _allProjects.insert(0, project);
          });
          _applyFiltersAndSearch();
        },
      ),
    );
  }

  void _onProjectTap(Map<String, dynamic> project) {
    // Navigate to project detail screen
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Ouverture des détails du projet: ${project['name']}'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _onAddExpense(Map<String, dynamic> project) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Ajouter une dépense pour: ${project['name']}'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _onUpdateProgress(Map<String, dynamic> project) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Mettre à jour le progrès de: ${project['name']}'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _onViewPhotos(Map<String, dynamic> project) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Voir les photos de: ${project['name']}'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _onEditProject(Map<String, dynamic> project) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Modifier le projet: ${project['name']}'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _onArchiveProject(Map<String, dynamic> project) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Archiver le projet'),
        content:
            Text('Êtes-vous sûr de vouloir archiver "${project['name']}" ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _allProjects.removeWhere((p) => p['id'] == project['id']);
              });
              _applyFiltersAndSearch();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Projet "${project['name']}" archivé'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            child: Text('Archiver'),
          ),
        ],
      ),
    );
  }

  void _onGenerateReport(Map<String, dynamic> project) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Génération du rapport pour: ${project['name']}'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _onShareProject(Map<String, dynamic> project) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Partage des mises à jour de: ${project['name']}'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        title: Text('Gestion des Projets'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'Projets'),
            Tab(text: 'En cours'),
            Tab(text: 'Terminés'),
            Tab(text: 'Rapports'),
          ],
        ),
        actions: [
          IconButton(
            onPressed: _showFilterBottomSheet,
            icon: CustomIconWidget(
              iconName: 'filter_list',
              color: AppTheme.textPrimaryLight,
              size: 24,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(4.w),
            color: AppTheme.lightTheme.colorScheme.surface,
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Rechercher un projet...',
                prefixIcon: Padding(
                  padding: EdgeInsets.all(3.w),
                  child: CustomIconWidget(
                    iconName: 'search',
                    color: AppTheme.textSecondaryLight,
                    size: 20,
                  ),
                ),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        onPressed: () {
                          _searchController.clear();
                          setState(() {
                            _searchQuery = '';
                          });
                          _applyFiltersAndSearch();
                        },
                        icon: CustomIconWidget(
                          iconName: 'clear',
                          color: AppTheme.textSecondaryLight,
                          size: 20,
                        ),
                      )
                    : null,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
                _applyFiltersAndSearch();
              },
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildProjectsList(),
                _buildProjectsList(statusFilter: 'active'),
                _buildProjectsList(statusFilter: 'completed'),
                _buildReportsTab(),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showNewProjectBottomSheet,
        icon: CustomIconWidget(
          iconName: 'add',
          color: Colors.white,
          size: 20,
        ),
        label: Text('Nouveau Projet'),
      ),
    );
  }

  Widget _buildProjectsList({String? statusFilter}) {
    List<Map<String, dynamic>> projects = statusFilter != null
        ? _filteredProjects.where((p) => p['status'] == statusFilter).toList()
        : _filteredProjects;

    if (projects.isEmpty) {
      return EmptyStateWidget(
        onCreateProject: _showNewProjectBottomSheet,
      );
    }

    return RefreshIndicator(
      key: _refreshIndicatorKey,
      onRefresh: _refreshProjects,
      child: ListView.builder(
        padding: EdgeInsets.symmetric(vertical: 2.h),
        itemCount: projects.length,
        itemBuilder: (context, index) {
          final project = projects[index];
          return ProjectCardWidget(
            project: project,
            onTap: () => _onProjectTap(project),
            onAddExpense: () => _onAddExpense(project),
            onUpdateProgress: () => _onUpdateProgress(project),
            onViewPhotos: () => _onViewPhotos(project),
            onEdit: () => _onEditProject(project),
            onArchive: () => _onArchiveProject(project),
            onGenerateReport: () => _onGenerateReport(project),
            onShare: () => _onShareProject(project),
          );
        },
      ),
    );
  }

  Widget _buildReportsTab() {
    return Padding(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Rapports de Projets',
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            'Générez des rapports détaillés sur vos projets pour un suivi optimal.',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.textSecondaryLight,
            ),
          ),
          SizedBox(height: 4.h),
          _buildReportCard(
            'Rapport Mensuel',
            'Résumé de tous les projets du mois',
            'calendar_today',
            () => _generateReport('monthly'),
          ),
          SizedBox(height: 2.h),
          _buildReportCard(
            'Rapport par Statut',
            'Analyse des projets par statut',
            'pie_chart',
            () => _generateReport('status'),
          ),
          SizedBox(height: 2.h),
          _buildReportCard(
            'Rapport Budgétaire',
            'Analyse des budgets et dépenses',
            'attach_money',
            () => _generateReport('budget'),
          ),
        ],
      ),
    );
  }

  Widget _buildReportCard(
      String title, String description, String iconName, VoidCallback onTap) {
    return Card(
      child: ListTile(
        leading: Container(
          padding: EdgeInsets.all(2.w),
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: CustomIconWidget(
            iconName: iconName,
            color: AppTheme.lightTheme.primaryColor,
            size: 24,
          ),
        ),
        title: Text(
          title,
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(
          description,
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            color: AppTheme.textSecondaryLight,
          ),
        ),
        trailing: CustomIconWidget(
          iconName: 'arrow_forward_ios',
          color: AppTheme.textSecondaryLight,
          size: 16,
        ),
        onTap: onTap,
      ),
    );
  }

  void _generateReport(String type) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Génération du rapport $type en cours...'),
        duration: Duration(seconds: 2),
      ),
    );
  }
}
