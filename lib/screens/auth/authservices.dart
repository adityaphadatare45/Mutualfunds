// auth_service.dart
import 'package:local_auth/local_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // for shared preferences

class AuthService {
  final LocalAuthentication _localAuth = LocalAuthentication();

  // Method to authenticate with fingerprint
  Future<bool> authenticateWithFingerprint(BuildContext context) async {
    final bool canCheckBiometrics = await _localAuth.canCheckBiometrics;
    if (!canCheckBiometrics) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Fingerprint authentication not available')),
      );
      return false;
    }

    try {
      final bool authenticated = await _localAuth.authenticate(
        localizedReason: 'Authenticate to access your account',
        options: const AuthenticationOptions(
          biometricOnly: true, // Use only biometrics
        ),
      );

      if (authenticated) {
        // Save login status in SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        prefs.setBool('isLoggedIn', true); // Save login status as true
      }
      
      return authenticated;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Authentication error: $e')),
      );
      return false;
    }
  }

  // Method to check if the user is logged in
  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false; // Returns false if the key is not found
  }

  // Method to log out and clear the saved login status
  Future<void> logOut() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isLoggedIn', false); // Set login status to false (log out)
  }
}
