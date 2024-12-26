import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:portfolio/screens/home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:local_auth/local_auth.dart';
import 'package:portfolio/verification/verificationpage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  // create a a class named loginpage which extends to stateful widget, which means it have mutable state.
  // Super 
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _pinController = TextEditingController();
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Login error: ${e.toString()}")),
      );
    }
  }

  Future<void> _onLoginSuccess({required bool isFirstLogin}) async {
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
            MaterialPageRoute(builder: (context) => const HomePage()),
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

  Widget _buildLoginContent(bool isFirstLogin) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (isFirstLogin) ...[
          _buildTextField(
            controller: _panController,
            labelText: 'Enter PAN',
          ),
          const SizedBox(height: 20),
          _buildTextField(
            controller: _pinController,
            labelText: 'Enter MPIN',
            isPassword: true,
          ),
          const SizedBox(height: 20),
          _buildButton(
            label: 'Login with PAN & MPIN',
            onPressed: _handleLoginWithPin,
          ),
        ],
        const SizedBox(height: 20),
        if (!isFirstLogin) ...[
         
          _buildButton(
            label: 'Login with Biometrics',
            onPressed: _handleBiometricLogin,
            
          ),
        ],
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    bool isPassword = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      keyboardType:
          isPassword ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        labelText: labelText,
        fillColor: Colors.white70,
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
      ),
    );
  }

  Widget _buildButton({
    required String label,
    required VoidCallback onPressed,
  }) {
    return TextButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.black,
        backgroundColor: Colors.white70,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
        elevation: 5,
      
      ),
      child: Text(label, style: const TextStyle(color: Colors.black)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _checkIfFirstLogin(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        bool isFirstLogin = snapshot.data ?? true;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Login'),
            backgroundColor: Colors.blue[50],
          ),
          body: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/main-image.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: _buildLoginContent(isFirstLogin),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
