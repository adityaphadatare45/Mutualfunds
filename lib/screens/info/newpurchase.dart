import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobileOs/screens/info/personaldetails.dart';

class NewPurchase extends StatefulWidget {
  const NewPurchase({super.key});

  @override
  State<NewPurchase> createState() => _NewPurchaseState();
}

class _NewPurchaseState extends State<NewPurchase> {
  final _formKey = GlobalKey<FormState>();

  String? _residentialCategory;
  String? _relationshipEmail;
  String? _relationshipMobile;
  String? _countryCode;
  DateTime? _dob;
  bool _isOtpSectionVisible = false;

  final _dobController = TextEditingController();
  final _panController = TextEditingController();
  final _emailController = TextEditingController();
  final _mobileController = TextEditingController();
  final _otpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Start Your Investment',
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 48, 128, 194),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildDropdown(
                label: 'Residential Category *',
                value: _residentialCategory,
                items: ['RI- Individual', 'RI- Minor', 'NRI- Individual', 'NRI- Minor'],
                onChanged: (val) => setState(() => _residentialCategory = val),
              ),
              _buildTextField(
                controller: _panController,
                label: 'PAN *',
                validator: (val) =>
                    val == null || val.isEmpty ? 'Enter PAN' : null,
              ),
              _buildTextField(
                controller: _emailController,
                label: 'Email ID *',
                validator: (val) => val != null && val.contains('@')
                    ? null
                    : 'Enter valid email',
              ),
              _buildDropdown(
                label: 'Email belongs to *',
                value: _relationshipEmail,
                items: [
                  'Self',
                  'Spouse',
                  'Dependent Children',
                  'Dependent Sibling',
                  'Dependent Parent',
                  'Guardian'
                ],
                onChanged: (val) => setState(() => _relationshipEmail = val),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: _buildDropdown(
                      label: 'Code *',
                      value: _countryCode,
                      items: ['+91', '+1', '+44'],
                      onChanged: (val) => setState(() => _countryCode = val),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 5,
                    child: _buildTextField(
                      controller: _mobileController,
                      label: 'Mobile Number *',
                      keyboardType: TextInputType.phone,
                      validator: (val) =>
                          val != null && val.length == 10
                              ? null
                              : 'Enter 10-digit number',
                    ),
                  ),
                ],
              ),
              _buildDatePicker(),
              CheckboxListTile(
                title: const Text(
                  "I confirm I am not a U.S. or restricted person",
                  style: TextStyle(fontSize: 14),
                ),
                value: true,
                onChanged: (_) {},
                controlAffinity: ListTileControlAffinity.leading,
              ),
              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    setState(() => _isOtpSectionVisible = true);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Details submitted!')),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  textStyle: const TextStyle(fontSize: 16),
                ),
                child: const Text('Submit'),
              ),

              const SizedBox(height: 20),

              if (_isOtpSectionVisible) ...[
                const Divider(),
                const Text(
                  "Verify OTP",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 10),
                _buildTextField(
                  controller: _otpController,
                  label: 'Enter OTP',
                  keyboardType: TextInputType.number,
                  validator: (val) =>
                      val != null && val.length == 6 ? null : 'Enter 6-digit OTP',
                ),
                const SizedBox(height: 10),
                ElevatedButton.icon(
                  onPressed: () {
                    if (_otpController.text == '123456') {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('OTP Verified')),
                      );
                      Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Personaldetails(), 
                      ),
                    );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Invalid OTP')),
                      );
                    }
                  },
                  icon: const Icon(Icons.verified_user),
                  label: const Text('Verify'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    
                  ),
                  
                ),
              ],
            ],
          ),
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
}
