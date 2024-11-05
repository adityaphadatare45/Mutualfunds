import 'package:flutter/material.dart';
import 'package:portfolio/screens/home.dart';

class VerificationPage extends StatefulWidget {
  @override
  _VerificationPageState createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  String selectedOption = 'Pan'; // Default selection
  final emailController = TextEditingController();
  final panController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    panController.dispose();
    super.dispose();
  }

  void verify() {
    // Logic to verify email or PAN
    if (selectedOption == 'email') {
      // Verify using the email data
      String email = emailController.text;
      // Implement your email verification logic
      print('Verifying email: $email');
    } else {
      // Verify using the PAN data
      String pan = panController.text;
      // Implement your PAN verification logic
      print('Verifying PAN: $pan');
    }

    // Navigate to Home Page after successful verification
    Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Verification Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Choose verification method:', style: TextStyle(fontSize: 16)),
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
                Text('Email'),
                Radio<String>(
                  value: 'pan',
                  groupValue: selectedOption,
                  onChanged: (value) {
                    setState(() {
                      selectedOption = value!;
                    });
                  },
                ),
                Text('PAN'),
              ],
            ),
            if (selectedOption == 'email')
              TextField(
                controller: emailController,
                decoration: InputDecoration(labelText: 'Enter your email'),
              ),
            if (selectedOption == 'pan')
              TextField(
                controller: panController,
                decoration: InputDecoration(labelText: 'Enter your PAN'),
              ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: verify,
              child: Text('Verify'),
            ),
          ],
        ),
      ),
    );
  }
}
