import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/empty_state_widget.dart';
import './widgets/filter_bottom_sheet.dart';
import './widgets/filter_chips_widget.dart';
import './widgets/search_bar_widget.dart';
import './widgets/transaction_card.dart';

class TransactionHistory extends StatefulWidget {
  const TransactionHistory({Key? key}) : super(key: key);

  @override
  State<TransactionHistory> createState() => _TransactionHistoryState();
}

class _TransactionHistoryState extends State<TransactionHistory>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final ScrollController _scrollController = ScrollController();

  // Search and filter state
  String _searchQuery = '';
  Map<String, dynamic> _activeFilters = {};
  List<String> _recentSearches = [
    'Dîmes',
    'Électricité',
    'Offrandes',
    'Carburant'
  ];

  // Data state
  List<Map<String, dynamic>> _allTransactions = [];
  List<Map<String, dynamic>> _filteredTransactions = [];
  bool _isLoading = false;
  bool _isLoadingMore = false;
  bool _hasMoreData = true;
  int _currentPage = 1;

  // User role (mock - in real app this would come from auth)
  String _userRole = 'Admin'; // Admin, Treasurer, Observer

  // Sync state
  bool _isOnline = true;
  DateTime? _lastSyncTime;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this, initialIndex: 1);
    _scrollController.addListener(_onScroll);
    _loadInitialData();
    _simulateLastSync();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _simulateLastSync() {
    _lastSyncTime = DateTime.now().subtract(const Duration(minutes: 5));
  }

  void _loadInitialData() {
    setState(() {
      _isLoading = true;
    });

    // Mock transaction data
    _allTransactions = [
      {
        "id": 1,
        "type": "income",
        "amount": "250 000 MGA",
        "category": "Dîmes",
        "date": "12/08/2025",
        "description": "Dîmes du dimanche - Service principal",
        "receiptUrl":
            "https://images.pexels.com/photos/6863183/pexels-photo-6863183.jpeg?auto=compress&cs=tinysrgb&w=400",
        "timestamp": DateTime.now().subtract(const Duration(hours: 2)),
      },
      {
        "id": 2,
        "type": "expense",
        "amount": "85 000 MGA",
        "category": "Électricité",
        "date": "11/08/2025",
        "description": "Facture d'électricité - Mois d'août",
        "receiptUrl":
            "https://images.pexels.com/photos/6863366/pexels-photo-6863366.jpeg?auto=compress&cs=tinysrgb&w=400",
        "timestamp": DateTime.now().subtract(const Duration(hours: 8)),
      },
      {
        "id": 3,
        "type": "income",
        "amount": "180 000 MGA",
        "category": "Offrandes",
        "date": "11/08/2025",
        "description": "Offrandes spéciales - Culte de jeunesse",
        "receiptUrl": null,
        "timestamp": DateTime.now().subtract(const Duration(hours: 12)),
      },
      {
        "id": 4,
        "type": "expense",
        "amount": "45 000 MGA",
        "category": "Carburant",
        "date": "10/08/2025",
        "description": "Essence pour le véhicule de l'église",
        "receiptUrl":
            "https://images.pexels.com/photos/6863297/pexels-photo-6863297.jpeg?auto=compress&cs=tinysrgb&w=400",
        "timestamp": DateTime.now().subtract(const Duration(days: 1)),
      },
      {
        "id": 5,
        "type": "income",
        "amount": "320 000 MGA",
        "category": "Dons",
        "date": "09/08/2025",
        "description": "Don généreux d'un membre pour la construction",
        "receiptUrl": null,
        "timestamp": DateTime.now().subtract(const Duration(days: 2)),
      },
      {
        "id": 6,
        "type": "expense",
        "amount": "125 000 MGA",
        "category": "Fournitures",
        "date": "08/08/2025",
        "description": "Matériel de bureau et fournitures diverses",
        "receiptUrl":
            "https://images.pexels.com/photos/6863445/pexels-photo-6863445.jpeg?auto=compress&cs=tinysrgb&w=400",
        "timestamp": DateTime.now().subtract(const Duration(days: 3)),
      },
      {
        "id": 7,
        "type": "income",
        "amount": "95 000 MGA",
        "category": "Collections spéciales",
        "date": "07/08/2025",
        "description": "Collection pour les orphelins",
        "receiptUrl": null,
        "timestamp": DateTime.now().subtract(const Duration(days: 4)),
      },
      {
        "id": 8,
        "type": "expense",
        "amount": "200 000 MGA",
        "category": "Maintenance",
        "date": "06/08/2025",
        "description": "Réparation du système de sonorisation",
        "receiptUrl":
            "https://images.pexels.com/photos/6863512/pexels-photo-6863512.jpeg?auto=compress&cs=tinysrgb&w=400",
        "timestamp": DateTime.now().subtract(const Duration(days: 5)),
      },
    ];

    _applyFilters();

    Future.delayed(const Duration(milliseconds: 800), () {
      setState(() {
        _isLoading = false;
      });
    });
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _loadMoreData();
    }
  }

  void _loadMoreData() {
    if (_isLoadingMore || !_hasMoreData) return;

    setState(() {
      _isLoadingMore = true;
    });

    // Simulate loading more data
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _isLoadingMore = false;
          _currentPage++;
          // In real app, load more transactions from API
          if (_currentPage > 3) {
            _hasMoreData = false;
          }
        });
      }
    });
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
    });
    _applyFilters();

    // Add to recent searches if not empty and not already present
    if (query.isNotEmpty && !_recentSearches.contains(query)) {
      setState(() {
        _recentSearches.insert(0, query);
        if (_recentSearches.length > 10) {
          _recentSearches = _recentSearches.take(10).toList();
        }
      });
    }
  }

  void _onRecentSearchTap(String search) {
    setState(() {
      _searchQuery = search;
    });
    _applyFilters();
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FilterBottomSheet(
        currentFilters: _activeFilters,
        onFiltersApplied: (filters) {
          setState(() {
            _activeFilters = filters;
          });
          _applyFilters();
        },
      ),
    );
  }

  void _applyFilters() {
    List<Map<String, dynamic>> filtered = List.from(_allTransactions);

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((transaction) {
        final searchLower = _searchQuery.toLowerCase();
        return (transaction['category'] as String)
                .toLowerCase()
                .contains(searchLower) ||
            (transaction['description'] as String)
                .toLowerCase()
                .contains(searchLower) ||
            (transaction['amount'] as String)
                .toLowerCase()
                .contains(searchLower);
      }).toList();
    }

    // Apply date range filter
    if (_activeFilters['dateRange'] != null) {
      final DateTimeRange dateRange =
          _activeFilters['dateRange'] as DateTimeRange;
      filtered = filtered.where((transaction) {
        final transactionDate = (transaction['timestamp'] as DateTime);
        return transactionDate
                .isAfter(dateRange.start.subtract(const Duration(days: 1))) &&
            transactionDate
                .isBefore(dateRange.end.add(const Duration(days: 1)));
      }).toList();
    }

    // Apply transaction type filter
    if (_activeFilters['transactionTypes'] != null) {
      final List<String> types =
          _activeFilters['transactionTypes'] as List<String>;
      filtered = filtered.where((transaction) {
        return types.contains(transaction['type'] as String);
      }).toList();
    }

    // Apply category filter
    if (_activeFilters['categories'] != null) {
      final List<String> categories =
          _activeFilters['categories'] as List<String>;
      filtered = filtered.where((transaction) {
        return categories.contains(transaction['category'] as String);
      }).toList();
    }

    // Apply amount range filter
    if (_activeFilters['amountRange'] != null) {
      final RangeValues amountRange =
          _activeFilters['amountRange'] as RangeValues;
      filtered = filtered.where((transaction) {
        final amountStr =
            (transaction['amount'] as String).replaceAll(RegExp(r'[^\d]'), '');
        final amount = double.tryParse(amountStr) ?? 0;
        return amount >= amountRange.start && amount <= amountRange.end;
      }).toList();
    }

    setState(() {
      _filteredTransactions = filtered;
    });
  }

  void _onFilterRemoved(String filterKey) {
    setState(() {
      if (filterKey.startsWith('category_')) {
        final category = filterKey.substring(9);
        if (_activeFilters['categories'] != null) {
          final List<String> categories =
              List<String>.from(_activeFilters['categories']);
          categories.remove(category);
          if (categories.isEmpty) {
            _activeFilters.remove('categories');
          } else {
            _activeFilters['categories'] = categories;
          }
        }
      } else {
        _activeFilters.remove(filterKey);
      }
    });
    _applyFilters();
  }

  void _clearAllFilters() {
    setState(() {
      _activeFilters.clear();
      _searchQuery = '';
    });
    _applyFilters();
  }

  Future<void> _refreshData() async {
    HapticFeedback.lightImpact();
    setState(() {
      _isLoading = true;
    });

    // Simulate refresh
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _isLoading = false;
      _lastSyncTime = DateTime.now();
    });
  }

  void _onTransactionTap(Map<String, dynamic> transaction) {
    // Navigate to transaction details
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Détails de la transaction: ${transaction['category']}'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _onEditTransaction(Map<String, dynamic> transaction) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Modifier: ${transaction['category']}'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _onDeleteTransaction(Map<String, dynamic> transaction) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Supprimer la transaction'),
        content: Text('Êtes-vous sûr de vouloir supprimer cette transaction ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _allTransactions
                    .removeWhere((t) => t['id'] == transaction['id']);
              });
              _applyFilters();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Transaction supprimée')),
              );
            },
            child: Text('Supprimer'),
          ),
        ],
      ),
    );
  }

  void _onDuplicateTransaction(Map<String, dynamic> transaction) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Dupliquer: ${transaction['category']}'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _onAddTransaction() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Ajouter une nouvelle transaction'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  int _getActiveFiltersCount() {
    int count = 0;
    if (_activeFilters['dateRange'] != null) count++;
    if (_activeFilters['transactionTypes'] != null) count++;
    if (_activeFilters['categories'] != null) {
      count += (_activeFilters['categories'] as List).length;
    }
    if (_activeFilters['amountRange'] != null) count++;
    return count;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('Historique des Transactions'),
        actions: [
          // Sync status indicator
          Container(
            margin: EdgeInsets.only(right: 4.w),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomIconWidget(
                  iconName: _isOnline ? 'cloud_done' : 'cloud_off',
                  color: _isOnline
                      ? AppTheme.lightTheme.colorScheme.tertiary
                      : AppTheme.lightTheme.colorScheme.error,
                  size: 20.sp,
                ),
                SizedBox(width: 1.w),
                Text(
                  _isOnline ? 'Sync' : 'Hors ligne',
                  style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                    color: _isOnline
                        ? AppTheme.lightTheme.colorScheme.tertiary
                        : AppTheme.lightTheme.colorScheme.error,
                  ),
                ),
              ],
            ),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabAlignment: TabAlignment.start,
          tabs: [
            Tab(text: 'Tableau de bord'),
            Tab(text: 'Transactions'),
            Tab(text: 'Projets'),
            Tab(text: 'Rapports'),
            Tab(text: 'Paramètres'),
            Tab(text: 'Plus'),
          ],
          onTap: (index) {
            if (index != 1) {
              // Navigate to other screens
              final routes = [
                '/dashboard',
                '/transaction-history',
                '/project-management',
                '/financial-reports',
                '/settings',
                '/settings',
              ];
              Navigator.pushReplacementNamed(context, routes[index]);
            }
          },
        ),
      ),
      body: Column(
        children: [
          // Search bar
          SearchBarWidget(
            searchQuery: _searchQuery,
            onSearchChanged: _onSearchChanged,
            onFilterTap: _showFilterBottomSheet,
            activeFiltersCount: _getActiveFiltersCount(),
            recentSearches: _recentSearches,
            onRecentSearchTap: _onRecentSearchTap,
          ),

          // Active filters chips
          FilterChipsWidget(
            activeFilters: _activeFilters,
            onFilterRemoved: _onFilterRemoved,
            onClearAll: _clearAllFilters,
          ),

          // Last sync info
          if (_lastSyncTime != null)
            Container(
              margin: EdgeInsets.symmetric(horizontal: 4.w),
              padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.tertiary
                    .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomIconWidget(
                    iconName: 'sync',
                    color: AppTheme.lightTheme.colorScheme.tertiary,
                    size: 14.sp,
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    'Dernière sync: ${_formatSyncTime(_lastSyncTime!)}',
                    style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.tertiary,
                    ),
                  ),
                ],
              ),
            ),

          SizedBox(height: 1.h),

          // Transaction list
          Expanded(
            child: _isLoading
                ? _buildLoadingState()
                : _filteredTransactions.isEmpty
                    ? EmptyStateWidget(
                        userRole: _userRole,
                        hasActiveFilters: _activeFilters.isNotEmpty ||
                            _searchQuery.isNotEmpty,
                        onAddTransaction: _onAddTransaction,
                        onClearFilters: _clearAllFilters,
                      )
                    : RefreshIndicator(
                        onRefresh: _refreshData,
                        child: ListView.builder(
                          controller: _scrollController,
                          physics: const AlwaysScrollableScrollPhysics(),
                          itemCount: _filteredTransactions.length +
                              (_isLoadingMore ? 1 : 0),
                          itemBuilder: (context, index) {
                            if (index == _filteredTransactions.length) {
                              return _buildLoadingMoreIndicator();
                            }

                            final transaction = _filteredTransactions[index];
                            return TransactionCard(
                              transaction: transaction,
                              userRole: _userRole,
                              onTap: () => _onTransactionTap(transaction),
                              onEdit: () => _onEditTransaction(transaction),
                              onDelete: () => _onDeleteTransaction(transaction),
                              onDuplicate: () =>
                                  _onDuplicateTransaction(transaction),
                              onViewDetails: () =>
                                  _onTransactionTap(transaction),
                              onShare: () => _shareTransaction(transaction),
                              onExport: () => _exportTransaction(transaction),
                              onAddToProject: () => _addToProject(transaction),
                            );
                          },
                        ),
                      ),
          ),
        ],
      ),
      floatingActionButton: _userRole != 'Observer'
          ? FloatingActionButton(
              onPressed: _onAddTransaction,
              child: CustomIconWidget(
                iconName: 'add',
                color: Colors.white,
                size: 24.sp,
              ),
            )
          : null,
    );
  }

  Widget _buildLoadingState() {
    return ListView.builder(
      itemCount: 6,
      itemBuilder: (context, index) => Container(
        margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
        height: 15.h,
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              colors: [
                Colors.grey.withValues(alpha: 0.1),
                Colors.grey.withValues(alpha: 0.3),
                Colors.grey.withValues(alpha: 0.1),
              ],
              stops: const [0.0, 0.5, 1.0],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingMoreIndicator() {
    return Container(
      padding: EdgeInsets.all(4.w),
      child: Center(
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(
            AppTheme.lightTheme.colorScheme.primary,
          ),
        ),
      ),
    );
  }

  String _formatSyncTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inMinutes < 1) {
      return 'À l\'instant';
    } else if (difference.inMinutes < 60) {
      return 'Il y a ${difference.inMinutes} min';
    } else if (difference.inHours < 24) {
      return 'Il y a ${difference.inHours}h';
    } else {
      return '${time.day}/${time.month}/${time.year}';
    }
  }

  void _shareTransaction(Map<String, dynamic> transaction) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Partager: ${transaction['category']}'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _exportTransaction(Map<String, dynamic> transaction) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Exporter: ${transaction['category']}'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _addToProject(Map<String, dynamic> transaction) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Ajouter au projet: ${transaction['category']}'),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
