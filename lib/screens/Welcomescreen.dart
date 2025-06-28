import 'package:flutter/material.dart';
import 'package:mobileOs/screens/identity/identity.dart';
import 'package:mobileOs/screens/identity/panverification.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});
 // the welcomescreen is a stateless widget that displays the welcome screen of the app.
 // const welcome screen is a constructor that 
 // super.key pass the key parameter to parent class 
 // super.key is useful for state preservation and restoration.
  @override
  Widget build(BuildContext context) { // build method is called to render the widget on the screen.
    return Scaffold(   // build method returns a scaffold widget which is a material design layout. Scaffolds provide basic structure for ui building
       appBar: AppBar(
       backgroundColor: Colors.blue[50],
       elevation: 0,
       centerTitle: true, // Ensures center alignment on Android too
       title: Image.asset(
          'assets/icon/AS1.png',
          height: 32, // Adjust as neede
        ),
      ),
      body: Container( // container is a widget that allows you to customize its child widget.
        decoration: const BoxDecoration(// decoration is used to add background image to the container.
          image: DecorationImage(
            image: AssetImage('assets/images/main-image.jpg'), // 
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Welcome to MobileOS',
                style: TextStyle(fontSize: 24,
                             fontWeight: FontWeight.bold,
                             color: Colors.white),
                             textAlign: TextAlign.center,
                 ),  
              const SizedBox(height: 40),

              ElevatedButton(                
                     style: ElevatedButton.styleFrom(
                     backgroundColor: Colors.white.withOpacity(0.8),
                     padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 15),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                 ),
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
                 style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white.withOpacity(0.8),
                  padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const PANPage()),
                  );
                },
                child: const Text('Login', style: TextStyle(color: Colors.black)),
              ),
              const SizedBox(height: 25),
              /*const Text(
                'OR',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),*/
             
            ],// children
          ),
        ),
      ),
    );
  }
}
