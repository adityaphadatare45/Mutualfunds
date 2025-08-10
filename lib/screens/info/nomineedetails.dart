import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobileOs/screens/info/investmentdetails.dart';

class Nomineedetails extends StatefulWidget {
  const Nomineedetails({super.key});

  @override
  State<StatefulWidget> createState() => _NomineePage();
}

class _NomineePage extends State<Nomineedetails> {
  final _formKey = GlobalKey<FormState>();
  DateTime? _dob;
  String? _identityType;
  String? _relation;
  String? _countryCode;
  String? _state;
  String? _city;

  final _nameController = TextEditingController();
  final _dobController = TextEditingController();
  final _relationController = TextEditingController();
  final _allocationController = TextEditingController();
  final _mobileController = TextEditingController();
  final _emailController = TextEditingController();
  final _pincodeController = TextEditingController();

  bool _noNominee = false; // checkbox state

  // Dropdown options
  final List<String> identityTypes = ['PAN', 'Aadhaar', 'Driving License', 'Passport'];
  final List<String> relations = ['Wife', 'Son', 'Husband', 'Father', 'Mother', 'Brother', 'Sister'];
  final List<String> countryCodes = ['+91', '+1', '+44', '+61', '+81'];
  final List<String> states = ['State 1', 'State 2', 'State 3'];
  final List<String> cities = ['City 1', 'City 2', 'City 3'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Nominee Details',
          style: TextStyle(color: Colors.black, fontSize: 22),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            CheckboxListTile(
              title: const Text(
                'I do not wish to nominate anyone as my nominee.',
                style: TextStyle(fontSize: 14),
              ),
              value: _noNominee,
              onChanged: (bool? value) {
                setState(() {
                  _noNominee = value ?? false;
                });

                if (value == true) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Investmentdetails(),
                    ),
                  ); // go immediately if checked
                }
              },
            ),
            const SizedBox(height: 10),

            // Show form only if _noNominee is false
            if (!_noNominee)
              Expanded(
                child: Form(
                  key: _formKey,
                  child: ListView(
                    children: [
                      // Nominee name
                      _buildTextField(
                        controller: _nameController,
                        label: 'Nominee Full Name',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter nominee name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),

                      // Date of birth of nominee
                      _buildDatePicker(),
                      const SizedBox(height: 10),

                      // Identity type
                      _buildDropdown(
                        label: 'Identity Type',
                        value: _identityType,
                        items: identityTypes,
                        onChanged: (val) => setState(() => _identityType = val),
                      ),
                      const SizedBox(height: 10),

                      // Relation with primary holder
                      _buildDropdown(
                        label: 'Relation with Primary Holder',
                        value: _relation,
                        items: relations,
                        onChanged: (val) => setState(() => _relation = val),
                      ),
                      const SizedBox(height: 10),

                      // Allocation to nominee in percentage
                      _buildTextField(
                        controller: _allocationController,
                        label: 'Allocation (%)',
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter allocation percentage';
                          }
                          final percentage = double.tryParse(value);
                          if (percentage == null || percentage < 0 || percentage > 100) {
                            return 'Enter a valid percentage (0-100)';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),

                      // Country code dropdown
                      _buildDropdown(
                        label: 'Country Code',
                        value: _countryCode,
                        items: countryCodes,
                        onChanged: (val) => setState(() => _countryCode = val),
                      ),
                      const SizedBox(height: 10),

                      // Mobile number
                      _buildTextField(
                        controller: _mobileController,
                        label: 'Mobile Number',
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter mobile number';
                          }
                          if (value.length < 10) {
                            return 'Enter a valid mobile number';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),

                      // Email ID
                      _buildTextField(
                        controller: _emailController,
                        label: 'Email ID',
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter email ID';
                          }
                          if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                            return 'Enter a valid email ID';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),

                      // State
                      _buildDropdown(
                        label: 'State',
                        value: _state,
                        items: states,
                        onChanged: (val) => setState(() => _state = val),
                      ),
                      const SizedBox(height: 10),

                      // City
                      _buildDropdown(
                        label: 'City',
                        value: _city,
                        items: cities,
                        onChanged: (val) => setState(() => _city = val),
                      ),
                      const SizedBox(height: 10),

                      // City Pincode
                      _buildTextField(
                        controller: _pincodeController,
                        label: 'City Pincode',
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter pincode';
                          }
                          if (value.length != 6) {
                            return 'Enter a valid 6-digit pincode';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),

                      // Next button
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const Investmentdetails(),
                              ),
                            );
                          }
                        },
                        child: const Text('Next'),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        keyboardType: keyboardType,
        validator: validator,
      ),
    );
  }

  Widget _buildDatePicker() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextFormField(
        controller: _dobController,
        readOnly: true,
        onTap: _selectDOB,
        decoration: const InputDecoration(
          labelText: 'Date of Birth *',
          border: OutlineInputBorder(),
          suffixIcon: Icon(Icons.calendar_today),
        ),
        validator: (val) => val == null || val.isEmpty ? 'Select DOB' : null,
      ),
    );
  }

  Future<void> _selectDOB() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _dob = picked;
        _dobController.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }

  Widget _buildDropdown({
    required String label,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: DropdownButtonFormField<String>(
        value: value,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        items: items
            .map((val) => DropdownMenuItem(value: val, child: Text(val)))
            .toList(),
        onChanged: onChanged,
        validator: (val) => val == null ? 'Required' : null,
      ),
    );
  }
}