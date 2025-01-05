import 'package:flutter/material.dart';
import 'package:portfolio/identity/identity.dart';
import 'package:portfolio/screens/auth/login.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});
 // the welcomescreen is a stateless widget that displays the welcome screen of the app.
 // const welcome screen is a constructor that 
 // super.key pass the key parameter to parent class 
 // super.key is useful for state preservation and restoration.
  @override
  Widget build(BuildContext context) { // build method is called to render the widget on the screen.
    return Scaffold(   // build method returns a scaffold widget which is a material design layout.
      appBar: AppBar(
        title: const Text('Tri Funds'),// appbar is used to display the title of the app.
        backgroundColor: Colors.blue[50],
        elevation: 0,
      ),
      body: Container( // container is a widget that allows you to customize its child widget.
        decoration: const BoxDecoration(// decoration is used to add background image to the container.
          image: DecorationImage(
            image: AssetImage('assets/images/main-image.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Welcome to Tri Funds',
                style: TextStyle(fontSize: 24,
                             fontWeight: FontWeight.bold,
                             color: Colors.white),
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
