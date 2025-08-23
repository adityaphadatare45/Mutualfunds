import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobileOs/providers/counter_provider.dart';
import 'package:mobileOs/screens/home.dart';

class NewSip extends StatefulWidget{
  const NewSip({super.key});
  @override
  State<StatefulWidget> createState() => _SipPage();
}

class _SipPage extends State<NewSip>{
  final _formKey = GlobalKey<FormState>();
  final Counter counter = Counter(); // shared object
  late final Map<String, List<String>> categories;
  late int _value;

  final _ammountController = TextEditingController();
  final _enrollmetController = TextEditingController();
  final _totalInstallmentController = TextEditingController();
  
  String? selectedScheme;
  String? selectedOption;
  String? _Sip;
  String? _Plantype;
  String? _frequency;
  DateTime? _dateTime;


 // Sip list 
 final List<String> sipList = ['SIP Through eNACH'];

 // plan type
final List<String> planType = ['Direct', 'Regular'];

// Scheme category
List<String> categoryList = [
    'Equity Fund',
    'Multi Assets',
    'Gold Funds',
    'Debt',
    'Q Nifty',
    'Hybrid Funds'
  ];

// scheme name 
final List<String> equityScheme =[
 'Quantum Value Fund - Regular Plan IDCW Payout Option',
   'Quantum Value Fund - Regular Plan IDCW Re-Investment Option',
   'Quantum Value Fund - Regular Plan Growth Option',
   'Quantum ELSS Tax Saver Fund - Regulat Plan IDCW ',
   'Quantum ELSS Tax Saver Fund - Regulat Plan Growth',
   'Quantum Equity Funds of Funds - Regular Plan IDCW Payout',
   'Quantum Equity Funds of Funds - Regular Plan IDCW Re-Investment',
   'Quantum Equity Funds of Funds - Regular Plan Growth',
   'Quantum ESG Best In Class Strategy Fund - Regular Plan Growth',
   'Quantum Small Cap Fund - Regular Plan Growth',
   'Quantum Ethical Fund - Regular Growth',
];

/// Debt fund schemes : 
  final List<String> debtScheme =[
    'Qunatum Liquid Fund - Regular Plan Daily IDCW Re-Investment',
    'Qunatum Liquid Fund - Regular Plan Growth',
    'Quantum Liquid Fund - Regular Plan Monthly IDCW Payout',
    'Quantum Liquid Fund - Regular Plan Monthly IDCW Re-Investment',
    'Quantum Dynamic Bond Fund - Regular Plan Growth',
    'Quantum Dynamic Bond Fund - Regular Plan Monthly IDCW Payout',
    'Quantum Dynamic Bond Fund - Regular Plan Monthly IDCW Re-Investment',
  ];

/// Multi asset scheme : 
 final List<String> multiassetfunds =[
   'Quantum Multi Assets Fund of Funds - Direct Plan Growth Option',
 ];

 /// Gold asset scheme :
 final List<String> goldassestfunds =[
  'Quantum Gold Saving Fund - Direct Plan Growth',
 ];

 /// Q Nifty fund : 
 final List<String> qniftyfunds =[
 'Quantum Nifty 50 Fund of Fund - Direct Plan Growth',
 ];

 /// Hybrid funds :
 final List<String> hybridfunds =[
  'Quantum Multi Assets Allocation Fund - Direct Plan Growth',
 ];

// Sip frequency list
final List<String> sipFrequency = [
 'Daily',
 'Weekly',
 'Fortnightly'
 'Monthly',
 'Quarterly'  
];

