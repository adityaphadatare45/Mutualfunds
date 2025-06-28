import 'package:flutter/material.dart';
import 'package:jailbreak_root_detection/jailbreak_root_detection.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:local_auth/local_auth.dart';
import 'package:usb_debug_checker/usb_debug_checker.dart';
// import 'package:flutter_jailbreak_detection/flutter_jailbreak_detection.dart';
import 'package:mobileOs/screens/Welcomescreen.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  final LocalAuthentication auth = LocalAuthentication();

  @override
  void initState() {
    super.initState();
    _checkSecurity();
  }

  Future<void> _checkPermissionsAndAuthenticate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool hasGivenPermission = prefs.getBool('local_auth_permission') ?? false;

    if (!hasGivenPermission) {
      _showPermissionDialog();
    } else {
      _authenticateUser();
    }
  }

  Future<void> _checkSecurity() async {
    bool isRooted = await JailbreakRootDetection.instance.isJailBroken;
    bool isUsbDebugging = await UsbDebugChecker.isUsbDebuggingEnabled();
    bool isDevMode = false; // or use another plugin if you need dev mode detection

    //bool isDevMode = await FlutterJailbreakDetection.developerMode;

    if (isRooted) {
      _showBlockedDialog("Root Detected", "This app cannot run on rooted devices.");
    } else if (isUsbDebugging) {
      _showBlockedDialog("USB Debugging Enabled", "Please disable USB Debugging to use this app.");
    } else {
      _checkPermissionsAndAuthenticate();
    }
  }
Future<void> _authenticateUser() async {
  try {
    // Optional: Perform real biometric auth here
    await Future.delayed(const Duration(seconds: 2)); // Simulate waiting or splash delay
  } catch (e) {
    print("Authentication error: $e");
  }

  if (mounted) {
    _navigateToLogin();
  }
}

  void _showPermissionDialog() {
    showDialog(
      context: context,   
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text("Enable Local Authentication"),
        content: const Text("To enhance security, please allow biometric or PIN authentication."),
        actions: [
          TextButton(
            onPressed: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              await prefs.setBool('local_auth_permission', true);
              Navigator.pop(context);
              _authenticateUser();
            },
            child: const Text("Enable"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _navigateToLogin();
            },
            child: const Text("Cancel"),
          ),
        ],
      ),
    );
  }

  void _showBlockedDialog(String title, String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton( 
            onPressed: () {
              Navigator.pop(context);
              // Optionally: close the app with `SystemNavigator.pop()` or prevent further navigation
            },
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  /*void _navigateToHome() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomePage(token: '',)),
    );
  }*/

  void _navigateToLogin() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const WelcomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[300], // Adjusted to a darker shade
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/icon/logo2.jpg", 
            height: 100),
            const SizedBox(height: 20),
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
