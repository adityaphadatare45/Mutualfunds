import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // provides persistent storage for simple data
import 'package:portfolio/main.dart'; // Ensure this path is correct for importing WelcomeScreen

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  // Logout function that clears login state and navigates to WelcomeScreen
  Future<void> logout(BuildContext context) async {    // logout is asynchronous function that performs two actions 
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
              logout(context);  // Call logout function
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.home,
              size: 100,
              color: Colors.blue,
            ),
            const SizedBox(height: 20),
            const Text(
              'Welcome to the Home Page!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Text(
              'You are now logged in.',
              style: TextStyle(fontSize: 18, color: Colors.grey[600]),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                print("Explore More Features clicked");
              },
              child: const Text('Explore More Features'),
            ),
          ],
        ),
      ),
    );
  }
}
