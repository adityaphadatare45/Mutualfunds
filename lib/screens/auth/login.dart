import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:portfolio/screens/home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:local_auth/local_auth.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  // create a a class named loginpage which extends to stateful widget, which means it have mutable state.[ Mutable state is a state that can be changed during the lifetime of a widget.]
  // Super key is used to pass the key parameter to the parent class, In this case parent class is stateful widget.
  @override
  _LoginPageState createState() => _LoginPageState();// create a state object for the loginpage class.
}

class _LoginPageState extends State<LoginPage> { // 
  final TextEditingController _pinController = TextEditingController();// create a text editing controller for pin.
  final TextEditingController _panController = TextEditingController();//  create a text editing controller for pan.

  @override
  void dispose() { // dispose method is called when the object is removed from the permanetly from the memory.
    _pinController.dispose(); // it will dipose the pin controller.
    _panController.dispose(); // it will dipose the pan controller.
    super.dispose();// super.dispose is used to call the dispose method of the parent class.
  }

  // Check if the user is logging in for the first time
  Future<bool> _checkIfFirstLogin() async {              // Future is used to represent a potential value or the error will exist in the future.
    final prefs = await SharedPreferences.getInstance(); // Shared preferences is used to store the data in the key value pair.
    return prefs.getBool('isFirstLogin') ?? true;        //getbool is used to get the value of the key from the shared preferences.
  }

  // Handle login process with MPIN and PAN
  Future<void> _handleLoginWithPin() async {   // Future is used to represent a potential value or the error will exist in the future.
    String enteredPan = _panController.text.trim(); // it will get the text from the pan controller and remove the white spaces.
    String enteredPin = _pinController.text.trim(); // it will get the text from the pin controller and remove the white spaces.

    try {                                                    // try block is used to enclose the code that might throw an exception and catch block is used to handle the exception.
      final querySnapshot = await FirebaseFirestore.instance // It will get the instance of the firebase firestore.
          .collection('users')                               // it will get the collection of the users.
          .where('pan', isEqualTo: enteredPan)               // it will get the pan from the users collection.
          .where('mpin', isEqualTo: enteredPin)              // it will get the mpin from the users collection.
          .get();

      if (querySnapshot.docs.isNotEmpty) {                  // If the query snapshot is not empty, then it will show the on login success.
        _onLoginSuccess(isFirstLogin: true);                // 
      } else {
        ScaffoldMessenger.of(context).showSnackBar(         // Scaffold messengers are used to show the snackbars.
          const SnackBar(content: Text("Incorrect PAN or MPIN")), // It will the snackbar with error message.
        );
      }
    } catch (e) {                                           // This code is used to handle teh exceptions.
      ScaffoldMessenger.of(context).showSnackBar(           // 
        SnackBar(content: Text("Login error: ${e.toString()}")),// Snackbar shows the error message to the user.
      );
    }
  }

