import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:portfolio/main.dart'; // Ensure this path is correct

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  // Logout function that clears login state and navigates to WelcomeScreen
  Future<void> logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);  // Clear login state
    await prefs.setBool('isSignedIn', false);  // Clear sign-up state

    // Navigate to WelcomeScreen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const WelcomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              logout(context); // Call logout function
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text("Welcome to the Home Page!"),
            Text("Enjoy using the app."),
          ],
        ),
      ),
    );
  }
}
