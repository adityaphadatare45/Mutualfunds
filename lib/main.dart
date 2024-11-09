import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:portfolio/identity/identity.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/auth/login.dart'; // import login path
// import 'screens/auth/signup.dart'; // import signup path
import 'screens/home.dart'; // import home page after login

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Hide debug banner
      title: 'Mutual Funds',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const AuthWrapper(), // Use AuthWrapper to handle login state
    );
  }
}

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({Key? key}) : super(key: key);

  @override
  _AuthWrapperState createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus(); // Check login status when the app starts
  }

  // Check if the user is logged in
  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false; // Default to false if not found
    setState(() {
      _isLoggedIn = isLoggedIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Wait for the login status to be checked before building the UI
    if (!_isLoggedIn) {
      // If not logged in, show the WelcomeScreen
      return const HomePage();
    } else {
      // If logged in, show the HomePage
      return const WelcomeScreen();
    }
  }
}

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tri Funds'),
         backgroundColor: Colors.blue[50], // Transparent background
             elevation: 0, // Optional: Remove shadow
                
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/main-image.jpg'),
            fit: BoxFit.cover, // This ensures the image covers the entire screen
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Welcome to Tri Funds',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const IdentityPage()),
                  );
                },
                child: const Text('Sign Up', style: TextStyle(color: Colors.white)),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                  );
                },
                
                child: const Text('Login', style: TextStyle(color: Colors.white)),
              ),
              const SizedBox(height: 25),

              const Text(
                'OR',
                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                textAlign: TextAlign.center,
                ),
              
            ],

           
          ),
        ),
      ),
    );
  }
}
