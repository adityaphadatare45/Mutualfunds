import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Newpurchase extends StatefulWidget{
  const Newpurchase({super.key});

  @override
  State<StatefulWidget> createState() => _NewpurchaseState();
  
}

class _NewpurchaseState extends State<Newpurchase>{
  final _formKey = GlobalKey<FormState>();
  String? _residentialCategory;
  String? _relationshipEmail;
  String? _relationshipMobile;
  String? _countryCode;
  DateTime? _dob;
  final TextEditingController _dobController = TextEditingController();

  

  @override
 Widget build(BuildContext context){
    return Scaffold(
     appBar: AppBar(
       backgroundColor: const Color.fromARGB(255, 48, 128, 194),
       title: const Text('Start Your Investment as a Thought Investor', 
       style: TextStyle(
       fontSize: 18,
       color: Colors.white,
       
       ),
       ),
       // backgroundColor: Colors.blue[10],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          child: ListView(
            children: [
              // Residential Category
              DropdownButtonFormField<String> (
                decoration: InputDecoration(labelText: 'Residential Category *'),
                items: ['RI- Individual','RI- Minor', 'NRI- Individual', 'NRI- Minor']
                .map((val) => DropdownMenuItem(value: val, child: Text(val)))
                .toList(),               
                onChanged: (val) => setState(() => _residentialCategory = val),
                validator: (value) => value == null? 'Required': null,
              ),
              const SizedBox(height: 10),
              // Pan Field
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'PAN *'
                ),
                validator: (val) => val == null || val.isEmpty ? 'Enter Pan' : null,
              ),
              const SizedBox(height: 10),
              // Email Field
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Email-Id *'
                ),
                validator: (val) =>
                    val != null && val.contains('@') ? null : 'Enter valid email',
              ),
               const SizedBox(height: 10),
              // Email relation
              DropdownButtonFormField(
                decoration: InputDecoration(
                  labelText: 'Email belongs to *'
                ),
                items: ['Self', 'Spouse', 'Dependent Children', 'Dependent Sibling', 'Dependent Parent', 'Gaurdian']
                .map((val) => DropdownMenuItem(value: val, child: Text(val)))
                .toList(),
                onChanged:(val) => setState(() => _relationshipEmail = val),
                validator: (value) => value == null ? 'Required' : null,
              ),
              const SizedBox(height: 10),

            // Mobile and country code
             Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: DropdownButtonFormField<String>(
                      decoration: InputDecoration(labelText: 'Country Code *'),
                      items: ['+91', '+1', '+44']
                          .map((val) => DropdownMenuItem(value: val, child: Text(val)))
                          .toList(),
                      onChanged: (val) => setState(() => _countryCode = val),
                      validator: (value) => value == null ? 'Required' : null,
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    flex: 5,
                    child: TextFormField(
                      decoration: InputDecoration(labelText: 'Mobile Number *'),
                      keyboardType: TextInputType.phone,
                      validator: (val) =>
                          val != null && val.length == 10 ? null : 'Enter valid number',
                    ),
                  ),
                ],
              ),
              const SizedBox(height:10),

              // Mobile Relationship
              TextFormField(
                controller: _dobController,
                decoration: InputDecoration(
                    labelText: 'Date of Birth *',
                    suffixIcon: Icon(Icons.calendar_today)),
                readOnly: true,
                onTap: _selectdob,
                validator: (val) => val == null || val.isEmpty ? 'Select DOB' : null,
              ),
              const SizedBox(height: 10),
              
              // Checkbox
              CheckboxListTile(
                title: Text("I hereby confirm I am not a U.S. or restricted person"),
                value: false,
                onChanged: (val) {}, // Add logic here
                controlAffinity: ListTileControlAffinity.leading,
              ),

              SizedBox(height: 20),

              // Submit Button
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Form Submitted Successfully')));
                  }
                },
                child: Text('Submit'),
              )
            ],
          )
        ),
      )
    );
  }
  Future<void> _selectdob() async {
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
