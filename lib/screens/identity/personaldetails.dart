import 'package:flutter/material.dart';

class Personaldetails extends StatefulWidget{
  const Personaldetails({super.key});

  @override
  State<StatefulWidget> createState()=> _PersonaldetailsPage();
}

class _PersonaldetailsPage extends State<Personaldetails>{
   final _formKey = GlobalKey<FormState>();


   final _nameController = TextEditingController();
   String? value; // Variable to hold the selected dropdown value
   final List<String> items = ['Single', 'Joint', 'Either or Survivor']; // Dropdown items

  @override
  Widget build(BuildContext context){
    return Scaffold(
     appBar: AppBar(
       backgroundColor: const Color.fromARGB(255, 48, 128, 194),
       title: const Text(
        'Personal Details', 
        style: TextStyle(
          fontSize: 24,
          //fontStyle: 
        ),
       ),
     ),
     body:Padding(
      padding: EdgeInsets.all(20),
      child: Form(
        key:_formKey,
        child: ListView(
         children: [

          // Name field of user
          TextFormField(
           controller: _nameController,
           decoration: InputDecoration(
            label: Text('Full Name of Invester as per PAN *',
            style: TextStyle(
               fontSize: 24,
               color: Colors.white,
            ),
            ),
           ),
          ),

          const SizedBox(height: 10),
          
          // Mode of holding drop down
          DropdownButtonFormField(
            value: value,
            decoration: InputDecoration(
              labelText: 'Mode of Holding',
              border: OutlineInputBorder(),
            ),
            items: items.map((item) => DropdownMenuItem(
              value: item,
              child: Text(item),
            )).toList(),
            onChanged: (newValue) {
              setState(() {
                value = newValue;
              });
            },
          ),

          const SizedBox(height: 10),

          // Occupation drop dowm.
         ], 
        )
      ), 
     )
    );
  }
}