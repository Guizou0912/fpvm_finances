import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String _hardcodedEmail = 'randrianirina.tsiorypro@gmail.com';
  static const String _hardcodedPassword = 'Tsiurvk3131*';
  static const String _authTokenKey = 'auth_token';
  static const String _userRoleKey = 'user_role';

  static AuthService? _instance;
  static AuthService get instance => _instance ??= AuthService._();

  AuthService._();

  /// Authenticate with hardcoded Super Admin credentials
  Future<AuthResult> login(String email, String password) async {
    await Future.delayed(
        const Duration(milliseconds: 800)); // Simulate network delay

    if (email.trim().toLowerCase() == _hardcodedEmail.toLowerCase() &&
        password == _hardcodedPassword) {
      // Store authentication state
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_authTokenKey,
          'super_admin_token_${DateTime.now().millisecondsSinceEpoch}');
      await prefs.setString(_userRoleKey, 'super_admin');

      return AuthResult(
        success: true,
        message: 'Connexion réussie',
        user: UserData(
          email: _hardcodedEmail,
          role: UserRole.superAdmin,
          name: 'Super Administrateur',
        ),
      );
    } else {
      return AuthResult(
        success: false,
        message: 'Email ou mot de passe incorrect',
      );
    }
  }

  /// Check if user is currently authenticated
  Future<bool> isAuthenticated() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_authTokenKey);
    return token != null && token.isNotEmpty;
  }

  /// Get current user data
  Future<UserData?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_authTokenKey);
    final role = prefs.getString(_userRoleKey);

    if (token != null && role == 'super_admin') {
      return UserData(
        email: _hardcodedEmail,
        role: UserRole.superAdmin,
        name: 'Super Administrateur',
      );
    }
    return null;
  }

  /// Logout user
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_authTokenKey);
    await prefs.remove(_userRoleKey);
  }

  /// Check if user has Super Admin privileges
  Future<bool> isSuperAdmin() async {
    final prefs = await SharedPreferences.getInstance();
    final role = prefs.getString(_userRoleKey);
    return role == 'super_admin';
  }
}

class AuthResult {
  final bool success;
  final String message;
  final UserData? user;

  AuthResult({
    required this.success,
    required this.message,
    this.user,
  });
}

class UserData {
  final String email;
  final UserRole role;
  final String name;

  UserData({
    required this.email,
    required this.role,
    required this.name,
  });
}

enum UserRole {
  superAdmin,
  admin,
  user,
}
