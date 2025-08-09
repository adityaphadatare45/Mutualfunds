import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobileOs/screens/info/investmentdetails.dart';

class Nomineedetails extends StatefulWidget{
  const Nomineedetails({super.key});

  @override
  State<StatefulWidget> createState()=> _NomineePage();
  
}

class _NomineePage extends State<Nomineedetails>{
  final _formKey = GlobalKey<FormState>();
  DateTime? _dob;
  String? _identityType;
  final _nameController = TextEditingController();
  final _dobController = TextEditingController();
  final _relationController = TextEditingController();
   bool _noNominee = false; // checkbox state
   
  @override
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
                    )
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
                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: 'Nominee Full Name',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter nominee name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 15),
                      TextFormField(
                        controller: _relationController,
                        decoration: const InputDecoration(
                          labelText: 'Relationship',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter relationship';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                             Navigator.push(
                                 context, 
                                 MaterialPageRoute(
                                  builder: (context) => const Investmentdetails(),
                              )
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