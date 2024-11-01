import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter/services.dart';
import 'package:portfolio/screens/home.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController _pinController = TextEditingController();
  final LocalAuthentication auth = LocalAuthentication();
  bool _canCheckBiometrics = false;
  bool _isFingerprintEnabled = false;

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
        localizedReason: 'Authenticate to access the app',
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
        ),
      );
      if (authenticated) {
        // Proceed with login or signup actions
        print("Authenticated successfully");

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder:(context)=>HomePage())
        );
      }
    } on PlatformException catch (e) {
      print("Error authenticating: $e");
    }
  }

    // Handle signup process
  void _handleSignup() {
    if (_pinController.text.isNotEmpty && _pinController.text.length == 4) {
      // Save PIN securely here (use secure storage in production apps)
      print("MPIN saved successfully");
      
      if (_isFingerprintEnabled) {
        _authenticateWithFingerprint();
      } else {
        // Navigate to the HomePage if fingerprint is not enabled
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      }
    } else {
      print("Enter a 4-digit PIN");
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Signup')),
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
              decoration: const InputDecoration(
                labelText: 'Enter 4-digit MPIN',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            if (_canCheckBiometrics)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Enable Fingerprint Authentication'),
                  Switch(
                    value: _isFingerprintEnabled,
                    onChanged: (value) {
                      setState(() {
                        _isFingerprintEnabled = value;
                      });
                    },
                  ),
                ],
              ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _handleSignup,
              child: const Text('Sign Up'),
            ),
          ],
        ),
      ),
    );
  }
}
