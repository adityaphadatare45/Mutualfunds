import 'package:cloud_firestore/cloud_firestore.dart'; // packages for handling database operations
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // provides persistent storage for simple data 
import 'package:local_auth/local_auth.dart';
import 'package:portfolio/verification/verificationpage.dart'; // Custom verification page

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState(); // creates the mutable for the widget
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _pinController = TextEditingController(); // controls the text fields
  final TextEditingController _panController = TextEditingController();
  
  get onPrimary => null;

  @override
  void dispose() { // clears all the state when the widget is removed from the widget tree
    _pinController.dispose();
    _panController.dispose();
    super.dispose();
  }

  // Handle login process with MPIN and PAN
  Future<void> _handleLoginWithPin() async { // uses Firestore to verify if the entered PAN and MPIN are stored in the Firestore database
    String enteredPan = _panController.text.trim(); // gets user inputs
    String enteredPin = _pinController.text.trim();

    try {
      // Query Firestore to check if PAN and MPIN match
      final querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('pan', isEqualTo: enteredPan)
          .where('mpin', isEqualTo: enteredPin)
          .get(); // fetches the documents for this query

      if (querySnapshot.docs.isNotEmpty) {
        // Login successful
        _onLoginSuccess();
      } else {
        // Show error if PAN and MPIN are incorrect
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

   Future<bool>_checkIfExistingUser() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isExistingUser') ?? false;
   }

  // Login success action
  Future<void> _onLoginSuccess() async { // when login is successful, navigate to the verification page
    print("Login Successful!");

    final prefs = await SharedPreferences.getInstance(); // shared preferences store the login status of the user
    await prefs.setBool('isLoggedIn', true); // sets the 'isLoggedIn' key to true
    await prefs.setBool('isExistingUser', true);
     final LocalAuthentication auth = LocalAuthentication();
  bool canCheckBiometrics = await auth.canCheckBiometrics;

  if (canCheckBiometrics) {
    bool authenticated = await auth.authenticate(
      localizedReason: 'Authenticate',
      options: const AuthenticationOptions(
        biometricOnly: true,
      ),
    );

    if (authenticated) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const VerificationPage()),
      );
      return; // Prevent further navigation
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Fingerprint authentication failed")),
      );
      return; // Avoid duplicate navigation
    }
  }


    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const VerificationPage()),
    );
  }

  @override
Widget build(BuildContext context) {
  return FutureBuilder<bool>(
    future: _checkIfExistingUser(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator());
      }
      bool isExistingUser = snapshot.data ?? false;

      return Scaffold(
        appBar: AppBar(
          title: const Text('Login'),
          backgroundColor: Colors.blue[50],
        ),
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/main-image.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
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
                if (isExistingUser)
                  ElevatedButton(
                    onPressed: () async {
                      final LocalAuthentication auth = LocalAuthentication();
                      bool authenticated = await auth.authenticate(
                        localizedReason: 'Authenticate to login',
                        options: const AuthenticationOptions(
                          biometricOnly: true,
                        ),
                      );

                      if (authenticated) {
                        _handleLoginWithPin();
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Authentication failed")),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.black,
                       backgroundColor: Colors.white10,
                       shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                       ),
                      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),  // Padding around the text
                       elevation: 5,  // Shadow effect
                    ),
                    child: const Text('Login with Fingerprint'),
                  ),
               if (!isExistingUser)
                 ElevatedButton(
                 onPressed: _handleLoginWithPin,
                 style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black, backgroundColor: Colors.white70,  // Text color
                 shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),  // Rounded corners
                 ),
                  padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),  // Padding around the text
                 elevation: 5,  // Shadow effect
                  ),
                 child: const Text(
                 'Login',
                 style: TextStyle(color: Colors.black),  // Text color
                    ),
                   ),
              ],
            ),
          ),
        ),
      );
    },
  );
 }
}