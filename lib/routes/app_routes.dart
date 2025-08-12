import 'package:flutter/material.dart';
import '../presentation/settings/settings.dart';
import '../presentation/financial_reports/financial_reports.dart';
import '../presentation/splash_screen/splash_screen.dart';
import '../presentation/dashboard/dashboard.dart';
import '../presentation/transaction_history/transaction_history.dart';
import '../presentation/project_management/project_management.dart';
import '../presentation/login/login_screen.dart';

class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/';
  static const String settings = '/settings';
  static const String financialReports = '/financial-reports';
  static const String splash = '/splash-screen';
  static const String dashboard = '/dashboard';
  static const String transactionHistory = '/transaction-history';
  static const String projectManagement = '/project-management';
  static const String login = '/login';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const SplashScreen(),
    settings: (context) => const Settings(),
    financialReports: (context) => const FinancialReports(),
    splash: (context) => const SplashScreen(),
    dashboard: (context) => const Dashboard(),
    transactionHistory: (context) => const TransactionHistory(),
    projectManagement: (context) => const ProjectManagement(),
    login: (context) => const LoginScreen(),
    // TODO: Add your other routes here
  };
}
