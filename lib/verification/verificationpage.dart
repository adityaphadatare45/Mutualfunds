import 'package:flutter/material.dart';
import 'package:portfolio/screens/home.dart';
// import 'package:portfolio/verification/verifypan.dart'; // imports necessary packages

class VerificationPage extends StatefulWidget {
  const VerificationPage({super.key});

  @override
  _VerificationPageState createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  String selectedOption = 'pan'; // Default selection
  final emailController = TextEditingController();
  final panController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    panController.dispose();
    super.dispose();
  }

  // Verify email or PAN based on the selected option
  void verify() {
    if (selectedOption == 'email') {
      String email = emailController.text.trim();
      if (_isValidEmail(email)) {
        // Email verification logic
        print('Verifying email: $email');
        _navigateToHomePage();
      } else {
        _showSnackBar("Please enter a valid email address");
      }
    } else {
      String pan = panController.text.trim();
      if (_isValidPan(pan)) {
        // PAN verification logic
        print('Verifying PAN: $pan');
        // Uncomment if specific verification for PAN is needed
        // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => PanVerify()));
        _navigateToHomePage();
      } else {
        _showSnackBar("Please enter a valid PAN");
      }
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
      MaterialPageRoute(builder: (context) => const HomePage()),
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
                Radio<String>(
                  value: 'email',
                  groupValue: selectedOption,
                  onChanged: (value) {
                    setState(() {
                      selectedOption = value!;
                    });
                  },
                ),
                const Text('Email'),
                Radio<String>(
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
