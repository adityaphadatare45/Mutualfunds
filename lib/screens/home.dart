import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // provides persistent storage for simple data
import 'package:portfolio/main.dart'; // Ensure this path is correct for importing WelcomeScreen

class HomePage extends StatelessWidget {
   final User user;
  const HomePage({super.key, required this.user});

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
              logout(context);  
                      // Call logout functions
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Welcome, ${user.displayName ?? 'User'}"),
            Text("Email: ${user.email ?? 'N/A'}"),
            CircleAvatar(
              backgroundImage: NetworkImage(user.photoURL ?? ''),
              radius: 40,
            ),
          ],
        ),
      ),
    );
  }
}
