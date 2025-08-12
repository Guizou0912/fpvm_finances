import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/about_section_widget.dart';
import './widgets/app_preferences_section_widget.dart';
import './widgets/bottom_navigation_widget.dart';
import './widgets/data_management_section_widget.dart';
import './widgets/notification_section_widget.dart';
import './widgets/profile_section_widget.dart';
import './widgets/role_specific_section_widget.dart';
import './widgets/security_section_widget.dart';
import './widgets/sync_section_widget.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  // Mock user profile data
  final Map<String, dynamic> _userProfile = {
    "id": 1,
    "name": "Marie Rasoamanana",
    "role": "Admin Church",
    "church": "FPVM Antananarivo Centre",
    "email": "marie.rasoamanana@fpvm.mg",
    "avatar":
        "https://images.pexels.com/photos/774909/pexels-photo-774909.jpeg?auto=compress&cs=tinysrgb&w=400",
  };

  // Security settings
  bool _biometricEnabled = true;
  int _sessionTimeout = 15;

  // Notification settings
  final Map<String, bool> _notificationSettings = {
    "transactionAlerts": true,
    "reportCompletion": true,
    "budgetWarnings": false,
    "syncStatus": true,
  };

  // App preferences
  String _currencyFormat = "MGA";
  String _dateFormat = "DD/MM/YYYY";
  String _language = "Français";

  // Sync settings
  DateTime? _lastSyncTime = DateTime.now().subtract(Duration(minutes: 23));
  bool _isSyncing = false;
  String _connectionStatus = "Connecté";

  // Data management
  final String _offlineDataSize = "2.4 MB";
  final DateTime? _lastBackup = DateTime.now().subtract(Duration(hours: 6));

  @override
  Widget build(BuildContext context) {
    final bool isLight = Theme.of(context).brightness == Brightness.light;

    return Scaffold(
      backgroundColor:
          isLight ? AppTheme.backgroundLight : AppTheme.backgroundDark,
      appBar: _buildAppBar(context, isLight),
      body: _buildBody(context, isLight),
      bottomNavigationBar: BottomNavigationWidget(
        currentIndex: 4,
        onTap: (index) {},
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, bool isLight) {
    return AppBar(
      backgroundColor: isLight
          ? AppTheme.lightTheme.colorScheme.surface
          : AppTheme.darkTheme.colorScheme.surface,
      elevation: 2,
      automaticallyImplyLeading: false,
      title: Text(
        'Paramètres',
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: isLight
                  ? AppTheme.textPrimaryLight
                  : AppTheme.textPrimaryDark,
            ),
      ),
      centerTitle: true,
      actions: [
        IconButton(
          onPressed: () => _showLogoutDialog(context, isLight),
          icon: CustomIconWidget(
            iconName: 'logout',
            color: isLight ? AppTheme.errorLight : AppTheme.errorDark,
            size: 6.w,
          ),
        ),
      ],
    );
  }

  Widget _buildBody(BuildContext context, bool isLight) {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Column(
        children: [
          SizedBox(height: 1.h),
          ProfileSectionWidget(
            userProfile: _userProfile,
            onEditProfile:
                _userProfile['role'] == 'Admin Church' ? _editProfile : null,
          ),
          SecuritySectionWidget(
            biometricEnabled: _biometricEnabled,
            onBiometricToggle: _toggleBiometric,
            onChangePassword: _changePassword,
            sessionTimeout: _sessionTimeout,
            onSessionTimeoutChange: _updateSessionTimeout,
          ),
          NotificationSectionWidget(
            notificationSettings: _notificationSettings,
            onNotificationToggle: _updateNotificationSetting,
          ),
          DataManagementSectionWidget(
            onExportPDF: _exportPDF,
            onExportExcel: _exportExcel,
            lastBackup: _lastBackup,
            offlineDataSize: _offlineDataSize,
            onClearCache: _clearCache,
          ),
          AppPreferencesSectionWidget(
            currencyFormat: _currencyFormat,
            dateFormat: _dateFormat,
            language: _language,
            onCurrencyFormatChange: _updateCurrencyFormat,
            onDateFormatChange: _updateDateFormat,
            onLanguageChange: _updateLanguage,
          ),
          SyncSectionWidget(
            lastSyncTime: _lastSyncTime,
            isSyncing: _isSyncing,
            connectionStatus: _connectionStatus,
            onManualSync: _performManualSync,
          ),
          RoleSpecificSectionWidget(
            userRole: _userProfile['role'] as String,
            onUserManagement: _userProfile['role'] == 'Admin Church'
                ? _openUserManagement
                : null,
            onChurchSettings: _userProfile['role'] == 'Admin Church'
                ? _openChurchSettings
                : null,
            onTransactionPreferences: _userProfile['role'] == 'Treasurer'
                ? _openTransactionPreferences
                : null,
            onReportSettings:
                _userProfile['role'] == 'Observer' ? _openReportSettings : null,
          ),
          AboutSectionWidget(
            appVersion: "1.2.3 (Build 45)",
            onPrivacyPolicy: _openPrivacyPolicy,
            onTermsOfService: _openTermsOfService,
            onContactSupport: _contactSupport,
          ),
          SizedBox(height: 2.h),
          _buildLogoutButton(context, isLight),
          SizedBox(height: 4.h),
        ],
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context, bool isLight) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () => _showLogoutDialog(context, isLight),
        style: ElevatedButton.styleFrom(
          backgroundColor: isLight ? AppTheme.errorLight : AppTheme.errorDark,
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(vertical: 2.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'logout',
              color: Colors.white,
              size: 5.w,
            ),
            SizedBox(width: 2.w),
            Text(
              'Se déconnecter',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  void _editProfile() {
    _showToast('Modification du profil - Fonctionnalité à venir');
  }

  void _toggleBiometric(bool enabled) {
    setState(() {
      _biometricEnabled = enabled;
    });
    _showToast(enabled
        ? 'Authentification biométrique activée'
        : 'Authentification biométrique désactivée');
  }

  void _changePassword() {
    _showToast('Changement de mot de passe - Fonctionnalité à venir');
  }

  void _updateSessionTimeout(int timeout) {
    setState(() {
      _sessionTimeout = timeout;
    });
    _showToast('Délai d\'expiration mis à jour: $timeout minutes');
  }

  void _updateNotificationSetting(String key, bool value) {
    setState(() {
      _notificationSettings[key] = value;
    });
    _showToast('Paramètre de notification mis à jour');
  }

  void _exportPDF() {
    _showToast('Export PDF en cours...');
    // Simulate export process
    Future.delayed(Duration(seconds: 2), () {
      _showToast('Export PDF terminé');
    });
  }

  void _exportExcel() {
    _showToast('Export Excel en cours...');
    // Simulate export process
    Future.delayed(Duration(seconds: 2), () {
      _showToast('Export Excel terminé');
    });
  }

  void _clearCache() {
    _showToast('Cache vidé avec succès');
  }

  void _updateCurrencyFormat(String format) {
    setState(() {
      _currencyFormat = format;
    });
    _showToast('Format de devise mis à jour: $format');
  }

  void _updateDateFormat(String format) {
    setState(() {
      _dateFormat = format;
    });
    _showToast('Format de date mis à jour: $format');
  }

  void _updateLanguage(String language) {
    setState(() {
      _language = language;
    });
    _showToast('Langue mise à jour: $language');
  }

  void _performManualSync() {
    setState(() {
      _isSyncing = true;
    });

    Future.delayed(Duration(seconds: 3), () {
      setState(() {
        _isSyncing = false;
        _lastSyncTime = DateTime.now();
      });
      _showToast('Synchronisation terminée avec succès');
    });
  }

  void _openUserManagement() {
    _showToast('Gestion des utilisateurs - Fonctionnalité à venir');
  }

  void _openChurchSettings() {
    _showToast('Paramètres de l\'église - Fonctionnalité à venir');
  }

  void _openTransactionPreferences() {
    _showToast('Préférences de transaction - Fonctionnalité à venir');
  }

  void _openReportSettings() {
    _showToast('Paramètres de rapport - Fonctionnalité à venir');
  }

  void _openPrivacyPolicy() {
    _showToast('Politique de confidentialité - Fonctionnalité à venir');
  }

  void _openTermsOfService() {
    _showToast('Conditions d\'utilisation - Fonctionnalité à venir');
  }

  void _contactSupport() {
    _showToast('Contact support - Fonctionnalité à venir');
  }

  void _showLogoutDialog(BuildContext context, bool isLight) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: isLight
              ? AppTheme.lightTheme.colorScheme.surface
              : AppTheme.darkTheme.colorScheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            'Confirmation',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: isLight
                      ? AppTheme.textPrimaryLight
                      : AppTheme.textPrimaryDark,
                ),
          ),
          content: Text(
            'Êtes-vous sûr de vouloir vous déconnecter?',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: isLight
                      ? AppTheme.textPrimaryLight
                      : AppTheme.textPrimaryDark,
                ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Annuler',
                style: TextStyle(
                  color: isLight
                      ? AppTheme.textSecondaryLight
                      : AppTheme.textSecondaryDark,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _performLogout();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    isLight ? AppTheme.errorLight : AppTheme.errorDark,
                foregroundColor: Colors.white,
              ),
              child: Text('Se déconnecter'),
            ),
          ],
        );
      },
    );
  }

  void _performLogout() {
    _showToast('Déconnexion en cours...');
    Future.delayed(Duration(seconds: 1), () {
      Navigator.pushNamedAndRemoveUntil(
          context, '/splash-screen', (route) => false);
    });
  }

  void _showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.black87,
      textColor: Colors.white,
      fontSize: 14.sp,
    );
  }
}