  @override
 void initState(){
  super.initState();
   _totalInstallmentController.text = counter.value.toString();
   categories = {
  "Equity Fund": equityScheme,
  "Debt Fund": debtScheme,
  "Multi Assets": multiassetfunds,
  "Gold Funds": goldassestfunds,
  "Q Nifty": qniftyfunds,
  "Hybrid Funds": hybridfunds,
  };
}

void _refresh() {
    setState(() {
      _totalInstallmentController.text = counter.value.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
   return Scaffold(
    appBar: AppBar(
      backgroundColor: const Color.fromARGB(255, 48, 128, 194),
      title: const Text('SIP Registration',
      style: TextStyle(
        fontSize: 24,
      ),
      ),
    ),
    body: Padding(
      padding: EdgeInsets.all(20),
      child: Form(
        key: _formKey,
        child:ListView(
          children: [
           // Sip through dropdown.
          _buildDropdown(
            label: 'Register SIP Through', 
            value: _Sip, 
            items: sipList, 
            onChanged: (val) {
              setState(() {
                _Sip = val;
              });
            }
           ),
          
          // Plan type dropdown
          _buildDropdown(
            label: 'Plan Type', 
            value: _Plantype, 
            items: planType, 
            onChanged: (val){
              setState(() {
                _Plantype = val;
              });
            }
          ),

          // Category 
         // 1. Scheme Category dropdown
              DropdownButtonFormField<String>(
              value: selectedScheme,
              decoration: const InputDecoration(
               labelText: "Scheme Category",
               border: OutlineInputBorder(),
                ),
              items: categories.keys.map((scheme) {
               return DropdownMenuItem(
               value: scheme,
               child: Text(scheme),
                );
              }).toList(),
                 onChanged: (value) {
                 setState(() {
                 selectedScheme = value;
                 selectedOption = null; // reset scheme option when category changes
                 });
                },
                validator: (val) => val == null ? 'Required' : null,
              ),

               const SizedBox(height: 14),

              // 2. Specific Scheme dropdown (depends on category)
              if (selectedScheme != null)
              DropdownButtonFormField<String>(
               isExpanded: true,
               value: selectedOption,
               decoration: const InputDecoration(
                labelText: "Select Scheme",
                border: OutlineInputBorder(),
               ),
               items: categories[selectedScheme]!
               .map((schemeOption) => DropdownMenuItem(
                value: schemeOption,
                child: Text(schemeOption),
                ))
               .toList(),
               onChanged: (value) {
                  setState(() {
                  selectedOption = value;
                 });
                 },
              validator: (val) => val == null ? 'Required' : null,
              ),
              const SizedBox(height : 10),

          //Sip frequency dropdown
          _buildDropdown(
            label: 'SIP Frequency', 
            value: _frequency, 
            items: sipFrequency, 
            onChanged:(val){
              setState(() {
                _frequency = val;
              });
            }
          ),

          // Amount text input field
          _buildTextField(
            controller: _ammountController, 
            label: 'Add SIP Amount'
          ),

          // enrollment picker
          _buildDatePicker(),

          // Number of Installment 
          Row(
           children: [
           Expanded(
            child: TextField(
              controller: _totalInstallmentController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Number of Installments',
                border: OutlineInputBorder(),
              ),
              onChanged: (val){
                final num = int.tryParse(val);
                if(num != null){
                  counter.setValue(num);
                  _refresh();
                }
              },
            ),
          ),
          Column(
            children: [
              IconButton(
                onPressed:(){
                  counter.increment();
                  _refresh();
                }, 
                icon:const Icon(Icons.arrow_drop_up),
              ),
              IconButton(
                onPressed: (){
                  counter.decrement();
                  _refresh();
                }, 
                icon: const Icon(Icons.arrow_drop_down),
              )
             ],
            ),
           ],
          ),
          const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Handle form submission or navigation
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('New SIP Saved!')),
                    );
                  }
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HomePage(token: ''),
                    )
                  );
                },
                 style: ElevatedButton.styleFrom(
                   backgroundColor: const Color.fromARGB(255, 102, 140, 206),
                   textStyle: const TextStyle(fontSize: 16),
                   shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10), 
                   ),
                   padding: const EdgeInsets.all(8),
                  ),                
                child: const Text('Submit'),
          ),
         ],
        ),
      ), 
     ),
   );
  }

  /// Dropdown menu
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
   

  /// Text field 
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
        validator: validator ??
            (val) {
              if (val == null || val.isEmpty) return 'Required';
              return null;
            },
      ),
    );
  }
 
 /// Date Picker 
  Widget _buildDatePicker() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextFormField(
        controller: _enrollmetController,
        readOnly: true,
        onTap: _selectDOB,
        decoration: const InputDecoration(
          labelText: 'Enrollment Period',
          border: OutlineInputBorder(),
          suffixIcon: Icon(Icons.calendar_today),
        ),
        validator: (val) => val == null || val.isEmpty ? 'Select Date' : null,
      ),
    );
  }
  
  /// Date format
  Future<void> _selectDOB() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1960),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _dateTime = picked;
        _enrollmetController.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }
}