  Future<void> _onLoginSuccess({required bool isFirstLogin}) async { // Future<void>: This indicates that the function is asynchronous and will eventually complete without returning a value.
    final prefs = await SharedPreferences.getInstance();             // Shared preference is used to store the data in the key value pair.
    await prefs.setBool('isLoggedIn', true);                         // It will set the value of the key to the shared preferences for users logging status.
    await prefs.setBool('isExistingUser', true);                     // It will set the value of the key to the shared preferences, if the user is existing user.
                                      
    if (isFirstLogin) {                                              // If the user is the first timer for login, then it will show the biometric authentication with mpin and pan login.
      final LocalAuthentication auth = LocalAuthentication();       // Local authentication is used to authenticate the user with the biometrics.
      bool canCheckBiometrics = await auth.canCheckBiometrics;     //  This object will check the biometrics functionality of the device.

      if (canCheckBiometrics) {                                    // THis if condition checks, if the biometrics is available for authentication.
        bool authenticated = await auth.authenticate(              // It will authenticate the user with the biometrics.
          localizedReason: 'Authenticate with biometrics to login', // This line shows the reason for the use of the biometrics.
          options: const AuthenticationOptions(biometricOnly: true),// 
        );

        if (authenticated) {                                       // If the authentication succeds. then the user is no longer the first user 
          await prefs.setBool('isFirstLogin', false);              // It will set the value of the key to the shared preferences, that the user is no longer the first time user.
          Navigator.pushReplacement(                               // After authentication navigator will push the user to the home page.
            context,
            MaterialPageRoute(builder: (context) => const HomePage()),
          );
          return;                                                  
        } else {                                                   // If the authentication fails, then it will show error message to the user.
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Fingerprint authentication failed")),
          );
          return;
        }
      }
    }
    Navigator.pushReplacement(                                     // If the user is not the first time user, then it will only show the biometric auth option for login and navigate 
      context,                                                     // to homepage.
      MaterialPageRoute(builder: (context) => const HomePage()),
    );
  }

  Future<void> _handleBiometricLogin() async {                    // Future<void>: This indicates that the function is asynchronous and will eventually complete without returning a value.
    final LocalAuthentication auth = LocalAuthentication();       // Local authentication is used to authenticate the user with the biometrics.
    bool canCheckBiometrics = await auth.canCheckBiometrics;      // THis object will check the biometrics functionality is available for the device.

    if (canCheckBiometrics) {                                     // If the biometrics authentication is available.
      bool authenticated = await auth.authenticate(               // Then it will authenticate the user with the biometrics. 
        localizedReason: 'Authenticate with biometrics',          // This line shows the reason for the use of the biometrics.
        options: const AuthenticationOptions(biometricOnly: true),// 
      );

      if (authenticated) {                                        // If the authentication is successful, then it will navigate the user to the home page.
        Navigator.pushReplacement(                                
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      } else {                                                   // If the authentication fails, then it will show the error message to the user.
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Authentication failed")),
        );
      }
    } else {                                                     // If the biometrics authentication is not available, then it will show the error message to the user.
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Biometric authentication not available")),
      );
    }
  }

  Widget _buildLoginContent(bool isFirstLogin) {                // This method is used to build the login content for the user.
    return Column(                                              // Column is used to arrange the children in a vertical sequence. 
      mainAxisAlignment: MainAxisAlignment.center,              // Main axis alignment is used to align the children in the center of the main axis.
      crossAxisAlignment: CrossAxisAlignment.stretch,           // Cross axis alignment is used to align the children in the center of the cross axis. 
      children: [                                       // Children is used to display the widgets in the column.
        if (isFirstLogin) ...[                          // If the user is the first time user, then it will show the verification page.
          _buildTextField(                                      // This method is used to build the text field for the user.
            controller: _panController,                         // It will get the pan controller.
            labelText: 'Enter PAN',                             // It will show the label text to the user.
          ),
          const SizedBox(height: 20),                           // It will show the sized box with height 20.
          _buildTextField(                                      // This method is used to build the text field for the user.
            controller: _pinController,                         // It will get the pin controller.
            labelText: 'Enter MPIN',                            // It will show the label text to the user.
            isPassword: true,                                   // It will show the password in the text field.
          ),
          const SizedBox(height: 20),                           // It will show the sized box with height 20.
          _buildButton(                                         // This method is used to build the button for the user.
            label: 'Login with PAN & MPIN',                     // It will show the label text to the user.
            onPressed: _handleLoginWithPin,                     // It will handle the login with mpin and pan.
          ),
        ],
        const SizedBox(height: 20),
        if (!isFirstLogin) ...[                         // If the user is not the first time user, then it will show the biometric authentication for the user.
                                             
          _buildButton(                                         // This method is used to build the button for the user.
            label: 'Login with Biometrics',                     // It will show the label text to the user.
            onPressed: _handleBiometricLogin,                   // It will handle the biometric login for the user.
            
          ),
        ],
      ],
    );
  }

  Widget _buildTextField({                                     // This method is used to build the text field for the user.
    required TextEditingController controller,                 // It will get the controller for the text field.
    required String labelText,                                 // It will get the label text for the text field.
    bool isPassword = false,                                   // It will show the password in the text field.
  }) {
    return TextField(                                          // TextField is used to get the input from the user.
      controller: controller,                                  // It will get the controller for the text field.
      obscureText: isPassword,                                 // It will show the password in the text field.
      keyboardType:
          isPassword ? TextInputType.number : TextInputType.text, // It will show the keyboard type for the text field.
      decoration: InputDecoration(                                // It will show the decoration for the text field.
        labelText: labelText,                                     // It will show the label text for the text field.
        fillColor: Colors.white70,                              // It will show the color for the text field.
        filled: true,                                            
        border: OutlineInputBorder(                               // It will show the border for the text field.
          borderRadius: BorderRadius.circular(20.0),
        ),
      ),
    );
  }

  Widget _buildButton({                                           // This method is used to build the button for the user.
    required String label,                                        // It will get the label text for the button.
    required VoidCallback onPressed,                              // It will get the on pressed function for the button.
  }) {
    return TextButton(                                            // TextButton is used to create a button with text.
      onPressed: onPressed,                                       // It will get the on pressed function for the button.
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.black,
        backgroundColor: Colors.white70,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
        elevation: 5,
      
      ),
      child: Text(label, style: const TextStyle(color: Colors.black)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _checkIfFirstLogin(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        bool isFirstLogin = snapshot.data ?? true;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Login'),
            backgroundColor: Colors.blue[50],
          ),
          body: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/main-image.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: _buildLoginContent(isFirstLogin),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
