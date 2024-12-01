// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:portfolio/screens/home.dart';

class PanVerify extends StatefulWidget{
  
  const PanVerify({super.key});
   

  @override
  _PanVerification createState() => _PanVerification();
  
}

class _PanVerification extends State<PanVerify>{
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _panController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  




  void _handleSubmit() {  // hecks if all form fields are valid using _formKey.currentState!.validate().
    if (_formKey.currentState!.validate()) { // if the values are correct then it will navigate to homepage 
      // Process the inputs here
      print("PAN: ${_panController.text}");
      print("OTP:${_otpController.text}");
      

      // Navigate to the HomePage
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    }
  }

   // Future <void>
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MutualFunds'),
      ),
      body: Padding(                           // parameters 
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // PAN Input
              TextFormField(
                controller: _panController,
                decoration: const InputDecoration(labelText: 'PAN Number'),
                validator: (value) {               // The validator checks if the PAN is non-empty and matches a specific pattern
                  if (value == null || value.isEmpty) {
                    return 'Please enter the PAN number';
                  }
                  if (!RegExp(r'^[A-Z]{5}[0-9]{4}[A-Z]{1}$').hasMatch(value)) {
                    return 'Enter a valid PAN number'; 
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20), // adds distance 

              TextFormField(
                controller: _otpController,
                decoration: const InputDecoration(labelText: 'OTP'),
               /* validator: (value){
                  if(value == null ||value.isEmpty){
                     return'Please enter the OTP';
                  }
                  if(){
                    return 'Enter the valid OTP';
                  }
                  return null;
                }*/
                obscureText: true,
                maxLength: 4,
               keyboardType: TextInputType.number,
            
              )
            ]
          ),
        ),
      ),
      
    );
  }
}