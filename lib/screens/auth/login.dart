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
  _LoginPageState createState() => _LoginPageState();// create a state object for the loginpage class.
}

class _LoginPageState extends State<LoginPage> { // 
  final TextEditingController _pinController = TextEditingController();// create a text editing controller for pin.
  final TextEditingController _panController = TextEditingController();//  create a text editing controller for pan.

  @override
  void dispose() { // dispose method is called when the object is removed from the permanetly from the memory.
    _pinController.dispose(); // it will dipose the pin controller.
    _panController.dispose(); // it will dipose the pan controller.
    super.dispose();// super.dispose is used to call the dispose method of the parent class.
  }

  // Check if the user is logging in for the first time
  Future<bool> _checkIfFirstLogin() async {              // Future is used to represent a potential value or the error will exist in the future.
    final prefs = await SharedPreferences.getInstance(); // Shared preferences is used to store the data in the key value pair.
    return prefs.getBool('isFirstLogin') ?? true;        //getbool is used to get the value of the key from the shared preferences.
  }

  // Handle login process with MPIN and PAN
  Future<void> _handleLoginWithPin() async {   // Future is used to represent a potential value or the error will exist in the future.
    String enteredPan = _panController.text.trim(); // it will get the text from the pan controller and remove the white spaces.
    String enteredPin = _pinController.text.trim(); // it will get the text from the pin controller and remove the white spaces.

    try {                                                    // try block is used to enclose the code that might throw an exception and catch block is used to handle the exception.
      final querySnapshot = await FirebaseFirestore.instance // It will get the instance of the firebase firestore.
          .collection('users')                               // it will get the collection of the users.
          .where('pan', isEqualTo: enteredPan)               // it will get the pan from the users collection.
          .where('mpin', isEqualTo: enteredPin)              // it will get the mpin from the users collection.
          .get();

      if (querySnapshot.docs.isNotEmpty) {                  // If the query snapshot is not empty, then it will show the on login success.
        _onLoginSuccess(isFirstLogin: true);                // 
      } else {
        ScaffoldMessenger.of(context).showSnackBar(         // Scaffold messengers are used to show the snackbars.
          const SnackBar(content: Text("Incorrect PAN or MPIN")), // It will the snackbar with error message.
        );
      }
    } catch (e) {                                           // This code is used to handle teh exceptions.
      ScaffoldMessenger.of(context).showSnackBar(           // 
        SnackBar(content: Text("Login error: ${e.toString()}")),// 
      );
    }
  }

  Future<void> _onLoginSuccess({required bool isFirstLogin}) async { // Future is used to represent a potential value or the error will exist in the future.
    final prefs = await SharedPreferences.getInstance();             // Shared preference is used to store the data in the key value pair.
    await prefs.setBool('isLoggedIn', true);                         // It will set the value of the key to the shared preferences for users logging status.
    await prefs.setBool('isExistingUser', true);                     // It will set the value of the key to the shared preferences, if the user is existing user.
                                      
    if (isFirstLogin) {                                              // If the user is the first timer for login, then it will show the biometric authentication with mpin and pan login.
      final LocalAuthentication auth = LocalAuthentication();       //
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
      MaterialPageRoute(builder: (context) => const HomePage()),
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
