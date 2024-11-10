import 'package:cloud_firestore/cloud_firestore.dart'; //  packages for handling the  database operations 
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart'; // provides local authentication 
import 'package:flutter/services.dart';
import 'package:portfolio/screens/home.dart';
import 'package:portfolio/verification/verificationpage.dart';
import 'package:shared_preferences/shared_preferences.dart'; // provides persistent storage for simple data 

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState(); // creates the mutable for the widget 
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _pinController = TextEditingController(); // controls the text fields 
  final TextEditingController _panController = TextEditingController();
  final LocalAuthentication auth = LocalAuthentication();               // instance of local auth to manage biometric auth 
  bool _canCheckBiometrics = false;

  @override
  void initState() {      // USed to know that the device supports the biometric auth 
    super.initState();
    _checkBiometrics();
  }

  @override
  void dispose() {           // clears all the state when the widget is removed from the widgwt tree 
    _pinController.dispose();
    _panController.dispose();
    super.dispose();
  }

  // Check if the device has biometric capabilities
  Future<void> _checkBiometrics() async {
    try {
      bool canCheckBiometrics = await auth.canCheckBiometrics; // this line checks the deivces biometric capabilitites
      setState(() {
        _canCheckBiometrics = canCheckBiometrics;  // once the result is retrived setstate is used to update the ui 
      });
    } on PlatformException catch (e) {         // this blocks handles the errors that may arises when trying to access the biometric auth
      print("Error checking biometrics: $e");
    }
  }

  // Authenticate with fingerprint
  Future<void> _authenticateWithFingerprint() async {
    try {
      bool authenticated = await auth.authenticate(   // The authenticate() method from the LocalAuthentication instance is used to trigger the biometric authentication process
        localizedReason: 'Use fingerprint to log in', // The await keyword pauses the function's execution until the authentication process completes.
        options: const AuthenticationOptions( // defines the opstions for authentication 
          biometricOnly: true,                 //  This option specifies that only biometric authentication should be used 
          stickyAuth: true,                    // This option ensures that the authentication state remains valid even if the app is temporarily interrupted
        ),
      );
      if (authenticated) {  // if the authentication is successful the methods calls the loginsuccess
        _onLoginSuccess();
      }
    } on PlatformException catch (e) {   // If there’s an error during the authentication process, such as if the device does not support biometrics or if the user cancels the authentication, a PlatformException is thrown.
      print("Error authenticating: $e");
      ScaffoldMessenger.of(context).showSnackBar(      // If an error occurs, a SnackBar is shown with the error message. 
        SnackBar(content: Text("Error: ${e.message}")), // This provides feedback to the user, so they know that the authentication attempt failed.
      );
    }
  }

  // Handle login process with MPIN and PAN
  Future<void> _handleLoginWithPin() async {        // uses the firestore to verify if the entered pan ans pin is stored in the firestore database 
    String enteredPan = _panController.text.trim(); // use to get user inputs 
    String enteredPin = _pinController.text.trim();

    try {
      // Query Firestore to check if PAN and MPIN match
      final querySnapshot = await FirebaseFirestore.instance  //  It queries the users collection in Firestore where the document’s pan field matches the entered PAN and the mpin field matches the entered MPIN.
          .collection('users')
          .where('pan', isEqualTo: enteredPan)
          .where('mpin', isEqualTo: enteredPin)
          .get();                                   // fetch the document for this query results 

      if (querySnapshot.docs.isNotEmpty) {  // if query returs document , the login is successful and loginsuccess method is called 
        // Login successful
        _onLoginSuccess();
      } else {
        // Show error if PAN and MPIN are incorrect
        ScaffoldMessenger.of(context).showSnackBar(             // if no records are found then show the error msg   
          const SnackBar(content: Text("Incorrect PAN or MPIN")),
        );
      }
    } catch (e) {
      print("Error during login: $e");                   // if anythings happens in the query process it shows the error 
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Login error: ${e.toString()}")),
      );
    }
  }

  // Login success action
  Future<void> _onLoginSuccess() async {       // when the login is succesfull navigate to home screen 
    print("Login Successful!");

    final prefs = await SharedPreferences.getInstance();  // shared preferences is uesd to store the data , In this case it saves the logging status of the user 
                                                         // getIntance retrieves the instance the shared preferences 
    await prefs.setBool('isLoggedIn', true);              // setBool store the key value pair 
    
    Navigator.pushReplacement(                           // If the login is successful it will navigate to  the verification page 
      context,
      MaterialPageRoute(builder: (context) => const VerificationPage()),
    );
  }

  @override
  Widget build(BuildContext context) {  // build method is override 
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _panController,
              decoration: const InputDecoration(
                labelText: 'Enter PAN',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _pinController,
              obscureText: true,
              maxLength: 4,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Enter MPIN',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _handleLoginWithPin,
              child: const Text('Login'),
            ),
            if (_canCheckBiometrics) ...[
              const SizedBox(height: 20),
              ElevatedButton.icon(
                icon: const Icon(Icons.fingerprint),
                label: const Text('Login with Fingerprint'),
                onPressed: _authenticateWithFingerprint,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
