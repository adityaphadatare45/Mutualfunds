import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // provides persistent storage for simple data 
import 'package:local_auth/local_auth.dart';
import 'package:portfolio/verification/verificationpage.dart'; // Custom verification page

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _pinController = TextEditingController(); // controls the text fields
  final TextEditingController _panController = TextEditingController();

  @override
  void dispose() {
    _pinController.dispose();
    _panController.dispose();
    super.dispose();
  }

  // Check if the user is logging in for the first time
  Future<bool> _checkIfFirstLogin() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isFirstLogin') ?? true;
  }

  // Handle login process with MPIN and PAN
  Future<void> _handleLoginWithPin() async {
    String enteredPan = _panController.text.trim(); 
    String enteredPin = _pinController.text.trim();

    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('pan', isEqualTo: enteredPan)
          .where('mpin', isEqualTo: enteredPin)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        _onLoginSuccess(isFirstLogin: true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Incorrect PAN or MPIN")),
        );
      }
    } catch (e) {
      print("Error during login: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Login error: ${e.toString()}")),
      );
    }
  }

  Future<void> _onLoginSuccess({required bool isFirstLogin}) async {
    print("Login Successful!");

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);
    await prefs.setBool('isExistingUser', true);

    if (isFirstLogin) {
      final LocalAuthentication auth = LocalAuthentication();
      bool canCheckBiometrics = await auth.canCheckBiometrics;

      if (canCheckBiometrics) {
        bool authenticated = await auth.authenticate(
          localizedReason: 'Authenticate with biometrics to complete setup',
          options: const AuthenticationOptions(biometricOnly: true),
        );

        if (authenticated) {
          await prefs.setBool('isFirstLogin', false);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const VerificationPage()),
          );
          return;
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Fingerprint authentication failed")),
          );
          return;
        }
      }
    }
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const VerificationPage()),
    );
  }

  Future<void> _handleBiometricLogin() async {
    final LocalAuthentication auth = LocalAuthentication();
    bool canCheckBiometrics = await auth.canCheckBiometrics;

    if (canCheckBiometrics) {
      bool authenticated = await auth.authenticate(
        localizedReason: 'Authenticate with biometrics',
        options: const AuthenticationOptions(biometricOnly: true),
      );

      if (authenticated) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const VerificationPage()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Authentication failed")),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Biometric authentication not available")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _checkIfFirstLogin(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        bool isFirstLogin = snapshot.data ?? true;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Login'),
            backgroundColor: Colors.blue[50],
          ),
          body: Stack(
            children: [
              // Background image stretched across the screen
              Positioned.fill(
                child: Image.asset(
                  'assets/images/main-image.jpg',
                  fit: BoxFit.cover, // Ensures the image covers the entire screen
                ),
              ),
              // SafeArea to prevent the UI from overlapping with system UI like notches or the navigation bar
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (isFirstLogin) ...[
                        TextField(
                          controller: _panController,
                          decoration: InputDecoration(
                            labelText: 'Enter PAN',
                            fillColor: Colors.white70,
                            filled: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextField(
                          controller: _pinController,
                          obscureText: true,
                          maxLength: 4,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'Enter MPIN',
                            fillColor: Colors.white70,
                            filled: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: _handleLoginWithPin,
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.black,
                            backgroundColor: Colors.white70,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
                            elevation: 5,
                          ),
                          child: const Text(
                            'Login with PAN & MPIN',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ],
                      const SizedBox(height: 20),
                      if (!isFirstLogin) ...[
                        ElevatedButton(
                          onPressed: _handleBiometricLogin,
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.black,
                            backgroundColor: Colors.white10,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
                            elevation: 5,
                          ),
                          child: const Text('Login with Biometrics'),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
