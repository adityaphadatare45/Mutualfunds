import 'package:flutter/material.dart';
import 'package:portfolio/screens/home.dart';

class IdentityPage extends StatefulWidget {
  @override
  _IdentityPageState createState() => _IdentityPageState();
}

class _IdentityPageState extends State<IdentityPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _panController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  DateTime? _selectedDate;

  // Function for date picking
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  // Handle form submission
  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      // Process the inputs here
      print("PAN: ${_panController.text}");
      print("Email: ${_emailController.text}");
      print("Mobile: ${_mobileController.text}");
      print("Date of Birth: ${_selectedDate?.toLocal().toString().split(' ')[0]}");

      // Navigate to the HomePage
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('New User')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // PAN Input
              TextFormField(
                controller: _panController,
                decoration: InputDecoration(labelText: 'PAN Number'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the PAN number';
                  }
                  if (!RegExp(r'^[A-Z]{5}[0-9]{4}[A-Z]{1}$').hasMatch(value)) {
                    return 'Enter a valid PAN number';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),

              // Email Input
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email ID'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return 'Enter a valid email address';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),

              // Mobile Input
              TextFormField(
                controller: _mobileController,
                decoration: InputDecoration(labelText: 'Mobile Number'),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your mobile number';
                  }
                  if (!RegExp(r'^[6-9]\d{9}$').hasMatch(value)) {
                    return 'Enter a valid 10-digit mobile number';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),

              // Date of Birth Picker
              Text(
                _selectedDate == null
                    ? 'Select Date of Birth'
                    : 'Date of Birth: ${_selectedDate?.toLocal().toString().split(' ')[0]}',
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: () => _selectDate(context),
                child: Text('Choose Date of Birth'),
              ),
              SizedBox(height: 40),

              // Submit Button
              Center(
                child: ElevatedButton(
                  onPressed: _handleSubmit,
                  child: Text('Submit'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
