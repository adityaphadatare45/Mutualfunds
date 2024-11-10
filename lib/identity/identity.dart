import 'package:cloud_firestore/cloud_firestore.dart'; // packages for handling the auth and database operations 
import 'package:firebase_auth/firebase_auth.dart';   // 
import 'package:flutter/material.dart';
// import 'package:portfolio/screens/auth/signup.dart';
import 'package:portfolio/screens/home.dart';
import 'package:shared_preferences/shared_preferences.dart'; // provides persistent storage for simple data
 

class IdentityPage extends StatefulWidget {  // 
  const IdentityPage({super.key});

  @override
  _IdentityPageState createState() => _IdentityPageState();
}

class _IdentityPageState extends State<IdentityPage> {   // 
  final _formKey = GlobalKey<FormState>();                // used validate the form fields 
  final TextEditingController _panController = TextEditingController();  // text controllers handles the text inputs 
  final TextEditingController _emailController = TextEditingController();  // 
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _pinController = TextEditingController();
  DateTime? _selectedDate;                                               // stores the selected date 
  bool _isPasswordVisible = false;                                       // for visibility of password

  // Function for date picking
  Future<void> _selectDate(BuildContext context) async {  // opens a date picker so user can choose their birth date 
    final DateTime? picked = await showDatePicker(        // 
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != _selectedDate) {   // if the date is picked setstate will notify the framework that the state has been changed 
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  // Function to create a new user in Firebase
  Future<void> _createUser() async {
    try {
      // Create user with email and password
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(                        // tries to create new user with given email and password  
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // Store user details in Firestore
      await FirebaseFirestore.instance.collection('users').doc(userCredential.user?.uid).set({  // stores the additional data to firestore under users with unique id to each user
        'email': _emailController.text.trim(),
        'mobile': _mobileController.text.trim(),
        'pan': _panController.text.trim(),
        'dob': _selectedDate?.toLocal().toString().split(' ')[0],
        'mpin': _pinController.text.trim(),
       
      });

      final prefs = await SharedPreferences.getInstance(); // used to store simple data 
      await prefs.setBool('isLoggedIn', true);             // saves the boolean value 

      // Navigate to HomePage
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    } catch (e) {
      print("Error: $e");
      ScaffoldMessenger.of(context).showSnackBar( // This class provides APIs for showing snack bars and material banners at the bottom and top of the screen, respectively.
        SnackBar(content: Text("Error: ${e.toString()}")),
      );
    }
  }

  // Handle form submission
  void _handleSubmit() {     // validate the form inputs , if it is valid it calls the createuser method 
    if (_formKey.currentState!.validate()) {
      _createUser();
    }
  }

  @override
  void dispose() {             // Dispose method clears the controllers when the widget is removed from the widget tree 
    _panController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _mobileController.dispose();
    _pinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('New User')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // PAN Input
              TextFormField(
                controller: _panController,
                decoration: const InputDecoration(labelText: 'PAN Number'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the PAN number';
                  }
                  if (!RegExp(r'^[A-Z]{5}[0-9]{4}[A-Z]{1}$').hasMatch(value)) {  /// checks the regular expression match the input 
                    return 'Enter a valid PAN number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Email Input
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email ID'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) { /// checks the regular expression match the input 
                    return 'Enter a valid email address';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Password Input with Visibility Toggle
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  ),
                ),
                obscureText: !_isPasswordVisible,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the password';
                  }
                  if (!RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$').hasMatch(value)) { /// checks the regular expression match the input 
                    return 'Enter a valid password';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Mobile Input
              TextFormField(
                controller: _mobileController,
                decoration: const InputDecoration(labelText: 'Mobile Number'),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your mobile number';
                  }
                  if (!RegExp(r'^[6-9]\d{9}$').hasMatch(value)) { /// checks the regular expression match the input 
                    return 'Enter a valid 10-digit mobile number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              TextFormField(
               controller: _pinController,
               obscureText: true,
               maxLength: 4,
               keyboardType: TextInputType.number,
               decoration: const InputDecoration(
                labelText: 'Enter 4-digit MPIN',
               // border: OutlineInputBorder(),
               ),
              ),
              const SizedBox(height:20),

              // Date of Birth Picker
              Text(
                _selectedDate == null
                    ? ' '
                    : 'Date of Birth: ${_selectedDate?.toLocal().toString().split(' ')[0]}',
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () => _selectDate(context),
                child: const Text('Choose Date of Birth'),
              ),
              const SizedBox(height: 40),

              // Submit Button
              Center(
                child: ElevatedButton(
                  onPressed: _handleSubmit,
                  child: const Text('Submit'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
