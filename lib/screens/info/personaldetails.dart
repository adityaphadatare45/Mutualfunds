import 'package:flutter/material.dart';

class Personaldetails extends StatefulWidget{
  const Personaldetails({super.key});

  @override
  State<StatefulWidget> createState()=> _PersonaldetailsPage();
}

class _PersonaldetailsPage extends State<Personaldetails>{
   final _formKey = GlobalKey<FormState>();


   final _nameController = TextEditingController();
   final _annualIncomeController = TextEditingController();
   String? value; // Variable to hold the selected dropdown value
   String? occupation;
   final List<String> holding = ['Single', 'Joint', 'Either or Survivor']; // Dropdown items
   final List<String> occupationOptions = ['Student', 'Public sector service', 'Private sector service', 'Self Employed', 'Business', 'Not categorised', 'Others'];
   final List<String> income = [' Below 100000', '100000 to 500000', '5 lakhs to 10 lakhs', '10 lakhs to 25 lakhs', '25 lakhs to 1 crore', 'Above 1 crore'];
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
            value: value,
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
                value = newValue;
              });
            },
          ),

          const SizedBox(height: 10),

          // Occupation drop dowm.
          DropdownButtonFormField<String>(
               value: occupation,
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
                 occupation = newValue;
                    });
                  },
              ),
          
          const SizedBox(height: 10),
          // Annual Income dropdowm.
          DropdownButtonFormField<String>(
            value: income.isNotEmpty ? income.first : null,
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
                // Update the selected income value
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
        /*  _buildDropdown(
            label: label, 
            value: value, 
            items: items, 
            onChanged: onChanged
          ),
           const SizedBox(height: 10),

          // Country of citizenship/ Nationality
           _buildDropdown(label: label, value: value, items: items, onChanged: onChanged),
            const SizedBox(height: 10),
          // Tax resident other than India 
           */
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