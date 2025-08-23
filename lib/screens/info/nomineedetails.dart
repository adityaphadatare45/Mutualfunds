import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobileOs/providers/nominee_provider.dart';
import 'package:mobileOs/screens/info/investmentdetails.dart';

class Nomineedetails extends StatefulWidget {
  const Nomineedetails({super.key});

  @override
  State<StatefulWidget> createState() => _NomineePage();
}

class _NomineePage extends State<Nomineedetails> {
  final _formKey = GlobalKey<FormState>();
  List<Nominee> nominees = [Nominee()]; // start with 1 nominee

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
                  );
                }
              },
            ),
            const SizedBox(height: 10),

            if (!_noNominee)
              Expanded(
                child: Form(
                  key: _formKey,
                  child: ListView(
                    children: [
                      for (int i = 0; i < nominees.length; i++)
                        buildNomineeForm(i, nominees[i]),

                      const SizedBox(height: 20),

                      ElevatedButton.icon(
                        onPressed: () {
                          setState(() {
                            nominees.add(Nominee());
                          });
                        },
                        icon: const Icon(Icons.add),
                        label: const Text("Add Nominee"),
                      ),

                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            // Collect nominee data
                            for (var nominee in nominees) {
                              debugPrint("Nominee: ${nominee.nameController.text}, "
                                  "Relation: ${nominee.relation}, "
                                  "DOB: ${nominee.dobController.text}");
                            }

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
   Widget buildNomineeForm(int index, Nominee nominee) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Nominee ${index + 1}",
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                if (nominees.length > 1)
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      setState(() {
                        nominees.removeAt(index);
                      });
                    },
                  ),
              ],
            ),
            const SizedBox(height: 10),

            _buildTextField(controller: nominee.nameController, label: "Nominee Full Name"),
            _buildDatePicker(nominee),
            _buildDropdown(
              label: "Identity Type",
              value: nominee.identityType,
              items: identityTypes,
              onChanged: (val) => setState(() => nominee.identityType = val),
            ),
            _buildDropdown(
              label: "Relation with Primary Holder",
              value: nominee.relation,
              items: relations,
              onChanged: (val) => setState(() => nominee.relation = val),
            ),
            _buildTextField(controller: nominee.allocationController, label: "Allocation (%)", keyboardType: TextInputType.number),
            _buildDropdown(
              label: "Country Code",
              value: nominee.countryCode,
              items: countryCodes,
              onChanged: (val) => setState(() => nominee.countryCode = val),
            ),
            _buildTextField(controller: nominee.mobileController, label: "Mobile Number", keyboardType: TextInputType.phone),
            _buildTextField(controller: nominee.emailController, label: "Email ID", keyboardType: TextInputType.emailAddress),
            _buildDropdown(
              label: "State",
              value: nominee.state,
              items: states,
              onChanged: (val) => setState(() => nominee.state = val),
            ),
            _buildDropdown(
              label: "City",
              value: nominee.city,
              items: cities,
              onChanged: (val) => setState(() => nominee.city = val),
            ),
            _buildTextField(controller: nominee.pincodeController, label: "City Pincode", keyboardType: TextInputType.number),
          ],
        ),
      ),
    );
  }
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    TextInputType? keyboardType,
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
        validator: (value) {
          if (value == null || value.isEmpty) return 'Required';
          return null;
        },
      ),
    );
  }
  Widget _buildDatePicker(Nominee nominee) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextFormField(
        controller: nominee.dobController,
        readOnly: true,
        onTap: () async {
          final picked = await showDatePicker(
            context: context,
            initialDate: DateTime(2000),
            firstDate: DateTime(1950),
            lastDate: DateTime.now(),
          );
          if (picked != null) {
            setState(() {
              nominee.dob = picked;
              nominee.dobController.text = DateFormat('dd/MM/yyyy').format(picked);
            });
          }
        },
        decoration: const InputDecoration(
          labelText: 'Date of Birth *',
          border: OutlineInputBorder(),
          suffixIcon: Icon(Icons.calendar_today),
        ),
        validator: (val) => val == null || val.isEmpty ? 'Select DOB' : null,
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
}