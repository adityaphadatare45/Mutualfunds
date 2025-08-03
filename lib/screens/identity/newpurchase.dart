import 'package:flutter/material.dart';

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
                .map((val) => DropdownMenuItem(value: val, child: Text('Select Relationship')))
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
                      items: [], 
                      onChanged:(val) => setState(() => _countryCode = val ),
                      
                    )
                  ), 

                ],
              )
            ],
          )
        ),
      )
    );
  }
}