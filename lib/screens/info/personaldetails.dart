import 'package:flutter/material.dart';
import 'package:mobileOs/screens/info/nomineedetails.dart';

class Personaldetails extends StatefulWidget{
  const Personaldetails({super.key});

  @override
  State<StatefulWidget> createState()=> _PersonaldetailsPage();
}

class _PersonaldetailsPage extends State<Personaldetails>{
   final _formKey = GlobalKey<FormState>();


   final _nameController = TextEditingController();
   final _annualIncomeController = TextEditingController();
   
   // Variable to hold the selected dropdown value
   String? _value; 
   String? _occupation;
   String? _citizenship;
   String? _birthCountry;
   String? _annualIncome;

   // Check box state.
  // bool? _yesCheck = false;
//   bool? _noCheck = false;

   // List for selection
   final List<String> holding = ['Single', 'Joint', 'Either or Survivor']; // Dropdown items
   final List<String> occupationOptions = ['Student', 'Public sector service', 'Private sector service', 'Self Employed', 'Business', 'Not categorised', 'Others'];
   final List<String> income = [' Below 100000', '1 lakh to 5 lakh', '5 lakhs to 10 lakhs', '10 lakhs to 25 lakhs', '25 lakhs to 1 crore', 'Above 1 crore'];
   final List<String> countries = ['India', 'US', 'Other'];
   final List<String> citizenship = ['India', 'US', 'Other'];

 

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
          _buildTextField(
            controller: _nameController, 
            label: 'Full name as per Pan'
            ),

          const SizedBox(height: 10),
          
          // Mode of holding drop down
          DropdownButtonFormField(
            value: _value,
            decoration: InputDecoration(
              labelText: 'Mode of Holding',
              border: OutlineInputBorder(),
            ),
            items: holding.map((item) => DropdownMenuItem(
              value: item,
              child: Text(item),
            )).toList(),
            onChanged: (newValue) {
              setState(() {
                _value = newValue;
              });
            },
          ),

          const SizedBox(height: 10),

          // Occupation drop dowm.
          DropdownButtonFormField<String>(
               value: _occupation,
               decoration: const InputDecoration(
               labelText: 'Occupation',
               border: OutlineInputBorder(),
              ),
              items: occupationOptions.map((item) => DropdownMenuItem(
              value: item,
              child: Text(item),
               )).toList(),
                onChanged: (newValue) {
                  setState(() {
                 _occupation = newValue;
                    });
                  },
              ),
          
          const SizedBox(height: 10),
          // Annual Income dropdowm.
          DropdownButtonFormField<String>(
            value: _annualIncome,
            decoration: const InputDecoration(
              labelText: 'Annual Income',
              border: OutlineInputBorder(),
            ),
            items: income.map((item) => DropdownMenuItem(
              value: item,
              child: Text(item),
            )).toList(),
            onChanged: (newValue) {
              setState(() {
                _annualIncome = newValue;
              });
            },
          ),
          const SizedBox(height: 10,),

          // Income text input field.
          _buildTextField(
            controller: _annualIncomeController, 
            label: 'Annual Income'
          ),
          
         const SizedBox(height: 10,),
          /// Regulatory details.
            Text('Regulatory Details',
            style: TextStyle(
              fontSize: 18,
              color: Colors.black,
            ),
            ),
            const SizedBox(height: 10),
          // Country of birth.
          _buildDropdown(
            label: 'Country Of Birth', 
            value: _birthCountry, 
            items: countries, 
            onChanged: (newValue) {
              setState(() {
                _birthCountry= newValue;
              });
            }
          ),
           const SizedBox(height: 10),

          // Country of citizenship/ Nationality
           _buildDropdown(
            label: 'Country of citizenship', 
            value: _citizenship, 
            items: citizenship, 
            onChanged: (citizenshipValue){
              setState(() {
                _citizenship = citizenshipValue;
              });
            }
            ),
            const SizedBox(height: 10),

          // Tax resident other than India 
           /*Row(
            children: [
              Checkbox(
                value: _yesCheck, 
                onChanged: (bool? value) {
                  setState(() {
                    _yesCheck = value;
                  });
                }
              ),
              const SizedBox(width: 10),
              Checkbox(
                value: _noCheck, 
                onChanged: (bool? value) {
                  setState(() {
                    _noCheck = value;
                  });
                }
              ),

            ],
           ),*/
           const SizedBox(height: 30),
           ElevatedButton(
            onPressed: (){
              Navigator.push(
                context, 
                MaterialPageRoute(
                  builder: (context) => const Nomineedetails(),
                )
              );
            }, 
            style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  textStyle: const TextStyle(fontSize: 16),
             ),
            child: const Text('Next'),
           )
         ], 
        )
      ), 
     )
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
}