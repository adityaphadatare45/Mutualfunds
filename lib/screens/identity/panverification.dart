import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:mobileOs/screens/home.dart';
//import 'package:portfolio/screens/home.dart'; // Update the import if needed
// Included as per original code, though not used for sensitive data
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

enum VerificationStep {
  pan,
  password,
  otp,
}

class PANPage extends StatefulWidget {
  const PANPage({super.key});

  @override
  State<PANPage> createState() => _PANPageState();
}

class _PANPageState extends State<PANPage> {
  final TextEditingController _panController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();

  VerificationStep _currentStep = VerificationStep.pan;
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();
 // SharedPreferences? _prefs; // Included as per original code, but not used for sensitive data

  List<String> folios = [];
  String? selectedFolio;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _checkStoredCredentials();
  }

 Future<void> _checkStoredCredentials() async {
  setState(() {
    _isLoading = true;
  });

  String? storedJwtToken = await _secureStorage.read(key: 'jwttoken');
  String? expiryStr = await _secureStorage.read(key: 'jwt_expiry');

  if (storedJwtToken != null && expiryStr != null) {
    DateTime? expiry = DateTime.tryParse(expiryStr);
    if (expiry != null && DateTime.now().isBefore(expiry)) {
      print('JWT token is still valid locally. Skipping login APIs.');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage(token: '',)),
      );
      return;
    } else {
      print('JWT token expired locally. Validating with server...');
      await _jwtapi(); // Fallback to server-side validation
    }
  } else {
    print('No stored JWT token or expiry found.');
  }

  setState(() {
    _isLoading = false;
  });
}


  @override
  void dispose() {
    _panController.dispose();
    _passwordController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  Future<void> _fetchFolios(String pan) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.get(
        Uri.parse(''),
        headers: {
          "username": "EGh6Zsg4nj+SO81BWBL8XemX1+F5GJW9+OwW3ZlsqdPiLYJc70vN/1e7nMAATjq0",
          "password": "3Def411k6P4g0+zMNuV89R45uDduU2RAx7r5k7wBHHs6O52NH40N0l6OG7cIL3Kjiilcd4cVPfvWzJdJ9wWkPqoME7qPVDv+I9Y6Z7tuup4="
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('API Response: $data');

        if (data != null && data['data'] != null && data['data']['FolioList'] != null) {
          List<dynamic> folioList = data['data']['FolioList'];

          setState(() {
            folios = folioList.map<String>((item) {
              return item['FolioNum'] != null ? item['FolioNum'].toString() : 'Unknown Folio';
            }).toList();

            selectedFolio = folios.isNotEmpty ? folios.first : null;
            _currentStep = VerificationStep.password;
          });

          if (folios.isNotEmpty) {
            ScaffoldMessenger.of(context).showSnackBar( 
             SnackBar(
              content: Row(
              children: [
              Icon(Icons.folder_copy_rounded, color: Colors.white),
              SizedBox(width: 10),
             Text('${folios.length} folio(s) found.'),
             ],
           ),
             backgroundColor: const Color.fromARGB(255, 67, 79, 146),
             behavior: SnackBarBehavior.floating,
             shape: RoundedRectangleBorder(
             borderRadius: BorderRadius.circular(12),
            ),
             margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
             duration: Duration(seconds: 3),
             elevation: 6,
             ),
           );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('No folios found for this PAN.'),
                 backgroundColor: Colors.blueAccent,
                 behavior: SnackBarBehavior.floating,
                 duration: Duration(seconds: 3),
               ),
            );
          }

          // Extract and store contactDetail from each folio securely
          for (var folio in folioList) {
            final contactDetail = folio['ContactDetail'];
            final folioNum = folio['FolioNum'];

            if (contactDetail != null && folioNum != null) {
              await _secureStorage.write(key: 'contact_detail_$folioNum', value: contactDetail.toString());
            }
          }

        } else {
          setState(() {
            folios = [];
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Unexpected data format from API.')),
          );
        }
      } else if (response.statusCode == 400) {
        setState(() {
          folios = [];
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Bad request. Please check your PAN number.')),
        );
      } else if (response.statusCode == 429) {
        setState(() {
          folios = [];
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Rate limit exceeded. Please try again later.')),
        );
      } else {
        setState(() {
          folios = [];
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to fetch folios. Status code: ${response.statusCode}.')),
        );
      }
    } catch (e) {
      setState(() {
        folios = [];
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching folios: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _validatePassword(String pan, String folio, String password) async {
    print("Password is:$password");
    setState(() {
      _isLoading = true;
    }); 

    // Retrieve contactDetail before making the API call
    String? contactDetail = await _secureStorage.read(key: 'contact_detail_$folio');
    if (contactDetail == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Contact detail not found for this folio.')),
      );
      setState(() {
        _isLoading = false;
      });
      return; // Stop if contact detail is missing
    }


    try {
      final response = await http.post(
        Uri.parse(''),
        headers: {
          'Content-Type': 'application/json',
          "username": "EGh6Zsg4nj+SO81BWBL8XemX1+F5GJW9+OwW3ZlsqdPiLYJc70vN/1e7nMAATjq0",
          "password": "3Def411k6P4g0+zMNuV89R45uDduU2RAx7r5k7wBHHs6O52NH40N0l6OG7cIL3Kjiilcd4cVPfvWzJdJ9wWkPqoME7qPVDv+I9Y6Z7tuup4="
        },
        body: jsonEncode({
          "ContactDetail": contactDetail, // Use the retrieved contact detail
          "DualAuthentication": "0",
          "FolioNumber": folio,
          "IsFolioMapped": "0",
          "loginoption": "loginusingpassword",
          "LoginType": "PAN",
          "password": password,
          "PanNo": pan,
          "USConsent": 1,
          "WrongPwdCount": 0
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('API Response: $data');
        if (data['data'] == 'redirect') {
          setState(() {
            _currentStep = VerificationStep.otp;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Password validated successfully. OTP sent.')),
          );

          //  Store PAN, Selected Folio, and Password securely 
          await _secureStorage.write(key: 'stored_pan', value: pan);
          await _secureStorage.write(key: 'stored_folio', value: folio);
          await _secureStorage.write(key: 'stored_password', value: password); // Store password securely

        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(data['msg'] ?? data['data'] ?? 'Password validation failed')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed with status code: ${response.statusCode}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error validating password: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _validateOtp(String pan, String password, String folio, String otp) async {
    print('OTP is: $otp');

    setState(() {
      _isLoading = true;
    });

    // Retrieve contactDetail before making the API call
    String? contactDetail = await _secureStorage.read(key: 'contact_detail_$folio');
    if (contactDetail == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Contact detail not found for this folio.')),
      );
      setState(() {
        _isLoading = false;
      });
      return; // Stop if contact detail is missing
    }

    try {
      final response = await http.post(
        Uri.parse(''),
        headers: {
          "Content-Type": "application/json",
          "username": "EGh6Zsg4nj+SO81BWBL8XemX1+F5GJW9+OwW3ZlsqdPiLYJc70vN/1e7nMAATjq0",
          "password": "3Def411k6P4g0+zMNuV89R45uDduU2RAx7r5k7wBHHs6O52NH40N0l6OG7cIL3Kjiilcd4cVPfvWzJdJ9wWkPqoME7qPVDv+I9Y6Z7tuup4="
        },
        body: json.encode({
          "contactDetail": contactDetail, // Use the retrieved contact detail
          "folioNumber": folio,
          "otpno": otp,
          "IsFolioMapped": "0",
          "loginoption": "loginusingotp",
          "LoginType": "PAN",
          "password": password, // Use the password (ideally already stored)
          "PanNo": pan, // Use the PAN (ideally already stored)
          "USConsent": 1,
          "WrongPwdCount": 0,
          "Browser": "Chrome"
        }),
      );

      final data = json.decode(response.body);
      print("OTP verification response: $data");

      if (response.statusCode == 200 && data['msg'] == 'OK') {
       
        final jwtToken = data['JWTToken'];
         print("JWT Token: $jwtToken");

        await _secureStorage.write(key: 'jwttoken', value: jwtToken);
        await _secureStorage.write(
          key: 'jwt_expiry', 
          value:DateTime
          .now()
          .add(Duration(days: 1))
          .toString()
          );

         // Ensure PAN and Selected Folio are stored if not already
        await _secureStorage.write(key: 'stored_pan', value: pan);
        await _secureStorage.write(key: 'stored_folio', value: folio);
        await _jwtapi();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('OTP verified successfully. Logging in...')),
        );
       /* Navigator.pushReplacement(
         context,
         MaterialPageRoute(
          builder: (context) => HomePage(token:jwtToken),
         ),
        );*/
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['msg'] ?? 'OTP verification failed')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error validating OTP: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

   Future<void> _jwtapi() async { 
  setState(() {
    _isLoading = true;
  });

  String? storedJwtToken = await _secureStorage.read(key: 'jwttoken');

  if (storedJwtToken == null) {
    print("No JWT token found in secure storage for validation.");
    setState(() {
      _isLoading = false;
    });
    return;
  }

  try {
    final response = await http.post(
      Uri.parse(""),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $storedJwtToken",
        "username": "EGh6Zsg4nj+SO81BWBL8XemX1+F5GJW9+OwW3ZlsqdPiLYJc70vN/1e7nMAATjq0",
        "password": "3Def411k6P4g0+zMNuV89R45uDduU2RAx7r5k7wBHHs6O52NH40N0l6OG7cIL3Kjiilcd4cVPfvWzJdJ9wWkPqoME7qPVDv+I9Y6Z7tuup4="
      },
      body: json.encode({
        "jwt": storedJwtToken,
      }),
    );

    final data = json.decode(response.body);
    print("JWT token validation response: $data");

    if (response.statusCode == 200 && data['IsValid'] == true) {
    

      // Optionally update the token if a new one is returned
      if (data['data'] != null) {
        await _secureStorage.write(key: 'newtoken', value: data['data']);
        //await _secureStorage.read(key: 'newtoken');
      }
        Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) =>  HomePage(token:storedJwtToken)),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Session validated successfully."),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 3),
        ),
      );
    } else {
      await _secureStorage.deleteAll();
      _resetUI();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(data['msg'] ?? 'Session expired. Please log in again.'),
          backgroundColor: Colors.orange,
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 4),
        ),
      );
    }
  } catch (e) {
    print("Error validating JWT token: $e");
    await _secureStorage.deleteAll();
    _resetUI();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Error validating session. Please log in again.'),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 4),
      ),
    );
  } finally {
    setState(() {
      _isLoading = false;
    });
  }
}
void _resetUI() {
  setState(() {
    _currentStep = VerificationStep.pan;
    _panController.clear();
    _passwordController.clear();
    _otpController.clear();
    folios = [];
    selectedFolio = null;
  });
}

  void _handleSubmit() {
    final pan = _panController.text.trim().toUpperCase();
    final password = _passwordController.text.trim();
    final otp = _otpController.text.trim();
  //  
    switch (_currentStep) {
      case VerificationStep.pan:
        if (pan.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Enter PAN")));
        } else if (!RegExp(r'^[A-Z]{5}[0-9]{4}[A-Z]{1}$').hasMatch(pan)) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Invalid PAN format")));
        } else {
          _fetchFolios(pan);
        }
        break;

      case VerificationStep.password:
        if (password.isEmpty || selectedFolio == null) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Enter password and select a folio")));
        } else {
          
          _validatePassword(pan, selectedFolio!, password);
        }
        break;

      case VerificationStep.otp:
        if (otp.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Enter OTP")));
        } else {
         
          _validateOtp(pan, password, selectedFolio!, otp);
        }
        break;
    }
  }

  @override
  Widget build(BuildContext context) { 
    return Scaffold(
     appBar: AppBar(
       backgroundColor: Colors.blue[40],
       elevation: 0,
       centerTitle: true, // Ensures center alignment on Android too
       title: Image.asset(
          'assets/icon/AS1.png',
          height: 32, // Adjust as needed
        ),
      ),
      body: Stack(
        children: [
          // 1. Background Image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/main-image.jpg'), // <-- Image path
                fit: BoxFit.cover,
              ),
            ),
          ),
          // 2. Foreground UI
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          // PAN Input Field (First Step)
                          if (_currentStep == VerificationStep.pan || _currentStep == VerificationStep.password || _currentStep == VerificationStep.otp)
                            TextField(
                              controller: _panController,
                              decoration: InputDecoration(
                                labelText: 'Enter PAN',
                                labelStyle: const TextStyle(color: Colors.white70),
                                prefixIcon: const Icon(Icons.credit_card, color: Colors.white70),
                                border: OutlineInputBorder(
                                  borderSide: const BorderSide(color: Colors.white70),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(color: Colors.white54),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(color: Colors.white),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              textCapitalization: TextCapitalization.characters,
                            ),
                          const SizedBox(height: 16),

                          // Folio List (Visible after PAN)
                          if (_currentStep == VerificationStep.password || _currentStep == VerificationStep.otp)
                            DropdownButtonFormField<String>(
                              value: selectedFolio,
                              decoration: const InputDecoration(
                                labelText: 'Select Folio',
                                border: OutlineInputBorder(),
                                filled: true,
                                fillColor: Colors.white70,
                              ),
                              items: folios.map((folio) {
                                return DropdownMenuItem(
                                  value: folio,
                                  child: Text(folio),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  selectedFolio = value;
                                });
                              },
                            ),
                          const SizedBox(height: 16),

                          // Password Input Field (Visible after PAN and Folio selection)
                          if (_currentStep == VerificationStep.password || _currentStep == VerificationStep.otp)
                            TextField(
                              controller: _passwordController,
                              decoration: InputDecoration(
                                labelText: 'Enter Password',
                                labelStyle: const TextStyle(color: Colors.white70),
                                prefixIcon: const Icon(Icons.lock, color: Colors.white70),
                                border: OutlineInputBorder(
                                  borderSide: const BorderSide(color: Colors.white70),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(color: Colors.white54),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(color: Colors.white),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              obscureText: true, // Set to true for password fields
                            ),
                          const SizedBox(height: 20),

                          // OTP Input Field (Visible after Password)
                          if (_currentStep == VerificationStep.otp)
                            TextField(
                              controller: _otpController,
                              decoration: InputDecoration(
                                labelText: 'Enter OTP',
                                labelStyle: const TextStyle(color: Colors.black),
                                prefixIcon: const Icon(Icons.lock, color: Colors.black12),
                                border: OutlineInputBorder(
                                  borderSide: const BorderSide(color: Colors.white24),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(color: Colors.white54),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(color: Colors.white),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          if (_currentStep == VerificationStep.otp)
                            const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),

                  // Submit Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _handleSubmit, // Disable button while loading
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.black,
                        minimumSize: const Size(double.infinity, 50),
                        backgroundColor: Colors.blue[100],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 5,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                      ),
                      child: _isLoading
                          ? const CircularProgressIndicator() // Show loading indicator
                          : Text(
                              'Submit',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.2,
                              ),
                            ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}