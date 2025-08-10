import 'package:flutter/material.dart';

class Investmentdetails extends StatefulWidget{
  const Investmentdetails({super.key});

   
   @override
  State<StatefulWidget> createState() => _InvestmentPage();
}

 class _InvestmentPage extends State<Investmentdetails>{

  String? _plantype;
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
     appBar: AppBar(
      title: const Text('Investment Details',
      style: TextStyle(
        fontSize: 24,
      ),
      ),
     ),
     body: Padding(
      padding: EdgeInsets.all(20),
      child: Form(
        key: _formKey,
        child: ListView(
           children: [
           /* _buildDropdown(
              label: 'The Plan',
              value: _plantype, 
              items: [], 
              onChanged: onChanged
            )*/
           ],
        )
        ),
      )
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