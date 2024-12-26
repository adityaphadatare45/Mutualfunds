import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart'; // Used to fire base initialization 
import 'package:flutter/material.dart';
import 'package:portfolio/screens/home.dart';
import 'screens/Welcomescreen.dart';
import 'package:shared_preferences/shared_preferences.dart'; // provides persistent storage for simple data


Future<void> main() async {                       // main entry point for app 
  WidgetsFlutterBinding. ensureInitialized(); 
  // when we need to use fire base or other things we need the flutter engine be fully prepared 
  // initializes the framework before Firebase setup and returns the instance , 
  // called to make sure the app is ready for Firebase initializations. 
  // It essentially ensures that the Flutter engine is fully initialized before you perform tasks that rely on it.

  await Firebase.initializeApp();              // Initialize the firebase with the configuturation of the app , it is a await call so it ensure that firebase is fully initialized before moving to the next step
     runApp(const MyApp());                   // await tell that the following statement will return the future (await is keyword)
  }                                         // after firebase is initialized runapp is called to start the flutter app and load the main widget 

class MyApp extends StatelessWidget {         // create a class named as MyApp 
  const MyApp({super.key});                  

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Hide debug banner 
      title: 'Mutual Funds',
      theme: ThemeData(primarySwatch: Colors.blue
      ),
      home: const AuthWrapper(), // set authwrapper as the home page . 
      // Use AuthWrapper to handle login state / checks whether the user is logged in and redirects accordingly.
    );   
  }
}

class AuthWrapper extends StatefulWidget { //  AuthWrapper is a stateful widget, meaning it has mutable state.
  const AuthWrapper({super.key});          // the constructor initializes the widget. 

  @override
  _AuthWrapperState createState() => _AuthWrapperState(); // Creates the mutable state for this widget at a given location in the tree.
}

class _AuthWrapperState extends State<AuthWrapper> { // The state for the authwrapper widget for managing the login status of the user.
  bool _isLoggedIn = false; // Variable to store the login status of the user .


  @override
  void initState() { // Initstate is called when the state object is created.
    super.initState(); // call the parent class initstate method.
    _checkLoginStatus(); // Check login status when the app starts
  }
  //The primary purpose of using initState() in this 
  //context is to set up any necessary initial state for your widget, 
  //such as checking if a user is logged in before navigating to different screens or displaying specific content.


  // Check if the user is logged in
  Future<void> _checkLoginStatus() async {  // sees the shared preference to retrieve the login status from the persistent storage 
    final prefs = await SharedPreferences.getInstance(); 
   // final keyword is useful for runtime initialization of variable values, which can be done only once. 
   // this async function is used to retrive the shared preference instance in key value pairs to persistent storage.

    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false; // retrive the value associated with the key , if the key isn't found the default value is false 
    // prefs.getBool('isLoggedIn') this line is used to obtain the value of the key which is associated with 'isLoggedIn'.
    // This key is typically set when the user logs in or log out from the app.
    // If the key is not found, the default value is false, which means the user is not logged in.
    // ?? false;  retrive the value associated with the key , if the key isn't found in the sharedpreferences the default value is false.
    final currentUser = FirebaseAuth.instance.currentUser;
    // This retrieves the currently authenticated user from Firebase Authentication. 
    // If there’s a user logged in, this will return a User object; otherwise, it will be null.
    setState(() {                                       
      _isLoggedIn = isLoggedIn && currentUser != null; 
    });
  }
   // setstate notifies the framework that the internal state of the object has changed in a way that might impact the user interface in this build context.
   // currentUser != null; this checks if the user is logged in and the user is not null.
 
  @override
  Widget build(BuildContext context) {
    // Wait for the login status to be checked before building the UI
    if (!_isLoggedIn) {
      // If not logged in, show the WelcomeScreen
      return const WelcomeScreen();
    } else {
      // If logged in , show the home screen 
      return HomePage();
    }
  }
}

