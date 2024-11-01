import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter/services.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _pinController = TextEditingController();
  final LocalAuthentication auth = LocalAuthentication();
  bool _canCheckBiometrics = false;

  @override
  void initState() {
    super.initState();
    _checkBiometrics();
  }

  // Check if the device has biometric capabilities
  Future<void> _checkBiometrics() async {
    try {
      bool canCheckBiometrics = await auth.canCheckBiometrics;
      setState(() {
        _canCheckBiometrics = canCheckBiometrics;
      });
    } on PlatformException catch (e) {
      print("Error checking biometrics: $e");
    }
  }

  // Authenticate with fingerprint
  Future<void> _authenticateWithFingerprint() async {
    try {
      bool authenticated = await auth.authenticate(
        localizedReason: 'Use fingerprint to log in',
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
        ),
      );
      if (authenticated) {
        // Proceed with login
        _onLoginSuccess();
      }
    } on PlatformException catch (e) {
      print("Error authenticating: $e");
    }
  }

  // Handle login process with MPIN
  void _handleLoginWithPin() {
    const storedPin = "1234"; // Example stored PIN, replace with actual storage retrieval
    if (_pinController.text == storedPin) {
      _onLoginSuccess();
    } else {
      print("Incorrect MPIN");
    }
  }

  // Login success action
  void _onLoginSuccess() {
    // Navigate to the next page or home page
    print("Login Successful!");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _pinController,
              obscureText: true,
              maxLength: 4,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Enter MPIN',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _handleLoginWithPin,
              child: Text('Login with MPIN'),
            ),
            if (_canCheckBiometrics) ...[
              SizedBox(height: 20),
              ElevatedButton.icon(
                icon: Icon(Icons.fingerprint),
                label: Text('Login with Fingerprint'),
                onPressed: _authenticateWithFingerprint,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
