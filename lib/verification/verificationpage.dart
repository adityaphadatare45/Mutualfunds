import 'package:cloud_firestore/cloud_firestore.dart'; // fetch the users record to validate 
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:portfolio/screens/home.dart';
// import 'package:portfolio/verification/verifypan.dart'; // imports necessary packages

class VerificationPage extends StatefulWidget {  // 
  const VerificationPage({super.key});

  @override
  _VerificationPageState createState() => _VerificationPageState(); // create the mutable state 
}

class _VerificationPageState extends State<VerificationPage> {
  String selectedOption = 'pan'; // Default selection
  final emailController = TextEditingController(); // used to manage users input 
  final panController = TextEditingController();
 // User?_user;

  @override
  void dispose() {                //  Dispose method clears the controllers when the widget is removed from the widget tree 
    emailController.dispose();
    panController.dispose();
    super.dispose();
  }

  Future<void> verify() async{                      // Based on the selected input it validate the input 
    if (selectedOption == 'email'){
      String email = emailController.text.trim();
      if(_isValidEmail(email)){                      
        bool isValid = await _validateEmailFirestore(email); // It checks if the email is valid and whether it exists in Firestore , if it exits in fire store navigate to homepage
        if(isValid){
              _navigateToHomePage();
        }else{
          _showSnackBar('Email not found in the records'); // if not show then snackbar message 
        }
      }else{
          _showSnackBar("Please enter a valid email address."); // if the user input is not same as email structure show them snackbar
      }
    }else{
       String pan = panController.text.trim();
       if(_isValidPan(pan)){

        bool isValid = await _validatePanFirestore(pan); //  It checks if the PAN is valid and exists in Firestore , if it exits in fire store navigate to homepage
        if(isValid){
           _navigateToHomePage();
        }else{
          _showSnackBar('Pan not found in the records'); // if not show then snackbar message 
        }
       }else{
        _showSnackBar('Enter the valid Pan'); // if the user input is not same as pan structure show them snackbar
       }
    }
  }

  Future<bool>_validateEmailFirestore(String email) async{
    try {
       final querySnapshot = await FirebaseFirestore.instance  // Queries Firestore to see if the given email exists in the 'users' collection.
          .collection('users')
          .where('email', isEqualTo: email)     // returns true if the email exist in the fire store otherwise false and show the message  
          .get();
      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      print('Error verifying the email');
      return false;    
    }
  }

   Future<bool>_validatePanFirestore(String pan) async{
     try {
       final querySnapshot = await FirebaseFirestore.instance // Queries Firestore to see if the given PAN exists in the 'users' collection.
          .collection('users')
          .where('pan', isEqualTo: pan)                    // returns true if pan exist in the firestore otherwise false and show the message 
          .get();
      return querySnapshot.docs.isNotEmpty;
     } catch (e) {
         print("Error verifying PAN: $e");
      return false;
     }
   }

  // Helper function to validate email
  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-]+@[a-zA-Z]+\.[a-zA-Z]+$');
    return emailRegex.hasMatch(email);
  }

  // Helper function to validate PAN
  bool _isValidPan(String pan) {
    final panRegex = RegExp(r'^[A-Z]{5}[0-9]{4}[A-Z]{1}$');
    return panRegex.hasMatch(pan);
  }

  // Show a SnackBar with the provided message
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  // Navigate to the Home Page
  void _navigateToHomePage() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verification Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Choose verification method:', style: TextStyle(fontSize: 16)),
            Row(
              children: [
                Radio<String>(             // radio button is button that holds the string or boolean value that we provided
                  value: 'email',
                  groupValue: selectedOption,
                  onChanged: (value) {
                    setState(() {
                      selectedOption = value!;
                    });
                  },
                ),
                const Text('Email'),
                Radio<String>(         //  when the radio button is selected, the widget calls the [onChanged] callback.
                  value: 'pan',
                  groupValue: selectedOption,
                  onChanged: (value) {
                    setState(() {
                      selectedOption = value!;
                    });
                  },
                ),
                const Text('PAN'),
              ],
            ), 
             /// check which option is selected , if email is selected follow the procedure of email verification or if pan is selected follow the procedure of the pan verification
            if (selectedOption == 'email') 
              TextField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Enter your email'),
              ),
            if (selectedOption == 'pan')
              TextField(
                controller: panController,
                decoration: const InputDecoration(labelText: 'Enter your PAN'),
              ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: verify,
              child: const Text('Verify'),
            ),
          ],
        ),
      ),
    );
  }
}
