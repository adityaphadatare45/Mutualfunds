import 'package:cloud_firestore/cloud_firestore.dart'; // packages for handling database operations
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // provides persistent storage for simple data 

import 'package:portfolio/verification/verificationpage.dart'; // Custom verification page

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState(); // creates the mutable for the widget
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _pinController = TextEditingController(); // controls the text fields
  final TextEditingController _panController = TextEditingController();

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

  // Login success action
  Future<void> _onLoginSuccess() async { // when login is successful, navigate to the verification page
    print("Login Successful!");

    final prefs = await SharedPreferences.getInstance(); // shared preferences store the login status of the user
    await prefs.setBool('isLoggedIn', true); // sets the 'isLoggedIn' key to true

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const VerificationPage()),
    );
  }

  @override
  Widget build(BuildContext context) { // builds the widget tree
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        backgroundColor: Colors.blue[50],
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/main-image.jpg'), // Replace with your image path
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
              ElevatedButton(
                onPressed: _handleLoginWithPin,
                child: const Text(
                  'Login',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
