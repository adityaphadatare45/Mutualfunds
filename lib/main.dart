import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart'; // Used to fire base initialization 
import 'package:flutter/material.dart';
import 'package:portfolio/identity/identity.dart';
import 'package:shared_preferences/shared_preferences.dart'; // provides persistent storage for simple data
import 'screens/auth/login.dart'; // import login path
// import 'screens/auth/signup.dart'; // import signup path
import 'screens/home.dart'; // import home page after login
import 'package:portfolio/screens/auth/authservices.dart';
Future<void> main() async {                  // main entry point for app 
  WidgetsFlutterBinding.  // when we need to use fire base or other things we need the flutter engine be fully prepared 
     ensureInitialized(); // initializes the framework before Firebase setup and returns the instance , 
  // called to make sure the app is ready for Firebase initialization. 
  //  used in Flutter to initialize the framework before any other Flutter-related operations. 
  // It essentially ensures that the Flutter engine is fully initialized before you perform tasks that rely on it
 
  await Firebase.initializeApp();            // Initialize the firebase with the configuturation of the app , it is a await call so it ensure that firebase is fully initialized before moving to the next step
                                             // await tell that the following statement will return the future (await is keyword)
  runApp(const MyApp());                     // after firebase is initialized runapp is called to start the flutter app and load the main widget 
}

class MyApp extends StatelessWidget {         // create a class named as MyApp 
  const MyApp({super.key});                 

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Hide debug banner 
      title: 'Mutual Funds',
      theme: ThemeData(primarySwatch: Colors.blue
      ),
      home: const AuthWrapper(), // Use AuthWrapper to handle login state / checks whether the user is logged in and redirects accordingly.
    );
  }
}

class AuthWrapper extends StatefulWidget { //  A widget that has mutable state 
  const AuthWrapper({super.key});          // 

  @override
  _AuthWrapperState createState() => _AuthWrapperState(); // Creates the mutable state for this widget at a given location in the tree.
}

class _AuthWrapperState extends State<AuthWrapper> { // authwrapper is stateful widget with boolean _isLoggedIn that indicates login status
  bool _isLoggedIn = false;
  User? _user;

  @override
  void initState() { // Called when the object is inserted into the tree. // The framework will call this method exactly once for each [State] object it creates.
    super.initState();
    _checkLoginStatus(); // Check login status when the app starts
  }

  // Check if the user is logged in
  Future<void> _checkLoginStatus() async {  // sees the shared preference to retrieve the login status from the persistent storage 
    final prefs = await SharedPreferences.getInstance(); // allow access to sharedpreference 
    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false; // retrive the value associated with the key , if the key isn't found the default value is false 

    final currentUser = FirebaseAuth.instance.currentUser;
    setState(() {                                            // setstate ensures that ui refresh if necessary 
      _isLoggedIn = isLoggedIn && currentUser != null; 
      _user = currentUser;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Wait for the login status to be checked before building the UI
    if (!_isLoggedIn) {
      // If not logged in, show the WelcomeScreen
      return const WelcomeScreen();
    } else {
      // If logged in, show the HomePage
      return HomePage(user:_user!);
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
         backgroundColor: Colors.blue[50], // 
             elevation: 0, //          
        ),
      body: Container(
        decoration: const BoxDecoration(
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
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const IdentityPage()),
                  );
                },
                child: const Text('Sign Up', style: TextStyle(color: Colors.black)),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                  );
                },
                
                child: const Text('Login', style: TextStyle(color: Colors.black)),
              ),
              const SizedBox(height: 25),

              const Text(
                'OR',
                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                textAlign: TextAlign.center,
                ),
              const SizedBox(height: 20,),

              ElevatedButton.icon(icon: const Icon(Icons.g_mobiledata),
              onPressed: () async{
                final user = await Authservices().signInWithGoogle();
                if (user != null){
                  Navigator.pushReplacement(
                    context,
                   MaterialPageRoute(builder:(context)=> HomePage(user:user)),
                  );
                }else{
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Google Sign-In failed")),
                  );
                }
               },
               label: const Text('Google'),
              ),
            ], 
          ),
        ),
      ),
    );
  }
}
