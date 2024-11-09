import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter/services.dart';
import 'package:portfolio/identity/identity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:portfolio/screens/home.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController _pinController = TextEditingController();
  final LocalAuthentication auth = LocalAuthentication();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _canCheckBiometrics = false;
  bool _isFingerprintEnabled = true;

  @override
  void initState() {
    super.initState();
    _checkBiometrics();
  }

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
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
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      }
    } on PlatformException catch (e) {
      print("Error authenticating: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${e.message}")),
      );
    }
  }

  // Save MPIN to Firestore for the current user
  Future<void> _saveMpinToFirebase(String mpin) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await _firestore.collection('users').doc(user.uid).set({
          'mpin': mpin,
          'timestamp': FieldValue.serverTimestamp(),
        });
        print("MPIN saved successfully");
      }
    } catch (e) {
      print("Error saving MPIN: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error saving MPIN: ${e.toString()}")),
      );
    }
  }

  // Handle signup process
  void _handleSignup() {
    if (_pinController.text.isNotEmpty && _pinController.text.length == 4) {
      _saveMpinToFirebase(_pinController.text);

      if (_isFingerprintEnabled) {
        _authenticateWithFingerprint();
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const IdentityPage()),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Enter a valid 4-digit PIN")),
      );
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
